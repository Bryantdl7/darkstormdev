ITEM.Name = 'Permanent Damascus (beta)'
ITEM.Price = 1
ITEM.Model = 'models/weapons/w_damascus_sword.mdl'
ITEM.WeaponClass = 'm9k_damascus'
ITEM.AdminOnly = true

function ITEM:OnEquip(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnHolster(ply)
	ply:StripWeapon(self.WeaponClass)
end
