-- place in addons/ULX/lua/ulx/modules/sh/crash.lua
 
-- lol, why I made this I don't know.
 
local function ulx_CrashTheGuy( slayer, ply, comment )
 
        ply:SendLua("cam.End3D()")
 
end
 
local CATEGORY_NAME = "Evil"
 
local function ulx_lolcrash( ply, target, comment )
        if not comment or comment == "" or comment == "StringArg" then
               -- ulx.fancyLogAdmin( ply, "#A crashed #T without a reason.", target )
                pcall( ulx_CrashTheGuy, ply, target, "" )
        else
               -- ulx.fancyLogAdmin( ply, "#A crashed #T with the reason #s", target, comment )
                pcall( ulx_CrashTheGuy, ply, target, comment )
        end
end
 
local lolcrash = ulx.command( CATEGORY_NAME, "ulx crash", ulx_lolcrash, "!crash" )
lolcrash:defaultAccess( ULib.ACCESS_SUPERADMIN )
lolcrash:help( "Crashes the victim's game." )
lolcrash:addParam{ type=ULib.cmds.PlayerArg }
lolcrash:addParam{ type=ULib.cmds.StringArg, ULib.cmds.optional, ULib.cmds.takeRestOfLine }