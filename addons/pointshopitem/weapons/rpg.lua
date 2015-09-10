ITEM.Name = 'RPG'
ITEM.Price = 4500
ITEM.Model = 'models/weapons/w_rocket_launcher.mdl'
ITEM.WeaponClass = 'weapon_rpg'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end