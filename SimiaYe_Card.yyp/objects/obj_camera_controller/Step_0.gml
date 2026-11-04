if(variable_global_exists("room_is_arena") && global.room_is_arena) {
	set_camera_pos(camera_width / 2, camera_height / 2)
}
else if(camera_is_zooming) {
	zoom_camera()
}
else {
	if(follow_target == noone) {
		find_follow_target()	
	}
	else if(instance_exists(follow_target)) {
		set_camera_pos(follow_target.x, follow_target.y)
	}
}
