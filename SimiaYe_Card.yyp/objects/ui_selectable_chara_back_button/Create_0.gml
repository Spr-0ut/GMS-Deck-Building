// Inherit the parent event
event_inherited();

is_back_enabled = back_return_fuction != undefined
if(!is_back_enabled) {
	image_blend = c_dkgrey
}

/// @desc						Handles returning to the previous selection screen
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	
	layer_destroy_instances(layer)
	if(is_method(back_return_fuction) && back_return_fuction != undefined) {
		method_call(back_return_fuction, [])
	}
}