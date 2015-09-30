local DATABASE_HOST = "127.0.0.1"
local DATABASE_PORT = 3306
local DATABASE_NAME = "awarn"
local DATABASE_USERNAME = "root"
local DATABASE_PASSWORD = ""

--[[
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!
DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!DO NOT EDIT ANYTHING BELOW THIS UNLESS YOU KNOW WHAT YOU ARE DOING!!!!3
.
]]

AWarnDB = {}

function AWarnDB_Init()
	
	AWarnDB_ConnectToDatabase()
	timer.Simple(60, AWarnDB_Init )
	
end
hook.Add( "Initialize", "AWarnDB_Init", AWarnDB_Init )

function AWarnDB_Format( str )
	if not str then return "NULL" end
	return string.format( "%q", str )
end

function Escape( str )
	if not AWarnDB.db then
		Msg( "Not connected to DB.\n" )
		return
	end
	
	if not str then return end

	local esc = AWarnDB.db:escape( str )
	if not esc then
		return nil
	end
	return "'" .. esc .. "'"
end


function AWarnDB_ConnectToDatabase()
	if not IsValid(AWarnDB.db) then
		AWarnDB.db = mysqloo.connect( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT )
		AWarnDB.db:connect()
		return
	end
	
	if AWarnDB.db:status() ~= 0 then
		AWarnDB.db = mysqloo.connect( DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD, DATABASE_NAME, DATABASE_PORT )
		AWarnDB.db:connect()
		return
	end
end



local PlayerMeta = FindMetaTable("Player")

function awarn_tbl_exist()
	
	print(AWarnDB.db:status())
	if AWarnDB.db:status() ~= 0 then
		ServerLog("AWarn: Database Object not created. Trying again...\n")
		timer.Simple(0.5, function() awarn_tbl_exist() end )
		return
	end

	local db = AWarnDB.db
	
	print(db:status())
	
	local query = "CREATE TABLE IF NOT EXISTS awarn_warnings ( pid INTEGER AUTO_INCREMENT, unique_id VARCHAR(255), admin VARCHAR(255), reason TEXT, date VARCHAR(255), PRIMARY KEY(pid) )"
	local q = AWarnDB.db:query( query )
	function q:onSuccess( data )
		ServerLog("AWarn: Checked existance of awarn_warnings table. Table exists or was created!\n")
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() awarn_tbl_exist() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
	
	local query = "CREATE TABLE IF NOT EXISTS awarn_playerdata ( unique_id VARCHAR(255), warnings INTEGER, lastwarn VARCHAR(255) )"
	local q = AWarnDB.db:query( query )
	function q:onSuccess( data )
		ServerLog("AWarn: Checked existance of awarn_playerdata table. Table exists or was created!\n")
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() awarn_tbl_exist() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()

	local query = "CREATE TABLE IF NOT EXISTS awarn_serverdata ( k TEXT, val INTEGER )"
	local q = AWarnDB.db:query( query )
	function q:onSuccess( data )
		ServerLog("AWarn: Checked existance of awarn_serverdata table. Table exists or was created!\n")
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() awarn_tbl_exist() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
	
	
	awarn_setserverdefaultvalues()
end

function awarn_saveservervalue( key, val )
	local db = AWarnDB.db
	
	if db == nil then 
		AWarnDB_ConnectToDatabase()
		return 
	end

	local query = "SELECT * FROM awarn_serverdata WHERE k='" .. key .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		if #data ~= 1 then
			local query = "INSERT INTO awarn_serverdata VALUES ( '" ..key.. "', '" .. val .. "' )"
			SetGlobalInt( key, val )
			net.Start("AWarnChatMessage") net.WriteTable({ Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Value ", Color(0,0,0), "(" .. key .. ") ", Color(255,255,255), "has been set to ", Color(0,0,0), "(" .. val .. ")" }) net.Broadcast()
			local q = db:query( query )
			function q:onSuccess( data )
				ServerLog( "AWarn: Server Setting (" .. key .. ") set to " .. val .. "\n")
			end
			function q:onError( err )
				ServerLog( "AWarn: Problem setting value for (" .. key .. ")\n")
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
			end
			q:start()
		else
			local query = "UPDATE awarn_serverdata SET val='" .. val .. "' WHERE k='" ..key.. "'"
			SetGlobalInt( key, val )
			net.Start("AWarnChatMessage") net.WriteTable({ Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), "Value ", Color(0,0,0), "(" .. key .. ") ", Color(255,255,255), "has been set to ", Color(0,0,0), "(" .. val .. ")" }) net.Broadcast()
			local q = db:query( query )
			function q:onSuccess( data )
				ServerLog( "AWarn: Server Setting (" .. key .. ") set to " .. val .. "\n")
			end
			function q:onError( err )
				ServerLog( "AWarn: Problem setting value for (" .. key .. ")\n")
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
			end
			q:start()		
		end
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
	
end


function awarn_setserverdefaultvalues()
	local db = AWarnDB.db

	for k, v in pairs( AWarn.DefaultValues ) do
		local query = "SELECT * FROM awarn_serverdata WHERE k='" .. k .. "'"
		local q = db:query( query )
		function q:onSuccess( data )
			
			if #data == 1 then
				awarn_saveservervalue( k, data[1].val )
			else
				awarn_saveservervalue( k, v )
			end
		end
		function q:onError( err )
			if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
				ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
				timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
			end
			ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
		end
		q:start()
	end

end

function awarn_addwarning( uid, reason, admin )
	local db = AWarnDB.db
	reason = Escape( reason )
	admin = Escape( admin )
	date = os.date()
	
	local query = "INSERT INTO awarn_warnings VALUES (NULL, '" ..uid.. "', " ..admin.. ", " ..reason.. ", '" ..date.. "')"
	print(query)
	local q = db:query( query )
	function q:onError(err)
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_incwarnings( ply )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		local wnum = 0
		
		if #data == 0 then
			wnum = 1
			local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		else
			wnum = tonumber(data[1].warnings) + 1
			local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		end
	
		awarn_checkkickban( ply )
		awarn_decaywarns( ply )
	
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_incwarningsid( uid )
	local db = AWarnDB.db
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		local wnum = 0
		
		if #data == 0 then
			wnum = 1
			local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		else
			wnum = tonumber(data[1].warnings) + 1
			local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		end
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_decwarnings( ply, admin )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		local wnum = 0
		
		if #data == 0 then
			if admin then AWSendMessage(admin, "AWarn: This player has no warnings on record") end
		else
			if tonumber(data[1].warnings) > 0 then
				wnum = tonumber(data[1].warnings) - 1
				local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
				local q = db:query( query )
				function q:onError( err )
					if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
						ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
						timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
					end
					ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
				end
				q:start()
				AWSendMessage( admin, "AWarn: Reduced " .. ply:Nick() .. "'s active warnings by 1!")
			else
				if admin then AWSendMessage(admin, "AWarn: This player has 0 active warnings already") end
			end
		end
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_decwarningsid( uid, admin )
	local db = AWarnDB.db
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
	
		local wnum = 0
		if #data == 0 then
			if admin then AWSendMessage(admin, "AWarn: This player has no warnings on record") end
		else
			if tonumber(data[1].warnings) > 0 then
				wnum = tonumber(data[1].warnings) - 1
				local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
				local q = db:query( query )
				function q:onError( err )
					if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
						ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
						timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
					end
					ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
				end
				q:start()
				AWSendMessage( admin, "AWarn: Reduced " .. tostring(uid) .. "'s active warnings by 1!")
			else
				if admin then AWSendMessage(admin, "AWarn: This player has 0 active warnings already") end
			end
		end
	
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_setwarnings( ply, num )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		local wnum = 0
		
		if #data == 0 then
			local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. num .. "', '" .. os.time() .."' )"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		else
			local query = "UPDATE awarn_playerdata SET warnings='" .. num .. "' WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
		end
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_delwarnings( ply, admin )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
	
		if #data == 0 then
			AWSendMessage(admin, "AWarn: This player has no warnings on record")
		else
			local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
			
			local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
			
			AWSendMessage(admin, "AWarn: Cleared all warnings for player: " .. ply:Nick() )
		end
	
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_delwarningsid( uid, admin )
	local db = AWarnDB.db

	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		if #data == 0 then
			AWSendMessage(admin, "AWarn: This player has no warnings on record")
		else
			local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
			
			local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
			local q = db:query( query )
			function q:onError( err )
				if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
					ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
					timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
				end
				ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
			end
			q:start()
			
			AWSendMessage(admin, "AWarn: Cleared all warnings for player: " .. tostring(uid) )
		end
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
end

function awarn_getwarnings( ply )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
		local wnum = 0
		
		if #data == 0 then
			wnum = 0
		else
			wnum = data[1].warnings
		end
		
		return tonumber( wnum )
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()

	return 0
end

function awarn_getlastwarn( ply )
	local db = AWarnDB.db
	local uid = ply:SteamID64()
	
	local query = "SELECT lastwarn FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	local q = db:query( query )
	function q:onSuccess( data )
	
		local lastwarn = "NONE"
		
		if #data == 0 then
			lastwarn = "NONE"
		else
			lastwarn = data[1].lastwarn
		end
		
		return tostring( lastwarn )
	end
	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			ServerLog("AWarn: Database not connected! Retrying connection in 3 seconds.\n")
			timer.Simple( 3, function() AWarnDB_ConnectToDatabase() end )
		end
		ServerLog("AWarn: SQL Error - " .. err .. " on sql: " .. query .. "\n")
	end
	q:start()
	
	return "NONE"
end

function awarn_sendwarnings( ply, target_ply )
	local db = AWarnDB.db
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
	local db = AWarnDB.db
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
	local db = AWarnDB.db
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
