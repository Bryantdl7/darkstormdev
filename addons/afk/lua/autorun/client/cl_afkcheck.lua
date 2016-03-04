local translucency = 80
local MENU_COLOR = Color(0,0,0,translucency) -- Color for the AFK checker
local TITLE_BG_COLOR = Color(122,122,122, 90) -- Color behind AFK Timer text
local BG_COLOR = Color(255,255,255,translucency) -- Color for the background of the AFK checker
local TEXT_COLOR = Color(255,255,255,225) -- Color for Text
local COUNTER_TEXT = Color(255,50,50,255) -- Color for the timer	
local TITLE_TEXT = Color(210,210,210,255) -- Color for AFK Timer text

net.Receive( "timerstart", function( len )
	local afktime = net.ReadInt(16)
	local secondsLeft = net.ReadInt(16)
	
	local DPanel = vgui.Create( "DPanel" )
	DPanel:SetSize(175, 200)
	DPanel:SetPos(5,ScrH()/2)
	DPanel:SetBackgroundColor( BG_COLOR )
	DPanel:SetVisible( true )
	
	local DPanel2 = vgui.Create( "DPanel", DPanel )
	DPanel2:SetSize(170, 195)
	DPanel2:SetPos(3, 3)
	DPanel2:SetBackgroundColor( MENU_COLOR )

	
	local DPanel3 = vgui.Create( "DPanel", DPanel )
	DPanel3:SetSize(170, 35)
	DPanel3:SetPos(3, 3)
	DPanel3:SetBackgroundColor( TITLE_BG_COLOR )

	local DLabel = vgui.Create( "DLabel", DPanel )
	DLabel:SetPos( 25, 5 )
	DLabel:SetText( "AFK Timer" )
	DLabel:SetColor( TITLE_TEXT )
	DLabel:SetFont("titletext")
	DLabel:SizeToContents()

	local AFKTEXT1 = vgui.Create( "DLabel", DPanel )
	AFKTEXT1:SetPos( 10, 45 )
	AFKTEXT1:SetText( "Are you AFK?" )
	AFKTEXT1:SetColor( TEXT_COLOR )
	AFKTEXT1:SetFont("afktext")
	AFKTEXT1:SizeToContents()
	

	local AFKTEXT2 = vgui.Create( "DLabel", DPanel )
	AFKTEXT2:SetPos( 10, 60 )
	AFKTEXT2:SetText( "Click okay to show you're here." )
	AFKTEXT2:SetColor( TEXT_COLOR )
	AFKTEXT2:SetFont("afktext")
	AFKTEXT2:SizeToContents()
	
	
	local AFKTEXT3 = vgui.Create( "DLabel", DPanel )
	AFKTEXT3:SetPos( 10, 75 )
	AFKTEXT3:SetText( "This appears every " .. afktime .. " minutes." )
	AFKTEXT3:SetColor( TEXT_COLOR )
	AFKTEXT3:SetFont("afktext")
	AFKTEXT3:SizeToContents()
	
	
	local AFKTEXT4 = vgui.Create( "DLabel", DPanel )
	AFKTEXT4:SetPos( 75, 90 )
	AFKTEXT4:SetColor( COUNTER_TEXT )
	AFKTEXT4:SetText( secondsLeft )
	AFKTEXT4:SetFont("hudcountdown")
	AFKTEXT4:SizeToContents()
	
	local AFKTEXT5 = vgui.Create( "DLabel", DPanel )
	AFKTEXT5:SetPos( 10, 125 )
	AFKTEXT5:SetText( "Press B to unlock your cursor" )
	AFKTEXT5:SetColor( TEXT_COLOR )
	AFKTEXT5:SetFont("afktext")
	AFKTEXT5:SizeToContents()
	

	local button = vgui.Create( "DButton", DPanel)
	button:SetPos(3,148)
	button:SetSize(170,50)
	button:SetText("Okay")
	button:SetFont("buttontext")
	button:SetColor( TEXT_COLOR )
	button.DoClick = function()
		net.Start("kickstop")
		net.SendToServer()
		gui.EnableScreenClicker(false)
		timer.Remove("countdown")
		DPanel:Remove()
	end
	timer.Create("countdown",1,secondsLeft, function()
		secondsLeft = secondsLeft - 1
		AFKTEXT4:SetText( secondsLeft )
	end)
end)
--======FONTS========--
surface.CreateFont( "hudcountdown", {
	font = "Arial",
	size = 28,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "afktext", {
	font = "Arial",
	size = 12,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "titletext", {
	font = "Arial",
	size = 28,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "buttontext", {
	font = "Arial",
	size = 20,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

hook.Add("Think","pressb",function()
	gui.EnableScreenClicker( input.IsKeyDown( KEY_B ) )
end)