if(!chara_card_selected && !global.object_being_clicked && visible && is_top_layer(layer, mouse_x, mouse_y)) {
		global.object_being_clicked	= true
		chara_card_selected = true
		chara_card_start_x_position = x
		chara_card_start_y_position = y
		x = mouse_x - (sprite_width / 2)
		y = mouse_y - (sprite_height / 2)
		flexpanels.set_draw_to_surface(false)
}