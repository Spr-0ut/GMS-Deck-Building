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
scroll_grid_items(0)

/// @desc								Handles updating the scroll bar data if the scroll bar or scrolled
///											items need to change size
/// @param {Real} scroll_bar_y_pos		The new y position of the scroll bar, scroll_min is also updated
/// @param {Real} scroll_bar_y_scale	The y scale for the scroll bar, the thumb scale is also updated
/// @param {Real} list_height			The height of the full list being scrolled
/// @param {Real} height_of_rows		The height of each row, amount_bar_moves_on_scroll is also updated
/// @param {Real} number_of_columns		The number of columns displayed in the grid
/// @param {Real} view_window_height	The height of the portion of the grid that's visible also updates
///											scroll thumb scaling
function update_scroll_data(scroll_bar_y_pos = undefined, scroll_bar_y_scale = undefined,
							list_height = undefined, height_of_rows = undefined,
							number_of_columns = undefined, view_window_height = undefined) {
	if(scroll_bar_y_pos != undefined && is_real(scroll_bar_y_pos)) {
		y = scroll_bar_y_pos
		scroll_min = scroll_bar_y_pos + floor(SCROLL_BORDER_WIDTH * image_yscale)
	}
	if(scroll_bar_y_scale != undefined && is_real(scroll_bar_y_scale) && image_yscale > 0) {
		image_yscale = scroll_bar_y_scale
	}
	if(list_height != undefined && is_real(list_height) && list_height > 0) {
		scrollable_list_height = list_height
	}
	if(height_of_rows != undefined && is_real(height_of_rows) && height_of_rows > 0) {
		row_height = height_of_rows
	}
	if(number_of_columns != undefined && is_real(number_of_columns) && number_of_columns > 0) {
		num_columns = number_of_columns
	}
	if(view_window_height != undefined && is_real(view_window_height) && view_window_height > 0) {
		viewable_window_height = view_window_height
	}
	
	var thumb_scale = find_scroll_thumb_scale()
	scroll_thumb.image_yscale = thumb_scale
	scroll_max = find_scroll_thumb_max_y(thumb_scale)
	amount_bar_moves_on_scroll = find_scroll_wheel_scaling(thumb_scale)
	reset_scroll()
}

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

/// @desc								Sets the thumb and objects_to_move to their top most position
function reset_scroll() {
	amount_scrolled = scroll_min
	move_scroll_thumb(false)
}

/// @desc								Sets the position of all the objects_to_move based on the
///											given percent_scrolled and their ystart position
function set_objects_to_scroll_pos() {
	var percent_scrolled = abs((scroll_thumb.y - scroll_min) / (scroll_max - scroll_min))
	scroll_grid_items(percent_scrolled)
}

/// @desc								Handles moving the instances in objects_to_move by the given
///											scroll_percent of the viewable_window_height
/// @param {Real} scroll_percent		The percentage of viewable_window_height to move the grid items
function scroll_grid_items(scroll_percent) {
	var num_rows_displayed = ceil(viewable_window_height / row_height)
	var y_shift_from_scroll = find_y_shift_from_scroll(scroll_percent)
	var max_rows_scrolled = (scrollable_list_height - viewable_window_height) / row_height
	var start_index = clamp(floor(scroll_percent * max_rows_scrolled) * num_columns, 0, array_length(objects_to_move))
	var end_index = clamp(start_index + ((num_rows_displayed + 1) * num_columns), 0, array_length(objects_to_move))
	
	for (var movable_objects_index = 0; movable_objects_index < start_index; movable_objects_index++)
	{
		if(objects_to_move[movable_objects_index] != noone) {
			objects_to_move[movable_objects_index].visible = false
		}
	}
	for (var movable_objects_index = start_index; movable_objects_index < end_index; movable_objects_index++)
	{
		if(objects_to_move[movable_objects_index] != noone) {
			var current_obj = objects_to_move[movable_objects_index]
			current_obj.visible = true
			current_obj.y = current_obj.ystart - y_shift_from_scroll
		}
	}
	for (var movable_objects_index = end_index; movable_objects_index < array_length(objects_to_move); movable_objects_index++)
	{
		if(objects_to_move[movable_objects_index] != noone) {
			objects_to_move[movable_objects_index].visible = false
		}
	}
}

/// @desc								Calculates the y distance scrolled items need to move up
///											based on the amount scrolled
/// @param {Real} scroll_percent		The optional percentage the scroll bar has been scrolled
/// @returns {Real}						The amount to subtract from grid item's y positions
function find_y_shift_from_scroll(percent_scrolled = -1) {
	if(!is_real(percent_scrolled) || percent_scrolled < 0) {
		percent_scrolled = abs((scroll_thumb.y - scroll_min) / (scroll_max - scroll_min))
	}
	return percent_scrolled * (scrollable_list_height - viewable_window_height)
}