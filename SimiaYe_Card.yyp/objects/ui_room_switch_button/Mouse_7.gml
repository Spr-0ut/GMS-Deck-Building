if(is_top_layer(layer) && button_clicked && room_exists(new_room)) {
	button_clicked = false
	global.object_being_clicked = false
	room_goto(new_room)
}