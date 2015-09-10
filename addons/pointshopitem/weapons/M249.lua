ITEM.Name = 'M249 Para'
ITEM.Price = 450
ITEM.Model = 'models/weapons/w_m249_machine_gun.mdl'
ITEM.WeaponClass = 'm9k_m249lmg'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end