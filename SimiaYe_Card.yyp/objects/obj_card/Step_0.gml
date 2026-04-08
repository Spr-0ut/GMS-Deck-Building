if(card_can_be_moved && visible) {
	if(card_selected) {
		x = mouse_x
		y = mouse_y - (sprite_height / 2)
	
		if(y + (sprite_height / 2) > global.card_min_y) {
			ui_player_hand.check_for_card_swap(card_index_in_hand, x)
		}
	}
	else if(card_can_auto_adjust) {
		if(!global.object_being_clicked && abs(x - card_start_x_position) < 1 && abs(y - card_start_y_position) < 1 &&
				abs(image_angle - card_start_angle) < 1) {
			x = card_start_x_position
			y = card_start_y_position
			image_angle = card_start_angle
			if(hovering_over_card) {
				indicate_hovering_over_card()	
			}
		}
		else {
			if(x != card_start_x_position) {
				x = lerp(x, card_start_x_position, CARD_POSITION_ADJUSTMENT_SPEED)
			}
			if(y != card_start_y_position) {
				y = lerp(y, card_start_y_position, CARD_POSITION_ADJUSTMENT_SPEED)
			}
			if(image_angle != card_start_angle) {
				image_angle = lerp(image_angle, card_start_angle, CARD_ANGLE_ADJUSTMENT_SPEED)
			}
		}
	}
}