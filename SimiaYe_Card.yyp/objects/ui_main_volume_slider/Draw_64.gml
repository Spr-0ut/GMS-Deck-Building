// Inherit the parent event
event_inherited();

draw_set_colour(VOLUME_TEXT_COLOR)
draw_set_font(VOLUME_TEXT_FONT)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
var text_scale = sprite_height / string_height(global.main_volume_percent)
var percent_text = round(global.main_volume_percent * 100)
draw_text_transformed(x + sprite_width + VOLUME_TEXT_PADDING, y, percent_text, text_scale, text_scale, image_angle)