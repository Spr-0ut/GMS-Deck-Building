#macro ATTACK_INDICATOR_PADDING 15

if(instance_number(obj_enemy_attack_manager) > 1) {
	instance_destroy()
}

enemy_attack_indicator_layer = noone
attack_indicators = {}
ordered_player_charas = []
create_indicators()

/// @desc								Creates an obj_attack_indicator above each character and
///											saves them into attack_indicators
function create_indicators() {
	if(array_length(ordered_player_charas) < 1) {
		ordered_player_charas = obj_follower_order_manager.find_charas_ordered()
	}
	if(enemy_attack_indicator_layer == noone || !layer_exists(enemy_attack_indicator_layer)) {
		enemy_attack_indicator_layer = layer_create(ordered_player_charas[0].depth, "enemy_attack_indicator_layer")
	}
	for(var chara_index = 0; chara_index < array_length(ordered_player_charas); chara_index++) {
		var chara = ordered_player_charas[chara_index]
		var indicator_x_pos = chara.x - chara.sprite_xoffset
		var indicator_y_pos = chara.y - chara.sprite_yoffset - ATTACK_INDICATOR_PADDING
		var indicator = instance_create_layer(indicator_x_pos, indicator_y_pos, enemy_attack_indicator_layer, obj_attack_indicator, {
				chara_targeted : chara,
				target_sprite_width : chara.sprite_width
		})
		attack_indicators[$ chara] = indicator
	}
}

/// @desc												Adds an attack to the attack indicator for the
///															given characters
/// @param {Id.Instance} enemy_instance_id				The enemy initiating the attack
/// @param {attack_data_struct} enemy_attack			The struct containing required data for the attack
/// @param {enemy_attack_target} attack_targeting_type	The targeting type to determine who is targeted
function add_enemy_intent(enemy_instance_id, enemy_attack, attack_targeting_type) {
	var charas_to_attack = get_players_targeted(attack_targeting_type)
	if(typeof(enemy_instance_id) != "ref" || !object_is_ancestor(enemy_instance_id.object_index, obj_enemy)) {
		return
	}
	if(typeof(enemy_attack) != "struct" || !is_instanceof(enemy_attack, attack_data_struct)) {
		return
	}
	if(typeof(charas_to_attack) != "array" || array_length(charas_to_attack) < 1) {
		return
	}
	
	for(var chara_index = 0; chara_index < array_length(charas_to_attack); chara_index++) {
		var chara_instance_id = charas_to_attack[chara_index]
		attack_indicators[$ chara_instance_id].add_attack(enemy_instance_id, enemy_attack)
	}
}

/// @desc											Finds all the players targeted for the given
///														targeting_type
/// @param {enemy_attack_target} targeting_type		The targeting type which determines which player
///														characters will be hit
/// @returns {Array<Id.Instance>}					All the players targeted for the given targeting type
function get_players_targeted(targeting_type) {
	if(array_length(ordered_player_charas) < 1) {
		ordered_player_charas = obj_follower_order_manager.find_charas_ordered()
	}
	
	switch(targeting_type) {
		case enemy_attack_target.first_closest_chara :
			return [array_last(ordered_player_charas)]
		case enemy_attack_target.second_closest_chara :
			return [ordered_player_charas[max(array_length(ordered_player_charas) - 2, 0)]]
		case enemy_attack_target.third_closest_chara :
			return [ordered_player_charas[max(array_length(ordered_player_charas) - 3, 0)]]
		case enemy_attack_target.fourth_closest_chara :
			return [ordered_player_charas[max(array_length(ordered_player_charas) - 4, 0)]]
		case enemy_attack_target.fifth_closest_chara :
			return [ordered_player_charas[max(array_length(ordered_player_charas) - 5, 0)]]
		case enemy_attack_target.random_chara :
			return [ordered_player_charas[irandom(array_length(ordered_player_charas) - 1)]]
	}
}

/// @desc											Removes any attacks previously initiated by the
///														given enemy
/// @param {Id.Instance} enemy_instance_id			The enemy that initiated the attack
function remove_enemy_intent(enemy_instance_id) {
	if(typeof(enemy_instance_id) != "ref" || !object_is_ancestor(enemy_instance_id.object_index, obj_enemy)) {
		return
	}

	struct_foreach(attack_indicators, function (_name, _value) {
		_value.remove_attack(enemy_instance_id)
	})
}

/// @desc								Loops through all the indicators and completes their attack
function perform_attacks() {
	var charas_to_attack = struct_get_names(attack_indicators)
	for(var chara_index = 0; chara_index < array_length(charas_to_attack); chara_index++) {
		attack_indicators[$ charas_to_attack[chara_index]].attack_target_character()
	}
}

/// @desc										Hides the enemy attack intents for the given character.
///													NOTE: The attack will remain present in the
///													indicator, so if the intent is shown again it will
///													still be present
/// @param {Id.Instance} chara_instance_id		The character to hide the attack intents for
function hide_chara_intents(chara_instance_id) {
	attack_indicators[$ chara_instance_id].hide_attack_intents()
}

/// @desc										Clears the attack indicators so that they no
///													longer show the chara being attacked
/// @param {Array<String>} charas_to_clear		An optional array of the charas to clear the
///													intents for. Defaults to all charas
function clear_intents(charas_to_clear = []) {
	if(typeof(charas_to_clear) != "array" || array_length(charas_to_clear) < 1) {
		charas_to_clear = struct_get_names(attack_indicators)
	}
	
	for(var chara_index = 0; chara_index < array_length(charas_to_clear); chara_index++) {
		attack_indicators[$ charas_to_clear[chara_index]].clear_attacks()
	}
}