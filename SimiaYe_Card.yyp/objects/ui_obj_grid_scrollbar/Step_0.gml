if(scroll_thumb.y > scroll_min && scroll_thumb.y < scroll_max && abs(scroll_thumb.y - amount_scrolled) > 1) {
	move_scroll_thumb(true)	
}

if(scroll_clicked) {
	var temp_amount_scrolled = mouse_y - pos_thumb_clicked
	amount_scrolled = clamp(temp_amount_scrolled, scroll_min, scroll_max)
	move_scroll_thumb(false)
}
else if(mouse_wheel_up()) {
	if(is_top_layer(layer)) {
		var temp_amount_scrolled = amount_scrolled - amount_bar_moves_on_scroll
		amount_scrolled = clamp(temp_amount_scrolled, scroll_min, scroll_max)
		move_scroll_thumb(true)
	}
}
else if(mouse_wheel_down()) {
	if(is_top_layer(layer)) {
		var temp_amount_scrolled = amount_scrolled + amount_bar_moves_on_scroll
		amount_scrolled = clamp(temp_amount_scrolled, scroll_min, scroll_max)
		move_scroll_thumb(true)
	}
}