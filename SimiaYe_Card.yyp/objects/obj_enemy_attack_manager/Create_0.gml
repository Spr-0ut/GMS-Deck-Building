#macro ATTACK_INDICATOR_GROUP_PADDING 100
#macro ATTACK_INDICATOR_Y_PADDING 15
#macro MAX_NUM_CHARA 5
#macro MAX_NUM_ENEMIES 5

if(instance_number(obj_enemy_attack_manager) > 1) {
	instance_destroy()
}

attack_highlight_layer = layer_create(layer_get_depth(find_top_layer()) - 1, "attack_highlight_layer")
attack_indicators = array_create(MAX_NUM_CHARA + MAX_NUM_ENEMIES, noone)
ordered_player_charas = []
ordered_enemies = []
attack_highlighter = instance_find(obj_attack_highlight, 0)
enemy_to_highlight_attack = noone
highlight_enemy_attack = false

/// @desc								Creates an obj_attack_indicator for each character / enemy then
///											position each character / enemy below the indicator and save
///											it into attack_indicators
function create_indicators() {
	var enemy_attack_indicator_layer = layer_get_id("enemy_attack_indicator_layer")
	if(enemy_attack_indicator_layer == -1) {
		var first_enemy = instance_find(obj_enemy, 0)
		if(first_enemy == noone) {
			return
		}
		enemy_attack_indicator_layer = layer_create(first_enemy.depth, "enemy_attack_indicator_layer")
	}
	
	var indicator_x_pos = ATTACK_INDICATOR_GROUP_PADDING
	var indicator_y_pos = room_height / 2
	var x_dist_to_add = ((room_width / 2) - (2 * ATTACK_INDICATOR_GROUP_PADDING)) / MAX_NUM_CHARA
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		var indicator = instance_create_layer(indicator_x_pos, indicator_y_pos, enemy_attack_indicator_layer, obj_attack_indicator)
		var indicator_target = find_indicator_target(indicator_index)
		
		if(indicator_target != noone) {
			indicator.target = indicator_target
			indicator.target_sprite_width = indicator_target.sprite_width
			
			indicator_target.x = indicator_x_pos + indicator_target.sprite_xoffset
			indicator_target.y = indicator_y_pos + indicator_target.sprite_yoffset + ATTACK_INDICATOR_Y_PADDING
		}
		
		attack_indicators[indicator_index] = indicator
		indicator_x_pos += x_dist_to_add
		
		if(indicator_index == MAX_NUM_CHARA - 1) {
			indicator_x_pos += 2 * ATTACK_INDICATOR_GROUP_PADDING
		}
	}
}

/// @desc								Finds the entity assigned to the indicator at the
///											given index, if any at all
/// @param {Real} indicator_index		The index of the indicator in attack_indicators.
///											NOTE: The indicator does not need to exist yet
/// @returns {Id.Instance}				The entity to be put into the attack indicator's "target"
///											variable, or noone if the target should remain empty
function find_indicator_target(indicator_index) {
	if(instance_exists(obj_follower_order_manager)) {
		if(array_length(ordered_player_charas) < 1) {
			ordered_player_charas = obj_follower_order_manager.find_charas_ordered()
		}
	}
	else {
		var follower_order_manager_layer = layer_create(0, "follower_order_manager_layer")
		instance_create_layer(0, 0, follower_order_manager_layer, obj_follower_order_manager)
	}
	
	if(indicator_index >= MAX_NUM_CHARA - array_length(ordered_player_charas) && indicator_index < MAX_NUM_CHARA) {
		return ordered_player_charas[(MAX_NUM_CHARA - 1) - indicator_index]
	}
	
	if(instance_exists(obj_enemy_manager)) {
		var ordered_enemies = obj_enemy_manager.get_ordered_enemies_array()
		if(indicator_index > MAX_NUM_CHARA - 1 && indicator_index < MAX_NUM_CHARA + array_length(ordered_enemies)) {
			return ordered_enemies[indicator_index - MAX_NUM_CHARA]
		}
	}
	else {
		var enemy_manager_layer = layer_create(0, "enemy_manager_layer")
		instance_create_layer(0, 0, enemy_manager_layer, obj_enemy_manager)
	}
	
	return noone
}


/// @desc								Searches through the enemy's attack indicators to find
///											an indicator without a target assigned
/// @returns {Id.Instance}				The first indicator without a target or noone if none exist
function find_open_enemy_indicator() {
	for(var indicator_index = MAX_NUM_CHARA - 1; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone && attack_indicators[indicator_index].target == noone) {
			return attack_indicators[indicator_index]
		}
	}
	return noone
}

/// @desc								Searches through the chara's attack indicators to find
///											an indicator without a target assigned
/// @returns {Id.Instance}				The first indicator without a target or noone if none exist
function find_open_chara_indicator() {
	for(var indicator_index = MAX_NUM_CHARA - 1; indicator_index >= 0; indicator_index--) {
		if(attack_indicators[indicator_index] != noone && attack_indicators[indicator_index].target == noone) {
			return attack_indicators[indicator_index]
		}
	}
	return noone
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
	
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		var indicator = attack_indicators[indicator_index]
		if(indicator != noone && array_contains(charas_to_attack, indicator.target)) {
			indicator.add_attack(enemy_instance_id, enemy_attack)
		}
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
		case enemy_attack_target.summon_enemy :
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

	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone) {
			attack_indicators[indicator_index].remove_attack(enemy_instance_id)
		}
	}
}

/// @desc								Loops through all the indicators and completes their attack
function perform_attacks() {
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone) {
			attack_indicators[indicator_index].attack_target_character()
		}
	}
}

/// @desc										Hides the enemy attack intents for the given character.
///													NOTE: The attack will remain present in the
///													indicator, so if the intent is shown again it will
///													still be present
/// @param {Id.Instance} chara_instance_id		The character to hide the attack intents for
function hide_chara_intents(chara_instance_id) {
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone &&
				attack_indicators[indicator_index].target == chara_instance_id) {
			attack_indicators[indicator_index].hide_attack_intents()
		}
	}
}

/// @desc										Clears the attack indicators so that they no
///													longer show the chara being attacked
/// @param {Array<String>} charas_to_clear		An optional array of the charas to clear the
///													intents for. Defaults to all charas
function clear_intents(charas_to_clear = []) {
	var clear_all = false
	if(typeof(charas_to_clear) != "array" || array_length(charas_to_clear) < 1) {
		clear_all = true
	}
	
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone && 
				(clear_all || array_contains(charas_to_clear, attack_indicators[indicator_index]))) {
			attack_indicators[indicator_index].clear_attacks()
		}
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
	var charas_targeted = []
	var indicators_used = []

	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(attack_indicators[indicator_index] != noone) {
			var attack_index = attack_indicators[indicator_index].find_enemy_attack(enemy_to_highlight_attack)
			if(attack_index != undefined) {
				array_push(charas_targeted, attack_indicators[indicator_index].target)
				array_push(indicators_used, attack_indicators[indicator_index])
			}
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