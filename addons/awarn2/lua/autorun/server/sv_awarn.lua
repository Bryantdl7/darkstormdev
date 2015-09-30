AWarn = {}

AWarn.DefaultValues = { awarn_kick = 1, awarn_kick_threshold = 3, awarn_ban = 1, awarn_ban_threshold = 5, awarn_ban_time = 30, awarn_decay = 1, awarn_decay_rate = 30, awarn_reasonrequired = 1 }

function awarn_loadscript()
	awarn_tbl_exist()
	
	util.AddNetworkString("SendPlayerWarns")
	util.AddNetworkString("SendOwnWarns")
	util.AddNetworkString("AWarnMenu")
	util.AddNetworkString("AWarnClientMenu")
	util.AddNetworkString("AWarnOptionsMenu")
	util.AddNetworkString("AWarnNotification")
	util.AddNetworkString("AWarnNotification2")
	util.AddNetworkString("AWarnChatMessage")
	util.AddNetworkString("awarn_openoptions")
	util.AddNetworkString("awarn_openmenu")
	util.AddNetworkString("awarn_fetchwarnings")
	util.AddNetworkString("awarn_fetchownwarnings")
	util.AddNetworkString("awarn_deletesinglewarn")
	util.AddNetworkString("awarn_deletewarningsid")
	util.AddNetworkString("awarn_deletewarnings")
	util.AddNetworkString("awarn_removewarningsid")
	util.AddNetworkString("awarn_removewarnings")
	util.AddNetworkString("awarn_removewarn")
	util.AddNetworkString("awarn_warn")
	util.AddNetworkString("awarn_warnid")
	util.AddNetworkString("awarn_changeconvarbool")
	util.AddNetworkString("awarn_changeconvar")
	
	
	
	

end
hook.Add( "Initialize", "Awarn_Initialize", awarn_loadscript )


function awarn_checkkickban( ply )
	local kt = tonumber(GetGlobalInt( "awarn_kick_threshold", 3 ))
	local bt = tonumber(GetGlobalInt( "awarn_ban_threshold", 5 ))
	local btime = tonumber(GetGlobalInt( "awarn_ban_time", 30 ))
	
	local kickon = tobool(GetGlobalInt( "awarn_kick", 1 ))
	local banon = tobool(GetGlobalInt( "awarn_ban", 1 ))
	
	
	
	if banon then
		if tonumber(awarn_getwarnings( ply )) >= tonumber(bt) then
			ServerLog("AWarn: BANNING " .. ply:Nick() .. " FOR " .. btime .. " minutes!\n")
			for k, v in pairs(player.GetAll()) do AWSendMessage( v, "AWarn: " .. ply:Nick() .. " was banned for reaching the warning threshold" ) end
			local AWarnLimitBan = hook.Call( "AWarnLimitBan", GAMEMODE, ply )
			timer.Simple(1, function() awarn_ban( ply, btime ) end )
			return
		end
	end
	
	if kickon then
		if awarn_getwarnings( ply ) >= tonumber(kt) then
			ServerLog("AWarn: KICKING " .. ply:Nick().. "\n")
			for k, v in pairs(player.GetAll()) do AWSendMessage( v, "AWarn: " .. ply:Nick() .. " was kicked for reaching the warning threshold" ) end
			local AWarnLimitKick = hook.Call( "AWarnLimitKick", GAMEMODE, ply )
			timer.Simple(1, function() awarn_kick( ply ) end )
			return
		end
	end
	--print("DEBUG: " .. awarn_getwarnings( ply ))
end


function awarn_kick( ply )
	if ulx then
		ULib.kick( ply, "AWarn: Warning Threshold Met" )
	else
		ply:Kick( "AWarn: Warning Threshold Met" )
	end
end

function awarn_ban( ply, time )
	if ulx then
		ULib.kickban( ply, time, "AWarn: Ban Threshold Met" )
	else
		ply:Ban( time, "AWarn: Ban Threshold Met" )
	end
end


function awarn_decaywarns( ply )
	if tobool(GetGlobalInt( "awarn_decay", 1 )) then
		local dr = GetGlobalInt( "awarn_decay_rate", 30 )
		
		if awarn_getlastwarn( ply ) == "NONE" then
			--print("DEBUG: HAS NO WARNINGS")
		else
			--print("DEBUG: Has warnings on connect..")
			if tonumber(os.time()) >= tonumber(awarn_getlastwarn( ply )) + (dr*60) then
				--print("DEBUG: connection warning should be decayed")
				awarn_decwarnings(ply)
			end
			
			--print("DEBUG: " .. awarn_getwarnings( ply ) .. " warnings remaining.")
			if awarn_getwarnings( ply ) > 0 then
				--print("DEBUG: Creating timer.")
				timer.Create( ply:SteamID64() .. "_awarn_decay", dr*60, 1, function() if IsValid(ply) then awarn_decaywarns(ply) end end )
			end
		end
	end

end
hook.Add( "PlayerInitialSpawn", "awarn_decaywarns", awarn_decaywarns )

function awarn_welcomebackannounce( ply )
	if awarn_getwarnings( ply ) > 0 then
		local t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Welcome back to the server, " .. ply:Nick() .. "." }
		net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( ply )
		local t2 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Current Active Warnings: ", Color(255,0,0), tostring(awarn_getwarnings( ply )) }
		net.Start("AWarnChatMessage") net.WriteTable(t2) net.Send( ply )
		if tobool( GetGlobalInt("awarn_kick", 1) ) then
			local t3 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You will be kicked after: ", Color(255,0,0), GetGlobalInt("awarn_kick_threshold", 3), Color(255,255,255), " total active warnings." }
			net.Start("AWarnChatMessage") net.WriteTable(t3) net.Send( ply )
		end
		if tobool( GetGlobalInt("awarn_ban", 1) ) then
			local t4 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You will be banned after: ", Color(255,0,0), GetGlobalInt("awarn_ban_threshold", 7), Color(255,255,255), " total active warnings." }
			net.Start("AWarnChatMessage") net.WriteTable(t4) net.Send( ply )
		end
		local t5 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Type !warn to see a list of your warnings." }
		net.Start("AWarnChatMessage") net.WriteTable(t5) net.Send( ply )
	end
end
hook.Add( "PlayerInitialSpawn", "awarn_welcomebackannounce", awarn_welcomebackannounce )

function awarn_notifyadmins( ply )
	if awarn_gettotalwarnings( ply ) > 0 then
		local total_warnings = awarn_gettotalwarnings( ply )
		local total_active_warnings = awarn_getwarnings( ply )
		timer.Simple(1, function()
			local t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), ply, " joins the server with (", Color(255,0,0), tostring(total_warnings), Color(255,255,255), ") total warnings and (", Color(255,0,0), tostring(total_active_warnings), Color(255,255,255), ") active warnings." }
			for k, v in pairs(player.GetAll()) do
				if awarn_checkadmin_view( v ) then
					net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( v )
				end
			end
		end )
	end
end
hook.Add( "PlayerInitialSpawn", "awarn_notifyadmins", awarn_notifyadmins )


function awarn_playerdisconnected( ply )
	timer.Remove( ply:SteamID64() .. "_awarn_decay" )
end
hook.Add( "PlayerDisconnected", "awarn_playerdisconnected", awarn_playerdisconnected )

net.Receive( "awarn_fetchwarnings", function( l, ply )

	if not awarn_checkadmin_view( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local target_ply = awarn_getUser( net.ReadString() )
	
	if target_ply then
		awarn_sendwarnings( ply, target_ply )
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end

end )

net.Receive( "awarn_fetchownwarnings", function( l, ply )
    
	awarn_sendownwarnings( ply )

end )

net.Receive( "awarn_changeconvarbool", function( l, ply )
    
	local allowed = { "awarn_kick", "awarn_ban", "awarn_decay", "awarn_reasonrequired" }
	local convar = net.ReadString()
	local val = net.ReadString()

	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	if not table.HasValue( allowed, convar ) then
		AWSendMessage( ply, "AWarn: You can not set this CVar with this command.")
		return
	end
	
	if val == "true" then
		awarn_saveservervalue( convar, 0 )
		return
	end
	awarn_saveservervalue( convar, 1 )

end )

net.Receive( "awarn_changeconvar", function( l, ply )
    
	local allowed = { "awarn_kick_threshold", "awarn_ban_threshold", "awarn_ban_time", "awarn_decay_rate" }
	local convar = net.ReadString()
	local val = net.ReadInt(32)

	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	if not table.HasValue( allowed, convar ) then
		AWSendMessage( ply, "AWarn: You can not set this CVar with this command.")
		return
	end
	
	if val < 0 then
		AWSendMessage( ply, "AWarn: You must pass this ConVar a positive value.")
		return
	end

	awarn_saveservervalue( convar, val )

end )

function AWSendMessage( ply, message )
    if IsValid(ply) then
        ply:PrintMessage( HUD_PRINTTALK, message )
    else
        print( message )
    end
end

function AWarn_ChatWarn( ply, text, public )
    if (string.sub(string.lower(text), 1, 5) == "!warn") then
		local args = string.Explode( " ", text )
		if #args == 1 then
			ply:ConCommand( "awarn_menu" )
		else
			table.remove( args, 1 )
			awarn_con_warn( ply, _, args )
			--ply:ConCommand( "awarn_warn " .. table.concat( args, " ", 2 ) )
		end
		return false
    end
end
hook.Add( "PlayerSay", "AWarn_ChatWarn", AWarn_ChatWarn )

function awarn_con_warn( ply, _, args )
	
	if not ( #args >= 1 ) then return end
	local tar = awarn_getUser( args[1] )
	local reason = table.concat( args, " ", 2 )
	
	if (string.sub(string.lower(args[1]), 1, 5) == "steam") then
		if string.len(args[1]) == 7 then
			AWSendMessage( ply, "AWarn: Make sure you wrap the steamID in quotes!"  )
			return
		end
		tid = AWarn_ConvertSteamID( args[1] )
		awarn_warnplayerid( ply, tid, reason )
		return
	end
	
	if not (IsValid(tar)) then return end
	print("DEBUG =-=-= Reason: " .. reason)
	awarn_warnplayer( ply, tar, reason )

end
concommand.Add( "awarn_warn", awarn_con_warn )


net.Receive( "awarn_warn", function( l, ply )
    
	awarn_warnplayer( ply, net.ReadEntity(), net.ReadString() )

end )

net.Receive( "awarn_warnid", function( l, ply )
    
	awarn_warnplayerid( ply, net.ReadString(), net.ReadString() )

end )


function awarn_warnplayer( ply, tar, reason )

	if not awarn_checkadmin_warn( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
    
	target_ply = tar
	if reason == nil then reason = "" end
	
	if not IsValid(target_ply) then return end
	if not target_ply:IsPlayer() then return end
	
	if tobool(GetGlobalInt( "awarn_reasonrequired", 1 )) then
		if not reason then
			AWSendMessage( ply, "AWarn: You MUST include a reason. Disable this in the options.")
			return
		end
		if reason == "" then
			AWSendMessage( ply, "AWarn: You MUST include a reason. Disable this in the options.")
			return
		end
	end
	
	if not reason then reason = "NONE GIVEN" end
	if reason == "" then reason = "NONE GIVEN" end
	
	if target_ply then
		for k, v in pairs(player.GetAll()) do
			if v ~= target_ply then
				net.Start("AWarnNotification")
					net.WriteEntity( ply )
					net.WriteEntity( target_ply )
					net.WriteString( reason )
				net.Send( v )
			end
		end
        
		
		if IsValid(ply) then
            awarn_addwarning( target_ply:SteamID64(), reason, ply:Nick() )
            ServerLog( "[AWarn] " .. ply:Nick() .. " warned " .. target_ply:Nick() .. " for reason: " .. reason.. "\n" )
        else
            awarn_addwarning( target_ply:SteamID64(), reason, "[CONSOLE]" )
            ServerLog( "[AWarn] [CONSOLE] warned " .. target_ply:Nick() .. " for reason: " .. reason.. "\n" )
        end
		awarn_incwarnings( target_ply )
		
		local t1 = {}
        if IsValid( ply ) then
            t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You have been warned by ", ply, " for ", Color(150,40,40), reason, Color(255,255,255), "." }
        else
            t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You have been warned by ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), " for ", Color(150,40,40), reason, Color(255,255,255), "." }
        end
		net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( target_ply )
		
		local t2 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Current Active Warnings: ", Color(255,0,0), tostring(awarn_getwarnings( target_ply )) }
		net.Start("AWarnChatMessage") net.WriteTable(t2) net.Send( target_ply )
		
		if tobool( GetGlobalInt("awarn_kick", 1) ) then
			local t3 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You will be kicked after: ", Color(255,0,0), GetGlobalInt("awarn_kick_threshold", 3), Color(255,255,255), " total active warnings." }
			net.Start("AWarnChatMessage") net.WriteTable(t3) net.Send( target_ply )
		end
		
		if tobool( GetGlobalInt("awarn_ban", 1) ) then
			local t4 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "You will be banned after: ", Color(255,0,0), GetGlobalInt("awarn_ban_threshold", 7), Color(255,255,255), " total active warnings." }
			net.Start("AWarnChatMessage") net.WriteTable(t4) net.Send( target_ply )
		end
		
		local t5 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Type !warn to see a list of your warnings." }
		net.Start("AWarnChatMessage") net.WriteTable(t5) net.Send( target_ply )
		
		if IsValid( ply ) then
            awarn_sendwarnings( ply, target_ply )
        end
		
		local AWarnPlayerWarned = hook.Call( "AWarnPlayerWarned", GAMEMODE, target_ply, ply, reason )
			
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end

end

function awarn_warnplayerid( ply, tarid, reason )

	if not awarn_checkadmin_warn( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	if tobool(GetGlobalInt( "awarn_reasonrequired", 1 )) then
		if not reason then
			AWSendMessage( ply, "AWarn: You MUST include a reason. Disable this in the options.")
			return
		end
		if reason == "" then
			AWSendMessage( ply, "AWarn: You MUST include a reason. Disable this in the options.")
			return
		end
	end
	
	if not reason then reason = "NONE GIVEN" end
	if reason == "" then reason = "NONE GIVEN" end
	
	net.Start("AWarnNotification2")
		net.WriteEntity( ply )
		net.WriteString( tarid )
		net.WriteString( reason )
	net.Broadcast()
        
		
	if IsValid(ply) then
		awarn_addwarning( tarid, reason, ply:Nick() )
		ServerLog( "[AWarn] " .. ply:Nick() .. " warned " .. tostring(tarid) .. " for reason: " .. reason.. "\n" )
	else
		awarn_addwarning( tarid, reason, "[CONSOLE]" )
		ServerLog( "[AWarn] [CONSOLE] warned " .. tostring(tarid) .. " for reason: " .. reason.. "\n" )
	end
	awarn_incwarningsid( tarid )
	
	local AWarnPlayerIDWarned = hook.Call( "AWarnPlayerIDWarned", GAMEMODE, tarid, ply, reason )
end

function awarn_remwarn( ply, tar )

	if not awarn_checkadmin_remove( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local target_ply = awarn_getUser( tar )
	
	if target_ply then
		awarn_decwarnings( target_ply, ply )
        if IsValid( ply ) then
            awarn_sendwarnings( ply, target_ply )
        end
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end

end

net.Receive( "awarn_removewarnid", function( l, ply )

	if not awarn_checkadmin_remove( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local uid = net.ReadString()
	awarn_decwarningsid( uid, ply )

end )

net.Receive( "awarn_removewarn", function( l, ply )
    if not IsValid( ply ) then return end
	local p_id = net.ReadString()
	
    if (string.sub(string.lower( p_id ), 1, 5) == "steam") then
		if string.len(args[1]) == 7 then
			AWSendMessage( ply, "AWarn: Make sure you wrap the steamID in quotes!"  )
			return
		end
        id = AWarn_ConvertSteamID( p_id )
		awarn_decwarningsid( id, ply )
        return
    end
	awarn_remwarn( ply, p_id )

end )

net.Receive( "awarn_deletewarnings", function( l, ply )

	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local target_ply = awarn_getUser( net.ReadString() )
	
	if target_ply then
		awarn_delwarnings( target_ply, ply )
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end

end )

concommand.Add( "awarn_deletewarnings", function( ply, _, args )
	if IsValid(ply) then return end
	if #args ~= 1 then return end
	local target_ply = awarn_getUser( args[1] )
	
	if target_ply then
		awarn_delwarnings( target_ply, ply )
	else
		AWSendMessage( ply, "AWarn: Player not found!")
	end
end )

net.Receive( "awarn_deletewarningsid", function( l, ply )
	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local uid = net.ReadString()
	
	awarn_delwarningsid( uid, ply )
end )

concommand.Add( "awarn_deletewarningsid", function( ply, _, args )
	if IsValid(ply) then return end
	if #args ~= 1 then return end
	
	local uid = args[1]
	awarn_delwarningsid( uid, ply )
end )

net.Receive( "awarn_openmenu", function( l, ply )

    if not IsValid( ply ) then
        AWSendMessage( ply, "AWarn: This command can not be run from the server's console!")
        return
    end

	if not awarn_checkadmin_view( ply ) then
		net.Start("AWarnClientMenu")
		net.Send( ply )
		return
	end
	
	
	net.Start("AWarnMenu")
	net.Send( ply )

end )

net.Receive( "awarn_openoptions", function( l, ply )

    if not IsValid( ply ) then
        AWSendMessage( ply, "AWarn: This command can not be run from the server's console!")
        return
    end

	if not awarn_checkadmin_options( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	
	net.Start("AWarnOptionsMenu")
	net.Send( ply )

end )

net.Receive( "awarn_deletesinglewarn", function( l, ply )

	if not awarn_checkadmin_delete( ply ) then
		AWSendMessage( ply, "AWarn: You do not have access to this command.")
		return
	end
	
	local warningid = net.ReadInt(16)
	
	awarn_delsinglewarning( ply, warningid )

end )

local files, dirs = file.Find("awarn/modules/*.lua", "LUA")
for k, v in pairs( files ) do
	ServerLog("AWarn: Loading module (" .. v .. ")\n")
	include( "awarn/modules/" .. v )
end
