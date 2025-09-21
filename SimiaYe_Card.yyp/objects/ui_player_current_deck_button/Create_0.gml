// Inherit the parent event
event_inherited();

#macro CARD_PADDING 10
#macro BACKGROUND_ALPHA 0.5
#macro CLOSE_BUTTON_PADDING 10

show_player_deck = false

/// @desc									Displays all of the players cards in their current deck in a grid
/// @param {String, Id.Layer} layer_id		The layer the deck will be shown on
function create_player_deck_view(layer_id) {
	var player_current_deck = get_player_current_deck()
	if(array_length(player_current_deck) > 0) {
		//This assumes the cards will always be the same size. As of right now that's true and to make it
		//	more generic would result in a potentially worse solution
		var card_width = sprite_get_width(object_get_sprite(player_current_deck[0]))
		var card_height = sprite_get_height(object_get_sprite(player_current_deck[0]))
		var default_camera_id = camera_get_default()
		var screen_width = camera_get_view_width(default_camera_id)
		var num_columns = floor(screen_width / (card_width + CARD_PADDING))
		
		for (var card_index = 0; card_index < array_length(player_current_deck); card_index++) {
			var card_x_pos = card_index % num_columns * (card_width + CARD_PADDING) + CARD_PADDING
			var card_y_pos = floor(card_index / num_columns) * (card_height + CARD_PADDING) + CARD_PADDING
			
			instance_create_layer(card_x_pos, card_y_pos, layer_id, obj_display_card, {
				sprite_index : object_get_sprite(player_current_deck[card_index])
			})
		}
	}
}

/// @desc									Draws a rectangle over the whole camera to dim the game
///												NOTE: this must be called in the Draw event or it won't
///												work correctly
function draw_deck_background() {
	draw_set_colour(c_black)
	draw_set_alpha(BACKGROUND_ALPHA)
	var default_camera_id = camera_get_default()
	var screen_width = camera_get_view_width(default_camera_id)
	var screen_height = camera_get_view_height(default_camera_id)
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)	
}

/// @desc									Creates a button to delete the layer it's placed on
/// @param {String, Id.Layer} layer_id		The layer the button will be shown on
function create_close_button(layer_id) {
	var close_button_sprite_width = sprite_get_width(object_get_sprite(ui_close_layer_button))
	var button_x_pos = display_get_gui_width() - CLOSE_BUTTON_PADDING - close_button_sprite_width
	var button_y_pos = CLOSE_BUTTON_PADDING
	instance_create_layer(button_x_pos, button_y_pos, layer_id, ui_close_layer_button)
}

/// @desc									Clean up the background after the deck view is closed
function hide_player_deck() {
	show_player_deck = false
}