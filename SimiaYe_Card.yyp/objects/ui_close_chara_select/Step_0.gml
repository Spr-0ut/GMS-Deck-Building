// Inherit the parent event
event_inherited();

if(hovering_over_button) {
	if(sprite_frame_index < sprite_get_number(sprite_index) - 1) {
		var frames_between_subimages = game_get_speed(gamespeed_fps) / sprite_get_speed(sprite_index)
		sprite_frame_index += 1 / frames_between_subimages
	}
}
else {
	sprite_frame_index = 0
}