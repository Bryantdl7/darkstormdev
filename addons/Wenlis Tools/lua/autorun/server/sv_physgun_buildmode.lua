// Physgun Build Mode - by Wenli
if CLIENT then return end

AddCSLuaFile( "autorun/client/cl_physgun_buildmode.lua" )

local pb = "physgun_buildmode"
local pb_ = "physgun_buildmode_"

local buildmode_ents = {}


//********************************************************************************************************************//
// Client settings
//********************************************************************************************************************//

// Get physgun settings from the player
local function Update_Settings( ply )
	if !IsValid( ply ) then return false end
	
	if ply:GetInfoNum( pb_.. "enabled" ) ~= 0 then
		local status = {}
		
		status.ply = ply
		status.sleep = ply:GetInfoNum( pb_.. "sleep" ) ~= 0
		status.nocollide = ply:GetInfoNum( pb_.. "nocollide" ) ~= 0
		status.limit_rotation = ply:GetInfoNum( pb_.. "norotate" ) ~= 0
		status.snapmove = ply:GetInfoNum( pb_.. "snapmove" ) ~= 0
		
		if ply:GetInfoNum( pb_.. "snap_position" ) ~= 0 then
			local snap_position = Vector(0,0,0)
			local snap_origin = Vector(0,0,0)
			
			snap_position.x = math.max( 0, ply:GetInfoNum( pb_.. "grid_x" ) )
			snap_position.y = math.max( 0, ply:GetInfoNum( pb_.. "grid_y" ) )
			snap_position.z = math.max( 0, ply:GetInfoNum( pb_.. "grid_z" ) )
			
			if snap_position ~= Vector(0,0,0) then
				snap_origin.x = math.max( 0, ply:GetInfoNum( pb_.. "origin_x" ) )
				snap_origin.y = math.max( 0, ply:GetInfoNum( pb_.. "origin_y" ) )
				snap_origin.z = math.max( 0, ply:GetInfoNum( pb_.. "origin_z" ) )
				
				status.snap_position = snap_position
				status.snap_origin = snap_origin
				status.snap_boxcentre = ply:GetInfoNum( pb_.. "snap_boxcentre" ) ~= 0
			end
		end
		
		if ply:GetInfoNum( pb_.. "snap_angles" ) ~= 0 then
			local snap_angles = Angle(0,0,0)
			
			snap_angles.p = math.max( 0, ply:GetInfoNum( pb_.. "angles_p" ) )
			snap_angles.y = math.max( 0, ply:GetInfoNum( pb_.. "angles_y" ) )
			snap_angles.r = math.max( 0, ply:GetInfoNum( pb_.. "angles_r" ) )
			
			if snap_angles ~= Angle(0,0,0) then
				status.snap_angles = snap_angles
			end
		end
		
		return status
	end
	
	return false
end

// Let the client know that Physgun Build Mode is enabled on server
local function Notify_Player( ply )
	SendUserMessage( "Server_Has_PhysBuildMode", ply )
end

hook.Add( "PlayerInitialSpawn", "Physgun Build Mode:Player Spawn", Notify_Player )

// Enable buildmode for all players on file reload
for k, ply in pairs ( player.GetAll() ) do
	if IsValid( ply ) then
		Notify_Player( ply )
	end
end

// Concommand that lets client check whether the server has Physgun Build Mode
concommand.Add( pb_.. "check_server", Notify_Player )


//********************************************************************************************************************//
// Snap mechanics
//********************************************************************************************************************//

local function limit_rotation( ent )
	local status = buildmode_ents[ent]

	// Use adv ballsocket to prevent the prop from rotating
	if !status.ballsockets then
		local pos = ent:GetPos()
		status.ballsockets = {}
		status.ballsockets[1] = constraint.AdvBallsocket( ent, GetWorldEntity(), 0, 0, pos, pos, 0, 0, 0, -180, -180, 0, 180, 180, 0, 0, 0, 1, 0 )
		status.ballsockets[2] = constraint.AdvBallsocket( ent, GetWorldEntity(), 0, 0, pos, pos, 0, 0, -180, 0, -180, 180, 0, 180, 0, 0, 0, 1, 0 )
		status.ballsockets[3] = constraint.AdvBallsocket( ent, GetWorldEntity(), 0, 0, pos, pos, 0, 0, -180, -180, 0, 180, 180, 0, 0, 0, 0, 1, 0 )
	end
end

local function allow_rotation( ent, status )
	if status.ballsockets then
		for k, v in pairs ( status.ballsockets ) do
			if IsValid(v) then
				v:Remove()
			end
		end
		
		table.Empty( status.ballsockets )
		status.ballsockets = nil
	end
end

local function snap_position( ent, status )
	if status.snap_position then
		local pos = ent:GetPos()
		
		local snap = status.snap_position or Vector(0,0,0)
		local origin = status.snap_origin or Vector(0,0,0)
		
		if status.snap_boxcentre then
			origin = origin + pos - ent:LocalToWorld( ent:OBBCenter() )
		end
		
		// Sensitivity affects the behaviour difference between snap while moving, and snap after moving
		local sensitivity = status.sensitivity or snap * 0.16
		
		local offset = Vector(0,0,0)
		
		if snap.x > 0 then offset.x = ( -origin.x + pos.x + snap.x/2 ) % snap.x - snap.x/2 end
		if snap.y > 0 then offset.y = ( -origin.y + pos.y + snap.y/2 ) % snap.y - snap.y/2 end
		if snap.z > 0 then offset.z = ( -origin.z + pos.z + snap.z/2 ) % snap.z - snap.z/2 end
		
		local absoffset = Vector( math.abs( offset.x ), math.abs( offset.y ), math.abs( offset.z ) )
		
		if absoffset.x > sensitivity.x then offset.x = offset.x - snap.x * ( offset.x / absoffset.x ) end
		if absoffset.y > sensitivity.y then offset.y = offset.y - snap.y * ( offset.y / absoffset.y ) end
		if absoffset.z > sensitivity.z then offset.z = offset.z - snap.z * ( offset.z / absoffset.z ) end
		
		ent:SetPos( pos - offset )
	end
end

local function snap_angles( ent, status )
	if status.snap_angles then
		local ang = ent:GetAngles()
		local snap = status.snap_angles
		if snap then
			local offset = Angle(
				( ang.p + snap.p/2 ) % snap.p - snap.p/2,
				( ang.y + snap.y/2 ) % snap.y - snap.y/2,
				( ang.r + snap.r/2 ) % snap.r - snap.r/2
			)
			
			ent:SetAngles( ang - offset )
		end
	end
end

local function Phys_Snap ()
	for ent, status in pairs ( buildmode_ents ) do
		if IsValid( ent ) and IsValid( status.ply ) then
			if status.snapmove then
				snap_position( ent, status )
			end
			
			if status.ply:KeyDown( IN_USE )  then
				allow_rotation( ent, status )
			elseif status.limit_rotation then
				limit_rotation( ent )
			end
		else
			buildmode_ents[ent] = nil
		end
	end
end

hook.Add( "Tick", "Physgun Build Mode:Snap", function()
	local r, e = pcall( Phys_Snap )
	if !r then print("Physgun Build Mode Snap Error: " .. e) end
end)


//********************************************************************************************************************//
// Pickup/Drop functions
//********************************************************************************************************************//

// This is so that the Phys_Drop function can call to the Phys_Grab function and vice-versa
local Phys_Grab = function() end

local function Phys_Drop( ply, ent )
	if !IsValid( ply ) or !IsValid( ent ) then
		buildmode_ents[ent] = nil
		return false
	end
	
	// Check in case player enabled build mode while holding a prop
	if !buildmode_ents[ent] then
		if ply:GetInfoNum( pb_.. "enabled" ) ~= 0 then
			Phys_Grab( ply, ent )
		end
		
	else
		local status = buildmode_ents[ent]
		local phys = ent:GetPhysicsObject()
		
		allow_rotation( ent, status )
		
		// Check in case player disabled build mode while holding a prop
		if ply:GetInfoNum( pb_.. "enabled" ) ~= 0 then
			phys:EnableMotion( false )
			
			if status.sleep then
				local function Sleep()
					phys:Sleep()
					phys:EnableMotion( true )
				end
				timer.Simple( 0.02, Sleep )
			end
			
			if status.snap_position then
				status.sensitivity = status.snap_position * 0.5
			end
			snap_position( ent, status )
			snap_angles( ent, status )
		end
		
		// Restore nocollide info
		if status.collision_group then
			ent:SetCollisionGroup( status.collision_group )
			status.collision_group = nil
		end
		
		// Restore gravity
		if status.gravity then
			phys:EnableGravity( true )
		end
		
		// Clear entry from buildmode_ents
		buildmode_ents[ent] = nil
	end
end

Phys_Grab = function( ply, ent )
	if IsValid( ent ) and IsValid( ply ) and !IsValid( ent:GetParent() ) then
		// Check if ent is already being held
		if buildmode_ents[ent] then
			Phys_Drop( buildmode_ents[ent].ply, ent )
		end
		
		local status = Update_Settings( ply )
		
		if status then
			// Store nocollide info
			if status.nocollide then
				status.collision_group = ent:GetCollisionGroup()
				ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
			end
			
			// Store gravity info
			local phys = ent:GetPhysicsObject()
			status.gravity = phys:IsGravityEnabled()
			if status.gravity then
				phys:EnableGravity( false )
			end
			
			buildmode_ents[ent] = status
		end
	end
end

hook.Add( "PhysgunDrop", "Physgun Build Mode:Drop", function( ply, ent )
	local r, e = pcall( Phys_Drop, ply, ent )
	if !r then print("Physgun Build Mode Drop Error: " .. e) end
end)

hook.Add( "PhysgunPickup", "Physgun Build Mode:Pickup", function( ply, ent )
	local r, e = pcall( Phys_Grab, ply, ent )
	if !r then print("Physgun Build Mode Pickup Error: " .. e) end
end)