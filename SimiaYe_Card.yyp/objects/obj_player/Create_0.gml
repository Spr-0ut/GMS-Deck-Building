#macro TIME_BETWEEN_EFFECT_TEXT 12
#macro MAX_CHARA_SHIELD 5

class = chara_class.damage
active_buffs = {}
display_next_effect_text = true
effect_to_display = []
chara_shield = 0
player_current_health = player_max_health
turns_since_gain_strength_on_attack = 1

/// @desc										Handles the character being hit by removing health equal
///													to enemy_attack's damage and adding debuffs. Then
///													checks if the player is still alive
/// @param {attack_data_struct} enemy_attack	The struct containing the attack data of the enemy
function hit_by_enemy(enemy_attack) {
	if(struct_exists(enemy_attack, "damage")) {
		var damage_taken = max(enemy_attack.damage - chara_shield, 0)
		array_push(effect_to_display, [damage_taken, c_white])
		player_current_health = clamp(player_current_health - damage_taken, 0, player_max_health)
		
		show_debug_message(player_current_health)
		if(player_current_health <= 0)
			show_debug_message("Player is dead")
	}
	
	if(struct_exists(enemy_attack, "debuffs")) {
		for(var attack_debuff_index = 0; attack_debuff_index < array_length(enemy_attack.debuffs); attack_debuff_index++) {
			var debuff_type = enemy_attack.debuffs[attack_debuff_index][0]
			var debuff_amount = enemy_attack.debuffs[attack_debuff_index][1]
			apply_debuff_to_player(debuff_type, debuff_amount)
		}
	}
}

/// @desc								Displays the damage, buffs, and debuffs applied to the chara, 
///											allowing for different quantity and color to differentiate
///											the source of the text
function display_effect_text() {
	if(display_next_effect_text) {
		if(array_length(effect_to_display) > 0) {
			var damage_data = array_shift(effect_to_display)
			var amount_of_damage = format_display_number(damage_data[0])
			var damage_text_color = damage_data[1]
			instance_create_layer(x, y, "Instances", obj_damageText,
			{
				damage_taken : amount_of_damage,
				text_color : damage_text_color
			})
			alarm[0] = TIME_BETWEEN_EFFECT_TEXT
			display_next_effect_text = false
		}
	}
}

/// @desc							Formats a number by removing any trailing 0s or decimals
/// @param {Real} num_to_format		The number to be returned after formatting
/// @returns						A string representation of the given number with trailing 0s and if
///										if needed decimal point removed
function format_display_number(num_to_format) {
	if(num_to_format == undefined) {
		return "0"	
	}
	
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

/// @desc								Finds the type and amount of damage/debuffs the character does
///											when they attack
/// @returns							The struct containing the attack data of the character
function get_attack(damage_multiplier) {
	//TODO need to make this the chara's actual attacks
	var strength = 0
	if(active_buffs[$ card_buff_effects.Strength] != undefined)
		strength = active_buffs[$ card_buff_effects.Strength]
		
	var hitstrct = new attack_data_struct ((10 + strength) * damage_multiplier, 
											[[card_debuff_effects.Poison, 3 * damage_multiplier]])
	return hitstrct
}

/// @desc								Adds the amount of shield provided to the chara's shield
/// @param {Real} shield_amount			The amount of shield being added
function add_shield(shield_amount) {
	if (shield_amount > 0)
		chara_shield = clamp(chara_shield + shield_amount, 0, MAX_CHARA_SHIELD)
}

/// @desc								Heals the chara by the given amount up, but not more than,
///											their max health
/// @param {Real} health_to_add			The maximum health to be healed
function heal_chara(health_to_add) {
	if(health_to_add > 0)
		player_current_health = clamp(player_current_health + health_to_add, 0, player_max_health)
}

/// @desc										Applies a buff to this chara and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being applied
/// @param {Real} buff_amount					The amount of the buff being added
function apply_buff(buff_type, buff_amount) {
	if(active_buffs[$ buff_type] == undefined)
			active_buffs[$ buff_type] = buff_amount
	else
		active_buffs[$ buff_type] += buff_amount
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_fuchsia])
			turns_since_gain_strength_on_attack = 1
			break;
	}
}

/// @desc										Debuffs this character through the debuff_handler and
///													adds it to the damage_to_display
/// @param {card_debuff_effects} debuff_type	The debuff being applied to this character
/// @param {Real} debuff_amount					The amount of the debuff being added
function apply_debuff_to_player(debuff_type, debuff_amount) {
	var debuff_damage = apply_debuff(active_debuffs, debuff_type, debuff_amount)
	if(array_length(debuff_damage) == 2) {
		array_push(damage_to_display, debuff_damage)
	}
}

/// @desc										Increases the amount of a given buff by multiplying it
///													by amount_multipled and adds them to the 
///													effect_to_display queue
/// @param {card_buff_effects} buff_type		The buff being modified
/// @param {Real} buff_amount					The amount of the buff being added
function multiply_buff(buff_type, amount_multiplied) {
	if(active_buffs[$ buff_type] != undefined) {
			active_buffs[$ buff_type] *= amount_multiplied
	}
			
	switch (buff_type) {
		case card_buff_effects.Strength:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_maroon])
			break;
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			array_push(effect_to_display, [active_buffs[$ buff_type], c_fuchsia])
			break;
	}
}

/// @desc										Loops through each buff for this player and handles
///													what should happen with it at the end of the
///													player's turn
function trigger_end_of_turn_buffs() {
	struct_foreach(active_buffs, function (debuff_name, debuff_amount) {
		switch (debuff_name) {
			case card_buff_effects.Gain_Strength_On_Any_Attack:
				struct_remove(active_buffs, debuff_name)
				turns_since_gain_strength_on_attack = 1
				break
		}
	})
}