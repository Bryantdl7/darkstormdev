ITEM.Name = 'KRISS Vector'
ITEM.Price = 450
ITEM.Model = 'models/weapons/w_kriss_vector.mdl'
ITEM.WeaponClass = 'm9k_vector'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end