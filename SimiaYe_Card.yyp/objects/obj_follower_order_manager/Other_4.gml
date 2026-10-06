room_has_started = true
show_chara_select_button()
if(room == rm_forest) {
	create_chara_instances(chara_order)
}
find_player_chara()
add_queue_to_follower_chain()