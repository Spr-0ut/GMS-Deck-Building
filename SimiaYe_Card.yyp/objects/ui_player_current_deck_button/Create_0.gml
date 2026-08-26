// Inherit the parent event
event_inherited();

/// @desc						Handles finding and displaying the player's current deck
function handle_mouse_left_button_release() {
	var player_current_deck = get_player_current_deck()
	var card_display_instance_id = layer_create(-100, "player_deck_instance")
	instance_create_layer(x, y, card_display_instance_id, ui_card_grid_display, {
		cards_to_display : player_current_deck,
		cards_are_selectable : false
	})
}