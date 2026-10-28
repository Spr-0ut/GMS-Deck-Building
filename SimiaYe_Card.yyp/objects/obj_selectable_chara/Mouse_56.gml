if(chara_clicked) {
	if (hovering_over_chara && is_top_layer(layer, mouse_x, mouse_y)) {
		handle_selectable_chara_chosen()	
	}
	
	chara_clicked = false
	global.object_being_clicked = false
}