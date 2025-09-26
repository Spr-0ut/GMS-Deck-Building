// Inherit the parent event
event_inherited();

#macro CARD_PADDING 10
#macro BACKGROUND_ALPHA 0.5
#macro SCROLL_BAR_PADDING 5

show_player_deck = false
player_current_deck = get_player_current_deck()
player_deck_instance_id = -1
bottom_of_header = 0

/// @desc									Creates the header that displays above the player deck
/// @param {String, Id.Layer} layer_id		The layer the header will be shown on
function create_player_deck_header(layer_id) {
	var header_x_pos = 0
	var header_y_pos = 0
	var header_sprite_width = sprite_get_width(object_get_sprite(ui_player_deck_header_background))
	var header_sprite_scale = display_get_gui_width() / header_sprite_width
	bottom_of_header = header_y_pos + 
						(sprite_get_height(object_get_sprite(ui_player_deck_header_background)) * 
						header_sprite_scale)
	instance_create_layer(header_x_pos, header_y_pos, layer_id, ui_player_deck_header_background, {
		image_xscale : header_sprite_scale,
		image_yscale : header_sprite_scale
	})
}

/// @desc									Displays all of the players cards in their current deck in a grid
/// @param {String, Id.Layer} layer_id		The layer the deck will be shown on
function create_player_deck_view(layer_id) {
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
			var card_y_pos = bottom_of_header + (floor(card_index / num_columns) * 
								(card_height + CARD_PADDING)) + CARD_PADDING
			
			instance_create_layer(card_x_pos, card_y_pos, layer_id, obj_display_card, {
				sprite_index : object_get_sprite(player_current_deck[card_index])
			})
		}
	}
}

/// @desc									Clears out the displayed cards, sorts the displayed deck,
///												and recreates them to be visable to the player
function sort_player_deck(sort_function) {
	if(array_length(player_current_deck) <= 0) {
		player_current_deck = get_player_current_deck()
	}
	
	for (var display_card_index = 0; display_card_index < instance_number(obj_display_card); display_card_index++)
	{
		instance_destroy(instance_find(obj_display_card,display_card_index))
	}
	
	array_sort(player_current_deck, sort_function)
	create_player_deck_view(player_deck_instance_id)
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

/// @desc									Creates a scroll bar to move all display cards
/// @param {String, Id.Layer} layer_id		The layer the scroll bar will be shown on
function create_scroll_bar(layer_id) {
	var bar_sprite_width = sprite_get_width(object_get_sprite(ui_player_deck_scrollbar))
	var bar_sprite_height = sprite_get_height(object_get_sprite(ui_player_deck_scrollbar))
	var bar_x_pos = display_get_gui_width() - SCROLL_BAR_PADDING - bar_sprite_width
	var bar_y_pos = bottom_of_header + SCROLL_BAR_PADDING
	var bar_sprite_y_scale = (display_get_gui_height() - bar_y_pos -  SCROLL_BAR_PADDING) / bar_sprite_height
	instance_create_layer(bar_x_pos, bar_y_pos, layer_id, ui_player_deck_scrollbar, {
		image_yscale : bar_sprite_y_scale
	})
}

/// @desc									Clean up the background after the deck view is closed
function hide_player_deck() {
	show_player_deck = false
}