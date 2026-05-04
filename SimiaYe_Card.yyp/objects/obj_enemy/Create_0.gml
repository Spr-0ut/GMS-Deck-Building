active_debuffs = {}
display_next_damage_text = true
damage_to_display = []
attack_options = [{attack : method(self, basic_attack), attack_parameters : [], targeting_type : enemy_attack_target.first_closest_chara}]
next_attack_index = -1

/// @desc							This is a basic example of an enemy's attack. It is expected that there
///										will be multiple attack functions implemented in each enemy type
/// @returns {attack_data_struct}	The return value of attack functions must be an attack_data_struct
function basic_attack() {
	return new attack_data_struct(irandom(10) + 1)
}

/// @desc										Handles player attacks by applying debuffs and removing
///													attack_data.damage from their health
/// @param {Id.Instance} attacking_chara		The character attacking this enemy			
/// @param {Real} damage_multiplyer				The amount that the character's damage will be multiplied by	
function hit_by_player(attacking_chara, damage_multiplyer) {
	var attack_data = attacking_chara.get_attack(damage_multiplyer)
	if(struct_exists(attack_data, "damage")) {
		take_damage(attack_data.damage)
		array_push(damage_to_display, [attack_data.damage, c_white])
		
		if(struct_exists(active_debuffs, card_debuff_effects.Mark) &&
			active_debuffs[$ card_debuff_effects.Mark] > 0) {
				attacking_chara.add_shield(1)
		}
	}
	
	if(struct_exists(attack_data, "debuffs")) {
		for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
			var debuff_type = attack_data.debuffs[attack_debuff_index][0]
			var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
			apply_debuff_to_enemy(debuff_type, debuff_amount)
		}
	}
}

/// @desc										Debuffs this enemy through the debuff_handler and adds it
///													to the damage_to_display
/// @param {card_debuff_effects} debuff_type	The debuff being applied to this enemy
/// @param {Real} debuff_amount					The amount of the debuff being added
function apply_debuff_to_enemy(debuff_type, debuff_amount) {
	var debuff_damage = apply_debuff(active_debuffs, debuff_type, debuff_amount)
	if(array_length(debuff_damage) == 2) {
		array_push(damage_to_display, debuff_damage)
	}
}

/// @desc							Increments the next_attack_index, looping back to 0 if required,
///										and sets the attack intent for this enemy
function select_next_attack() {
	next_attack_index++
	if(next_attack_index >= array_length(attack_options) || next_attack_index < 0) {
		next_attack_index = 0
	}
	
	if(instance_exists(obj_enemy_attack_manager)) {
		var enemy_attack_data = get_next_attack()
		var enemy_attack = method_call(enemy_attack_data.attack, enemy_attack_data.attack_parameters)
		obj_enemy_attack_manager.add_enemy_intent(id, enemy_attack, enemy_attack_data.targeting_type)
	}
}

/// @desc							Finds this enemy's next attack based on next_attack_index
///										NOTE: This function does NOT handle incrementing next_attack_index
/// @returns {Struct}				A struct with the attack function and targeting_type for the enemy's
///										next attack
function get_next_attack() {
	if(array_length(attack_options) < 1 || next_attack_index >= array_length(attack_options)) {
		return noone	
	}
	
	var attack_option = attack_options[next_attack_index]
	if(attack_option.attack == noone || !is_method(attack_option.attack) || 
			attack_option.targeting_type < 0) {
		array_delete(attack_options, next_attack_index, 1)
		attack_option = get_next_attack()
	}
	
	return attack_option
}

/// @desc							Formats a number by removing any trailing 0s or decimals
/// @param {Real} num_to_format		The number to be returned after formatting
/// @returns						A string representation of the given number with trailing 0s and if
///										if needed decimal point removed
function format_display_number(num_to_format) {
	var num_string = string(num_to_format)
	var decimal_pos = string_pos(num_string, ".")
	if(decimal_pos == 0) {
		return num_string
	}
	
	for(var char_index = string_length(num_string); char_index > decimal_pos - 1; char_index--) {
		if(string_ends_with(num_string, "0")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
		}
		else if (string_ends_with(num_string, ".")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
			break;
		}
		else {
			break;	
		}
	}
	if(string_length(num_string) == 0) {
		num_string = "0"
	}
	return num_string
}

/// @desc							Loops through the debuffs currently active on this enemy and
///										applys the damage
function trigger_end_of_turn_debuffs() {
	struct_foreach(active_debuffs, function (debuff_name, debuff_amount) {
		var debuff_data = get_debuff_damage(active_debuffs, debuff_name)
		if(array_length(debuff_data) == 2) {
			array_push(damage_to_display, debuff_data)
			take_damage(debuff_data[0])
		}
	})
}

/// @desc							Removes health from this enemy and checks if they die
/// @param {Real} health_damage		The amount of health to remove from this enemy
function take_damage(health_damage) {
	Health -= health_damage
	if(Health <= 0 && Is_alive) {
		Is_alive = false
		show_debug_message("This enemy is dead")
	}
}