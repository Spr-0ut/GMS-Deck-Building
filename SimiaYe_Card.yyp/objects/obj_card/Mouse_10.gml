if(!global.object_being_clicked && visible && card_can_be_moved
		&& is_top_layer(layer, mouse_x, mouse_y)) {
	if(y == card_start_y_position) {
		indicate_hovering_over_card()
	}
	hovering_over_card = true
}