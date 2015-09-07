ITEM.Name = 'Shotgun'
ITEM.Price = 350
ITEM.Model = 'models/weapons/w_shot_m3super90.mdl'
ITEM.WeaponClass = 'weapon_pumpshotgun'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end