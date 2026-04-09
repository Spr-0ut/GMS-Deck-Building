if(!global.object_being_clicked && visible && card_can_be_moved
		&& is_top_layer(layer, mouse_x, mouse_y)) {
	if(y == global.cards_in_hand_y_pos[card_index_in_hand]) {
		indicate_hovering_over_card()
	}
	hovering_over_card = true
}