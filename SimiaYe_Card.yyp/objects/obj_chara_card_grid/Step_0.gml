if(!is_expanded_grid && (mouse_wheel_up() || grid_is_moving) && is_top_layer(layer)) {
	expand_chara_card_grid()
}
else if(is_expanded_grid && (mouse_wheel_down() || grid_is_moving) && is_top_layer(layer)) {
	shrink_chara_card_grid()
}