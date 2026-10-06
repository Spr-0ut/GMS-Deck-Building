// Inherit the parent event
event_inherited();

/// @desc							Handles moving the player between rooms, resetting their deck and
///										determining if the room is an arena or not
function handle_mouse_left_button_release() {
	if(room_exists(new_room)) {
		button_clicked = false
		global.object_being_clicked = false
		reset_player_current_deck()
		reset_player_discard_deck()
		reset_player_exhaust_deck()
		room_goto(new_room)
		if(room_get_name(new_room) == "Arena") {
			global.room_is_arena = true
		}
		else {
			global.room_is_arena = false	
		}
	}
}