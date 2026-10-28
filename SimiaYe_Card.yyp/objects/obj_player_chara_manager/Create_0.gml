#macro CHARA_ARENA_SCALE		1.5
#macro CHARA_DEFAULT_X_POS		192
#macro CHARA_DEFAULT_y_POS		576

if(instance_number(obj_player_chara_manager) > 1) {
	instance_destroy()
}

room_chara_data = {}

/// @desc												Creates an instance of each of the characters given
/// @param {Array<data_chara>} sorted_chara_to_create	The array of data_chara to create instances of
function create_chara_instances() {
	if(instance_exists(obj_follower_order_manager)) {
		var sorted_chara_to_create = obj_follower_order_manager.get_charas_ordered()
		
		var chara_room_data = noone
		if(struct_exists(room_chara_data, room_get_name(room))) {
			chara_room_data = room_chara_data[$ room_get_name(room)]
		}
	
		var chara_layer = layer_get_id("Instances")
		if(chara_layer == noone) {
			chara_layer = layer_create(0, "Instances")	
		}
		
		var x_pos = CHARA_DEFAULT_X_POS
		var y_pos = CHARA_DEFAULT_y_POS
		
		var chara_x_scale = 1
		var chara_y_scale = 1
		if(variable_global_exists("room_is_arena") && global.room_is_arena) {
			chara_x_scale = CHARA_ARENA_SCALE
			chara_y_scale = CHARA_ARENA_SCALE
		}
	
		var previous_chara = noone
		for(var chara_index = 0; chara_index < array_length(sorted_chara_to_create); chara_index++) {
			if(is_instanceof(sorted_chara_to_create[chara_index], data_chara)) {
				var cur_chara = sorted_chara_to_create[chara_index]
				
				if(chara_room_data != noone) {
					x_pos = chara_room_data[$ cur_chara.chara_id].x_pos
					y_pos = chara_room_data[$ cur_chara.chara_id].y_pos
				}
				
				var chara_instance = instance_create_layer(x_pos, y_pos, chara_layer, cur_chara.object_index, {
					image_xscale : chara_x_scale,
					image_yscale : chara_y_scale,
					is_controlled_chara : cur_chara.is_controlled_chara,
					chara_data : cur_chara
				})
		
				if(previous_chara != noone) {
					previous_chara.follower = chara_instance
				}
				previous_chara = chara_instance
			}
		}
		
		struct_remove(room_chara_data, room_get_name(room))
	}
}

/// @desc									Saves the current party's data to be able to return
///												to the current room
function save_chara_encounter_data() {
	if(instance_exists(obj_follower_order_manager)) {
		var sorted_chara = obj_follower_order_manager.find_charas_ordered()
		save_chara_room_data(sorted_chara)
	}
}

/// @desc										Saves the given character's data for the given room
/// @param {Array<Id.Instance>} chara_to_save	The array of all characters whose data must be saved
///													to be recreated when entering the room
/// @param {Asset.GMRoom} room_to_save			Optional room to save the character data for, defaults
///													to the current room
function save_chara_room_data(chara_to_save, room_to_save = room) {
	var all_chara_to_save_data = {}
	for(var chara_index = 0; chara_index < array_length(chara_to_save); chara_index++) {
		var cur_chara = chara_to_save[chara_index]
		if(variable_instance_exists(cur_chara, "object_index") &&
			object_is_ancestor(cur_chara.object_index, obj_player)) {
				all_chara_to_save_data[$ cur_chara.chara_data.chara_id] = { 
					x_pos : cur_chara.x,
					y_pos : cur_chara.y,
					chara_data : cur_chara.chara_data
				}
		}
	}
	room_chara_data[$ room_get_name(room)] = all_chara_to_save_data
}