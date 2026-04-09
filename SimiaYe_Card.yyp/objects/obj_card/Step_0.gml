if(card_can_be_moved && visible) {
	if(card_selected) {
		x = mouse_x
		y = mouse_y - (sprite_height / 2)
	
		if(y + (sprite_height / 2) > global.card_min_y) {
			ui_player_hand.check_for_card_swap(card_index_in_hand, x)
		}
	}
	else if(card_can_auto_adjust) {
		if(!global.object_being_clicked && abs(x - global.cards_in_hand_x_pos[card_index_in_hand]) < 1 &&
				abs(y - global.cards_in_hand_y_pos[card_index_in_hand]) < 1 &&
				abs(image_angle - global.cards_in_hand_angle[card_index_in_hand]) < 1) {
			x = global.cards_in_hand_x_pos[card_index_in_hand]
			y = global.cards_in_hand_y_pos[card_index_in_hand]
			image_angle = global.cards_in_hand_angle[card_index_in_hand]
			if(hovering_over_card) {
				indicate_hovering_over_card()	
			}
		}
		else {
			if(x != global.cards_in_hand_x_pos[card_index_in_hand]) {
				x = lerp(x, global.cards_in_hand_x_pos[card_index_in_hand], CARD_POSITION_ADJUSTMENT_SPEED)
			}
			if(y != global.cards_in_hand_y_pos[card_index_in_hand]) {
				y = lerp(y, global.cards_in_hand_y_pos[card_index_in_hand], CARD_POSITION_ADJUSTMENT_SPEED)
			}
			if(image_angle != global.cards_in_hand_angle[card_index_in_hand]) {
				image_angle = lerp(image_angle, global.cards_in_hand_angle[card_index_in_hand], CARD_ANGLE_ADJUSTMENT_SPEED)
			}
		}
	}
}