// Inherit the parent event
event_inherited();

/// @desc						Handles confirming the action and calling on_confirm_function
function handle_mouse_left_button_release() {
	if(on_confirm_function != undefined && is_method(on_confirm_function))
			method_call(on_confirm_function, on_confirm_function_args)
	button_clicked = false
	global.object_being_clicked = false
	find_and_delete_related_layers(layer)
}