draw_self()

draw_energy_cost(energy_cost, flexpanels, card_elements_data)
draw_attacker_selected_icon(attacker_selection_type, flexpanels, card_elements_data)
draw_card_type(card_type, flexpanels, card_elements_data)
draw_description(card_description, flexpanels, card_elements_data, image_xscale, image_yscale)

if(string_length(error_text) > 0) {
	show_error_message(error_text)
}