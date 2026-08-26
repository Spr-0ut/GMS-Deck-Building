var mouse_gui_x = device_mouse_x_to_gui(0)
var mouse_gui_y = device_mouse_y_to_gui(0)
var x_pos = x - sprite_xoffset
var y_pos = y - sprite_yoffset
var mouse_over_button = point_in_rectangle(mouse_gui_x, mouse_gui_y, x_pos + min(sprite_width, 0), y_pos + min(sprite_height, 0),
											x_pos + max(sprite_width, 0), y_pos + max(sprite_height, 0))
if(!hovering_over_button) {
	if(mouse_over_button) {
		handle_mouse_enter()
	}
}
else {
	if(!mouse_over_button) {
		handle_mouse_leave()
	}
	else if(mouse_check_button_pressed(mb_left)) {
		handle_mouse_left_button_press()
	}
}