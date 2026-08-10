if(instance_number(obj_enemy_manager) > 1) {
	instance_destroy()
}

enemy_instance_layer = layer_create(depth, "enemy_instance_layer")
ordered_enemies = []

/// @desc								The function to be used to access ordered_enemies
/// @returns {Array<Id.Instance>}		All of the enemies ordered based on their x position
function get_ordered_enemies_array() {
	if(array_length(ordered_enemies) <= 0) {
		find_enemies_ordered()
	}
	return ordered_enemies
}

/// @desc								Finds all of the instances obj_enemy and its children
///											and orders them in a list based on their x position
function find_enemies_ordered() {
	ordered_enemies = array_create(instance_number(obj_enemy))
	for(var enemy_index = 0; enemy_index < instance_number(obj_enemy); enemy_index++) {
		ordered_enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(ordered_enemies, function (current, next) {
		return 	current.x - next.x
	})
}

/// @desc								Adds the given enemy to the ordered_enemies array
/// @param {Id.Instance} enemy			The enemy instance to keep a record of
function add_existing_enemy(enemy) {
	for(var enemy_index = 0; enemy_index <= array_length(ordered_enemies); enemy_index++) {
		if(enemy_index == array_length(ordered_enemies) ||
				enemy.x < ordered_enemies[enemy_index].x) {
			array_insert(ordered_enemies, enemy_index, enemy)
			break
		}
	}
}

/// @desc								Creates an enemy in an open indicator, if one is avaliable
/// @param {Asset.GMObject} enemy		The enemy to create an instance for
/// @returns {Id.Instance}				The instance id of the enemy created, or noone if it couldnt
///											be created
function create_new_enemy(enemy) {
	if(typeof(enemy) == "ref" && object_is_ancestor(enemy, obj_enemy)) {
		if(instance_exists(obj_enemy_attack_manager)) {
			var enemy_indicator = obj_enemy_attack_manager.find_open_enemy_indicator()
			if(enemy_indicator != noone) {
				var x_pos = enemy_indicator.x + sprite_get_xoffset(object_get_sprite(enemy))
				var y_pos = enemy_indicator.y + sprite_get_yoffset(object_get_sprite(enemy)) + ATTACK_INDICATOR_Y_PADDING
				
				var enemy_instance = instance_create_layer(x_pos, y_pos, enemy_instance_layer, enemy, { 
					has_summon_sickness : true
				})
				add_existing_enemy(enemy_instance)
				enemy_indicator.target = enemy_instance
				enemy_indicator.target_sprite_width = enemy_instance.sprite_width
				
				return enemy_instance
			}
		}
		else {
			var enemy_attack_manager_layer = layer_create(0, "enemy_attack_manager_layer")
			instance_create_layer(0, 0, enemy_attack_manager_layer, obj_enemy_attack_manager)
		}
	}
	return noone
}

/// @desc								Handles ending the enemies turn, triggering their debuffs,
///											removing any temporary attacks after they are used, and
///											selecting the next attack
function end_enemies_turn() {
	if(array_length(ordered_enemies) < 1) {
		ordered_enemies = find_enemies_ordered()
	}
	
	if(object_exists(obj_enemy_attack_manager)) {
		obj_enemy_attack_manager.clear_intents()
	}
	else {
		var enemy_attack_manager_layer = layer_create(0, "enemy_attack_manager_layer")
		instance_create_layer(0, 0, enemy_attack_manager_layer, obj_enemy_attack_manager)
	}
	
	for(var enemy_index = 0; enemy_index < array_length(ordered_enemies); enemy_index++) {
		ordered_enemies[enemy_index].trigger_end_of_turn_debuffs()
	}
	
	for(var enemy_index = 0; enemy_index < array_length(ordered_enemies); enemy_index++) {
		ordered_enemies[enemy_index].check_for_conditional_attack()
		ordered_enemies[enemy_index].check_for_summon_sickness()
	}
	
	for(var enemy_index = 0; enemy_index < array_length(ordered_enemies); enemy_index++) {
		ordered_enemies[enemy_index].remove_temporary_attack()
		ordered_enemies[enemy_index].next_attack_index++
		ordered_enemies[enemy_index].select_next_attack()
	}
}