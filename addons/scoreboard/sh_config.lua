-----------------------------------------------------------------
-- @package     Vliss
-- @authors     Richard & Phoenixf129
-- @build       v1.1
-- @release     09.30.2015
-----------------------------------------------------------------

-----------------------------------------------------------------
--
--  SETTINGS DIRECTORY
--      FastDL Resources
--      Background Settings
--      Scoreboard GUI Settings
--      Player Action Commands
--          -> ULX
--          -> EVOLVE
--          -> EXSTO
--      TTT Mode Settings
--      Sorting Settings
--      Group Settings
--      Player Card Permissions
--      Column Configuration
--      Home Buttons
--      Control Buttons
--      Action Buttons
--      Server Listings
--      Browser Settings
--
-----------------------------------------------------------------

-----------------------------------------------------------------
-- [ FASTDL RESOURCES ]
-- 
-- Set to false if you do not wish for the server to force 
-- players to download the resources/materials.
-----------------------------------------------------------------

Vliss.ResourcesEnable = true

-----------------------------------------------------------------
-- [ BACKGROUND SETTINGS ]
-- 
-- These settings are for background functionality
-----------------------------------------------------------------

Vliss.BackgroundsEnable = true
Vliss.Backgrounds = {
    "http://buzzgfx.com/wp-content/uploads/2014/06/main-background1.jpg",
    "http://images2.alphacoders.com/878/87822.jpg",
    "http://p1.pichost.me/i/52/1752357.jpg",
    "http://www.electricblueskies.com/wp/wp-content/uploads/2012/05/48-Half-Life-2-1080p-Wallpaper-Garrys-Mod-Highway-17-COAST-Landscape-Environment-scenery-set-piece-Bridge.jpg"
}

-----------------------------------------------------------------
-- [ SCOREBOARD GUI SETTINGS ]
-- 
-- These settings change the overall look of the scoreboard
-----------------------------------------------------------------

Vliss.NetworkName = "Welcome to the Network"

Vliss.NetworkNameColor = Color( 255, 255, 255, 255 )        -- Color for network name
Vliss.MapNameColor = Color( 255, 255, 255, 255 )            -- Color for map text 
Vliss.PlayerCountColor = Color( 255, 255, 255, 255 )        -- Color for player count text

Vliss.MiddlePanelBlur = false
Vliss.MiddlePanelBackgroundColor = Color( 16, 16, 16, 210 )

Vliss.LeftMidPanelBlur = false
Vliss.LeftMidPanelBackgroundColor = Color( 0, 0, 0, 250 )

Vliss.LeftTopPanelBackgroundColor = Color( 128, 0, 0, 250 )
Vliss.LeftTopButtonHoverColor = Color( 40, 0, 0, 255 )

Vliss.StaffCardBlur = false
Vliss.StaffCardBackgroundUseRankColor = true                -- Use rank color for staff card background color?
Vliss.StaffCardBackgroundColor = Color( 0, 0, 0, 230 )      -- If Vliss.StaffCardBackgroundUseRankColor is FALSE - what do you want the card color to be?
Vliss.StaffCardNameColor = Color( 255, 255, 255, 255 )      -- Text color for player name
Vliss.StaffCardRankColor = Color( 255, 255, 255, 255 )      -- Text color for rank name

Vliss.ColumnStyleMatch = false                              -- A little tweak that moves the top column over. Just a graphical preference. true = normal | false = shifted over.

-----------------------------------------------------------------
-- [ PLAYER ACTION COMMANDS ]
-- 
-- When you click on a player within the scoreboard, actions 
-- will be displayed. The list below defines what other staff 
-- are allowed to do to a player.
--
-----------------------------------------------------------------

Vliss.ULXCmds = {
    {
        name = "Kick",
        cmd = "kick"
    },
    {
        name = "Ignite",
        cmd = "ignite"
    },
    {
        name = "Whip",
        cmd = "whip"
    },
    {
        name = "Maul",
        cmd = "maul"
    }
}

Vliss.EvolveCmds = {
    {
        name = "Kick",
        cmd = "kick"
    }
}

Vliss.ExstoCmds = {
    {
        name = "Kick",
        cmd = "kick"
    }
}

-----------------------------------------------------------------
-- [ TTT MODE SETTINGS ]
-- These are ONLY for the TTT gamemode.
-----------------------------------------------------------------

Vliss.TTTMode = false -- Set this to true if TTT is your gamemode.
Vliss.TTTColorDetective = Color(25, 25, 200, 200)
Vliss.TTTColorTraitor = Color(200, 25, 25, 200)

Vliss.TTTColorTerrorist = Color(25, 200, 25, 200)
Vliss.TTTColorMIA = Color(130, 190, 130, 200)
Vliss.TTTColorDead = Color(130, 170, 10, 200)
Vliss.TTTColorSpec = Color(200, 200, 0, 200)

-----------------------------------------------------------------
-- [ SORTING SETTINGS ]
-- Allows you to specify how the scoreboard will be sorted
-----------------------------------------------------------------

Vliss.PlayerSortFunc = nil -- Set this to a proper sorting function for custom sorting.
Vliss.SortBy = "teams" -- Set this to "teams", "kills" or "deaths" for valid functionality.

-----------------------------------------------------------------
-- [ GROUP SETTINGS ]
-- Usergroup colors and naming
-----------------------------------------------------------------

Vliss.HideSpectators = false   -- Set this to true if you don't want spectators shown on the scoreboard. Uses TEAM_SPECTATOR by default. If spectator team's are different, this will not work!
Vliss.TeamMode = false           -- Set this to true if you want vliss to show players grouped in a team box.
Vliss.TeamRowColor = Color( 25, 25, 25, 220 )  -- Color of team name row
Vliss.TeamColoring = false      -- Set this to true if you want the player rows to reflect their team coloring.

Vliss.UserGroupColoring = false  -- Set this to true if you want your user groups to have different coloring as defined below. 

Vliss.UserGroupColors = {}
Vliss.UserGroupColors["superadmin"] = Color( 200, 51, 50, 220 )
Vliss.UserGroupColors["admin"] = Color( 72, 112, 58, 220 )
Vliss.UserGroupColors["supervisor"] = Color( 145, 71, 101, 220 )
Vliss.UserGroupColors["operator"] = Color( 171, 108, 44, 220 )
Vliss.UserGroupColors["moderator"] = Color( 171, 108, 44, 220 )
Vliss.UserGroupColors["trialmod"] = Color( 163, 135, 79, 220 )
Vliss.UserGroupColors["donator"] = Color( 64, 105, 126, 220 )
Vliss.UserGroupColors["enthralled"] = Color( 94, 75, 75, 220 )
Vliss.UserGroupColors["respected"] = Color( 69, 42, 42, 220 )
Vliss.UserGroupColors["user"] = Color( 5, 5, 5, 220 )

Vliss.UserGroupTitles = {}
--Vliss.UserGroupTitles["superadmin"] = "Owner"
--Vliss.UserGroupTitles["admin"] = "Administrator"
--Vliss.UserGroupTitles["supervisor"] = "Supervisor"
--Vliss.UserGroupTitles["operator"] = "Moderator"
--Vliss.UserGroupTitles["moderator"] = "Moderator"
--Vliss.UserGroupTitles["trialmod"] = "Trial Moderator"
--Vliss.UserGroupTitles["donator"] = "Donator"
--Vliss.UserGroupTitles["enthralled"] = "Enthralled"
--Vliss.UserGroupTitles["respected"] = "Respected"
--Vliss.UserGroupTitles["user"] = "User"

Vliss.StaffGroups = { 
    "superadmin", 
	"head-admin",
	"owner",
	"srserveradmin",
	"retired-staff",
	"p-admin",
    "serveradmin", 
    "mod" 
} 

-----------------------------------------------------------------
-- [ PLAYER CARD PERMISSIONS ]
--
-- These are special buttons that allow you to copy the SteamID
-- or IP Address of a player. The groups below are allowed to 
-- click on a name and perform this action within the player card
-----------------------------------------------------------------

Vliss.StaffGroupsPermissionCopySteam = { 
    "superadmin", 
	"head-admin",
	"owner",
	"srserveradmin",
	"retired-staff",
	"p-admin",
    "serveradmin", 
    "mod" 
} 

Vliss.StaffGroupsPermissionCopyIP = { 
    "superadmin", 
	"head-admin",
	"owner",
	"srserveradmin",
	"retired-staff",
    "serveradmin", 
    "mod" 
} 

-----------------------------------------------------------------
--  [ COLUMN CONFIGURATION ]
--  
--  This area allows you to setup the columns how you want.
--  The following list of items can be used for displaying data.
-- 
--  REMEMBER: Columns are sorted from RIGHT TO LEFT.
--
--  [GENERAL] ---------------------------------------------------
--
--  ply:Deaths()        (Number of deaths)
--  ply:Frags()         (Number of kills)
--  ply:Health()        (Players current HP)
--  ply:GetUserGroup()  (User group player is in)
--  ply:Team()          (Team assigned to player)
--
--  [TTT]  ------------------------------------------------------
--
--  math.Round( ply:GetBaseKarma() )  (Returns player karma)
--
-----------------------------------------------------------------

Vliss.ColumnKillSkullEnabled = true	-- Enabled the skull to the right of a player who has died. False to disable.
Vliss.ColumnKillSkullColor = Color( 255, 255, 255, 255 ) -- Color of the skull. Default is white.

Vliss.CustomColumns = {}

Vliss.CustomColumns[2] = { 
    enabled = true,
    name = "Deaths", 
    width = 70, 
    func = function(ply) return ply:Deaths() end
}

Vliss.CustomColumns[3] = { 
    enabled = true,
    name = "Kills", 
    width = 70, 
    func = function(ply) return ply:Frags() end
}

Vliss.CustomColumns[4] = { 
    enabled = false,
    name = "Health", 
    width = 100, 
    func = function(ply) return ply:Health() end
}

Vliss.CustomColumns[5] = { 
    enabled = false,
    name = "Team", width = 100, 
    func = function(ply) return team.GetName(ply:Team()) end
}

Vliss.CustomColumns[6] = { 
    enabled = true,
    name = "Rank", width = 100, 
    func = function(ply) return Vliss.UserGroupTitles[ply:GetUserGroup()] and Vliss.UserGroupTitles[ply:GetUserGroup()] or ply:GetUserGroup() end
}

-----------------------------------------------------------------
-- [ HOME BUTTONS ]
-- 
-- Displayed on left-side of scoreboard
-- You can disable any one of these by changing 
-- enabled = true to false.
--
-- To open a URL:
--      Vliss:OpenURL("http://url.com", "Titlebar Text")
--
-- To open standard text:
--      Vliss:OpenText("Text here", "Titlebar Text")
--
-----------------------------------------------------------------

Vliss.MenuLinkDonate = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=Y4AGHR3ZYSUES"
Vliss.MenuLinkWebsite = "www.bit.ly/darkstorm"
Vliss.MenuLinkWorkshop = "www.bit.ly/darkstorm-addons"

Vliss.Buttons = {
    {
        name = "Donate",
        description = "Donate to help keep us running",
        icon = "vliss/vliss_btn_donate.png",
        buttonNormal = Color(64, 105, 126, 190),
        buttonHover = Color(64, 105, 126, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            Vliss:OpenURL(Vliss.MenuLinkDonate, "Donate to our Network!")
        end
    },
    {
        name = "Website",
        description = "Visit the official website",
        icon = "vliss/vliss_btn_website.png",
        buttonNormal = Color(163, 135, 79, 190),
        buttonHover = Color(163, 135, 79, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            Vliss:OpenURL(Vliss.MenuLinkWebsite, "Welcome to our Official Website!")
        end
    },
    {
        name = "Steam Collection",
        description = "Download our addons here",
        icon = "vliss/vliss_btn_workshop.png",
        buttonNormal = Color(145, 71, 101, 190),
        buttonHover = Color(145, 71, 101, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            Vliss:OpenURL(Vliss.MenuLinkWorkshop, "The Official Network Steam Collection")
        end
    },
    {
        name = "Disconnect",
        description = "Disconnect from our server",
        icon = "vliss/vliss_btn_disconnect.png",
        buttonNormal = Color(124, 51, 50, 190),
        buttonHover = Color(124, 51, 50, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            RunConsoleCommand("disconnect")
        end
    }
}

-----------------------------------------------------------------
-- [ CONTROL BUTTONS ]
-- 
-- These are pretty much set for your own specifications based 
-- on what features your server has. I like to use a certain
-- color scheme for the buttons, so if you would like the same;
-- I've listed the colors below:
--
-- Red              Color( 124, 51, 50, 190 )
-- Yellow/Gold      Color( 163, 135, 79, 190 )
-- Blue             Color( 64, 105, 126, 190 )
-- Fuschia          Color( 145, 71, 101, 190 )
-- Green            Color( 72, 112, 58, 190 )
-- Brown            Color( 112, 87, 58, 190 )
--
-----------------------------------------------------------------

Vliss.Controls = {
    {
        control = "Q",
        description = "Context Menu",
        color = Color(124, 51, 50, 190),
        colorHover = Color(124, 51, 50, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("+menu_context")
        end
    },
    {
        control = "Z",
        description = "Undo",
        color = Color(163, 135, 79, 190),
        colorHover = Color(163, 135, 79, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("undo")
        end
    },
    {
        control = "C",
        description = "PAC Editor",
        color = Color(64, 105, 126, 190),
        colorHover = Color(64, 105, 126, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("+menu")
        end
    },
    {
        control = "F3",
        description = "Pointshop",
        color = Color(145, 71, 101, 190),
        colorHover = Color(145, 71, 101, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("+menu")
        end
    },
    {
        control = "F7",
        description = "Leaderboard",
        color = Color(72, 112, 58, 190),
        colorHover = Color(72, 112, 58, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("+menu")
        end
    },
    {
        control = "F8",
        description = "Suggestions",
        color = Color(112, 87, 58, 190),
        colorHover = Color(112, 87, 58, 240),
        enabled = true,
        func = function()
            RunConsoleCommand("+menu")
        end
    }
}

-----------------------------------------------------------------
-- [ ACTION BUTTONS ]
-- 
-- Displayed on left-side of scoreboard
-----------------------------------------------------------------

Vliss.Actions = {
    {
        name = "Cleanup Props",
        description = "Remove all your props",
        icon = "vliss/vliss_btn_cleanup.png",
        buttonNormal = Color(64, 105, 126, 190),
        buttonHover = Color(64, 105, 126, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            RunConsoleCommand("gmod_cleanup")
        end
    },
    {
        name = "Stop Sound",
        description = "Clear local sounds",
        icon = "vliss/vliss_btn_stopsound.png",
        buttonNormal = Color(64, 105, 126, 190),
        buttonHover = Color(64, 105, 126, 240),
        textNormal = Color(255, 255, 255, 255),
        textHover = Color(255, 255, 255, 255),
        enabled = true,
        func = function()
            RunConsoleCommand("stopsound")
        end
    }
}

Vliss.UseActionsIconsWithText = false       -- This shows the icons with text. SIMPLEZ.

-----------------------------------------------------------------
--  Server Listings
-----------------------------------------------------------------

Vliss.ServersEnabled = false                                 -- Should server row even display?
Vliss.ServerButtonColor = Color(15, 15, 15, 0)
Vliss.ServerButtonHoverColor = Color(255, 255, 255, 220)
Vliss.ServerButtonTextColor = Color(255, 255, 255, 255)
Vliss.ServerButtonHoverTextColor = Color(0, 0, 0, 255)
Vliss.UseServerIconsWithText = false                         -- This shows the icons with text.
Vliss.UseServerIconsOnly = false                            -- This will show the icons only, without the text counterpart. The above option OVERRIDES this, so please turn that off first.

Vliss.Servers = {
    {
        hostname = "EXAMPLE TTT SERVER",
        icon = "vliss/vliss_btn_server.png",
        ip = "192.168.1.55:28015"
    },
    {
        hostname = "EXAMPLE SANDBOX SERVER",
        icon = "vliss/vliss_btn_server.png",
        ip = "192.168.1.55:28015"
    }
}

-----------------------------------------------------------------
-- Browser Settings
-- 
-- How the internet browser will act when outside links 
-- are clicked.
-----------------------------------------------------------------

Vliss.BrowserColor = Color( 0, 0, 0, 240 )                  -- Color to use for the custom browser window.

-----------------------------------------------------------------
--  Broadcasting System - Dont really need to touch
-----------------------------------------------------------------
Vliss.BCColorServer = Color(255, 255, 0)
Vliss.BCColorName = Color(77, 145, 255)
Vliss.BCColorMsg = Color(255, 255, 255)
Vliss.BCColorValue = Color(255, 0, 0)
Vliss.BCColorValue2 = Color(255, 166, 0)
Vliss.BCColorBind = Color(255, 255, 0)
