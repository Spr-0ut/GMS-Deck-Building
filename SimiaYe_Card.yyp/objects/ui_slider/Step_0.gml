if(slider_clicked) {
	var slider_percent = clamp((mouse_x - slider_min) / (slider_max - slider_min), 0, 1)
	slider_thumb.move_slider_thumb(slider_percent, method(self, on_slider_change), [slider_percent])
}