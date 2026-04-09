if(card_can_be_moved && visible) {
	if(card_selected) {
		x = mouse_x
		y = mouse_y - (sprite_height / 2)
	
		if(y + (sprite_height / 2) > global.card_min_y) {
			ui_player_hand.check_for_card_swap(card_index_in_hand, x)
		}
	}
	else if(card_can_auto_adjust) {
		if(!global.object_being_clicked && hovering_over_card) {
			x = lerp(x, global.cards_in_hand_x_pos[card_index_in_hand], CARD_POSITION_ADJUSTMENT_SPEED)
			y = lerp(y, CARD_Y_POS_WHILE_HOVERING_OVER, CARD_POSITION_ADJUSTMENT_SPEED)
			image_angle = lerp(image_angle, CARD_ANGLE_WHILE_HOVERING_OVER, CARD_ANGLE_ADJUSTMENT_SPEED)
		}
		else {
			x = lerp(x, global.cards_in_hand_x_pos[card_index_in_hand], CARD_POSITION_ADJUSTMENT_SPEED)
			y = lerp(y, global.cards_in_hand_y_pos[card_index_in_hand], CARD_POSITION_ADJUSTMENT_SPEED)
			image_angle = lerp(image_angle, global.cards_in_hand_angle[card_index_in_hand], CARD_ANGLE_ADJUSTMENT_SPEED)
		}
	}
}