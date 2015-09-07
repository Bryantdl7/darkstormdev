ITEM.Name = 'M4a1'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_rif_m4a1.mdl'
ITEM.WeaponClass = 'weapon_m4a1'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end