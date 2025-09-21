/// @desc								Deletes all objects in the layer this button is placed on and the
///											layer itself. NOTE the button has additional code to clean up
///											variables since the button itself is being deleted
if(is_top_layer(layer) && button_clicked) {
	button_clicked = false
	global.button_being_clicked = false
	ui_player_current_deck_button.hide_player_deck()
	layer_destroy(layer)
}