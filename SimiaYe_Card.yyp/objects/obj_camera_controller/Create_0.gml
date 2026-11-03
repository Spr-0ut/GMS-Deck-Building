#macro CAMERA_EASING		0.15
#macro CAMERA_ZOOM_SPEED	0.2

main_camera = view_camera[0]
camera_width = camera_get_view_width(main_camera)
camera_height = camera_get_view_height(main_camera)
follow_target = noone
camera_is_zooming = false
camera_zoom_callback = noone
camera_zoom_callback_args = []
camera_target_width = camera_width
camera_target_height = camera_height
zoom_shader_center_radius = 0
shd_zoom_pos = shader_get_uniform(shd_camera_zoom, "pos")
shd_zoom_radius_not_blured = shader_get_uniform(shd_camera_zoom, "radius_not_blured")

/// @desc						Sets the initial position of the camera so it starts on the player character
function set_camera_initial_pos() {
	var new_camera_x = camera_width / 2
	var new_camera_y = camera_height / 2
	if(!variable_global_exists("room_is_arena") || !global.room_is_arena) {
		find_follow_target()
		new_camera_x = clamp(follow_target.x - (camera_width / 2), 0, room_width - camera_width)
		new_camera_y = clamp(follow_target.y - (camera_height / 2), 0, room_height - camera_height)
	}
	camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
}

/// @desc						Sets the camera to be closer to the target using an asymptotic averaging
///									function. NOTE: This should be run every frame for smooth movement
function set_camera_pos(x_target, y_target) {
	var target_camera_x = x_target - (camera_width / 2)
	var target_camera_y = y_target - (camera_height / 2)
	var camera_x_movement = CAMERA_EASING * (target_camera_x - camera_get_view_x(main_camera))
	var camera_y_movement = CAMERA_EASING * (target_camera_y - camera_get_view_y(main_camera))
	var new_camera_x = clamp(camera_get_view_x(main_camera) + camera_x_movement, 0, room_width - camera_width)
	var new_camera_y = clamp(camera_get_view_y(main_camera) + camera_y_movement, 0, room_height - camera_height)
	camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
}

/// @desc						Finds a player controlled character and sets it as the camera's
///									follow target
function find_follow_target() {
	if(variable_global_exists("player_chara") && global.player_chara != noone) {
		if(!instance_exists(global.player_chara)) {
			return
		}
		if(instance_number(global.player_chara.object_index) == 1) {
			follow_target = global.player_chara
		}
		else {
			for(var player_chara_index = 0; player_chara_index < instance_number(global.player_chara.object_index); player_chara_index++) {
				var chara_instance = instance_find(global.player_chara.object_index, player_chara_index)
				if(chara_instance != noone && chara_instance.is_controlled_chara) {
					follow_target = chara_instance
				}
			}
		}
	}
	else {
		for(var chara_index = 0; chara_index < instance_number(obj_player); chara_index++) {
			var chara = instance_find(obj_player, chara_index)
			if(chara != noone && chara.is_controlled_chara) {
				follow_target = chara
				break
			}
		}
	}
	
	camera_set_view_target(main_camera, follow_target)
}

/// @desc									Sets up variables to begin the camera zoom
/// @param {Real} new_width_percent			Percentage of camera's current width to zoom to as a decimal
/// @param {Real} new_height_percent		Percentage of camera's current height to zoom to as a decimal
/// @param {Real} zoom_focus_radius			The radius of center of the zoom that isnt blurred
/// @param {Method} on_camera_zoomed		Optional method called when the zooming is finished
/// @param {Array} on_camera_zoomed_args	Optional array of arguments for on_camera_zoomed
function start_camera_zoom(new_width_percent, new_height_percent, zoom_focus_radius, on_camera_zoomed = noone, on_camera_zoomed_args = []) {
	if (!camera_is_zooming && is_numeric(new_width_percent) && new_width_percent > 0 && 
		is_numeric(new_height_percent) && new_height_percent > 0) {
			camera_zoom_callback = on_camera_zoomed
			camera_zoom_callback_args = on_camera_zoomed_args
			camera_target_width = new_width_percent * camera_width
			camera_target_height = new_height_percent * camera_height
			zoom_shader_center_radius = zoom_focus_radius / surface_get_width(application_surface)
			camera_is_zooming = true
			application_surface_draw_enable(false)
			
	}
}

/// @desc						Zooms and moves the camera every step towards camera_target_width
///									and camera_target_height
function zoom_camera() {
	if(camera_is_zooming) {
		var new_camera_width = lerp(camera_width, camera_target_width, CAMERA_ZOOM_SPEED)
		var new_camera_height = lerp(camera_height, camera_target_height, CAMERA_ZOOM_SPEED)
		var new_camera_x = camera_get_view_x(view_camera[0]) + (camera_width - new_camera_width) / 2
		var new_camera_y = camera_get_view_y(view_camera[0]) + (camera_height - new_camera_height) / 2
		
		camera_set_view_size(main_camera, new_camera_width, new_camera_height)
		camera_set_view_pos(main_camera, new_camera_x, new_camera_y)
		camera_width = new_camera_width
		camera_height = new_camera_height
		
		if(abs(camera_width - camera_target_width) < 1 &&
			abs(camera_height - camera_target_height) < 1) {
				camera_is_zooming = false
				application_surface_draw_enable(true)
				if(camera_zoom_callback != noone && is_method(camera_zoom_callback)) {
					method_call(camera_zoom_callback, camera_zoom_callback_args)	
				}
		}
	}
}

/// @desc						Draws the application surface with a blur shader applied
function draw_camera_zoom() {
	shader_set(shd_camera_zoom)
	shader_set_uniform_f(shd_zoom_pos, 0.5, 0.5)
	shader_set_uniform_f(shd_zoom_radius_not_blured, zoom_shader_center_radius)
	draw_surface(application_surface, 0, 0)
	shader_reset()
}