ITEM.Name = 'Para'
ITEM.Price = 450
ITEM.Model = 'models/weapons/w_mach_m249para.mdl'
ITEM.WeaponClass = 'weapon_para'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end