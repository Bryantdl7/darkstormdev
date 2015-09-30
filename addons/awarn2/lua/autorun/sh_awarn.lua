AddCSLuaFile()


local PlayerMeta = FindMetaTable("Player")

function awarn_ULXCompatability()
	if CLIENT then return end
	if ulx then
		ULib.ucl.registerAccess( "awarn_view", ULib.ACCESS_ADMIN, "Ability to view other players' warnings.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_warn", ULib.ACCESS_ADMIN, "Ability to warn players.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_remove", ULib.ACCESS_ADMIN, "Ability to reduce a player's active warnings.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_delete", ULib.ACCESS_SUPERADMIN, "Ability to delete a player's warning data entirely.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_options", ULib.ACCESS_SUPERADMIN, "Ability to view and change AWarn settings.", "AWarn" )
	end
end
hook.Add( "InitPostEntity", "awarn_ULXCompatability", awarn_ULXCompatability )

function awarn_checkadmin_view( self )
	if not IsValid( self ) then return true end
	
	if ulx then
		if ULib.ucl.query( self, "awarn_view" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_view" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end	
	end
end

function awarn_checkadmin_warn( self )
	if not IsValid( self ) then return true end
	
	if ulx then
		if ULib.ucl.query( self, "awarn_warn" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_warn" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end	
	end
end

function awarn_checkadmin_remove( self )
	if not IsValid( self ) then return true end
	
	if ulx then
		if ULib.ucl.query( self, "awarn_remove" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_remove" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end	
	end
end

function awarn_checkadmin_delete( self )
	if not IsValid( self ) then return true end
	
	if ulx then
		if ULib.ucl.query( self, "awarn_delete" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_delete" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end	
	end
end

function awarn_checkadmin_options( self )
	if not IsValid( self ) then return true end
	
	if ulx then
		if ULib.ucl.query( self, "awarn_options" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_options" ) then return true end
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end	
	end
end


--ALL CREDIT FOR THIS COMMAND GOES TO THE ULX TEAM. I PULLED THIS OUT SO THAT I COULD NOT HAVE TO RELY ON ULIB FOR A SINGLE FUNCTION.
function awarn_getUser( target )
	if not target then return false end

	local players = player.GetAll()
	target = target:lower()

	local plyMatch

	-- First, do a full name match in case someone's trying to exploit our target system
	for _, player in ipairs( players ) do
		if target == player:Nick():lower() then
			if not plyMatch then
				return player
			else
				return false
			end
		end
	end

	for _, player in ipairs( players ) do
		local nameMatch
		if player:Nick():lower():find( target, 1, true ) then -- No patterns
			nameMatch = player
		end

		if plyMatch and nameMatch then -- Already have one
			return false
		end
		if nameMatch then
			plyMatch = nameMatch
		end
	end

	if not plyMatch then
		return false
	end

	return plyMatch
end

---------------------------------END OF CREDITED CODE------------------------------------------

function AWarn_ConvertSteamID( id )
	id = string.upper(string.Trim( id ))
	if string.sub( id, 1, 6 ) == 'STEAM_' then
		local parts = string.Explode( ':', string.sub(id,7) )
		local id_64 = (1197960265728 + tonumber(parts[2])) + (tonumber(parts[3]) * 2)
		local str = string.format('%f',id_64)
		return '7656'..string.sub( str, 1, string.find(str,'.',1,true)-1 )
	else
		if tonumber( id ) ~= nil then
		  local id_64 = tonumber( id:sub(2) )
		  local a = id_64 % 2 == 0 and 0 or  1
		  local b = math.abs(6561197960265728 - id_64 - a) / 2
		  local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
		  return sid
		end
	end
end