ITEM.Name = 'LightSaber'
ITEM.Price = 750
ITEM.Model = 'models/props_junk/harpoon002a.mdl'
ITEM.WeaponClass = 'weapon_lightsaber'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end