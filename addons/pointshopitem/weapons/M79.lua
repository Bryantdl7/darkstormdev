ITEM.Name = 'M79 GL'
ITEM.Price = 4750
ITEM.Model = 'models/weapons/w_m79_grenadelauncher.mdl'
ITEM.WeaponClass = 'm9k_m79gl'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end