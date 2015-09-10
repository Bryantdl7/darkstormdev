ITEM.Name = 'Matador'
ITEM.Price = 5000
ITEM.Model = 'models/weapons/w_gdcw_matador_rl.mdl'
ITEM.WeaponClass = 'm9k_matador'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end