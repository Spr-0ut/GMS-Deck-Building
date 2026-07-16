#macro CHARA_CARD_GRID_PADDING		16
#macro CHARA_CARD_X_PADDING			6
#macro CHARA_CARD_Y_PADDING			6

chara_cards_to_display = array_create(10, obj_chara_card)
chara_card_instances = []
chara_card_grid_layer = layer_create(layer_get_depth(layer) - 1, "chara_card_grid_instance")
is_expanded_grid = false
grid_is_moving = false
target_grid_y = y
create_chara_card_grid_view()

/// @desc							Creates a grid of the character cards in chara_cards_to_display
///										and saves them to chara_card_instances
function create_chara_card_grid_view() {
	if(array_length(chara_cards_to_display) > 0) {
		if(chara_card_grid_layer == -1) {
			var chara_card_layer_name = "chara_card_grid_instance"
			chara_card_grid_layer = layer_get_id(chara_card_layer_name)
			if(chara_card_grid_layer == -1) {
				chara_card_grid_layer = layer_create(layer_get_depth(layer) - 1, chara_card_layer_name)
			}
		}
		
		//This assumes the cards will always be the same size. As of right now that's true and to make it
		//	more generic would result in a potentially worse solution
		var chara_card_width = (sprite_get_width(spr_shrunk_chara_card) +
									(2 * CHARA_CARD_X_PADDING)) * image_xscale
		var chara_card_height = (sprite_get_height(spr_shrunk_chara_card) +
									(2 * CHARA_CARD_Y_PADDING)) * image_yscale
		var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
		var num_columns = floor(chara_card_grid_width / chara_card_width)
		
		var initial_x_pos = x + CHARA_CARD_GRID_PADDING * image_xscale +
								(chara_card_grid_width % chara_card_width / num_columns)
		var initial_y_pos = y + (CHARA_CARD_GRID_PADDING + CHARA_CARD_Y_PADDING) * image_yscale
		chara_card_instances = array_create(array_length(chara_cards_to_display))
	
		var card_x_pos = initial_x_pos
		var card_y_pos = initial_y_pos - chara_card_height
		for (var card_index = 0; card_index < array_length(chara_cards_to_display); card_index++) {
			if(card_index % num_columns == 0) {
				card_x_pos = initial_x_pos + CHARA_CARD_X_PADDING * chara_card_instances[card_index].image_xscale
				card_y_pos += chara_card_height
			}

			var display_card = instance_create_layer(card_x_pos, card_y_pos, chara_card_grid_layer, chara_cards_to_display[card_index], {
				sprite_index : spr_shrunk_chara_card,
				image_xscale,
				image_yscale,
				grid_index : card_index
			})
			chara_card_instances[card_index] = display_card
			
			card_x_pos += chara_card_width + (chara_card_grid_width % chara_card_width / num_columns)
		}
	}
}

/// @desc								Returns the given card back into the chara card grid display.
///											NOTE: This assumes it existed in the grid before and is
///											being placed back into the grid, NOT adding a new card
/// @param {Id.Instance} chara_card		The chara card to be placed in the grid
function return_chara_card_to_grid(chara_card) {
	if(typeof(chara_card) == "ref" && chara_card != noone && instance_exists(chara_card)) {
		var chara_card_sprite = spr_shrunk_chara_card
		if(is_expanded_grid) {
			chara_card_sprite	= spr_expanded_chara_card
		}
		chara_card.sprite_index	= chara_card_sprite
		
		var chara_card_width = (sprite_get_width(chara_card_sprite) + (2 * CHARA_CARD_X_PADDING)) * image_xscale
		var chara_card_height = (sprite_get_height(chara_card_sprite) + (2 * CHARA_CARD_Y_PADDING)) * image_yscale
		var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
		var num_columns = floor(chara_card_grid_width / chara_card_width)
		
		var initial_x_pos = x + CHARA_CARD_GRID_PADDING * image_xscale +
								CHARA_CARD_X_PADDING * chara_card.image_xscale +
								(chara_card_grid_width % chara_card_width / (num_columns))
		var initial_y_pos = y + (CHARA_CARD_GRID_PADDING + CHARA_CARD_Y_PADDING) * image_yscale
		var card_column = chara_card.grid_index % num_columns
		
		var card_x_pos = initial_x_pos + chara_card_width * card_column +
							(chara_card_grid_width % chara_card_width / num_columns) * card_column 
		var card_y_pos = initial_y_pos + floor(chara_card.grid_index / num_columns) * chara_card_height
			
		chara_card_instances[chara_card.grid_index] = chara_card
		chara_card.x = card_x_pos
		chara_card.y = card_y_pos
		chara_card.chara_card_start_x_position = card_x_pos
		chara_card.chara_card_start_y_position = card_y_pos
	}
}

/// @desc							Handles expanding the character card grid each frame
function expand_chara_card_grid() {
	if(!grid_is_moving && !is_expanded_grid) {
		sprite_index = spr_expanded_chara_select_grid
		var amount_grid_grows = (sprite_get_height(spr_expanded_chara_select_grid) -
								 sprite_get_height(spr_shrunk_chara_select_grid)) *
								 image_yscale
		target_grid_y = y - amount_grid_grows
		grid_is_moving = true
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(y - target_grid_y < 1) {
			grid_is_moving = false
			is_expanded_grid = true
			set_chara_cards_pos(false, y)
			if(instance_exists(obj_party_chara_card_box)) {
				obj_party_chara_card_box.shrink_chara_card_box()
			}
		}
	}
}

/// @desc							Handles shrinking the character card grid each frame
function shrink_chara_card_grid() {
	if(!grid_is_moving && is_expanded_grid) {
		var amount_grid_shrinks = (sprite_get_height(spr_expanded_chara_select_grid) - sprite_get_height(spr_shrunk_chara_select_grid)) *
									image_yscale
		target_grid_y = y + amount_grid_shrinks
		grid_is_moving = true
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(target_grid_y - y < 1) {
			is_expanded_grid = false
			grid_is_moving = false
			sprite_index = spr_shrunk_chara_select_grid
			set_chara_cards_pos(true, y)
			if(instance_exists(obj_party_chara_card_box)) {
				obj_party_chara_card_box.expand_chara_card_box()
			}
		}
	}
}

/// @desc							Sets the character cards in the grid to the correct position
///										based on whether it is expanded or shrunk sprites
/// @param {Bool} shrunk_cards	Flag to determine if the cards will be the shrunk version or not
/// @param {Real} grid_y_pos		The vertical position of the character card grid
function set_chara_cards_pos(shrunk_cards, grid_y_pos) {
	var chara_card_sprite = shrunk_cards ? spr_shrunk_chara_card : spr_expanded_chara_card
	
	//This assumes the cards will always be the same size. As of right now that's true and to make it
	//	more generic would result in a potentially worse solution
	var chara_card_width = (sprite_get_width(chara_card_sprite) + (2 * CHARA_CARD_X_PADDING)) * image_xscale
	var chara_card_height = (sprite_get_height(chara_card_sprite) + (2 * CHARA_CARD_Y_PADDING)) * image_yscale
	var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
	var num_columns = floor(chara_card_grid_width / chara_card_width)
		
	var card_y_pos = y + CHARA_CARD_GRID_PADDING * image_yscale - chara_card_height
	for (var card_index = 0; card_index < array_length(chara_cards_to_display); card_index++) {
		if(card_index % num_columns == 0) {
			card_y_pos += chara_card_height
		}

		if(chara_card_instances[card_index] != noone) {
			chara_card_instances[card_index].sprite_index = chara_card_sprite
			chara_card_instances[card_index].y = card_y_pos
		}
	}
}

/// @desc								Removes the given character card from the grid, but leaves
///											the space open for the card to be added again later
/// @param {Id.Instance} chara_card		The character card to be removed from the grid
function empty_card_slot(chara_card) {
	if(chara_card != noone && chara_card.grid_index >= 0 && 
			chara_card.grid_index < array_length(chara_card_instances)) {
		chara_card_instances[chara_card.grid_index] = noone
	}
}