if(array_contains(interaction_type, card_interaction_type.selectable_card) &&
		card_selected && is_top_layer(layer, mouse_x, mouse_y)) {
	card_selected = false
	global.object_being_clicked = false
	is_selected = !is_selected
	if(is_selected) {
		y -= CARD_SELECTION_CONFIRMATION_MOVEMENT
		obj_target_selection_handler.target_selected(id)
	}
	else {
		image_angle = global.cards_in_hand_angle[card_index_in_hand]
		y = global.cards_in_hand_y_pos[card_index_in_hand]
		obj_target_selection_handler.target_deselected(id)
	}
}
else if(array_contains(interaction_type, card_interaction_type.expandable_card) &&
		!card_can_be_moved && card_selected && is_top_layer(layer, mouse_x, mouse_y)) {
	create_expanded_card()
}