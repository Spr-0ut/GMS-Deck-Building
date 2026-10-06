if(card_can_be_moved) {
	if (!surface_exists(global.card_surf))
	{
	    global.card_surf = surface_create(display_get_gui_width(), display_get_gui_height())
	}
	surface_set_target(global.card_surf)

	var _zwrite = gpu_get_zwriteenable()
	var _ztest = gpu_get_ztestenable()
	var _alphatest = gpu_get_alphatestenable()
	var _depth = gpu_get_depth()
	gpu_set_zwriteenable(true)
	gpu_set_ztestenable(true)
	gpu_set_alphatestenable(true)

	if(card_selected) {
		gpu_set_depth(depth - MAX_PLAYER_HAND_SIZE - 1)
	}
	else {
		gpu_set_depth(depth - card_index_in_hand)
	}

	draw_self()
	draw_energy_cost(energy_cost, flexpanels, card_elements_data)
	draw_attacker_selected_icon(attacker_selection_type, flexpanels, card_elements_data)
	draw_card_type(card_type, flexpanels, card_elements_data)
	draw_description(card_description, flexpanels, card_elements_data, image_xscale, image_yscale)

	gpu_set_depth(_depth)
	gpu_set_zwriteenable(_zwrite)
	gpu_set_ztestenable(_ztest)
	gpu_set_alphatestenable(_alphatest)

	if(string_length(error_text) > 0) {
		show_error_message(error_text)
	}

	surface_reset_target()
}
else {
	draw_self()
	draw_energy_cost(energy_cost, flexpanels, card_elements_data)
	draw_attacker_selected_icon(attacker_selection_type, flexpanels, card_elements_data)
	draw_card_type(card_type, flexpanels, card_elements_data)
	draw_description(card_description, flexpanels, card_elements_data, image_xscale, image_yscale)
}