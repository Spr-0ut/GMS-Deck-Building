if(grid_is_moving) {
	if(is_expanded_grid) {
		shrink_chara_card_grid()
	}
	else {
		expand_chara_card_grid()
	}
}
else if(!global.object_being_clicked) {
	if(point_in_rectangle(mouse_x, mouse_y, x, y, x + sprite_width, y + sprite_height)) {
		if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar) && is_top_layer(layer)) {
			chara_card_grid_scroll_bar.scroll_locked = false
		}
	}
	else if(is_top_layer(layer)) {
		if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
			chara_card_grid_scroll_bar.scroll_locked = true
		}
		
		if(!is_expanded_grid && mouse_wheel_up()) {
			expand_chara_card_grid()
		}
		else if(is_expanded_grid && mouse_wheel_down()) {
			shrink_chara_card_grid()
		}
	}
}