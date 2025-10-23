if (step_number == 0) {
	if(anti_aliasing == -1)
		anti_aliasing = display_aa
	
	if(!variable_global_exists("vsync_enabled"))
		global.vsync_enabled = true
	if(vsync_changed)
		global.vsync_enabled = !global.vsync_enabled
	
	display_reset(anti_aliasing, global.vsync_enabled); 
}
    
else if(step_number == 1 && screen_width != -1 && screen_height != -1) {
	window_set_size(screen_width, screen_height); 
}

else if(step_number == 2) {
	var fullscreen = window_get_fullscreen() ^^ fullscreen_changed
	window_set_fullscreen(fullscreen); 
}

else if(step_number > 2) {
	instance_destroy(); 
}

step_number++;