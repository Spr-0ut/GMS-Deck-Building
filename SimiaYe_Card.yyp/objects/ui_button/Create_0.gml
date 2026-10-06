if(!variable_global_exists("object_being_clicked")) {
	global.object_being_clicked = false
}
hovering_over_button = false
button_clicked = false

/// @desc						Handles the mouse hovering over this button by reducing it's alpha
function handle_mouse_enter() {
	if((!global.object_being_clicked || button_clicked) && is_top_layer(layer, mouse_x, mouse_y)) {
		hovering_over_button = true
		image_alpha = 0.6
	}
}

/// @desc						Handles the mouse leaving the button by resetting it's alpha
function handle_mouse_leave() {
	hovering_over_button = false
	image_alpha = 1
}

/// @desc						Handles the button being clicked, but not yet released, making
///									it move to indicate the button was pressed
function handle_mouse_left_button_press() {
	if(!global.object_being_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
		button_clicked = true
		global.object_being_clicked = true
		y = ystart + 4
	}
}

/// @desc						Handles the button action when it is successfully released
function handle_mouse_left_button_release() {
	// This function needs to be completed by each implementation of the button to give it functionality
	show_debug_message("This button has been pressed but no implementation of handle_mouse_left_button_release was found")
}