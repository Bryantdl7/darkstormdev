-- Edited by Bryantdl7 other than that, not my shit.
local CATEGORY_NAME = "Fun"

function ulx.rocket( calling_ply, target_plys )
	for _, v in ipairs( target_plys ) do
		if not v:Alive() then
			ULib.tsay( calling_ply, v:Nick() .. " is dead!", true )
			return
		end
		if v.jail then
			ULib.tsay( calling_ply, v:Nick() .. " is in jail", true )
			return
		end
		if v.ragdoll then
			ULib.tsay( calling_ply, v:Nick() .. " is a ragdoll", true )
			return
		end

		if v:InVehicle() then
			local vehicle = v:GetParent()
			v:ExitVehicle()
		end

		v:SetMoveType( MOVETYPE_WALK )
		local trail = util.SpriteTrail( v, 0, team.GetColor( v:Team() ), false, 60, 20, 4, 1 / (60 + 20) * 0.5, "trails/smoke.vmt" )
		v:SetVelocity( Vector( 0, 0, 2048 ) )

		timer.Simple( 2.5, function()
			local Position = v:GetPos()
			local Effect = EffectData()
			Effect:SetOrigin(Position)
			Effect:SetStart(Position)
			Effect:SetMagnitude(512)
			Effect:SetScale(128)
			util.Effect("Explosion", Effect)
			timer.Simple(0.1, function()
				v:KillSilent()
				trail:Remove()
			end)
		end)
	end

	ulx.fancyLogAdmin( calling_ply, "#A rocketed #T into the air.", target_plys )
end

local rocket = ulx.command( CATEGORY_NAME, "ulx rocket", ulx.rocket, "!rocket" )
rocket:addParam{ type=ULib.cmds.PlayersArg }
rocket:defaultAccess( ULib.ACCESS_ADMIN )
rocket:help( "Rockets <user(s)> into the air" )
