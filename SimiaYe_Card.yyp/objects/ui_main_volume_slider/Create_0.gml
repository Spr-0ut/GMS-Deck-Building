#macro VOLUME_TEXT_COLOR c_white
#macro VOLUME_TEXT_FONT fnt_volume_controls
#macro VOLUME_TEXT_PADDING 10

// Inherit the parent event
event_inherited();

if(!variable_global_exists("main_volume_percent")) {
	global.main_volume_percent = 1
}
slider_thumb.move_slider_thumb(global.main_volume_percent)	

/// @desc							Sets the main volume for the game to the given percent
/// @param {Real} slider_percent	The value to set the game's main gain volume to
on_slider_change = function(slider_percent) {
	if(is_real(slider_percent) && slider_percent >= 0) {
		global.main_volume_percent = slider_percent
		if(instance_exists(obj_sound_controller)) {
			obj_sound_controller.set_main_volume(slider_percent)
		}
	}
}