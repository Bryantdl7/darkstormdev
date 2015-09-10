ITEM.Name = 'Ithica M37'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_ithaca_m37.mdl'
ITEM.WeaponClass = 'm9k_ithacam37'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end