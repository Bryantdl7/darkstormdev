ITEM.Name = 'sCar Gas Can'
ITEM.Price = 1
ITEM.Model = 'models/props_junk/gascan001a.mdl'
ITEM.WeaponClass = 'weapon_scarrefuel'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end