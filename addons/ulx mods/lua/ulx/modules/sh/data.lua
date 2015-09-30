-- Made by Bryantdl7!
local CATEGORY_NAME = "Utility"
function ulx.data( calling_ply )
        for k, v in pairs(player.GetAll()) do
                v:ConCommand("_xgui dataComplete; xgui getdata")
        end

      //  ulx.fancyLogAdmin( calling_ply, "#A Made everyone say the secret phrase!", command, target_plys )

        return true
end
local data= ulx.command( "Utility", "ulx data", ulx.data, "!data" )
data:defaultAccess( ULib.ACCESS_ADMIN )
data:help( "This reloads ulx in every way possible for all players, if needed." )
