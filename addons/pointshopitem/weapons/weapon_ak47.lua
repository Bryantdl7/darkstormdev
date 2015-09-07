ITEM.Name = 'Ak47'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_rif_ak47.mdl'
ITEM.WeaponClass = 'weapon_ak47'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end