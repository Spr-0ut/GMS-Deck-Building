if(!card_selected && card_can_be_clicked) {
	card_selected = true
	card_can_be_clicked = false
	show_debug_message(card_selected)
	y -= 10
}
else if (card_can_be_clicked) {
	card_selected = false
	card_can_be_clicked = false
	y = display_get_gui_height() - sprite_height
}