/// @description	resets the card so other cards can be selected
if(card_selected) {
	card_selected = false
	ui_player_hand.card_can_be_selected = true
	x = card_start_x_position
	y = card_start_y_position
}