#macro CHARA_CARD_FILTER_ACTIVATE_X_MOVEMENT 32

// Inherit the parent event
event_inherited();

filter_active = false
filter_starting_x = x

/// @desc						Handles opening the character select screen by switching to it's room
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false

	if(instance_exists(obj_chara_card_grid)) {
		if(filter_active) {
			deactivate_filter(true)
		}
		else {
			activate_filter()
		}
	}
}

/// @desc						Activates this filter, making only the chara_class_filtered chara cards
///									are shown and deactivates all other chara card filters
function activate_filter() {
	if(!filter_active && is_int64(chara_class_filtered)) {
		filter_starting_x = x
		x += CHARA_CARD_FILTER_ACTIVATE_X_MOVEMENT * image_xscale
		obj_chara_card_grid.filter_chara_cards(chara_class_filtered)
		with(obj_chara_card_filter) {
			deactivate_filter(false)
		}
		filter_active = true
	}
}

/// @desc								Deactivates the filter, reseting the button and showing the
///											hidden chara cards
/// @param {Bool} clear_grid_filter		Optional flag that determines if this function should show all
///											the chara cards, this is just so the cards are not 
///											reactivated and immediately deactivated on filter switch
function deactivate_filter(clear_grid_filter = true) {
	if(filter_active) {
		x = filter_starting_x
		if(clear_grid_filter) {
			obj_chara_card_grid.clear_filter()
		}
		filter_active = false
	}
}