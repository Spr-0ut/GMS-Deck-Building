#macro ATTACK_INDICATOR_PADDING 15

if(instance_number(obj_enemy_attack_manager) > 1) {
	instance_destroy()
}

enemy_attack_indicator_layer = noone
attack_highlight_layer = layer_create(layer_get_depth(find_top_layer()) - 1, "attack_highlight_layer")
attack_indicators = {}
ordered_player_charas = []
ordered_enemies = []
attack_highlighter = instance_find(obj_attack_highlight, 0)
enemy_to_highlight_attack = noone
highlight_enemy_attack = false

/// @desc								Creates an obj_attack_indicator above each character / enemy and
///											saves them into attack_indicators
function create_indicators() {
	if(array_length(ordered_player_charas) < 1) {
		ordered_player_charas = obj_follower_order_manager.find_charas_ordered()
	}
	if(array_length(ordered_enemies) < 1) {
		ordered_enemies = find_enemies_ordered()
	}
	if(enemy_attack_indicator_layer == noone || !layer_exists(enemy_attack_indicator_layer)) {
		enemy_attack_indicator_layer = layer_create(ordered_player_charas[0].depth, "enemy_attack_indicator_layer")
	}
	for(var chara_index = 0; chara_index < array_length(ordered_player_charas); chara_index++) {
		var chara = ordered_player_charas[chara_index]
		var indicator_x_pos = chara.x - chara.sprite_xoffset
		var indicator_y_pos = chara.y - chara.sprite_yoffset - ATTACK_INDICATOR_PADDING
		var indicator = instance_create_layer(indicator_x_pos, indicator_y_pos, enemy_attack_indicator_layer, obj_attack_indicator, {
				target : chara,
				target_sprite_width : chara.sprite_width
		})
		attack_indicators[$ chara] = indicator
	}
	
	for(var enemy_index = 0; enemy_index < array_length(ordered_enemies); enemy_index++) {
		var enemy = ordered_enemies[enemy_index]
		var indicator_x_pos = enemy.x - enemy.sprite_xoffset
		var indicator_y_pos = enemy.y - enemy.sprite_yoffset - ATTACK_INDICATOR_PADDING
		var indicator = instance_create_layer(indicator_x_pos, indicator_y_pos, enemy_attack_indicator_layer, obj_attack_indicator, {
				target : enemy,
				target_sprite_width : enemy.sprite_width
		})
		attack_indicators[$ enemy] = indicator
	}
}

/// @desc								Finds all of the instances obj_enemy and its children
///											and orders them in a list based on their x position
/// @returns {Array<Id.Instance>}		All of the enemies order based on their x position
function find_enemies_ordered() {
	var enemies = array_create(instance_number(obj_enemy))
	for(var enemy_index = 0; enemy_index < instance_number(obj_enemy); enemy_index++) {
		enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(enemies, function (current, next) {
		return 	current.x - next.x
	})
	return enemies
}

/// @desc												Adds an attack to the attack indicator for the
///															given characters
/// @param {Id.Instance} enemy_instance_id				The enemy initiating the attack
/// @param {attack_data_struct} enemy_attack			The struct containing required data for the attack
/// @param {enemy_attack_target} attack_targeting_type	The targeting type to determine who is targeted
function add_enemy_intent(enemy_instance_id, enemy_attack, attack_targeting_type) {
	var charas_to_attack = get_players_targeted(attack_targeting_type, enemy_instance_id)
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
/// @param {Id.Instance} attacker_instance_id		The entity targeting the players
/// @returns {Array<Id.Instance>}					All the players targeted for the given targeting type
function get_players_targeted(targeting_type, attacker_instance_id) {
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
		case enemy_attack_target.all_chara :
			return ordered_player_charas
		case enemy_attack_target.no_target :
			return []
		case enemy_attack_target.self :
			return [attacker_instance_id]
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

/// @desc								Sets the given enemy's attack to be highlighted
/// @param {Id.Instance} enemy_id		The enemy who will be highlighted along with their
//											attack and attack target
function highlight_attack(enemy_id) {
	highlight_enemy_attack = true
	
	if (!instance_exists(attack_highlighter)) {
		attack_highlighter = instance_find(obj_attack_highlight, 0)
	}
	if(attack_highlighter != noone) {
		attack_highlighter.add_attack_highlight()	
	}
	
	if(enemy_to_highlight_attack != enemy_id || attack_highlighter == noone) {
		enemy_to_highlight_attack = enemy_id
		var targets = find_targeted_chara_and_indicators()
		
		if(attack_highlighter == noone) {
			instance_create_layer(0, 0, attack_highlight_layer, obj_attack_highlight, {
				chara_targeted : targets.charas_targeted,
				enemy_attacking : enemy_to_highlight_attack,
				attack_indicators : targets.indicators_used
			})
		}
		else {
			if(attack_highlighter.enemy_attacking != enemy_to_highlight_attack) {
				attack_highlighter.set_chara_targeted(targets.charas_targeted)
				attack_highlighter.set_enemy_attacking(enemy_to_highlight_attack)
				attack_highlighter.set_attack_indicators(targets.indicators_used)
			}
		}
	}
}

/// @desc								Finds all of the entities that are targeted by 
///											enemy_to_highlight_attack and their associated
///											indicators
/// @returns {Struct}					A struct containing the charas_targeted and
///											indicators_used arrays
function find_targeted_chara_and_indicators() {
	var indicator_ids = struct_get_names(attack_indicators)
	var charas_targeted = []
	var indicators_used = []

	for(var indicator_index = 0; indicator_index < variable_struct_names_count(attack_indicators); indicator_index++) {
		var attack_indicator = attack_indicators[$ indicator_ids[indicator_index]]
		var attack_index = attack_indicator.find_enemy_attack(enemy_to_highlight_attack)
		if(attack_index != undefined) {
			array_push(charas_targeted, attack_indicator.target)
			array_push(indicators_used, attack_indicator)
		}
	}
	return {charas_targeted, indicators_used}
}

/// @desc								Removes the highlighting of the attack
function remove_attack_highlight() {
	if(instance_exists(obj_attack_highlight)) {
		obj_attack_highlight.remove_attack_highlight()
	}
}