-- ULX Clear Decals for ULX SVN/ULib SVN by .:RynO-SauruS:. edited by Bryantdl7 to be user friendly.
local CATEGORY_NAME = "Utility"
function ulx.decals( calling_ply )
        for k, v in pairs(player.GetAll()) do
                v:ConCommand("r_cleardecals")
        end

        ulx.fancyLogAdmin( calling_ply, "#A cleared all decals", command, target_plys )

        return true
end
local decals= ulx.command( "Utility", "ulx decals", ulx.decals, "!decals" )
decals:defaultAccess( ULib.ACCESS_ADMIN )
decals:help( "Clears all decals." )
