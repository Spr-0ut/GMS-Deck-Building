if(button_clicked) {
	if (hovering_over_button && is_top_layer(layer, mouse_x, mouse_y)) {
		handle_mouse_left_button_release()	
	}
	
	button_clicked = false
	global.object_being_clicked = false
	y = ystart
}