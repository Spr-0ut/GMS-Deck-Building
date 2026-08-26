// Inherit the parent event
event_inherited();

/// @desc						Handles calling the given on_button_press method if it exists
function handle_mouse_left_button_release() {
	if(on_button_pressed != undefined && is_method(on_button_pressed))
		method_call(on_button_pressed, on_button_pressed_args)
}