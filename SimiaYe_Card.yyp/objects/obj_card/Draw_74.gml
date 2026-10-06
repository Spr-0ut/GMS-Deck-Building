if(global.card_surf_drawn) {
	global.card_surf_drawn = false
	surface_set_target(global.card_surf)
	draw_clear_alpha(c_black, 0)
	surface_reset_target()
}