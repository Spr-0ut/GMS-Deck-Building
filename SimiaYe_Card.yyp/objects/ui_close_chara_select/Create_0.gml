// Inherit the parent event
event_inherited();

/// @desc						Handles closing the character select screen by switching rooms
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	room_goto(new_room)
}