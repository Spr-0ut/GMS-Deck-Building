if(!card_selected && !global.object_being_clicked && card_can_be_moved &&
		is_top_layer(layer, mouse_x, mouse_y)) {
	card_can_auto_adjust = true
	y = global.cards_in_hand_y_pos[card_index_in_hand]
	hovering_over_card = false
}