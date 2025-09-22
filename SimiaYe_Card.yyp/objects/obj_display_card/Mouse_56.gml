if(card_clicked) {
	global.object_being_clicked	= false
	card_clicked = false
}
if(card_expanded && remove_expanded_card) {
	layer_destroy(layer)
}