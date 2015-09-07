ITEM.Name = 'Mac10'
ITEM.Price = 250
ITEM.Model = 'models/weapons/w_smg_mac10.mdl'
ITEM.WeaponClass = 'weapon_mac10'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end