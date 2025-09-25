#macro CLOSE_BUTTON_PADDING 10

fill_header()

/// @desc								Creates and organizes the buttons that go in the header
function fill_header() {
	var close_button_x_pos = sprite_width - sprite_get_width(object_get_sprite(ui_close_layer_button))
								- CLOSE_BUTTON_PADDING
	//create_close_button(layer)
	var sort_buttons_x_pos = get_sort_buttons_x_pos(close_button_x_pos, 3)
	var sort_button_y_pos = y + (sprite_height / 2) + CLOSE_BUTTON_PADDING
	var current_layer_depth = layer_get_depth(layer)
	var sort_buttons_layer_id = layer_create(current_layer_depth + 1)
	
	instance_create_layer(sort_buttons_x_pos[0], sort_button_y_pos, sort_buttons_layer_id, ui_card_sort_button)
	instance_create_layer(sort_buttons_x_pos[1], sort_button_y_pos, sort_buttons_layer_id, ui_card_sort_by_type)
	instance_create_layer(sort_buttons_x_pos[2], sort_button_y_pos, sort_buttons_layer_id, ui_card_sort_by_cost)
}

/// @desc								Calculates all of the x positions of the sort buttons to be
///											equally spaced in the header before the max_x_coord
/// @param {Real} max_x_coord			The right edge allwoed for the sort buttons
/// @param {Real} num_sort_buttons		The amount of times the given space is split
/// @returns							An array of x coordinates to use when placing sort buttions in
///											the header
function get_sort_buttons_x_pos(max_x_coord, num_sort_buttons) {
	var sort_buttons_x_pos = array_create(num_sort_buttons)
	var sort_button_max_length = max_x_coord / num_sort_buttons
	var sort_button_left_padding = sort_button_max_length / 6
	for (var pos_index = 0; pos_index < num_sort_buttons; pos_index++) {
		sort_buttons_x_pos[pos_index] = sort_button_max_length * pos_index + sort_button_left_padding 
	}
	return sort_buttons_x_pos
}