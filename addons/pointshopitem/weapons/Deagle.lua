bITEM.Name = 'Deagle'
ITEM.Price = 250
ITEM.Model = 'models/weapons/w_tcom_deagle.mdl'
ITEM.WeaponClass = 'm9k_deagle'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end