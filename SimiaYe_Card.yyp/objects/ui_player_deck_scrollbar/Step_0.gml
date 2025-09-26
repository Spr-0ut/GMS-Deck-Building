if(scroll_clicked) {
	var temp_amount_page_scrolled = mouse_y
	amount_page_scrolled = clamp(temp_amount_page_scrolled, scroll_min, scroll_max)
	move_scroll_thumb()
}
else if(mouse_wheel_up()) {
	if(is_top_layer(layer)) {
		var temp_amount_page_scrolled = amount_page_scrolled - amount_bar_moves
		amount_page_scrolled = clamp(temp_amount_page_scrolled, scroll_min, scroll_max)
		move_scroll_thumb()
	}
}
else if(mouse_wheel_down()) {
	if(is_top_layer(layer)) {
		var temp_amount_page_scrolled = amount_page_scrolled + amount_bar_moves
		amount_page_scrolled = clamp(temp_amount_page_scrolled, scroll_min, scroll_max)
		move_scroll_thumb()
	}
}