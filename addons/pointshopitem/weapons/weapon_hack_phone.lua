ITEM.Name = 'Watch_Dogs Phone'
ITEM.Price = 5000
ITEM.Model = 'models/nitro/iphone4.mdl'
ITEM.WeaponClass = 'weapon_hack_phone'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end