draw_self()
if(surface_exists(chara_card_grid_surface)) {
	draw_surface(chara_card_grid_surface, x + (CHARA_CARD_GRID_PADDING * image_xscale), y + (CHARA_CARD_GRID_PADDING * image_yscale))
	
	surface_set_target(chara_card_grid_surface)
	draw_clear_alpha(c_black, 0)
	surface_reset_target()
}