#macro CHARA_CARD_GRID_PADDING		8
#macro CHARA_CARD_X_PADDING			5
#macro CHARA_CARD_Y_PADDING			5

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
		var chara_card_width = sprite_get_width(object_get_sprite(chara_cards_to_display[0])) * image_xscale +
									(2 * CHARA_CARD_X_PADDING)
		var chara_card_height = sprite_get_height(object_get_sprite(chara_cards_to_display[0])) * image_yscale +
									(2 * CHARA_CARD_Y_PADDING)
		var chara_card_display_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
		var num_columns = floor(chara_card_display_width / chara_card_width)
		var num_rows = ceil(array_length(chara_cards_to_display) / num_columns)
		
		var initial_x_pos = x + CHARA_CARD_GRID_PADDING * image_xscale +
								(chara_card_display_width % chara_card_width / 2)
		var initial_y_pos = y + CHARA_CARD_GRID_PADDING * image_yscale + CHARA_CARD_Y_PADDING
		chara_card_instances = array_create(array_length(chara_cards_to_display))
	
		for (var card_index = 0; card_index < array_length(chara_cards_to_display); card_index++) {
			var card_x_pos = initial_x_pos + (card_index % num_columns) * chara_card_width
			var card_y_pos = initial_y_pos + floor(card_index / num_columns) * chara_card_height

			var display_card = instance_create_layer(card_x_pos, card_y_pos, chara_card_grid_layer, chara_cards_to_display[card_index], {
				image_xscale,
				image_yscale
			})
			chara_card_instances[card_index] = display_card
		}		
	}
}