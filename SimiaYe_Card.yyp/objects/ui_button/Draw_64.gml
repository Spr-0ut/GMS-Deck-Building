#macro TEXT_BORDER_BUFFER 10

draw_self()

draw_set_font(font)
draw_set_colour(text_color)

draw_set_halign(fa_center)
draw_set_valign(fa_middle)

var text_width = string_width(button_text);
var text_size_scale = 1;
if text_width >  (sprite_width - TEXT_BORDER_BUFFER) {
    text_size_scale = (sprite_width - TEXT_BORDER_BUFFER) / text_width;
}
draw_text_transformed(x, y, button_text, text_size_scale, text_size_scale, 0);

draw_set_halign(fa_left)
draw_set_valign(fa_top)