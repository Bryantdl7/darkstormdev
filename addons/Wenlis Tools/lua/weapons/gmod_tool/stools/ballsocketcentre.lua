// Ball Socket Centre tool - by Wenli

TOOL.Category = "Constraints"
TOOL.Name = "#Ball Socket - Centre"
TOOL.Command = nil
TOOL.ConfigName = nil

TOOL.ClientConVar[ "forcelimit" ] = 0
TOOL.ClientConVar[ "torquelimit" ] = 0
TOOL.ClientConVar[ "nocollide" ] = 0
TOOL.ClientConVar[ "moveprop" ] = 0
TOOL.ClientConVar[ "simpleballsocket" ] = 0
TOOL.ClientConVar[ "rotationonly" ] = 0

TOOL.ClientConVar[ "CXRotMin" ]		= "-180"
TOOL.ClientConVar[ "CXRotMax" ]		= "180"
TOOL.ClientConVar[ "CYRotMin" ]		= "-180"
TOOL.ClientConVar[ "CYRotMax" ]		= "180"
TOOL.ClientConVar[ "CZRotMin" ]		= "-180"
TOOL.ClientConVar[ "CZRotMax" ]		= "180"
TOOL.ClientConVar[ "CXRotFric" ]	= "0"
TOOL.ClientConVar[ "CYRotFric" ]	= "0"
TOOL.ClientConVar[ "CZRotFric" ]	= "0"

if CLIENT then
	language.Add("ballsocketcentre","Ball Socket - Centre" )
	language.Add("Tool_ballsocketcentre_name","Centre Ball Socket Constraint")
	language.Add("Tool_ballsocketcentre_desc", "Ball socket props by centre of mass" )
	language.Add("Tool_ballsocketcentre_0", "Left Click: Select prop to ball socket." )
	language.Add("Tool_ballsocketcentre_1", "Left Click: Select base prop to ball socket to." )
	language.Add("Tool_ballsocketcentre_nocollide", "Nocollide" )
	language.Add("Tool_ballsocketcentre_simpleballsocket", "Simple Ball Socket (ignore adv settings)" )
	language.Add("Tool_ballsocketcentre_rotationonly", "Rotation Constraint" )
	language.Add("Tool_ballsocketcentre_moveprop", "Move first prop (remember to nocollide!)" )
	language.Add("Undone_ballsocketcentre","Undone Ball Socket Centre")
end

function TOOL:LeftClick( trace )
	if trace.Entity:IsPlayer() then return false end
	if SERVER and !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) then return false end
	
	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	// Can't select world as first object
	if iNum == 0 then
		if trace.Entity:IsWorld() then
			self:ClearObjects()
			return false
		end
	end

	if iNum > 0 then
		if CLIENT then
			self:ClearObjects()
			return true
		end
		
		local ply = self:GetOwner()
		
		local forcelimit 		= self:GetClientNumber( "forcelimit", 0 )
		local torquelimit 		= self:GetClientNumber( "torquelimit", 0 )
		local nocollide 		= self:GetClientNumber( "nocollide", 0 )
		local moveprop 			= self:GetClientNumber( "moveprop", 0 )
		local simpleballsocket 	= self:GetClientNumber( "simpleballsocket", 0 )
		local rotationonly		= self:GetClientNumber( "rotationonly", 0 )
		
		local Ent1,  Ent2  = self:GetEnt(1),  self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
		local Phys1, Phys2 = self:GetPhys(1), self:GetPhys(2)
		local WPos1, WPos2 = self:GetPos(1),	self:GetPos(2)
		local LPos1	= Phys1:GetMassCenter()
		local LPos2	= Phys2:GetMassCenter()
		
		if Ent1 == Ent2 then
			self:ClearObjects()
			ply:SendLua( "GAMEMODE:AddNotify('Error: Selected the same prop!',NOTIFY_GENERIC,7);" )
			return true
		end
		
		if moveprop == 1 and !Ent1:IsWorld() and !Ent2:IsWorld() then
			// Move the object so that centres of mass overlap
			local Offset1 = Ent1:LocalToWorld(LPos1) - Ent1:GetPos()
			local Offset2 = Ent2:LocalToWorld(LPos2) - Ent2:GetPos()
			local TargetPos = Ent2:GetPos() + Offset2 - Offset1
			
			Phys1:SetPos( TargetPos )
			Phys1:EnableMotion( false )
			
			// Wake up the physics object so that the entity updates its position
			Phys1:Wake()
		end
		
		if rotationonly == 1 then
			undo.Create("Rotation Constraint")
			local constraint1 = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0, torquelimit, 0, -180, -180, 0, 180, 180, 50, 0, 0, 1, nocollide )
			local constraint2 = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0, torquelimit, -180, 0, -180, 180, 0, 180, 0, 50, 0, 1, nocollide )
			local constraint3 = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0, torquelimit, -180, -180, 0, 180, 180, 0, 0, 0, 50, 1, nocollide )
			
			undo.AddEntity( constraint1 )
			undo.AddEntity( constraint2 )
			undo.AddEntity( constraint3 )
			
			ply:AddCleanup( "constraints", constraint1 )
			ply:AddCleanup( "constraints", constraint2 )
			ply:AddCleanup( "constraints", constraint3 )
			
			ply:SendLua( "GAMEMODE:AddNotify('Rotation Constraint created',NOTIFY_GENERIC,7);" )
		else
			undo.Create("Ballsocket Centre")
			local constraint1
			if simpleballsocket == 1 then
				constraint1 = constraint.Ballsocket( Ent2, Ent1, Bone2, Bone1, LPos1, forcelimit, torquelimit, nocollide )
				undo.AddEntity( constraint1 )
			else
				constraint1 = constraint.AdvBallsocket( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, self:GetClientNumber( "CXRotMin", -180 ), self:GetClientNumber( "CYRotMin", -180 ), self:GetClientNumber( "CZRotMin", -180 ), self:GetClientNumber( "CXRotMax", 180 ), self:GetClientNumber( "CYRotMax", 180 ), self:GetClientNumber( "CZRotMax", 180 ), self:GetClientNumber( "CXRotFric", 0 ), self:GetClientNumber( "CYRotFric", 0 ), self:GetClientNumber( "CZRotFric", 0 ), 0, nocollide )
				undo.AddEntity( constraint1 )
			end
			
			ply:AddCleanup( "constraints", constraint1 )
			ply:SendLua( "GAMEMODE:AddNotify('Ball Socket created',NOTIFY_GENERIC,7);" )
		end
		
		undo.SetPlayer( ply )
		undo.Finish()
		
		Phys1:EnableMotion( false )
		
		self:ClearObjects()
	else
		self:SetStage( iNum + 1 )
	end

	return true
end

function TOOL:Reload( trace )
	if !trace.Entity:IsValid() or trace.Entity:IsPlayer() then return false end
	if CLIENT then return true end
	
	self:SetStage(0)
	return constraint.RemoveConstraints( trace.Entity, "Ballsocket" ) or constraint.RemoveConstraints( trace.Entity, "AdvBallsocket" )
end

function TOOL:Holster( trace )
	self:ClearObjects()	
end
		
function TOOL:RightClick( trace )
end

function TOOL.BuildCPanel( Panel )

		Panel:AddControl("ComboBox",
		{
			Label = "#Presets",
			MenuButton = 1,
			Folder = "ballsocketcentre",
			Options = {},
			CVars =
			{
				[0] = "ballsocketcentre_forcelimit",
				[1] = "ballsocketcentre_torquelimit",
				[0] = "ballsocketcentre_CXRotMin",
				[1] = "ballsocketcentre_CXRotMax",
				[2] = "ballsocketcentre_CYRotMin",
				[3] = "ballsocketcentre_CYRotMax",
				[4] = "ballsocketcentre_CZRotMin",
				[5] = "ballsocketcentre_CZRotMax",
				[6] = "ballsocketcentre_CXRotFric",
				[7] = "ballsocketcentre_CYRotFric",
				[8] = "ballsocketcentre_CZRotFric",
				[9] = "ballsocketcentre_nocollide",
				[10] = "ballsocketcentre_moveprop",
				[11] = "ballsocketcentre_simpleballsocket",
				[12] = "ballsocketcentre_rotationonly"
				}
		})
	Panel:AddControl( "Slider",  { Label	= "Force Limit",
			Type	= "Float",
			Min		= 0,
			Max		= 50000,
			Command = "ballsocketcentre_forcelimit",
			Description = "The amount of force it takes for the constraint to break. 0 means never break."}	 )
			
	Panel:AddControl( "Slider",  { Label	= "Torque Limit",
			Type	= "Float",
			Min		= 0,
			Max		= 50000,
			Command = "ballsocketcentre_torquelimit",
			Description = "The amount of torque it takes for the constraint to break. 0 means never break."}	 )
			
	Panel:AddControl( "Slider",  { Label	= "X Rotation Minimum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CXRotMin",
			Description = "Rotation minimum of advanced ballsocket in X axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "X Rotation Maximum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CXRotMax",
			Description = "Rotation maximum of advanced ballsocket in X axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Y Rotation Minimum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CYRotMin",
			Description = "Rotation minimum of advanced ballsocket in Y axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Y Rotation Maximum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CYRotMax",
			Description = "Rotation maximum of advanced ballsocket in Y axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Z Rotation Minimum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CZRotMin",
			Description = "Rotation minimum of advanced ballsocket in Z axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Z Rotation Maximum",
			Type	= "Float",
			Min		= -180,
			Max		= 180,
			Command = "ballsocketcentre_CZRotMax",
			Description = "Rotation maximum of advanced ballsocket in Z axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "X Rotation Friction",
			Type	= "Float",
			Min		= 0,
			Max		= 100,
			Command = "ballsocketcentre_CXRotFric",
			Description = "Rotation friction of advanced ballsocket in X axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Y Rotation Friction",
			Type	= "Float",
			Min		= 0,
			Max		= 100,
			Command = "ballsocketcentre_CYRotFric",
			Description = "Rotation friction of advanced ballsocket in Y axis"}	 )

	Panel:AddControl( "Slider",  { Label	= "Z Rotation Friction",
			Type	= "Float",
			Min		= 0,
			Max		= 100,
			Command = "ballsocketcentre_CZRotFric",
			Description = "Rotation friction of advanced ballsocket in Z axis"}	 )

	Panel:AddControl("Header",{Text = "#Tool_ballsocketcentre_name", Description	= "#Tool_ballsocketcentre_desc"})	
	Panel:AddControl("CheckBox",{Label = "#Tool_ballsocketcentre_nocollide", Description = "", Command = "ballsocketcentre_nocollide"})
	Panel:AddControl("CheckBox",{Label = "#Tool_ballsocketcentre_moveprop", Description = "Move prop so both centres overlap", Command = "ballsocketcentre_moveprop"})
	Panel:AddControl("CheckBox",{Label = "#Tool_ballsocketcentre_simpleballsocket", Description = "Create a simple ballsocket with no angle limits", Command = "ballsocketcentre_simpleballsocket"})
	Panel:AddControl("CheckBox",{Label = "#Tool_ballsocketcentre_rotationonly", Description = "Creates 3 separate X/Y/Z ballsockets to match rotation between the two constrained entities", Command = "ballsocketcentre_rotationonly"})
	Panel:AddControl( "Label", { Text = "Note: The Rotation Constraint creates 3 separate X/Y/Z ball sockets to match rotation between the two constrained entities. Selecting this option overrides all other settings besides nocollide and force limit.", Description	= "" }  )
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local button_help = vgui.Create( "DButton", Panel )
	
	button_help:SetText( "Help" )
	button_help:SetToolTip( "Open online help using the Steam in-game browser" )
	button_help.DoClick = function()
		return gui.OpenURL( "http://sourceforge.net/userapps/mediawiki/wenli/index.php?title=Ball_Socket_Centre" )
	end
	
	button_help.PerformLayout = function()
		button_help:SetSize(60, 20)
		button_help:AlignRight(10)
		button_help:AlignBottom(10)
	end
end