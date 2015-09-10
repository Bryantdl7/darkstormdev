ITEM.Name = 'Harpoon'
ITEM.Price = 800
ITEM.Model = 'models/props_junk/harpoon002a.mdl'
ITEM.WeaponClass = 'm9k_harpoon'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end