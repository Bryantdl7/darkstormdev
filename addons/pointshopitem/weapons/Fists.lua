ITEM.Name = 'Fists'
ITEM.Price = 250
ITEM.Model = 'models/weapons/v_invisible_nade.mdl'
ITEM.WeaponClass = 'm9k_fists'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end