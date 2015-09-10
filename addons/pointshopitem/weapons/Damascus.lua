ITEM.Name = 'Damascus Sword'
ITEM.Price = 750
ITEM.Model = 'models/weapons/w_damascus_sword.mdl'
ITEM.WeaponClass = 'm9k_damascus'
ITEM.SingleUse = true

function ITEM:OnBuy(ply)
	ply:Give(self.WeaponClass)
	ply:SelectWeapon(self.WeaponClass)
end

function ITEM:OnSell(ply)
	ply:StripWeapon(self.WeaponClass)
end