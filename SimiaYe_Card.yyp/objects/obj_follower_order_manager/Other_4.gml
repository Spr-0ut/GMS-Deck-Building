room_has_started = true
show_chara_select_button()
if(variable_global_exists("room_is_arena") && global.room_is_arena || room == rm_forest) {
	create_chara_instances(chara_order)
}

find_player_chara()
add_queue_to_follower_chain()