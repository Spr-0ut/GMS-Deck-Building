if(is_top_layer(layer) && !global.object_being_clicked) {
	scroll_clicked = true
	global.object_being_clicked = true
	
	if(mouse_y < amount_page_scrolled ||  mouse_y > amount_page_scrolled + scroll_thumb.sprite_height) {
		pos_thumb_clicked = scroll_thumb.sprite_height / 2
	}
	else {
		pos_thumb_clicked = mouse_y - scroll_thumb.y
	}
}