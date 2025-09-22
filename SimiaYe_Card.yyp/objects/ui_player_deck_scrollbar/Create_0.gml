#macro SCROLL_BORDER_WIDTH 2
#macro AMOUNT_SCREEN_MOVES_PER_SCROLL 50

scroll_clicked = false
amount_page_scrolled = 0
amount_bar_moves = AMOUNT_SCREEN_MOVES_PER_SCROLL //TODO sprite_height / (number of screen lengths below + 1)

var thumb_sprite_height = sprite_get_height(object_get_sprite(ui_player_deck_scroll_thumb))
scroll_min = y + floor(SCROLL_BORDER_WIDTH * image_yscale)
scroll_max = y + sprite_height - floor((SCROLL_BORDER_WIDTH + thumb_sprite_height) * image_yscale)

create_scroll_thumb()

/// @desc								Creates the scroll bar thumb that shows the user where on the screen
///											they are scrolled to
function create_scroll_thumb() {
	var thumb_layer_depth = layer_get_depth(layer) - 1
	var player_deck_scroll_thumb_instance_id = layer_create(thumb_layer_depth, "player_deck_scroll_thumb_instance")
	
	scroll_thumb = instance_create_layer(x + SCROLL_BORDER_WIDTH, scroll_min, player_deck_scroll_thumb_instance_id, ui_player_deck_scroll_thumb, {
		image_yscale : image_yscale	
	})
}

/// @desc								Moves the scroll bar thumb to the new position as well as moving
///											all of the display cards that exist after using the scroll
///											wheel or clicking on the bar
function move_scroll_thumb() {
	scroll_thumb.y = clamp(amount_page_scrolled, scroll_min, scroll_max)
		
	for (var movable_objects_index = 0; movable_objects_index < instance_number(obj_display_card); movable_objects_index++)
	{
		var display_card = instance_find(obj_display_card, movable_objects_index);
		display_card.y = display_card.ystart - amount_page_scrolled
	}
}