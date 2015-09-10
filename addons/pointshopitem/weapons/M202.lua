ITEM.Name = 'M202'
ITEM.Price = 5250
ITEM.Model = 'models/weapons/w_m202.mdl'
ITEM.WeaponClass = 'm9k_m202'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end