/// @desc			Checks if the End Turn button can be pressed and coordinates the end of the player's turn
if(button_can_be_pressed) {
	button_can_be_pressed = false
	end_player_turn()
	start_enemy_turn()
}