-- AntiCrash coded by Flapadar
-- Fixed by Leystryku
-- Modified by Agentmass

-- 30/11/12 last fix
-- Works with gmod 13 as of 6/11/14

AntiCrash = {}

CreateConVar("anticrash_enabled", "1", FCVAR_ARCHIVE)

if ( not GetConVar("anticrash_enabled"):GetBool() ) then

	return

end

if SERVER then

	util.AddNetworkString("AntiCrash.Pong")
	AddCSLuaFile("sh_anticrash.lua")

	function AntiCrash.Ping( ply, cmd, args )
	
		if ( not ply.LastPing or ply.LastPing + 5 < CurTime() ) then
		
			ply.LastPing = CurTime()
			
			net.Start("AntiCrash.Pong")
			net.Send( ply )

			--MsgN("Ping !")
		end
		
	end
	
	concommand.Add("_anticrash_ping", AntiCrash.Ping)

	return
end

AntiCrash.LastMoveTime = CurTime() + 10
AntiCrash.ShouldRetry = true
AntiCrash.Crashed = false
AntiCrash.Spawned = false
AntiCrash.Pending = false
AntiCrash.SpawnTime = 0



function AntiCrash.IsCrashed()

	if ( not AntiCrash.Spawned or not LocalPlayer or AntiCrash.Crashed ) then return end
		
	if ( AntiCrash.SpawnTime > CurTime() ) then return end

	if ( AntiCrash.LastMoveTime > CurTime() ) then return end

	if ( not IsValid(LocalPlayer()) ) then return end

	if ( not LocalPlayer():IsFrozen() and not LocalPlayer():InVehicle() ) then

		return true

	end

end

function AntiCrash.Pong( um )

	AntiCrash.LastMoveTime = CurTime() + 10
	MsgN("[AntiCrash] Connection regained - received pong")

end

function AntiCrash.Move()

	AntiCrash.LastMoveTime = CurTime() + 1
	
end

function AntiCrash.InitPostEntity()

	AntiCrash.Spawned = true
	AntiCrash.SpawnTime = CurTime() + 5

end

function AntiCrash.ServerCrash()

	local menucrashtime = CurTime()
	local retrytime = menucrashtime + 30
	
	for k , v  in ipairs(player.GetAll()) do
		v.CrashedPing = v:Ping()
	end

	local dframe = vgui.Create("DFrame")
	dframe:SetSize(200 , 150)
	dframe:SetTitle("AntiCrash")
	dframe:Center()
	dframe:MakePopup()

	function dframe:Close(...)
		AntiCrash.ShouldRetry = false
		return DFrame.Close(self , ...)
	end

	local dlabel = vgui.Create("DLabel")
	dlabel:SetParent(dframe)
	dlabel:SetPos(27 , 30)
	dlabel:SetSize(195 , 25)
	dlabel:SetText(string.format("Autoreconnect in %d seconds!" , retrytime - CurTime()))

	function dlabel:Paint( ... )
	
		self:SetText(string.format("Autoreconnect in %d seconds!" , retrytime - CurTime()))

	end

--	local dbutton = vgui.Create("DButton")
--	dbutton:SetParent(dframe)
--	dbutton:SetPos(5 , 55)
--	dbutton:SetSize(190 , 22)
--	dbutton:SetText("Reconnect now")
--	dbutton.DoClick = function()
--		RunConsoleCommand("retry")
--	end

	local dlabel = vgui.Create("DLabel")
	dlabel:SetParent(dframe)
	dlabel:SetPos(22 , 60)
	dlabel:SetSize(195 , 50)
	dlabel:SetText("Please wait until the above timer \nhits 0 in order to auto-reconnect \nwhen the server has been fully \n                restarted.")

	local dbutton = vgui.Create("DButton")
	dbutton:SetParent(dframe)
	dbutton:SetPos(5 , 120)
	dbutton:SetSize(190 , 22)
	dbutton:SetText("Cancel")
	dbutton.DoClick = function()
		AntiCrash.ShouldRetry = false
		dframe:SetVisible(false)
	end
	
	hook.Add("Think" , "Crashed" , function()
		for k , v in ipairs(player.GetAll()) do
			if v.CrashedPing != v:Ping() then
				MsgN("[AntiCrash] Connection regained - ping changed.")
				hook.Remove("Think" , "Crashed")
				AntiCrash.Crashed = false
				AntiCrash.LastMoveTime = CurTime() + 5
			end
		end
		
		/*
		local moving = false
		
		for k , v in ipairs(ents.GetAll()) do
			if v:GetVelocity():Length() > 5 then
				-- Well, not everything's stopped moving.
				-- 5 incase some props stuck in another prop and is spazzing or something
				-- It should stop moving, but i'm not entirely sure
				
				moving = true
			end
		end
		
		if moving then
			hook.Remove("Think" , "Crashed")
			MsgN("[AntiCrash] Connection regained - movement detected")
			AntiCrash.Crashed = false
			AntiCrash.LastMoveTime = CurTime() + 5
		end
		
		*/
		
		if AntiCrash.Crashed and (retrytime - CurTime() - 0.5) < 0 and AntiCrash.LastMoveTime + 5 < CurTime() then
			if AntiCrash.ShouldRetry then
				RunConsoleCommand("retry")
			end
		elseif AntiCrash.LastMoveTime > CurTime() then
			hook.Remove("Think" , "Crashed")
			AntiCrash.Crashed = false
			if dframe and dframe:IsValid() then
				dframe:Remove()
			end
		end
	end )
	
end

function AntiCrash.Think()

	if not AntiCrash.Crashed and AntiCrash.IsCrashed() then

		RunConsoleCommand("_anticrash_ping")
		
		if AntiCrash.LastMoveTime < CurTime() then
			MsgN("[AntiCrash] Connection down - Did not receive pong")
			AntiCrash.Crashed = true
			AntiCrash.ShouldRetry = true -- This is a seperate crash from the previous, the user might want to reconnect this time.

			AntiCrash.ServerCrash()
			hook.Call( "ServerCrash" , nil ) -- Incase anyone else wants to hook into server crashes.
		else
			AntiCrash.Crashed = false
		end

		MsgN("[AntiCrash] Connection lost - sending ping")
	end
	
end

hook.Add("InitPostEntity" , "AntiCrash.InitPostEntity", AntiCrash.InitPostEntity)
hook.Add("Move" , "AntiCrash.Move", AntiCrash.Move)
hook.Add("Think" , "AntiCrash.Think", AntiCrash.Think)

net.Receive("AntiCrash.Pong", AntiCrash.Pong)


MsgN("You are running AntiCrash by Flapadar.\nFixed by Leystryku.\nModified by Agentmass. \n")