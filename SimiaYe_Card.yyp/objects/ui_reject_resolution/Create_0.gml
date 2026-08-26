// Inherit the parent event
event_inherited();

/// @desc						Handles rejecting the resolution changes and reverts them to their
///									previous setting
function handle_mouse_left_button_release() {
	button_clicked = false
	global.object_being_clicked = false
	ui_window_settings_updater.revert_resolution_changes()
	find_and_delete_related_layers(layer)
}