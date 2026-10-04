var thumb_scale = self.find_scroll_thumb_scale()
scroll_max = find_scroll_thumb_max_y(thumb_scale)
scroll_thumb = self.create_scroll_thumb(scroll_min, thumb_scale)
amount_bar_moves_on_scroll = find_scroll_wheel_scaling(thumb_scale)