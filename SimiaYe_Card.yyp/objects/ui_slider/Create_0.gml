#macro SLIDER_BORDER_WIDTH 4

slider_clicked = false
slider_min = x + floor(SLIDER_BORDER_WIDTH * image_xscale)
slider_max = x + sprite_width - floor(SLIDER_BORDER_WIDTH * image_xscale)
slider_thumb = create_slider_thumb()

/// @desc								The function that is called whenever this slider is changed
/// @param {Real} slider_percent		The current percent of the slider that the thumb is at
on_slider_change = function(slider_percent) {
	//This function needs to be implemented for a slider child to do anything
}

/// @desc								Creates the slider thumb that visually indicates the current
///											percent of the slider it's set to
/// @returns {Id.Instance}				The new scroll thumb instance
function create_slider_thumb() {
	var thumb_layer_depth = layer_get_depth(layer) - 1
	var slider_thumb_instance_layer = layer_create(thumb_layer_depth, "slider_thumb_instance")
	var slider_thumb_sprite = object_get_sprite(ui_slider_thumb)
	var thumb_y_pos = y + 
						(sprite_height -
						(sprite_get_height(slider_thumb_sprite) * image_yscale)) / 2 - 
						(sprite_get_yoffset(slider_thumb_sprite) * image_yscale)
	
	return instance_create_layer(x, thumb_y_pos, slider_thumb_instance_layer, ui_slider_thumb, {
		image_xscale,
		image_yscale,
		slider_min,
		slider_max
	})
}