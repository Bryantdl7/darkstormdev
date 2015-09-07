// server side apple
AddCSLuaFile( "cl_player.lua"  )

//Spawn
function FirstSpawn( ply )
	timer.Simple( 3, function()
	if !ply:IsValid() then return end
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			if ply:IsBot() then return end
			umsg.Start( "player_spawn", v)
				umsg.String(ply:Nick())
				umsg.Short(ply:Team())
				umsg.String(ply:IPAddress())
			umsg.End()
			else
			umsg.Start( "player_spawn2", v)
				umsg.String(ply:Nick())
				umsg.Short(ply:Team())
			umsg.End()
		end
	end
Msg("Player " .. ply:Nick() .. " has joined the server.\n")
end)
end
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", FirstSpawn )

 
//Disconnect
function PlayerDisconnect( ply )
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			if ply:IsBot() then return end
			umsg.Start( "player_disconnect", v)
			umsg.String(ply:Nick())
			umsg.Short(ply:Team())
			umsg.String(ply:IPAddress())
			umsg.End()
		else
			umsg.Start( "player_disconnect2", v)
			umsg.String(ply:Nick())
			umsg.Short(ply:Team())
			umsg.End()
		end
	end
Msg("Player " .. ply:Nick() .. " has left the server.\n")
end
hook.Add( "PlayerDisconnected", "playerDisconnected", PlayerDisconnect )


if SERVER then
local YOUR_VERSION = "1.06"
local PLY2 = "100"
local ADDON_NAME = "join_disconnect"
local ADDON_ACTUAL_NAME = "apple_join_disconnect_warning"
local DOWNLOAD_LINK = "http://goo.gl/VitT7Z"
local MESSAGE_TO_SERVER = "APPLE'S JOIN/DISCONNECT MESSAGE"

hook.Add('PlayerInitialSpawn','PlayerInitialSpawn'..ADDON_NAME, function(ply)
if ply:IsSuperAdmin() == false then return end
http.Fetch( "https://gmod-development.googlecode.com/svn/branches/"..ADDON_NAME..".txt", function( body, len, headers, code )
if body == nil then return end
local body = string.Explode(" ",body)
	if body[1] != "Version" then return end
	if body[2] != YOUR_VERSION then
	if ply:GetPData(ADDON_NAME..""..PLY2) != nil then
		if ply:GetPData(ADDON_NAME..""..PLY2) != "1" then
			umsg.Start(ADDON_NAME, ply)
				umsg.String(YOUR_VERSION)
				umsg.String(body[2])
				umsg.String(ADDON_ACTUAL_NAME)
				umsg.String(DOWNLOAD_LINK)
			umsg.End()
		end
			MsgN("~"..MESSAGE_TO_SERVER.."~")
			MsgC(Color(255,255,255,255),"Your Version: ",Color(255,0,0,255),YOUR_VERSION,"\n")
			MsgC(Color(255,255,255,255),"Online Version: ",Color(255,0,0,255),body[2],"\n")
			MsgC(Color(255,0,0,255),"OUT OF DATE","\n")
			MsgN("We here at Apple Inc. strongly suggest that you keep this addon updated")
			MsgN("Please go here and update: "..DOWNLOAD_LINK)
		end
	end
end, 
function( error )
	MsgN("DOESNOT WORK")
end)
end)
net.Receive( ADDON_NAME, function( length, client )
	net.ReadEntity():SetPData(ADDON_NAME..""..PLY2,"1")
end )
util.AddNetworkString( ADDON_NAME )
end
