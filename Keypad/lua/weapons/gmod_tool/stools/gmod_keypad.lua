if (SERVER) then
	CreateConVar('sbox_maxkeypads', 10)
end

TOOL.Category = "Construction"
TOOL.Name = "Keypad"
TOOL.Command = nil

TOOL.ClientConVar['weld'] = '1'
TOOL.ClientConVar['freeze'] = '1'

TOOL.ClientConVar['password'] = '1234'
TOOL.ClientConVar['secure'] = '0'

TOOL.ClientConVar['repeats_granted'] = '0'
TOOL.ClientConVar['repeats_denied'] = '0'

TOOL.ClientConVar['length_granted'] = '0.1'
TOOL.ClientConVar['length_denied'] = '0.1'

TOOL.ClientConVar['delay_granted'] = '0'
TOOL.ClientConVar['delay_denied'] = '0'

TOOL.ClientConVar['init_delay_granted'] = '0'
TOOL.ClientConVar['init_delay_denied'] = '0'

TOOL.ClientConVar['key_granted'] = '0'
TOOL.ClientConVar['key_denied'] = '0'

cleanup.Register("keypads")

if(CLIENT) then
	language.Add("tool.gmod_keypad.name", "Keypad")
	language.Add("tool.gmod_keypad.0", "Left Click: Create, Right Click: Update")
	language.Add("tool.gmod_keypad.desc", "Creates Keypads for secure access")

	language.Add("Undone_Keypad", "Undone Keypad")
	language.Add("Cleanup_keypads", "Keypads")
	language.Add("Cleaned_keypads", "Cleaned up all Keypads")

	language.Add("SBoxLimit_keypads", "You've hit the Keypad limit!")
end

function TOOL:SetupKeypad(ent, pass)
	local data = {
		Password = pass,

		RepeatsGranted = self:GetClientNumber("repeats_granted"),
		RepeatsDenied = self:GetClientNumber("repeats_denied"),

		LengthGranted = self:GetClientNumber("length_granted"),
		LengthDenied = self:GetClientNumber("length_denied"),

		DelayGranted = self:GetClientNumber("delay_granted"),
		DelayDenied = self:GetClientNumber("delay_denied"),

		InitDelayGranted = self:GetClientNumber("init_delay_granted"),
		InitDelayDenied = self:GetClientNumber("init_delay_denied"),

		KeyGranted = self:GetClientNumber("key_granted"),
		KeyDenied = self:GetClientNumber("key_denied"),

		Secure = util.tobool(self:GetClientNumber("secure")),

		Owner = self:GetOwner()
	}

	ent:SetData(data)
end

function TOOL:RightClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() ~= "keypad") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = tonumber(ply:GetInfo("gmod_keypad_password"))

	local spawn_pos = tr.HitPos
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:PrintMessage(3, "Invalid password!")
		return false
	end

	if(trace_ent:GetClass() == "keypad" and trace_ent.KeypadData.Owner == ply) then
		self:SetupKeypad(trace_ent, password) -- validated password

		return true
	end
end

function TOOL:LeftClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() == "player") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = self:GetClientNumber("password")

	local spawn_pos = tr.HitPos + tr.HitNormal
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:PrintMessage(3, "Invalid password!")
		return false
	end

	if(not self:GetWeapon():CheckLimit("keypads")) then return false end

	local ent = ents.Create("keypad")
	ent:SetPos(spawn_pos)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()
	ent:SetPlayer(ply)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Activate()

	local phys = ent:GetPhysicsObject() -- rely on this being valid

	self:SetupKeypad(ent, password)

	undo.Create("Keypad")
		if(util.tobool(self:GetClientNumber("freeze"))) then
			phys:EnableMotion(false)
		end

		if(util.tobool(self:GetClientNumber("weld"))) then
			phys:EnableMotion(false) -- The timer allows the keypad to fall slightly, no thanks

			timer.Simple(0, function()
				if(IsValid(ent) and IsValid(trace_ent)) then
					local weld = constraint.Weld(ent, trace_ent, 0, 0, 0, true, false)

					if(not util.tobool(self:GetClientNumber("freeze"))) then
						phys:EnableMotion(true)
					end
				end
			end)

			ent:GetPhysicsObject():EnableCollisions(false)
		end

		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCount("keypads", ent)
	ply:AddCleanup("keypads", ent)

	return true
end


if(CLIENT) then
	local function ResetSettings(ply)
		ply:ConCommand("gmod_keypad_repeats_granted 0")
		ply:ConCommand("gmod_keypad_repeats_denied 0")
		ply:ConCommand("gmod_keypad_length_granted 0.1")
		ply:ConCommand("gmod_keypad_length_denied 0.1")
		ply:ConCommand("gmod_keypad_delay_granted 0")
		ply:ConCommand("gmod_keypad_delay_denied 0")
		ply:ConCommand("gmod_keypad_init_delay_granted 0")
		ply:ConCommand("gmod_keypad_init_delay_denied 0")
	end

	concommand.Add("gmod_keypad_reset", ResetSettings)

	function TOOL.BuildCPanel(CPanel)
		local r, l = CPanel:TextEntry("Access Password", "gmod_keypad_password")
		r:SetTall(22)

		CPanel:ControlHelp("Max Length: 4\nAllowed Digits: 1-9")

		CPanel:CheckBox("Secure Mode", "gmod_keypad_secure")
		CPanel:CheckBox("Weld", "gmod_keypad_weld")
		CPanel:CheckBox("Freeze", "gmod_keypad_freeze")

		local ctrl = vgui.Create("CtrlNumPad", CPanel)
			ctrl:SetConVar1("gmod_keypad_key_granted")
			ctrl:SetConVar2("gmod_keypad_key_denied")
			ctrl:SetLabel1("Access Granted Key")
			ctrl:SetLabel2("Access Denied Key")
		CPanel:AddPanel(ctrl)

		local granted = vgui.Create("DForm")
			granted:SetName("Access Granted Settings")

			granted:NumSlider("Hold Length:", "gmod_keypad_length_granted", 0.1, 10, 2)
			granted:NumSlider("Initial Delay:", "gmod_keypad_init_delay_granted", 0, 10, 2)
			granted:NumSlider("Multiple Press Delay:", "gmod_keypad_delay_granted", 0, 10, 2)
			granted:NumSlider("Additional Repeats:", "gmod_keypad_repeats_granted", 0, 5, 0)
		CPanel:AddItem(granted)

		local denied = vgui.Create("DForm")
			denied:SetName("Access Denied Settings")

				denied:NumSlider("Hold Length:", "gmod_keypad_length_denied", 0.1, 10, 2)
				denied:NumSlider("Initial Delay:", "gmod_keypad_init_delay_denied", 0, 10, 2)
				denied:NumSlider("Multiple Press Delay:", "gmod_keypad_delay_denied", 0, 10, 2)
				denied:NumSlider("Additional Repeats:", "gmod_keypad_repeats_denied", 0, 5, 0)
		CPanel:AddItem(denied)

		CPanel:Button("Default Settings", "gmod_keypad_reset")

		CPanel:Help("")

	end
end
