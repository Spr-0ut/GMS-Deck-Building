move_slider_thumb(1)

/// @desc									Moves this thumb to the given percent between slider_min
///												and slider_max before calling on_slider_change
/// @param {Real} slider_percent			The percent of the slider to set this thumb at
/// @param {Method} on_slider_change		The method called when after moving the thumb
/// @param {Array} on_slider_change_args	The arguments for on_slider_change
function move_slider_thumb(slider_percent, on_slider_change = noone, on_slider_change_args = []) {
	var slider_x_pos = (slider_percent * (slider_max - slider_min)) + slider_min -
			(sprite_width / 2) - sprite_xoffset
	x = clamp(slider_x_pos, slider_min, slider_max - (sprite_width))

	if(typeof(on_slider_change) == "method" && is_method(on_slider_change)) {
		method_call(on_slider_change, on_slider_change_args)
	}
}