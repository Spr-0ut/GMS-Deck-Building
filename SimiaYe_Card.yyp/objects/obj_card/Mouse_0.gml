/// @description	Checks to see if no other cards are selected then allows this card to be selected
if(!card_selected && ui_player_hand.card_can_be_selected && is_top_layer(layer)) {
	card_selected = true
	ui_player_hand.card_can_be_selected = false
	card_start_x_position = x
	card_start_y_position = y
	x = mouse_x - (sprite_width / 2)
	y = mouse_y - (sprite_height / 2)
}