if(chara_card_selected) {
	x = mouse_x - (sprite_width / 2)
	y = mouse_y - (sprite_height / 2)
}

flexpanels.set_chara_card_pos(x, y)

if(chara_card_is_changing_size) {
	animate_chara_card_change_size()	
}