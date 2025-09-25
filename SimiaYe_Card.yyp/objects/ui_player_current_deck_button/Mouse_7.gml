if(is_top_layer(layer) && button_clicked) {
	show_player_deck = true

	var player_deck_header_instance_id = layer_create(-100, "player_deck_header_instance")
	create_player_deck_header(player_deck_header_instance_id)
	
	player_deck_instance_id = layer_create(-95, "player_deck_instance")
	create_scroll_bar(player_deck_instance_id)
	create_player_deck_view(player_deck_instance_id)
}