end_player_turn()

/// @desc			controls the end of a players turn, filling the player's hand with cards
function end_player_turn() {
	if(instance_exists(ui_player_hand) && ui_player_hand.is_hand_visible) {
		ui_player_hand.fill_player_hand()
	}
}