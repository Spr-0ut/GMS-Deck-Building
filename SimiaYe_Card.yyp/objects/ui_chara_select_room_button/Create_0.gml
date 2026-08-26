#macro CHARA_SELECT_ROOM rm_chara_select

// Inherit the parent event
event_inherited();

/// @desc						Handles opening the character select screen by switching to it's room
function handle_mouse_left_button_release() {
	if(room_exists(CHARA_SELECT_ROOM)) {
		button_clicked = false
		global.object_being_clicked = false
		room_goto(CHARA_SELECT_ROOM)
	}
}