// Inherit the parent event
event_inherited();

/// @desc							Handles deleting all objects in the layer this button is placed on and
///										the layer itself. NOTE the button has additional code to clean up
///										variables since the button itself is being deleted
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	
	if(on_layer_closed != undefined && is_method(on_layer_closed))
		method_call(on_layer_closed, on_layer_closed_args)	
	find_and_delete_related_layers(layer)
}