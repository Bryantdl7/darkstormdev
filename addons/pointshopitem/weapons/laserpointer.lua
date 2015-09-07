ITEM.Name = 'Laser Pointer'
ITEM.Price = 1
ITEM.Model = 'models/weapons/W_pistol.mdl'
ITEM.WeaponClass = 'laserpointer'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end