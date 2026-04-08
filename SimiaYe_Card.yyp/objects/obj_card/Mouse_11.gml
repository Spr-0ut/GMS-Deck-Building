if(!card_selected && !global.object_being_clicked && card_can_be_moved &&
		is_top_layer(layer, mouse_x, mouse_y)) {
	card_can_auto_adjust = true
	y = card_start_y_position
	hovering_over_card = false
}