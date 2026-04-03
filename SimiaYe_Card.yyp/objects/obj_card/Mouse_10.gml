if(!global.object_being_clicked && visible && card_can_be_moved
		&& is_top_layer(layer, mouse_x, mouse_y)) {
	card_start_y_position = y
	y -= 10 * image_yscale
}