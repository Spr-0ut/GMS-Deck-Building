//Temp way to test attacking the enemy, this will be replaced with actually playing the cards
var hitstrct = {
	damage : 10,
	debuffs : [[Card_Debuff_Effects.Poison, 3],
				[Card_Debuff_Effects.Burn,  5]]
}

obj_enemy.hit_by_player(hitstrct)