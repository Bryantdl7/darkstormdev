ITEM.Name = 'sCar Repair'
ITEM.Price = 1
ITEM.Model = 'models/props_c17/tools_wrench01a.mdl'
ITEM.WeaponClass = 'weapon_scarrepair'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end