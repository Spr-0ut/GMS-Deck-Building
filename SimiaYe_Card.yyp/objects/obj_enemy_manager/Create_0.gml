if(instance_number(obj_enemy_manager) > 1) {
	instance_destroy()
}

ordered_enemies = []
dead_enemies = []
room_enemy_data = {}
encounter_data = []

/// @desc										Clears the room of enemies and creates the given enemy
///													instances then adds them to ordered_enemies
/// @param {Array<Struct>} enemies_to_create	An array of data_enemy structs used to create the enemies
function create_enemies(enemies_to_create) {
	instance_destroy(obj_enemy)
	
	ordered_enemies = create_enemy_instances(enemies_to_create)
	array_sort(ordered_enemies, function (current, next) {
		return 	current.x - next.x
	})
		
	if(instance_exists(obj_enemy_attack_manager)) {
		obj_enemy_attack_manager.create_indicators()
	}
}

/// @desc										Creates instances of each of the given enemies
/// @param {Array<Struct>} enemies_to_create	An array of data_enemy structs used to create the enemies
/// @returns {Array<Id.Instance>}				An array of the newly created enemy instances
function create_enemy_instances(enemies_to_create) {
	var enemy_instances_created = []
	var enemy_instance_layer = get_enemy_instance_layer()
	
	if(typeof(enemies_to_create) = "array") {
		for(var enemy_index = 0; enemy_index < array_length(enemies_to_create); enemy_index++) {
			var cur_enemy = enemies_to_create[enemy_index]
			if(typeof(cur_enemy) = "struct" && is_instanceof(cur_enemy, data_enemy)) {
				if(cur_enemy.is_alive || (cur_enemy.encounter_just_defeated && !global.room_is_arena)) {
					var x_pos = cur_enemy.initial_x_pos + sprite_get_xoffset(object_get_sprite(cur_enemy.object))
					var y_pos = cur_enemy.initial_y_pos + sprite_get_yoffset(object_get_sprite(cur_enemy.object))
				
					var enemy_instance = instance_create_layer(x_pos, y_pos, enemy_instance_layer, cur_enemy.object, { 
						enemy_data : cur_enemy
					})
					array_push(enemy_instances_created, enemy_instance)
				}
			}
		}
	}
	return enemy_instances_created
}

/// @desc										Saves the given data_enemy that will be used for the
///													next Arena encounter
/// @param {Array<Struct>} enemies_in_fight		The data_enemy used to create the enemies in the Arena
function save_enemy_encounter_data(enemies_in_fight) {
	encounter_data = enemies_in_fight
}

/// @desc										Attempts to find the layer to create enemy instances on
///													or creates a new one if no layer could be found
/// @returns {Id.Layer}							The layer to create enemy instances on
function get_enemy_instance_layer() {
	var enemy_instance_layer = layer_get_id("enemy_instance_layer")
	if(enemy_instance_layer != -1) {
		return enemy_instance_layer
	}
	else if(instance_exists(obj_enemy)) {
		var enemy_instance = instance_find(obj_enemy, 0)
		return enemy_instance.layer
	}
	
	return layer_create(0, "enemy_instance_layer")
}

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
/// @returns {Array<Id.Instance>}		The instances of enemies in the current room, sorted by their
///											x position. NOTE: This list is also the placed in
///											ordered_enemies, so it does not need to be added again
function find_enemies_ordered() {
	ordered_enemies = array_create(instance_number(obj_enemy))
	for(var enemy_index = 0; enemy_index < instance_number(obj_enemy); enemy_index++) {
		ordered_enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(ordered_enemies, function (current, next) {
		return 	current.x - next.x
	})
	
	return ordered_enemies
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
function summon_new_enemy(enemy) {
	if(typeof(enemy) == "ref" && object_is_ancestor(enemy, obj_enemy)) {
		if(instance_exists(obj_enemy_attack_manager)) {
			var enemy_indicator = obj_enemy_attack_manager.find_open_enemy_indicator()
			if(enemy_indicator != noone) {
				var enemy_instance_layer = get_enemy_instance_layer()
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

/// @desc								Handles an enemy dying, and determines if the encounter is over
/// @param {Id.Instance} enemy_instance	The enemy instance that died
function enemy_dies(enemy_instance) {
	if(variable_instance_exists(enemy_instance, "object_index") &&
		object_is_ancestor(enemy_instance.object_index, obj_enemy)) {
			array_push(dead_enemies, enemy_instance)
			var all_enemies_killed = array_all(ordered_enemies, function (element, index) { 
				return array_contains(dead_enemies, element) 
			})
	
			if(all_enemies_killed) {
				return_from_encounter()
			}
	}
}

/// @desc								Handles returning the player to the room_to_return_to and
///											marking it so it animates it's death
function return_from_encounter() {
	if(variable_global_exists("room_is_arena") && global.room_is_arena) {
		global.room_is_arena = false
		for(var enemy_index = 0; enemy_index < array_length(ordered_enemies); enemy_index++) {
			ordered_enemies[enemy_index].enemy_data.is_alive = true
			ordered_enemies[enemy_index].enemy_data.encounter_just_defeated = true
		}
	
		if(variable_global_exists("return_room") && room_exists(global.return_room)) {
			room_goto(global.return_room)
		}
	}
}

/// @desc								Handles ending the enemies turn, triggering their debuffs,
///											removing any temporary attacks after they are used, and
///											selecting the next attack
function end_enemies_turn() {
	if(array_length(ordered_enemies) < 1) {
		find_enemies_ordered()
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