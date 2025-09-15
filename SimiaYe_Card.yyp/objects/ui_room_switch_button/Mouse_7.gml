if(button_clicked && room_exists(new_room)) {
	button_clicked = false
	global.button_being_clicked = false
	room_goto(new_room)
}