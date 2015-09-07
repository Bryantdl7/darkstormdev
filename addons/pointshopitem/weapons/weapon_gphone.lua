ITEM.Name = 'iPhone'
ITEM.Price = 150
ITEM.Model = 'models/props/de_nuke/emergency_lighta.mdl'
ITEM.WeaponClass = 'weapon_gphone'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end