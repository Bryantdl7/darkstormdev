ITEM.Name = 'Uzi'
ITEM.Price = 250
ITEM.Model = 'models/weapons/w_uzi_imi.mdl'
ITEM.WeaponClass = 'm9k_uzi'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end
