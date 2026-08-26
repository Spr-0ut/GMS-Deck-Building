// Inherit the parent event
event_inherited();

/// @desc						Handles finding the current exhaust deck and displaying it
function handle_mouse_left_button_release() {
	var player_current_exhaust_deck = get_player_exhaust_deck()
	var card_display_instance_id = layer_create(depth - 100, "player_exhaust_deck_instance")
	instance_create_layer(x, y, card_display_instance_id, ui_card_grid_display, {
		cards_to_display : player_current_exhaust_deck,
		cards_are_selectable : false,
	})
}