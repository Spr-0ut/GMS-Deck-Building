active_debuffs = {}
/// @desc							Subtracts the amount of damage_taken and checks if enemy is alive
/// @param {Struct} attack_data		The struct containing information about the attack including damage,
///									debuffs, and buffs						
function hit_by_player(attack_data) {
	for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
		var debuff_type = attack_data.debuffs[attack_debuff_index][0]
		var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
		
		if(active_debuffs[$ debuff_type] == undefined)
			active_debuffs[$ debuff_type] = debuff_amount
		else
			active_debuffs[$ debuff_type] += debuff_amount
	}
	
	Health -= attack_data.damage
	if(Health <= 0) {
		Is_alive = false
	}
	
	show_debug_message(Health)
	show_debug_message(active_debuffs)
}

/// @desc			Damages the player by enemy Attack_damage
function attack_player() {
	obj_player.hit_by_enemy(Attack_damage)
}