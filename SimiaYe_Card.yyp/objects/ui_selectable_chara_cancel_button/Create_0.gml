// Inherit the parent event
event_inherited();

/// @desc						Handles canceling the target selection process 
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	
	obj_target_selection_handler.cancel_target_selection()
}