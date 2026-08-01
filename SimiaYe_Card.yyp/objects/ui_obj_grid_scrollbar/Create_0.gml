#macro SCROLL_BORDER_WIDTH 2
#macro SCROLL_SMOOTHING_AMOUNT 0.25

viewable_window_height = clamp(viewable_window_height, 0, display_get_gui_height())
row_height = max(row_height, 0)
scrollable_list_height = max(scrollable_list_height, 0)

var thumb_scale = find_scroll_thumb_scale()
scroll_min = y + floor(SCROLL_BORDER_WIDTH * image_yscale)
scroll_max = find_scroll_thumb_max_y(thumb_scale)
scroll_thumb = create_scroll_thumb(scroll_min, thumb_scale)
amount_bar_moves_on_scroll = find_scroll_wheel_scaling(thumb_scale)
scroll_clicked = false
amount_scrolled = scroll_min
pos_thumb_clicked = 0

/// @desc								Finds the amount that the scroll thumb will need to be scaled to
///											such that it will reflect how many screen lengths are below
///											what is shown. (1 screen length hidden = 1/2 the scroll bar)
/// @returns							The scroll thumb scaling (minimum: no scaling, maximum: the inner
///											portion of the bar)
function find_scroll_thumb_scale() {
	var max_scroll_thumb_scale = (sprite_height - (2 * SCROLL_BORDER_WIDTH * image_yscale))
									/ sprite_get_height(object_get_sprite(ui_obj_grid_scroll_thumb))
	var num_screen_lengths = viewable_window_height / scrollable_list_height
	return clamp(max_scroll_thumb_scale * num_screen_lengths, 1, max_scroll_thumb_scale)
}

/// @desc								Finds the maximum y position of the scroll thumb scaled to 
///											thumb_scale such that it will stay within the bar
/// @param {Real} thumb_scale			The amount the scroll thumb sprite is scaled (default 1)
/// @returns							The maximum y value of the thumb such that it stays in its bar
function find_scroll_thumb_max_y(thumb_scale = 1) {
	var thumb_sprite_height = sprite_get_height(object_get_sprite(ui_obj_grid_scroll_thumb)) * thumb_scale
	return y + sprite_height - floor(SCROLL_BORDER_WIDTH * image_yscale) - thumb_sprite_height
}

/// @desc								Creates the scroll bar thumb that shows the user where on the screen
///											they are scrolled to
/// @param {Real} scroll_min			The highest position on screen the scroll thumb can go to
/// @param {Real} thumb_scale			The amount the scroll thumb sprite is scaled
/// @returns							The new scroll thumb instance
function create_scroll_thumb(scroll_min, thumb_scale) {
	var thumb_layer_depth = layer_get_depth(layer) - 1
	var scroll_thumb_instance_id = layer_create(thumb_layer_depth, "scroll_thumb_instance")
	return instance_create_layer(x + SCROLL_BORDER_WIDTH, scroll_min, scroll_thumb_instance_id, ui_obj_grid_scroll_thumb, {
		image_yscale : thumb_scale
	})
}

/// @desc								Finds the scroll scaling needed to move 1 row
/// @returns							The scroll scaling needed to show 1 new row
function find_scroll_wheel_scaling(thumb_scale) {
	var max_scroll_thumb_y = (sprite_height - (2 * SCROLL_BORDER_WIDTH * image_yscale))
	if(array_length(objects_to_move) > 0) {
		var num_rows = scrollable_list_height / row_height
		return max_scroll_thumb_y / num_rows
	}
	return 0
}

/// @desc								Moves the scroll bar thumb to the new position as well as moving
///											all of the objects_to_move items
/// @param {bool} smooth_scroll			Flag to determine if the scroll should be animated or not
function move_scroll_thumb(smooth_scroll) {
	if(smooth_scroll) {
		scroll_thumb.y = lerp(scroll_thumb.y, amount_scrolled, SCROLL_SMOOTHING_AMOUNT);
	}
	else {
		scroll_thumb.y = amount_scrolled
	}

	set_objects_to_scroll_pos()
}

/// @desc								Sets the position of all the objects_to_move based on the
///											given percent_scrolled and their ystart position
function set_objects_to_scroll_pos() {
	var percent_scrolled = (scroll_thumb.y - scroll_min) / (scroll_max - scroll_min)
	scroll_grid_items(percent_scrolled)
}

/// @desc								Handles moving the instances in objects_to_move by the given
///											scroll_percent of the viewable_window_height
/// @param {Real} scroll_percent		The percentage of viewable_window_height to move the grid items
function scroll_grid_items(scroll_percent) {
	var num_rows_displayed = ceil(viewable_window_height / row_height)
	var y_shift_from_scroll = scroll_percent * (scrollable_list_height - viewable_window_height)
	var first_row_of_final_screen = ceil(array_length(objects_to_move) / num_columns) - num_rows_displayed
	var start_index = floor(scroll_percent * first_row_of_final_screen) * num_columns
	var end_index = min(start_index + ((num_rows_displayed + 1) * num_columns), array_length(objects_to_move))
	
	instance_deactivate_layer(objects_to_move[0].layer)
	for (var movable_objects_index = start_index; movable_objects_index < end_index; movable_objects_index++)
	{
		var current_obj = objects_to_move[movable_objects_index]
		instance_activate_object(current_obj)
		current_obj.y = current_obj.ystart - y_shift_from_scroll
	}
}