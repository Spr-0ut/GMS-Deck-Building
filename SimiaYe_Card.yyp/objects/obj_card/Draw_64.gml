draw_self()

draw_energy_cost(energy_cost, flexpanels)
draw_attacker_selected_icon(attacker_selection_type, flexpanels)
draw_card_type(card_type, flexpanels)
draw_description(card_description, flexpanels)

if(string_length(error_text) > 0) {
	show_error_message(error_text)
}