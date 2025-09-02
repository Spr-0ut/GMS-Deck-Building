active_debuffs = {}
display_next_damage_text = true
damageToDisplay = []

/// @desc							Handles player attacks by applying debuffs and removing attack_data.damage
///										from their health
/// @param {Struct} attack_data		The struct containing information about the attack including damage,
///										debuffs, and buffs						
function hit_by_player(attack_data) {
	Health -= attack_data.damage
	array_push(damageToDisplay, [attack_data.damage, c_white])
	if(Health <= 0) {
		Is_alive = false
	}
	
	for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
		var debuff_type = attack_data.debuffs[attack_debuff_index][0]
		var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
		
		if(active_debuffs[$ debuff_type] == undefined)
			active_debuffs[$ debuff_type] = debuff_amount
		else
			active_debuffs[$ debuff_type] += debuff_amount
			
		switch (debuff_type) {
			case Card_Debuff_Effects.Poison:
				array_push(damageToDisplay, [debuff_amount, c_purple])
				break;
			case Card_Debuff_Effects.Burn:
				array_push(damageToDisplay, [debuff_amount, c_red])
				break;
			default:
				array_push(damageToDisplay, [debuff_amount, c_orange])
				break;
		}
	}
}

/// @desc			Damages the player by enemy Attack_damage
function attack_player() {
	obj_player.hit_by_enemy(Attack_damage)
}