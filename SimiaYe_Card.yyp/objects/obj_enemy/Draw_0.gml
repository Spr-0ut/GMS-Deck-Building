//NOTE: It's silly but draw_self() is needed for the event_perform in obj_attack_highlight, 
//			even if there is nothing else in this event
draw_self()

if(display_enemy_loses_player_symbol) {
	if(variable_global_exists("room_is_arena") && !global.room_is_arena) {
		var confusion_symbol_x = x - sprite_xoffset + ((sprite_width - sprite_get_width(ENEMY_LOSES_PLAYER_SPRITE)) / 2)
		var confusion_symbol_y = y - sprite_yoffset - (ENEMY_LOSES_PLAYER_SYMBOL_PADDING * image_yscale) -
									(sprite_get_height(ENEMY_LOSES_PLAYER_SPRITE) * image_yscale)
		draw_sprite_ext(ENEMY_LOSES_PLAYER_SPRITE, 0, confusion_symbol_x, confusion_symbol_y, image_xscale, image_yscale, 0, image_blend, image_alpha)
	}
	else {
		display_enemy_loses_player_symbol = false
	}
}