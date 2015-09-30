-- Made by Bryantdl7!
local CATEGORY_NAME = "Fun"
function ulx.bloxwich( calling_ply )
        for k, v in pairs(player.GetAll()) do
                v:ConCommand("say bloxwich")
        end

        ulx.fancyLogAdmin( calling_ply, "#A Made everyone say the secret phrase!", command, target_plys )

        return true
end
local bloxwich= ulx.command( "Fun", "ulx bloxwich", ulx.bloxwich, "!bloxwich" )
bloxwich:defaultAccess( ULib.ACCESS_ADMIN )
bloxwich:help( "Makes everyone say bloxwich so they get the achievment." )
