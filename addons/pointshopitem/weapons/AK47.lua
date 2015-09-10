ITEM.Name = 'AK 47'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_ak47_m9k.mdl'
ITEM.WeaponClass = 'm9k_ak47'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end