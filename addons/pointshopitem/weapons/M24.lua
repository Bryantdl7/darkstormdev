bITEM.Name = 'M24'
ITEM.Price = 650
ITEM.Model = 'models/weapons/w_snip_m24_6.mdl'
ITEM.WeaponClass = 'm9k_m24'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end