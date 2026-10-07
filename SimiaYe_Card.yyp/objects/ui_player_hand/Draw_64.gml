if(surface_exists(global.card_surf)) {
	draw_surface(global.card_surf, 0, 0);
	
	surface_set_target(global.card_surf)
	draw_clear_alpha(c_black, 0)
	surface_reset_target()
}