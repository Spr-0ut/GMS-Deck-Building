#macro CHARA_CARD_GRID_PADDING		8
#macro CHARA_CARD_X_PADDING			3
#macro CHARA_CARD_Y_PADDING			3

chara_cards_to_display = array_create(10, obj_chara_card)
chara_card_instances = []
chara_card_grid_layer = layer_create(layer_get_depth(layer) - 1, "chara_card_grid_instance")
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
		var chara_card_width = (sprite_get_width(object_get_sprite(chara_cards_to_display[0])) +
									(2 * CHARA_CARD_X_PADDING)) * image_xscale
		var chara_card_height = (sprite_get_height(object_get_sprite(chara_cards_to_display[0])) +
									(2 * CHARA_CARD_Y_PADDING)) * image_yscale
		var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
		var num_columns = floor(chara_card_grid_width / chara_card_width)
		var num_rows = ceil(array_length(chara_cards_to_display) / num_columns)
		
		var initial_x_pos = x + CHARA_CARD_GRID_PADDING * image_xscale +
								CHARA_CARD_X_PADDING * image_xscale +
								(chara_card_grid_width % chara_card_width / 2)
		var initial_y_pos = y + CHARA_CARD_GRID_PADDING * image_yscale + CHARA_CARD_Y_PADDING * image_yscale
		chara_card_instances = array_create(array_length(chara_cards_to_display))
	
		for (var card_index = 0; card_index < array_length(chara_cards_to_display); card_index++) {
			var card_x_pos = initial_x_pos + (card_index % num_columns) * chara_card_width
			var card_y_pos = initial_y_pos + floor(card_index / num_columns) * chara_card_height

			var display_card = instance_create_layer(card_x_pos, card_y_pos, chara_card_grid_layer, chara_cards_to_display[card_index], {
				image_xscale,
				image_yscale,
				grid_index : card_index
			})
			chara_card_instances[card_index] = display_card
		}		
	}
}

/// @desc								Adds the given card back into the chara card grid display.
///											NOTE: This assumes it existed in the grid before and is
///											being placed back into the grid, NOT adding a new card
/// @param {Id.Instance} chara_card		The chara card to be placed in the grid
function add_chara_card_to_grid(chara_card) {
	if(typeof(chara_card) == "ref" && chara_card != noone && instance_exists(chara_card)) {
		var chara_card_width = chara_card.sprite_width + (2 * CHARA_CARD_X_PADDING * image_xscale)
		var chara_card_height = chara_card.sprite_height + (2 * CHARA_CARD_Y_PADDING * image_yscale)
		var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
		var num_columns = floor(chara_card_grid_width / chara_card_width)
		var num_rows = ceil(array_length(chara_cards_to_display) / num_columns)
		
		var initial_x_pos = x + CHARA_CARD_GRID_PADDING * image_xscale +
								CHARA_CARD_X_PADDING * image_xscale +
								(chara_card_grid_width % chara_card_width / 2)
		var initial_y_pos = y + CHARA_CARD_GRID_PADDING * image_yscale + CHARA_CARD_Y_PADDING * image_yscale
		var card_index = chara_card.grid_index
		var card_x_pos = initial_x_pos + (card_index % num_columns) * chara_card_width
		var card_y_pos = initial_y_pos + floor(card_index / num_columns) * chara_card_height
			
		chara_card_instances[card_index] = chara_card
		chara_card.x = card_x_pos
		chara_card.y = card_y_pos
		chara_card.chara_card_start_x_position = card_x_pos
		chara_card.chara_card_start_y_position = card_y_pos
	}
}