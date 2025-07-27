if(!instance_exists(ui_player_hand)) {
	instance_create_layer(x,y,"Instances",ui_player_hand)
}
else if (object_get_visible(ui_player_hand)) {
	//show player hand
}
else {
	//hide player hand
}
