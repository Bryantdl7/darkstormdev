ITEM.Name = 'Remote Controller'
ITEM.Price = 1
ITEM.Model = 'models/weapons/W_pistol.mdl'
ITEM.WeaponClass = 'remotecontroller'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end