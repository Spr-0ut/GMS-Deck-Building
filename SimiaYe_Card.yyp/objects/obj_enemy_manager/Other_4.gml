if(variable_global_exists("room_is_arena") && global.room_is_arena) {
	create_enemies(encounter_data)
}
else if(struct_exists(room_enemy_data, room_get_name(room))) {
	create_enemies(room_enemy_data[$ room_get_name(room)])
}
else {
	var ordered_enemies_array = find_enemies_ordered()
	var ordered_enemies_data = array_create(array_length(ordered_enemies_array))
	for(var enemy_index = 0; enemy_index < array_length(ordered_enemies_array); enemy_index++) {
		ordered_enemies_data[enemy_index] = ordered_enemies_array[enemy_index].enemy_data
	}
	
	room_enemy_data[$ room_get_name(room)] = ordered_enemies_data
}