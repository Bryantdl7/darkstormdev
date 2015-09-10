ITEM.Name = 'Grenade'
ITEM.Price = 850
ITEM.Model = 'models/weapons/w_m61_fraggynade_thrown.mdl'
ITEM.WeaponClass = 'm9k_m61_frag'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end