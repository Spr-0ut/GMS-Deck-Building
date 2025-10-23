#macro DROPDOWN_OPTION_TEXT_PADDING 10

/// @desc					Draws the text for the dropdown option
function draw_option_text() {
	var text_width = string_width(option_text);
	var text_size_scale = 1;
	if ((sprite_width - DROPDOWN_OPTION_TEXT_PADDING) > 0 && text_width > 
			(sprite_width - DROPDOWN_OPTION_TEXT_PADDING)) {
	    text_size_scale = (sprite_width - DROPDOWN_OPTION_TEXT_PADDING) / text_width;
	}
	draw_text_transformed(x + DROPDOWN_OPTION_TEXT_PADDING, y + DROPDOWN_OPTION_TEXT_PADDING,
							option_text, text_size_scale, text_size_scale, 0);
}