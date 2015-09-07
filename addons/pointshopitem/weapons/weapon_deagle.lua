ITEM.Name = 'Deagle'
ITEM.Price = 250
ITEM.Model = 'models/weapons/w_pist_deagle.mdl'
ITEM.WeaponClass = 'weapon_deagle'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end