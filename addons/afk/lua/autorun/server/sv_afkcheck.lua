CreateConVar( "sv_afktime", 45, FCVAR_ARCHIVE, "The time in minutes it takes for the AFK Timer to appear" )
CreateConVar( "sv_kicktime", 75, FCVAR_ARCHIVE, "The time it takes to kick someone. Make sure this is lower than AFK Timer amount in seconds!" )
CreateConVar( "sv_kickmessage", "You were kicked for being AFK", FCVAR_ARCHIVE, "The message that displays when kicked" )
util.AddNetworkString( "timerstart"	)
util.AddNetworkString( "kickstop" )
print("AFK Checker Version: 1.2 is now initialized!")

hook.Add("PlayerInitialSpawn","afkcheck", function(ply)
	--Creates uhh this is uh how long, how long the player should be on the server before showing the afk timer. Holy crap stop typing what I say.
	if not ply:IsAdmin() then
		timer.Create( "afktimer" .. ply:SteamID64(),GetConVarNumber("sv_afktime")*60,0, function()
			if not IsValid(ply) then return end
			net.Start("timerstart")
				net.WriteInt(GetConVarNumber("sv_afktime"), 16)
				net.WriteInt(GetConVarNumber("sv_kicktime"), 16)
			net.Send(ply)
			timer.Create("kicktimer" .. ply:SteamID64(),GetConVarNumber("sv_kicktime"),1, function()
				if not IsValid(ply) then return end
				ply:Kick(GetConVarString("sv_kickmessage"))
			end)
		end)
	end
end)

net.Receive("kickstop", function(len, ply)
	timer.Remove("kicktimer" .. ply:SteamID64() )
end)
