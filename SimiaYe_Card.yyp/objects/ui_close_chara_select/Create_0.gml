// Inherit the parent event
event_inherited();

sprite_frame_index = 0

/// @desc						Handles the mouse hovering over this button
function handle_mouse_enter() {
	if((!global.object_being_clicked || button_clicked) && is_top_layer(layer, mouse_x, mouse_y)) {
		hovering_over_button = true
	}
}

/// @desc						Handles the mouse leaving the button by resetting sprite_frame_index
function handle_mouse_leave() {
	hovering_over_button = false
	sprite_frame_index = 0
}

/// @desc						Handles the button being clicked, but not yet released
function handle_mouse_left_button_press() {
	if(!global.object_being_clicked && is_top_layer(layer, mouse_x, mouse_y)) {
		button_clicked = true
		global.object_being_clicked = true
	}
}

/// @desc						Handles closing the character select screen by switching rooms
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	room_goto(new_room)
}