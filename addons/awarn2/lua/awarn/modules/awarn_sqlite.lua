local PlayerMeta = FindMetaTable("Player")

function awarn_tbl_exist()
	if sql.TableExists("awarn_warnings") then
		ServerLog( "AWarn: Warning Table Exists\n" )
	else
		local query = "CREATE TABLE awarn_warnings ( pid INTEGER PRIMARY KEY AUTOINCREMENT, unique_id varchar(255), admin varchar(255), reason text, date varchar(255) )"
		result = sql.Query(query)
		ServerLog( "AWarn: Creating Warning Table...\n" )
		if sql.TableExists("awarn_warnings") then
			ServerLog( "AWarn: Warning Table created sucessfully.\n" )
		else
			ServerLog( "AWarn: Trouble creating the Warning Table\n" )
			ServerLog( "AWarn: " .. sql.LastError( result ).."\n" )
		end
	end
	
	if sql.TableExists("awarn_playerdata") then
		ServerLog( "AWarn: Player Data Table Exists\n" )
	else
		local query = "CREATE TABLE awarn_playerdata ( unique_id varchar(255), warnings INTEGER, lastwarn varchar(255) )"
		result = sql.Query(query)
		ServerLog( "AWarn: Creating Player Data Table...\n" )
		if sql.TableExists("awarn_playerdata") then
			ServerLog( "AWarn: Player Data Table created sucessfully.\n" )
		else
			ServerLog( "AWarn: Trouble creating the Player Data Table\n" )
			ServerLog( "AWarn: " .. sql.LastError( result ).. "\n" )
		end
	end
	
	if sql.TableExists("awarn_serverdata") then
		ServerLog( "AWarn: Server Data Table Exists\n" )
	else
		local query = "CREATE TABLE awarn_serverdata ( key TEXT, val INTEGER )"
		result = sql.Query(query)
		ServerLog( "AWarn: Creating Server Data Table...\n" )
		if sql.TableExists("awarn_serverdata") then
			ServerLog( "AWarn: Server Data Table created sucessfully.\n" )
		else
			ServerLog( "AWarn: Trouble creating the Server Data Table\n" )
			ServerLog( "AWarn: " .. sql.LastError( result ).. "\n" )
		end
	end
end


function awarn_reloadtables()
	if sql.TableExists("awarn_warnings") then
		local query = "DROP TABLE awarn_warnings"
		result = sql.Query(query)
	end
	if sql.TableExists("awarn_playerdata") then
		local query = "DROP TABLE awarn_playerdata"
		result = sql.Query(query)
	end
	awarn_tbl_exist()
end

function awarn_saveservervalue( key, val )
	--print( key .. " " .. val )
	local query = "SELECT * FROM awarn_serverdata WHERE key='" .. key .. "'"
	result = sql.QueryRow(query)
	
	--PrintTable(result)

	if not result then
		local query = "INSERT INTO awarn_serverdata VALUES ( '" ..key.. "', '" .. val .. "' )"
		result = sql.Query(query)
		SetGlobalInt( key, val )
		net.Start("AWarnChatMessage") net.WriteTable({ Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Value ", Color(0,0,0), "(" .. key .. ") ", Color(255,255,255), "has been set to ", Color(0,0,0), "(" .. val .. ")" }) net.Broadcast()
		if not result then
			ServerLog( "AWarn: Server Setting (" .. key .. ") set to " .. val .. "\n")
		else
			ServerLog( "AWarn: Problem setting value for (" .. key .. ")\n")
			ServerLog( "AWarn: " .. sql.LastError( result ).. "\n" )
		end
	else
		local query = "UPDATE awarn_serverdata SET val='" .. val .. "' WHERE key='" ..key.. "'"
		result = sql.Query(query)
		SetGlobalInt( key, val )
		net.Start("AWarnChatMessage") net.WriteTable({ Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Value ", Color(0,0,0), "(" .. key .. ") ", Color(255,255,255), "has been set to ", Color(0,0,0), "(" .. val .. ")" }) net.Broadcast()
		if not result then
			ServerLog( "AWarn: Server Setting (" .. key .. ") set to " .. val .. "\n")
		else
			ServerLog( "AWarn: Problem setting value for (" .. key .. ")\n")
			ServerLog( "AWarn: " .. sql.LastError( result ).. "\n" )
		end
	end
end


function awarn_setserverdefaultvalues()

	for k, v in pairs( AWarn.DefaultValues ) do
		local query = "SELECT * FROM awarn_serverdata WHERE key='" .. k .. "'"
		result = sql.QueryRow(query)
		
		if result then
			awarn_saveservervalue( k, result.val )
		else
			awarn_saveservervalue( k, v )
		end
	end

end
hook.Add( "InitPostEntity", "AWarn_SetServerDefaults", awarn_setserverdefaultvalues )

function awarn_addwarning( uid, reason, admin )
	reason = sql.SQLStr( reason )
	admin = sql.SQLStr( admin )
	date = os.date()
	local query = "INSERT INTO awarn_warnings VALUES (NULL, '" ..uid.. "', " ..admin.. ", " ..reason.. ", '" ..date.. "')"
	--print(query)
	result = sql.Query(query)
end

function awarn_incwarnings( ply )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		wnum = 1
		local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
		result = sql.Query(query)
	else
		wnum = tonumber(result.warnings) + 1
		local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
	end
	
	awarn_checkkickban( ply )
	awarn_decaywarns( ply )
end

function awarn_incwarningsid( uid )
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		wnum = 1
		local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
		result = sql.Query(query)
	else
		wnum = tonumber(result.warnings) + 1
		local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
	end

end

function awarn_decwarnings( ply, admin )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		if admin then AWSendMessage(admin, "AWarn: This player has no warnings on record") end
	else
		if tonumber(result.warnings) > 0 then
			wnum = tonumber(result.warnings) - 1
			local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
			result = sql.Query(query)
            AWSendMessage( admin, "AWarn: Reduced " .. ply:Nick() .. "'s active warnings by 1!")
		else
			if admin then AWSendMessage(admin, "AWarn: This player has 0 active warnings already") end
		end
	end
end

function awarn_decwarningsid( uid, admin )
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		if admin then AWSendMessage(admin, "AWarn: This player has no warnings on record") end
	else
		if tonumber(result.warnings) > 0 then
			wnum = tonumber(result.warnings) - 1
			local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
			result = sql.Query(query)
            AWSendMessage( admin, "AWarn: Reduced " .. tostring(uid) .. "'s active warnings by 1!")
		else
			if admin then AWSendMessage(admin, "AWarn: This player has 0 active warnings already") end
		end
	end
end

function awarn_setwarnings( ply, num )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. num .. "', '" .. os.time() .."' )"
		result = sql.Query(query)
	else
		local query = "UPDATE awarn_playerdata SET warnings='" .. num .. "' WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
	end
end

function awarn_delwarnings( ply, admin )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	if not result then
		AWSendMessage(admin, "AWarn: This player has no warnings on record")
	else
		local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)

		local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
		
		AWSendMessage(admin, "AWarn: Cleared all warnings for player: " .. ply:Nick() )
	end
end

function awarn_delwarnings( ply, admin )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	if not result then
		AWSendMessage(admin, "AWarn: This player has no warnings on record")
	else
		local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)

		local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
		
		AWSendMessage(admin, "AWarn: Cleared all warnings for player: " .. ply:Nick() )
	end
end

function awarn_delwarningsid( uid, admin )

	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	if not result then
		AWSendMessage(admin, "AWarn: This player has no warnings on record")
	else
		local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)

		local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
		result = sql.Query(query)
		
		AWSendMessage(admin, "AWarn: Cleared all warnings for player: " .. tostring(uid) )
	end
end

function awarn_delsinglewarning( admin, warningid )

	local query = "SELECT * FROM awarn_warnings WHERE pid=" .. warningid
	result = sql.QueryRow(query)
	
	if not result then
		AWSendMessage(admin, "AWarn: Record for this warning ID not found")
		return
	end

	local query = "DELETE FROM awarn_warnings WHERE pid=" .. warningid
	result = sql.Query( query )

end

function awarn_getwarnings( ply )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local wnum = 0
	
	if not result then
		wnum = 0
	else
		wnum = result.warnings
	end
	
	
	return tonumber(wnum)
end

function awarn_getlastwarn( ply )
	local uid = ply:SteamID64()
	
	local query = "SELECT lastwarn FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	result = sql.QueryRow(query)
	
	local lastwarn = "NONE"
	
	if not result then
		lastwarn = "NONE"
	else
		lastwarn = result.lastwarn
	end
	
	return tostring(lastwarn)
end

function awarn_sendwarnings( ply, target_ply )
	local uid = target_ply:SteamID64()
	local warns = awarn_getwarnings( target_ply )
	
	local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
	result = sql.Query(query)
	
	--print(warns)
	if result then
		net.Start("SendPlayerWarns")
			net.WriteTable( result )
			net.WriteInt( warns, 32 )
		net.Send( ply )
	else
		result = {}
		net.Start("SendPlayerWarns")
			net.WriteTable( result )
			net.WriteInt( warns, 32 )
		net.Send( ply )
	end
end

function awarn_gettotalwarnings( ply )
	local uid = ply:SteamID64()
	local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
	result = sql.Query( query )
	
	if result then
		return #result
	else
		return 0
	end
end

function awarn_sendownwarnings( ply, target_ply )
	local uid = ply:SteamID64()
	local warns = awarn_getwarnings( ply )
	
	local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
	result = sql.Query(query)
	
	--print(warns)
	if result then
		net.Start("SendOwnWarns")
			net.WriteTable( result )
			net.WriteInt( warns, 32 )
		net.Send( ply )
	else
		result = {}
		net.Start("SendOwnWarns")
			net.WriteTable( result )
			net.WriteInt( warns, 32 )
		net.Send( ply )
	end
end
