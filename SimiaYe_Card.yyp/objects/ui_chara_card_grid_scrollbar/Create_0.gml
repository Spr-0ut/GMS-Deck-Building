#macro CHARA_CARD_GRID_SCROLL_THUMB_OVERHANG	2

/// @desc								Finds the amount that the scroll thumb will need to be scaled to
///											such that it will reflect how many screen lengths are below
///											what is shown. (1 screen length hidden = 1/2 the scroll bar)
/// @returns							The scroll thumb scaling (minimum: no scaling, maximum: the inner
///											portion of the bar)
function find_scroll_thumb_scale() {
	var thumb_sprite = object_get_sprite(scrollbar_thumb_object)
	var max_scroll_thumb_scale = (sprite_height - (2 * SCROLL_BORDER_WIDTH * image_yscale))
									/ sprite_get_height(thumb_sprite)
									
	var thumb_sprite_x_scale = (sprite_width + CHARA_CARD_GRID_SCROLL_THUMB_OVERHANG * image_xscale) 
									/ sprite_get_width(thumb_sprite)
	return clamp(thumb_sprite_x_scale, 1, max_scroll_thumb_scale)
}

/// @desc								Creates the scroll bar thumb that shows the user where on the screen
///											they are scrolled to
/// @param {Real} scroll_min			The highest position on screen the scroll thumb can go to
/// @param {Real} thumb_scale			The amount the scroll thumb sprite is scaled
/// @returns							The new scroll thumb instance
function create_scroll_thumb(scroll_min, thumb_scale) {
	var thumb_layer_depth = layer_get_depth(layer) - 1
	var scroll_thumb_instance_id = layer_create(thumb_layer_depth, "scroll_thumb_instance")
	
	var thumb_sprite_width = sprite_get_width(object_get_sprite(ui_chara_card_grid_scroll_thumb)) * thumb_scale
	var thumb_x_pos = x + (sprite_width - thumb_sprite_width) / 2
	
	return instance_create_layer(thumb_x_pos, scroll_min, scroll_thumb_instance_id, scrollbar_thumb_object, {
		image_xscale : thumb_scale,
		image_yscale : thumb_scale
	})
}

// Inherit the parent event
// NOTE: This must be at the end of the create event due to overriding functions called during the create event
event_inherited();