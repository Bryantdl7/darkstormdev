ITEM.Name = 'Hands'
ITEM.Price = 1
ITEM.Model = 'models/props/de_nuke/emergency_lighta.mdl'
ITEM.WeaponClass = 'none'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end