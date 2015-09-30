AddCSLuaFile()
AWarn = {}
AWarn.Version = "2.6"
surface.CreateFont( "AWarnFont1",
{
	font      = "Arial",
	size      = 18,
	weight    = 700,
}
)

function awarn_menu()
	AWarn.MenuFrame = vgui.Create( "DFrame" )
	AWarn.MenuFrame:SetPos( ScrW() / 2 - 400, ScrH() / 2 - 300 )
	AWarn.MenuFrame:SetSize( 800, 595 )
	AWarn.MenuFrame:SetTitle( "AWarn Menu (Version: " .. AWarn.Version .. ") ::: Right Click on a player for more options!" )
	AWarn.MenuFrame:SetVisible( true )
	AWarn.MenuFrame:SetDraggable( true )
	AWarn.MenuFrame:ShowCloseButton( true )
	AWarn.MenuFrame:MakePopup()
	 
	local MenuPanel = vgui.Create( "DPanel", AWarn.MenuFrame )
	MenuPanel:SetPos( 10, 35 )
	MenuPanel:SetSize( 780, 510 )
	MenuPanel.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end
	
	local MenuPanel2 = vgui.Create( "DPanel", AWarn.MenuFrame )
	MenuPanel2:SetPos( 10, 550 )
	MenuPanel2:SetSize( 780, 35 )
	MenuPanel2.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel2:GetWide(), MenuPanel2:GetTall() ) -- Draw the rect
	end
	
	local MenuPanel2Text1 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text1:SetPos( 5, 2 )
	MenuPanel2Text1:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text1:SetFont( "AWarnFont1" )
	MenuPanel2Text1:SetText( "Selected Player's Active Warnings: " )
	MenuPanel2Text1:SizeToContents()
	
	AWarn.MenuFrame.MenuPanel2Text2 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.MenuFrame.MenuPanel2Text2:SetPos( 255, 2 )
	AWarn.MenuFrame.MenuPanel2Text2:SetColor( Color(255, 200, 200, 255) )
	AWarn.MenuFrame.MenuPanel2Text2:SetFont( "AWarnFont1" )
	AWarn.MenuFrame.MenuPanel2Text2:SetText( "0" )
	AWarn.MenuFrame.MenuPanel2Text2:SizeToContents()
	
	local MenuPanel2Text3 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text3:SetPos( 5, 17 )
	MenuPanel2Text3:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text3:SetFont( "AWarnFont1" )
	MenuPanel2Text3:SetText( "Selected Player's  Total  Warnings: " )
	MenuPanel2Text3:SizeToContents()
	
	AWarn.MenuFrame.MenuPanel2Text4 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.MenuFrame.MenuPanel2Text4:SetPos( 255, 17 )
	AWarn.MenuFrame.MenuPanel2Text4:SetColor( Color(255, 200, 200, 255) )
	AWarn.MenuFrame.MenuPanel2Text4:SetFont( "AWarnFont1" )
	AWarn.MenuFrame.MenuPanel2Text4:SetText( "0" )
	AWarn.MenuFrame.MenuPanel2Text4:SizeToContents()
	
	local MenuPanel2Button1 = vgui.Create( "DButton", MenuPanel2 )
	MenuPanel2Button1:SetSize( 80, 25 )
	MenuPanel2Button1:SetPos( 695, 5 )
	MenuPanel2Button1:SetText( "OPTIONS" )
	MenuPanel2Button1.DoClick = function( MenuPanel2Button1 )
		net.Start( "awarn_openoptions" )
		net.SendToServer()
	end
		
	AWarn.MenuFrame.WarningsList = vgui.Create( "DListView", MenuPanel )
	AWarn.MenuFrame.WarningsList:SetPos( 5, 5 )
	AWarn.MenuFrame.WarningsList:SetSize( 565, 500 )
	AWarn.MenuFrame.WarningsList:SetMultiSelect(false)
	AWarn.MenuFrame.WarningsList:AddColumn("ID"):SetFixedWidth( 40 )
	AWarn.MenuFrame.WarningsList:AddColumn("Warning Admin"):SetFixedWidth( 140 )
	AWarn.MenuFrame.WarningsList:AddColumn("Reason")
	AWarn.MenuFrame.WarningsList:AddColumn("Date/Time"):SetFixedWidth( 100 )
	AWarn.MenuFrame.WarningsList.OnRowRightClick = function( PlayerList, line )
		local DropDown = DermaMenu()
		DropDown:AddOption("Delete Warning", function()
			warning = AWarn.MenuFrame.WarningsList:GetLine( line ):GetValue( 1 )
			net.Start("awarn_deletesinglewarn")
				net.WriteInt( warning, 16 )
			net.SendToServer()
			
			AWarn.MenuFrame.WarningsList:Clear()
			net.Start("awarn_fetchwarnings")
				net.WriteString( AWarn.lastselected )
			net.SendToServer()
		end )
		DropDown:Open()
	end
		
	
	
	PlayerList = vgui.Create( "DListView", MenuPanel )
	PlayerList:SetPos( 575, 5 )
	PlayerList:SetSize( 200, 500 )
	PlayerList:SetMultiSelect(false)
	PlayerList:AddColumn("Player Name")
	PlayerList.OnRowSelected = function( PlayerList, line )
		AWarn.MenuFrame.WarningsList:Clear()
		net.Start("awarn_fetchwarnings")
			net.WriteString( tostring(PlayerList:GetLine( line ):GetValue( 1 )) )
		net.SendToServer()
		AWarn.lastselected = tostring(PlayerList:GetLine( line ):GetValue( 1 ))
	end
	PlayerList.OnRowRightClick = function( PlayerList, line )
		local DropDown = DermaMenu()
		DropDown:AddOption("Warn", function() 
			AWarn.activeplayer = PlayerList:GetLine( line ):GetValue( 1 )
			awarn_playerwarnmenu()
		end )
		DropDown:AddOption("Clear Warnings", function()
			AWarn.MenuFrame.WarningsList:Clear() 
			AWarn.playerinfo = {} 
			awarn_deletewarnings( PlayerList:GetLine( line ):GetValue( 1 ) )
		end )
		DropDown:AddOption("Reduce Active Warnings", function() 
		awarn_removewarn( PlayerList:GetLine( line ):GetValue( 1 ) )
		end )
		DropDown:AddSpacer()
		
		DropDown:Open()
	end
	
	for _, v in pairs( player.GetAll() ) do
		PlayerList:AddLine( v:Nick() )
	end
end

function awarn_clientmenu()
	AWarn.ClientMenuFrame = vgui.Create( "DFrame" )
	AWarn.ClientMenuFrame:SetPos( ScrW() / 2 - 400, ScrH() / 2 - 300 )
	AWarn.ClientMenuFrame:SetSize( 800, 595 )
	AWarn.ClientMenuFrame:SetTitle( "AWarn Menu ::: Showing your warnings!" )
	AWarn.ClientMenuFrame:SetVisible( true )
	AWarn.ClientMenuFrame:SetDraggable( true )
	AWarn.ClientMenuFrame:ShowCloseButton( true )
	AWarn.ClientMenuFrame:MakePopup()
	 
	local MenuPanel = vgui.Create( "DPanel", AWarn.ClientMenuFrame )
	MenuPanel:SetPos( 10, 35 )
	MenuPanel:SetSize( 780, 510 )
	MenuPanel.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end
	
	local MenuPanel2 = vgui.Create( "DPanel", AWarn.ClientMenuFrame )
	MenuPanel2:SetPos( 10, 550 )
	MenuPanel2:SetSize( 780, 35 )
	MenuPanel2.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel2:GetWide(), MenuPanel2:GetTall() ) -- Draw the rect
	end
	
	local MenuPanel2Text1 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text1:SetPos( 5, 2 )
	MenuPanel2Text1:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text1:SetFont( "AWarnFont1" )
	MenuPanel2Text1:SetText( "Your Active Warnings: " )
	MenuPanel2Text1:SizeToContents()
	
	AWarn.ClientMenuFrame.MenuPanel2Text2 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetPos( 165, 2 )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetColor( Color(255, 200, 200, 255) )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetFont( "AWarnFont1" )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetText( "0" )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SizeToContents()
	
	local MenuPanel2Text3 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text3:SetPos( 5, 17 )
	MenuPanel2Text3:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text3:SetFont( "AWarnFont1" )
	MenuPanel2Text3:SetText( "Your  Total  Warnings: " )
	MenuPanel2Text3:SizeToContents()
	
	AWarn.ClientMenuFrame.MenuPanel2Text4 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetPos( 165, 17 )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetColor( Color(255, 200, 200, 255) )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetFont( "AWarnFont1" )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetText( "0" )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SizeToContents()
	
	AWarn.ClientMenuFrame.WarningsList = vgui.Create( "DListView", MenuPanel )
	AWarn.ClientMenuFrame.WarningsList:SetPos( 5, 5 )
	AWarn.ClientMenuFrame.WarningsList:SetSize( 770, 500 )
	AWarn.ClientMenuFrame.WarningsList:SetMultiSelect(false)
	AWarn.ClientMenuFrame.WarningsList:AddColumn("Warning Admin"):SetFixedWidth( 140 )
	AWarn.ClientMenuFrame.WarningsList:AddColumn("Reason")
	AWarn.ClientMenuFrame.WarningsList:AddColumn("Date/Time"):SetFixedWidth( 100 )
	
	net.Start("awarn_fetchownwarnings")
	net.SendToServer()
end

function awarn_playerwarnmenu()
	local MenuFrame = vgui.Create( "DFrame" )
	MenuFrame:SetPos( ScrW() / 2 - 190, ScrH() / 2 - 85 )
	MenuFrame:SetSize( 380, 170 )
	MenuFrame:SetVisible( true )
	MenuFrame:SetDraggable( true )
	MenuFrame:ShowCloseButton( true )
	MenuFrame:MakePopup()
	 
	local MenuPanel = vgui.Create( "DPanel", MenuFrame )
	MenuPanel:SetPos( 5, 30 )
	MenuPanel:SetSize( 370, 135 )
	MenuPanel.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end
	
	local HiddenLabel = vgui.Create( "DLabel", MenuPanel )
	HiddenLabel:SetPos( 0, 0 )
	HiddenLabel:SetColor( Color(255, 255, 255, 0) )
	HiddenLabel:SetFont( "AWarnFont1" )
	HiddenLabel:SetText( AWarn.activeplayer )
	HiddenLabel:SizeToContents()
	
	MenuFrame:SetTitle( "AWarn Warning Menu ::: " .. HiddenLabel:GetText() )
	
	local MenuPanelLabel1 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel1:SetPos( 5, 5 )
	MenuPanelLabel1:SetColor( Color(255, 255, 255, 255) )
	MenuPanelLabel1:SetFont( "AWarnFont1" )
	MenuPanelLabel1:SetText( "Warning Player: " )
	MenuPanelLabel1:SizeToContents()
	
	local MenuPanelLabel2 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel2:SetPos( 120, 5 )
	MenuPanelLabel2:SetColor( Color(255, 20, 20, 255) )
	MenuPanelLabel2:SetFont( "AWarnFont1" )
	MenuPanelLabel2:SetText( HiddenLabel:GetText() )
	MenuPanelLabel2:SizeToContents()
	
	local MenuPanelLabel3 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel3:SetPos( 5, 25 )
	MenuPanelLabel3:SetColor( Color(255, 255, 255, 255) )
	MenuPanelLabel3:SetFont( "AWarnFont1" )
	MenuPanelLabel3:SetText( "Reason:" )
	MenuPanelLabel3:SizeToContents()
	
	local MenuPanelTextEntry1 = vgui.Create( "DTextEntry", MenuPanel )
	MenuPanelTextEntry1:SetPos( 5, 45 )
	MenuPanelTextEntry1:SetMultiline( true )
	MenuPanelTextEntry1:SetSize( 360, 50 )
	
	local MenuPanelButton1 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton1:SetSize( 80, 30 )
	MenuPanelButton1:SetPos( 5, 100 )
	MenuPanelButton1:SetText( "SUBMIT" )
	MenuPanelButton1.DoClick = function( MenuPanelButton1 )
		awarn_sendwarning( HiddenLabel:GetText(), MenuPanelTextEntry1:GetValue() )
		MenuFrame:Close()
	end
	
	local MenuPanelButton2 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton2:SetSize( 80, 30 )
	MenuPanelButton2:SetPos( 90, 100 )
	MenuPanelButton2:SetText( "CANCEL" )
	MenuPanelButton2.DoClick = function( MenuPanelButton2 )
		MenuFrame:Close()
	end
end

function awarn_optionsmenu()
	local MenuFrame = vgui.Create( "DFrame" )
	MenuFrame:SetPos( ScrW() / 2 - 205, ScrH() / 2 - 125 )
	MenuFrame:SetSize( 410, 250 )
	MenuFrame:SetVisible( true )
	MenuFrame:SetDraggable( true )
	MenuFrame:ShowCloseButton( true )
	MenuFrame:SetTitle( "AWarn Options Menu" )
	MenuFrame:MakePopup()
	 
	local MenuPanel = vgui.Create( "DPanel", MenuFrame )
	MenuPanel:SetPos( 5, 30 )
	MenuPanel:SetSize( 400, 213 )
	MenuPanel.Paint = function() -- Paint function
		--Set our rect color below us; we do this so you can see items added to this panel
		surface.SetDrawColor( 50, 50, 50, 255 ) 
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end
	
	local MenuPanelCheckBox1 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox1:SetPos( 5, 5 )
	MenuPanelCheckBox1:SetText( "Player will be KICK when their active warnings reach the kick threshold." )
	MenuPanelCheckBox1.Button.DoClick = function( MenuPanelCheckBox1 )
		local val = tostring(MenuPanelCheckBox1:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_kick")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox1.Think = function( MenuPanelCheckBox1 )
		if tobool(GetGlobalInt( "awarn_kick", 1)) ~= MenuPanelCheckBox1:GetChecked() then
			MenuPanelCheckBox1:SetValue( GetGlobalInt( "awarn_kick", 1) )
		end
	end
	MenuPanelCheckBox1:SizeToContents()
	
	
	local MenuPanelCheckBox2 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox2:SetPos( 5, 25 )
	MenuPanelCheckBox2:SetText( "Player will be BANNED when their active warnings reach the ban threshold." )
	MenuPanelCheckBox2.Button.DoClick = function( MenuPanelCheckBox2 )
		local val = tostring(MenuPanelCheckBox2:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_ban")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox2.Think = function( MenuPanelCheckBox2 )
		if tobool(GetGlobalInt( "awarn_ban", 1)) ~= MenuPanelCheckBox2:GetChecked() then
			MenuPanelCheckBox2:SetValue( GetGlobalInt( "awarn_ban", 1 ) )
		end
	end
	MenuPanelCheckBox2:SizeToContents()
	
	local MenuPanelCheckBox3 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox3:SetPos( 5, 45 )
	MenuPanelCheckBox3:SetText( "Player's active warnings will decay over time." )
	MenuPanelCheckBox3.Button.DoClick = function( MenuPanelCheckBox3 )
		local val = tostring(MenuPanelCheckBox3:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_decay")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox3.Think = function( MenuPanelCheckBox3 )
		if tobool(GetGlobalInt( "awarn_decay", 1)) ~= MenuPanelCheckBox3:GetChecked() then
			MenuPanelCheckBox3:SetValue( GetGlobalInt( "awarn_decay", 1 ) )
		end
	end
	MenuPanelCheckBox3:SizeToContents()
	
	local MenuPanelCheckBox4 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox4:SetPos( 5, 65 )
	MenuPanelCheckBox4:SetText( "Admins are required to submit a reason when they warn someone." )
	MenuPanelCheckBox4.Button.DoClick = function( MenuPanelCheckBox4 )
		local val = tostring(MenuPanelCheckBox4:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_reasonrequired")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox4.Think = function( MenuPanelCheckBox4 )
		if tobool(GetGlobalInt( "awarn_reasonrequired", 1)) ~= MenuPanelCheckBox4:GetChecked() then
			MenuPanelCheckBox4:SetValue( GetGlobalInt( "awarn_reasonrequired", 1 ) )
		end
	end
	MenuPanelCheckBox4:SizeToContents()
	
	
	local MenuPanelSlider1 = vgui.Create( "DNumSlider", MenuPanel )
	MenuPanelSlider1:SetPos( 5, 80 )
	MenuPanelSlider1:SetSize( 390, 30 )
	MenuPanelSlider1:SetText( "Kick Threshold: " )
	MenuPanelSlider1:SetMin( 0 )
	MenuPanelSlider1:SetMax( 100 )
	MenuPanelSlider1:SetDark( false )
	MenuPanelSlider1:SetDecimals( 0 )
	MenuPanelSlider1.TextArea:SetDrawBackground( true )
	MenuPanelSlider1.TextArea:SetWide( 30 )
	MenuPanelSlider1.Label:SetWide(150)
	MenuPanelSlider1:SetValue( GetGlobalInt( "awarn_kick_threshold", 3 ) )
	MenuPanelSlider1.Think = function( MenuPanelSlider1 )
		
		if MenuPanelSlider1.Slider:GetDragging() then return end
		if ( AWarn.MenuThink or CurTime() ) > CurTime() then return end
		
		if tonumber(MenuPanelSlider1.TextArea:GetValue()) ~= tonumber(GetGlobalInt( "awarn_kick_threshold", 3 )) then
			net.Start("awarn_changeconvar")
				net.WriteString("awarn_kick_threshold")
				net.WriteInt( MenuPanelSlider1.TextArea:GetValue(), 32 )
			net.SendToServer()
			AWarn.MenuThink = CurTime() + 1
			return
		end
		
		if GetGlobalInt( "awarn_kick_threshold", 3 ) ~= MenuPanelSlider1:GetValue() then
			MenuPanelSlider1:SetValue( GetGlobalInt( "awarn_kick_threshold", 3 ) )
		end
	end
	

	local MenuPanelSlider2 = vgui.Create( "DNumSlider", MenuPanel )
	MenuPanelSlider2:SetPos( 5, 110 )
	MenuPanelSlider2:SetSize( 390, 30 )
	MenuPanelSlider2:SetText( "Ban Threshold: " )
	MenuPanelSlider2:SetMin( 0 )
	MenuPanelSlider2:SetMax( 100 )
	MenuPanelSlider2:SetDark( false )
	MenuPanelSlider2:SetDecimals( 0 )
	MenuPanelSlider2.TextArea:SetDrawBackground( true )
	MenuPanelSlider2.TextArea:SetWide( 30 )
	MenuPanelSlider2.Label:SetWide(150)
	MenuPanelSlider2:SetValue( GetGlobalInt( "awarn_ban_threshold", 5 ) )
	MenuPanelSlider2.Think = function( MenuPanelSlider2 )
		
		if MenuPanelSlider2.Slider:GetDragging() then return end
		if ( AWarn.MenuThink or CurTime() ) > CurTime() then return end
		
		if tonumber(MenuPanelSlider2.TextArea:GetValue()) ~= tonumber(GetGlobalInt( "awarn_ban_threshold", 5 )) then
			net.Start("awarn_changeconvar")
				net.WriteString("awarn_ban_threshold")
				net.WriteInt( MenuPanelSlider2.TextArea:GetValue(), 32 )
			net.SendToServer()
			AWarn.MenuThink = CurTime() + 1
			return
		end
		if GetGlobalInt( "awarn_ban_threshold", 5 ) ~= MenuPanelSlider2:GetValue() then
			MenuPanelSlider2:SetValue( GetGlobalInt( "awarn_ban_threshold", 5 ) )
		end
	end
	
	local MenuPanelSlider3 = vgui.Create( "DNumSlider", MenuPanel )
	MenuPanelSlider3:SetPos( 5, 140 )
	MenuPanelSlider3:SetSize( 390, 30 )
	MenuPanelSlider3:SetText( "Ban Time (minutes, 0=Perma): " )
	MenuPanelSlider3:SetMin( 0 )
	MenuPanelSlider3:SetMax( 1440 )
	MenuPanelSlider3:SetDark( false )
	MenuPanelSlider3:SetDecimals( 0 )
	MenuPanelSlider3.TextArea:SetDrawBackground( true )
	MenuPanelSlider3.TextArea:SetWide( 30 )
	MenuPanelSlider3.Label:SetWide(150)
	MenuPanelSlider3:SetValue( GetGlobalInt( "awarn_ban_time", 30 ) )
	MenuPanelSlider3.Think = function( MenuPanelSlider3 )
		
		if MenuPanelSlider3.Slider:GetDragging() then return end
		if ( AWarn.MenuThink or CurTime() ) > CurTime() then return end
		
		if tonumber(MenuPanelSlider3.TextArea:GetValue()) ~= tonumber(GetGlobalInt( "awarn_ban_time", 30 )) then
			net.Start("awarn_changeconvar")
				net.WriteString("awarn_ban_time")
				net.WriteInt( MenuPanelSlider3.TextArea:GetValue(), 32 )
			net.SendToServer()
			AWarn.MenuThink = CurTime() + 1
			return
		end
		if GetGlobalInt( "awarn_ban_time", 30 ) ~= MenuPanelSlider3:GetValue() then
			MenuPanelSlider3:SetValue( GetGlobalInt( "awarn_ban_time", 30 ) )
		end
	end
	
	local MenuPanelSlider4 = vgui.Create( "DNumSlider", MenuPanel )
	MenuPanelSlider4:SetPos( 5, 170 )
	MenuPanelSlider4:SetSize( 390, 30 )
	MenuPanelSlider4:SetText( "Decay Rate (in minutes): " )
	MenuPanelSlider4:SetMin( 0 )
	MenuPanelSlider4:SetMax( 100 )
	MenuPanelSlider4:SetDark( false )
	MenuPanelSlider4:SetDecimals( 0 )
	MenuPanelSlider4.TextArea:SetDrawBackground( true )
	MenuPanelSlider4.TextArea:SetWide( 30 )
	MenuPanelSlider4.Label:SetWide(150)
	MenuPanelSlider4:SetValue( GetGlobalInt( "awarn_decay_rate", 30 ) )
	MenuPanelSlider4.Think = function( MenuPanelSlider4 )
		
		if MenuPanelSlider4.Slider:GetDragging() then return end
		if ( AWarn.MenuThink or CurTime() ) > CurTime() then return end
		
		if tonumber(MenuPanelSlider4.TextArea:GetValue()) ~= tonumber(GetGlobalInt( "awarn_decay_rate", 30 )) then
			net.Start("awarn_changeconvar")
				net.WriteString("awarn_decay_rate")
				net.WriteInt( MenuPanelSlider4.TextArea:GetValue(), 32 )
			net.SendToServer()
			AWarn.MenuThink = CurTime() + 1
			return
		end
		if GetGlobalInt( "awarn_decay_rate", 30 ) ~= MenuPanelSlider4:GetValue() then
			MenuPanelSlider4:SetValue( GetGlobalInt( "awarn_decay_rate", 30 ) )
		end
	end

	
end


net.Receive("SendPlayerWarns", function(length )
	AWarn.playerinfo = net.ReadTable()
	AWarn.playerwarns = net.ReadInt( 32 )

	if ValidPanel( AWarn.MenuFrame ) then
		if AWarn.playerinfo then
			AWarn.MenuFrame.WarningsList:Clear()
			for k, v in pairs(AWarn.playerinfo) do
				AWarn.MenuFrame.WarningsList:AddLine(v.pid, v.admin, v.reason, v.date)
			end
			AWarn.MenuFrame.WarningsList:SortByColumn( 3, true )
			AWarn.MenuFrame.MenuPanel2Text4:SetText( #AWarn.playerinfo )
			AWarn.MenuFrame.MenuPanel2Text4:SizeToContents()
		end
		
		if AWarn.playerwarns then
			AWarn.MenuFrame.MenuPanel2Text2:SetText( AWarn.playerwarns )
			AWarn.MenuFrame.MenuPanel2Text2:SizeToContents()
		end
	end
	--PrintTable(AWarn.playerinfo)
end)

net.Receive("SendOwnWarns", function(length )
	AWarn.ownplayerinfo = net.ReadTable()
	AWarn.ownplayerwarns = net.ReadInt( 32 )

	if ValidPanel( AWarn.ClientMenuFrame ) then
		if AWarn.ownplayerinfo then
			AWarn.ClientMenuFrame.WarningsList:Clear()
			for k, v in pairs(AWarn.ownplayerinfo) do
				AWarn.ClientMenuFrame.WarningsList:AddLine(v.admin, v.reason, v.date)
			end
			AWarn.ClientMenuFrame.WarningsList:SortByColumn( 3, true )
			AWarn.ClientMenuFrame.MenuPanel2Text4:SetText( #AWarn.ownplayerinfo )
			AWarn.ClientMenuFrame.MenuPanel2Text4:SizeToContents()
		end
		
		if AWarn.ownplayerwarns then
			AWarn.ClientMenuFrame.MenuPanel2Text2:SetText( AWarn.ownplayerwarns )
			AWarn.ClientMenuFrame.MenuPanel2Text2:SizeToContents()
		end
	end
end)

net.Receive("AWarnMenu", function(length )
	if not ValidPanel(AWarn.MenuFrame) then
		awarn_menu()
	end
end)

net.Receive("AWarnClientMenu", function(length )
	if not ValidPanel(AWarn.ClientMenuFrame) then
		awarn_clientmenu()
	end
end)

net.Receive("AWarnOptionsMenu", function(length )
	awarn_optionsmenu()
end)

net.Receive("AWarnNotification", function(length )
	local admin = net.ReadEntity()
	local target = net.ReadEntity()
	local reason = net.ReadString()
    
    if admin:EntIndex() == 0 then
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), " warned ", target, " for reason: ", Color(150,40,40), reason )
    else
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", admin, Color(255,255,255), " warned ", target, " for reason: ", Color(150,40,40), reason )
    end
end)

net.Receive("AWarnNotification2", function(length )
	local admin = net.ReadEntity()
	local target = net.ReadString()
	local reason = net.ReadString()
    
    if admin:EntIndex() == 0 then
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), " warned ", Color(255,0,0), target, Color(255,255,255), " for reason: ", Color(150,40,40), reason )
    else
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", admin, Color(255,255,255), " warned ", Color(255,0,0), target, Color(255,255,255), " for reason: ", Color(150,40,40), reason )
    end
end)

net.Receive("AWarnChatMessage", function(length )
	local message = net.ReadTable()
	
	chat.AddText( unpack( message ) )
end)

function awarn_con_warn( ply, _, args )
    if #args < 1 then return end
	
	awarn_sendwarning( args[1], args[2] or nil )
    
end
concommand.Add( "awarn_warn", awarn_con_warn )

function awarn_sendwarning( tar, reason )

	if (string.sub(string.lower( tar ), 1, 5) == "steam") then
		--We're working with a steamid here. Do Steamid things...
		if string.len( tar ) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: Make sure you wrap the steamID in quotes!"  )
		end
		tid = AWarn_ConvertSteamID( tar )
		net.Start( "awarn_warnid" )
			net.WriteString( tid )
			net.WriteString( reason )
		net.SendToServer()
		return
	end
	
	
	if awarn_getUser( tar ) then
		tar = awarn_getUser( tar )
		net.Start( "awarn_warn" )
			net.WriteEntity( tar )
			net.WriteString( reason )
		net.SendToServer()
	else
		LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: Player not found!"  )
	end
end

function awarn_removewarn( pl )
	print(pl)
	if (string.sub(string.lower( pl ), 1, 5) == "steam") then
		if string.len( pl ) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: Make sure you wrap the steamID in quotes!"  )
		end
		pl = AWarn_ConvertSteamID( pl )
		net.Start( "awarn_removewarnid" )
			net.WriteString( pl )
		net.SendToServer()
		return
	end
		
	net.Start( "awarn_removewarn" )
		net.WriteString( pl )
	net.SendToServer()
end

function awarn_con_delwarn( ply, _, args )
	if not (#args == 1) then return end
	awarn_deletewarnings( args[1] )
end
concommand.Add( "awarn_deletewarnings", awarn_con_delwarn )

function awarn_deletewarnings( pl )
	if (string.sub(string.lower( pl ), 1, 5) == "steam") then
		if string.len(pl) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: Make sure you wrap the steamID in quotes!"  )
		end
		pl = AWarn_ConvertSteamID( pl )
		net.Start( "awarn_deletewarningsid" )
			net.WriteString( pl )
		net.SendToServer()
		return
	end
	net.Start( "awarn_deletewarnings" )
		net.WriteString( pl )
	net.SendToServer()
end

function awarn_con_openmenu( ply, _, args )
	net.Start( "awarn_openmenu" )
	net.SendToServer()
end
concommand.Add( "awarn_menu", awarn_con_openmenu )

function awarn_con_openoptionsmenu( ply, _, args )
	net.Start( "awarn_openoptions" )
	net.SendToServer()
end
concommand.Add( "awarn_options", awarn_con_openoptionsmenu )
