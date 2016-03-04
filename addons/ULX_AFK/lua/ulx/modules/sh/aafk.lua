CreateConVar("ulx_afk_flagminutes", 8, FCVAR_ARCHIVE, "How many minutes an player can be AFK before being flagged as AFK.")
CreateConVar("ulx_afk_kickminutes", 10, FCVAR_ARCHIVE, "How many minutes an player can be AFK before being kicked.")
CreateConVar("ulx_afk_ignoreadmins", 0, FCVAR_ARCHIVE, "Should we ignore AFK admins? (1=yes, 0=no).")
CreateConVar("ulx_afk_kickonafk", 1, FCVAR_ARCHIVE, "Should AFK players be kicked from the server at all? (1=yes, 0=no).")
CreateConVar("ulx_afk_kickonlywhenfull", 0, FCVAR_ARCHIVE, "Should the script only kick afk players when the server is full? (1=yes, 0=no).")

if SERVER then
	function ulx.CheckAFK( pl )

		if pl:IsAdmin() and GetConVarNumber( "ulx_afk_ignoreadmins" ) == 1 then
			return
		end

		local afk_kth = GetConVarNumber( "ulx_afk_kickminutes" )

		if not IsValid( pl ) then return end
		if not pl:IsConnected() then return end
		
		if pl.lpos == nil then
			pl.lpos = pl:GetPos()
			pl.lang = pl:GetAngles()
			pl.afk = false
			return
		end
		
		if pl.afkc == nil then
			pl.afkc = 0
		end
		
		if ( pl:GetPos() == pl.lpos) and ( pl:GetAngles() == pl.lang ) then
			pl.afkc = pl.afkc + 1
		else
			pl.afkc = 0
			pl.afk = false
			pl.lpos = pl:GetPos()
			pl.lang = pl:GetAngles()
			return
		end
		
		if pl.afkc >= GetConVarNumber( "ulx_afk_flagminutes" ) then
			if pl.afk == false then
				pl.afk = true
				ulx.fancyLogAdmin( pl, "#A went AFK!" )
				ULib.tsayColor(_, Color(0,0,0,255), "[AAFK] ", team.GetColor(pl:Team()), pl:Nick(), Color(255,255,255), " went ", Color(255,0,0,255), "AFK.")
			end
		end

		if ( pl.afkc >= afk_kth ) and ( GetConVarNumber( "ulx_afk_kickonafk" ) ) then
			if ( #player.GetAll() < game.MaxPlayers() ) and ( GetConVarNumber( "ulx_afk_kickonlywhenfull" ) == 1 ) then
				return
			end
			ULib.kick( pl, "AFK: Exceeding the allowed AFK time!" )
		end

	end

	function ulx.AFKTimer( pl )

		local PID = pl:SteamID64()
		pl.afkc = 0
		pl.afk = false
		pl:SetNWBool("afk", false)
		pl.lpos = pl:GetPos()
		pl.lang = pl:GetAngles()
		timer.Create("ulx_afk_" .. PID, 60, 0, function() ulx.CheckAFK( pl ) end )

	end
	hook.Add( "ULibLocalPlayerReady", "AFKTimer", ulx.AFKTimer )

	function ulx.ResetAFKStatus( pl )

		if pl.lpos == nil then
			pl.lpos = pl:GetPos()
			pl.lang = pl:GetAngles()
			pl.afk = false
			return
		end
		
		pl.afkc = 0
		pl.afk = false
		pl:SetNWBool("afk", false)
		pl.lpos = pl:GetPos()
		pl.lang = pl:GetAngles()
		
		ulx.fancyLogAdmin( pl, "#A returned from being AFK!" )
		ULib.tsayColor(_, Color(0,0,0,255), "[AAFK] ", team.GetColor(pl:Team()), pl:Nick(), Color(255,255,255), " returned from being ", Color(255,0,0,255), "AFK.")
		
	end


	function ulx.AFKExit_Chat( pl )
		if pl.afk == false then return end
		
		if not IsValid( pl ) then return end
		if not pl:IsConnected() then return end
		ulx.ResetAFKStatus( pl )
		print("1")
		
	end
	hook.Add("PlayerSay", "AFKExit_Chat", ulx.AFKExit_Chat)
	
	function ulx.AFKExit_KeyPress( pl )
		if pl.afk == false then return end
		
		if not IsValid( pl ) then return end
		if not pl:IsConnected() then return end
		ulx.ResetAFKStatus( pl )
		print("2")
	end
	hook.Add("KeyPress", "AFKExit_KeyPress", ulx.AFKExit_KeyPress)
	
	function ulx.AFKExit_Move( pl )
		if pl.afk == false then return end
		
		if not IsValid( pl ) then return end
		if not pl:IsConnected() then return end
		ulx.ResetAFKStatus( pl )
		print("2")
	end
	hook.Add("PlayerFootstep", "AFKExit_Move", ulx.AFKExit_Move)
end

if CLIENT then
	surface.CreateFont( "SGS_HUD3", {
		font	=	"tahoma",
		size	=	14,
		weight	=	600
		}
	)
	local enablenames = true
	local enabletitles = true
	local textalign = 1
	local distancemulti = 0.6
	
	function DrawAFKStatus()

		local vStart = LocalPlayer():GetPos()
		local vEnd

		for k, v in pairs(player.GetAll()) do
		
			if v:GetNWBool("afk", false) == false then continue end

			local vStart = LocalPlayer():GetPos()
			local vEnd = v:GetPos() + Vector(0,0,25)
			local trace = {}
			
			trace.start = vStart
			trace.endpos = vEnd
			local trace = util.TraceLine( trace )
			
			if trace.HitWorld then
				local mepos = LocalPlayer():GetPos()
				local tpos = v:GetPos()
				local tdist = mepos:Distance(tpos)
				if tdist <= 2000 then
				
					local zadj = 0.03334 * tdist
					local pos = v:GetPos() + Vector(0,0,v:OBBMaxs().z + 5 + zadj)
					pos = pos:ToScreen()
					draw.RoundedBoxEx( 2, pos.x - 4, pos.y - 4, 8, 8, Color(255,0,0,255), true, true, true, true )

				end
			else
				local mepos = LocalPlayer():GetPos()
				local tpos = v:GetPos()
				local tdist = mepos:Distance(tpos)
				
				if tdist <= 600 then
					local zadj = 0.03334 * tdist
					local pos = v:GetPos() + Vector(0,0,v:OBBMaxs().z + 5 + zadj)
					pos = pos:ToScreen()
					
					if v != LocalPlayer() then
						draw.SimpleTextOutlined( "[AFK]", "SGS_HUD3", pos.x, pos.y - 8 , Color(255,0,0,255), textalign, 1,1,Color(0,0,0,255))
						draw.SimpleTextOutlined( v:Name(), "SGS_HUD3", pos.x, pos.y - 23 , Color(255,0,0,255), textalign, 1,1,Color(0,0,0,255))
					end
				elseif tdist > 600 and tdist <= 2000 then
				
					local zadj = 0.03334 * tdist
					local pos = v:GetPos() + Vector(0,0,v:OBBMaxs().z + 5 + zadj)
					pos = pos:ToScreen()
					draw.RoundedBoxEx( 2, pos.x - 4, pos.y - 4, 8, 8, Color(255,0,0,255), true, true, true, true )

				end
			end
		end
	end
	hook.Add("HUDPaint", "DrawAFKStatus", DrawAFKStatus)
end