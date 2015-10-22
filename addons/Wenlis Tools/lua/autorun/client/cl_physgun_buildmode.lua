// Physgun Build Mode - by Wenli
if SERVER then return end

local pb = "physgun_buildmode"
local pb_ = "physgun_buildmode_"

CreateClientConVar( pb_.. "enabled", 0, true, true )

local convars = {
	sleep			= "0",
	nocollide		= "1",
	norotate		= "1",
	snapmove		= "1",
	
	snap_position	= "0",
	snap_boxcentre	= "0",
	grid_x			= "1",
	grid_y			= "1",
	grid_z			= "1",
	origin_x		= "0",
	origin_y		= "0",
	origin_z		= "0",
	
	snap_angles		= "0",
	angles_p		= "45",
	angles_y		= "45",
	angles_r		= "45"
}

local convars_full = {}
local convar_array = {}

for k, v in pairs( convars ) do
	local convar = pb_.. k
	CreateClientConVar( convar, v, true, true )
	convar_array[ #convar_array + 1 ] = convar
	convars_full[convar] = v
end


//********************************************************************************************************************//
// Derma controls
//********************************************************************************************************************//


local function OnPopulateToolPanel( Panel )
 	Panel:AddControl("ComboBox", {
		Options = { ["default"] = convars_full
		},
		CVars = convar_array,
		Label = "",
		MenuButton = "1",
		Folder = pb
	})
	
	local checkbox_enabled = Panel:AddControl("CheckBox", {
		Label = "Enabled",
		Command = pb_.."enabled"
	})
	checkbox_enabled:SetToolTip( "You can also use the concommand phys_buildmode to toggle on/off" )
	
	local checkbox_sleep = Panel:AddControl("CheckBox", {
		Label = "Sleep Instead of Freeze",
		Command = pb_.."sleep"
	})
	checkbox_sleep:SetToolTip( "If sleep is enabled, the prop will move again if pushed or hit" )
	
	local checkbox_nocollide = Panel:AddControl("CheckBox", {
		Label = "Auto Nocollide",
		Command = pb_.."nocollide"
	})
	
	local checkbox_norotate = Panel:AddControl("CheckBox", {
		Label = "No Rotation While Moving",
		Command = pb_.."norotate"
	})
	checkbox_norotate:SetToolTip( "GMod 9 rotation behaviour" )
	
	local checkbox_snap_boxcentre = Panel:AddControl("CheckBox", {
		Label = "Snap by Bounding Box Centre",
		Command = pb_.."snap_boxcentre",
	})
	checkbox_snap_boxcentre:SetToolTip( "Useful for certain props, e.g. PHX super flat plates" )
	
	local checkbox_snapmove = Panel:AddControl("CheckBox", {
		Label = "Snap While Moving",
		Command = pb_.."snapmove"
	})
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local checkbox_snap_position = Panel:AddControl("CheckBox", {
		Label = "Snap Position",
		Command = pb_.."snap_position",
	})
	
	local slider_grid_x = vgui.Create( "DNumSlider", Panel )
		slider_grid_x:SetText( "Grid - X" )
		slider_grid_x:SetMinMax( 0, 50 )
		slider_grid_x:SetDecimals( 4 )
		slider_grid_x:SetConVar( pb_.. "grid_x" )
	Panel:AddPanel( slider_grid_x )
	
	local slider_grid_y = vgui.Create( "DNumSlider", Panel )
		slider_grid_y:SetText( "Grid - Y" )
		slider_grid_y:SetMinMax( 0, 50 )
		slider_grid_y:SetDecimals( 4 )
		slider_grid_y:SetConVar( pb_.. "grid_y" )
	Panel:AddPanel( slider_grid_y )
	
	local slider_grid_z = vgui.Create( "DNumSlider", Panel )
		slider_grid_z:SetText( "Grid - Z" )
		slider_grid_z:SetMinMax( 0, 50 )
		slider_grid_z:SetDecimals( 4 )
		slider_grid_z:SetConVar( pb_.. "grid_z" )
	Panel:AddPanel( slider_grid_z )
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local slider_origin_x = vgui.Create( "DNumSlider", Panel )
		slider_origin_x:SetText( "Origin - X" )
		slider_origin_x:SetMinMax( -50, 50 )
		slider_origin_x:SetDecimals( 3 )
		slider_origin_x:SetToolTip( "Sets the grid offset in the X direction" )
		slider_origin_x:SetConVar( pb_.. "origin_x" )
	Panel:AddPanel( slider_origin_x )
	
	local slider_origin_y = vgui.Create( "DNumSlider", Panel )
		slider_origin_y:SetText( "Origin - Y" )
		slider_origin_y:SetMinMax( -50, 50 )
		slider_origin_y:SetDecimals( 3 )
		slider_origin_y:SetToolTip( "Sets the grid offset in the Y direction" )
		slider_origin_y:SetConVar( pb_.. "origin_y" )
	Panel:AddPanel( slider_origin_y )
	
	local slider_origin_z = vgui.Create( "DNumSlider", Panel )
		slider_origin_z:SetText( "Origin - Z" )
		slider_origin_z:SetMinMax( -50, 50 )
		slider_origin_z:SetDecimals( 3 )
		slider_origin_z:SetToolTip( "Sets the grid offset in the Z direction" )
		slider_origin_z:SetConVar( pb_.. "origin_z" )
	Panel:AddPanel( slider_origin_z )
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local button_setorigin = Panel:AddControl("Button", {
		Label = "Set Origin by Entity",
	})
	
	button_setorigin:SetToolTip( "Set the grid offset according to the prop currently in view" )
	
	button_setorigin.DoClick = function()
		local ent = LocalPlayer():GetEyeTraceNoCursor().Entity
		local origin = Vector(0,0,0)
		
		if IsValid(ent) then
			local pos = ent:GetPos()
			origin.x = pos.x % GetConVarNumber( pb_.. "grid_x" )
			origin.y = pos.y % GetConVarNumber( pb_.. "grid_y" )
			origin.z = pos.z % GetConVarNumber( pb_.. "grid_z" )
		end
		
		RunConsoleCommand( pb_.. "origin_x", tostring( origin.x ) )
		RunConsoleCommand( pb_.. "origin_y", tostring( origin.y ) )
		RunConsoleCommand( pb_.. "origin_z", tostring( origin.z ) )
	end
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local checkbox_snap_angles = Panel:AddControl("CheckBox", {
		Label = "Snap Angles",
		Command = pb_.."snap_angles",
	})
	
	local slider_angles_p = Panel:AddControl("Slider", {
		Label = "Angles - Pitch",
		Command = pb_.. "angles_p",
		Type = "Float",
		Min = "0",
		Max = "180",
	})

	local slider_angles_y = Panel:AddControl("Slider", {
		Label = "Angles - Yaw",
		Command = pb_.. "angles_y",
		Type = "Float",
		Min = "0",
		Max = "180",
	})

	local slider_angles_r = Panel:AddControl("Slider", {
		Label = "Angles - Roll",
		Command = pb_.. "angles_r",
		Type = "Float",
		Min = "0",
		Max = "180",
	})
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	Panel:AddControl("Label", {
		Text = ""
	})
	
	
	local button_help = vgui.Create( "DButton", Panel )
	
	button_help:SetText( "Help" )
	button_help:SetToolTip( "Open online help using the Steam in-game browser" )
	button_help.DoClick = function()
		return gui.OpenURL( "https://sourceforge.net/userapps/mediawiki/wenli/index.php?title=Physgun_Build_Mode" )
	end
	
	button_help.PerformLayout = function()
		button_help:SetSize(60, 20)
		button_help:AlignRight(10)
		button_help:AlignBottom(10)
	end
end

local function Build_ToolMenu()
	spawnmenu.AddToolMenuOption( "Options", "Player", "PhysgunSettings", "Physgun Build Mode", "", "", OnPopulateToolPanel, {SwitchConVar = 'physgun_buildmode_enabled'} )
end

hook.Add( "PopulateToolMenu", "phys_buildmode_menu", Build_ToolMenu )


//********************************************************************************************************************//
// Server-related functions
//********************************************************************************************************************//


// Receive notification that server has Physgun Build Mode enabled
local buildmode_enabled = false

usermessage.Hook("Server_Has_PhysBuildMode", function()
	buildmode_enabled = true
	print("Physgun build mode is available on this server")
end )

// Toggle on/off
local function Buildmode_Toggle ( ply, cmd, args )
	if !buildmode_enabled then
		RunConsoleCommand( pb_.. "check_server" )
	end
	
	if GetConVarNumber( pb_.. "enabled" ) == 0 then
		if buildmode_enabled then
			ply:ChatPrint("Physgun Build Mode enabled")
		end
		RunConsoleCommand( pb_.. "enabled", "1" )
	else
		if buildmode_enabled then
			ply:ChatPrint("Physgun Build Mode disabled")
		end
		RunConsoleCommand( pb_.. "enabled", "0" )
	end
end
concommand.Add( "phys_buildmode", Buildmode_Toggle )