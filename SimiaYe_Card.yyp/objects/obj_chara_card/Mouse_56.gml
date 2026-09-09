if(chara_card_selected) {
	chara_card_selected = false
	global.object_being_clicked = false
	x = chara_card_start_x_position
	y = chara_card_start_y_position
	flexpanels.set_chara_card_pos(x, y)
}