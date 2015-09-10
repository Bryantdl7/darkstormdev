ITEM.Name = 'M4A1'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_m4a1_iron.mdl'
ITEM.WeaponClass = 'm9k_m4a1'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end