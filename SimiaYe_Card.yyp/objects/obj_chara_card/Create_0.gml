chara_card_selected = false
chara_card_start_x_position = x
chara_card_start_y_position = y

flexpanels.set_chara_card_pos(x, y)
flexpanels.setup_chara_card_drawn_data(chara_card_data.num_potion_slots,
										chara_card_data.chara_portrait,
										chara_card_data.player_max_health,
										chara_card_data.player_max_health,
										chara_card_data.chara_attack,
										chara_card_data.chara_description)

/// @desc									Handles this chara card being expanded or shrunk, updating the
///												sprite and the drawn items
/// @param {Bool} is_expanded_chara_card	Flag that determines if this chara card should use its expanded
///												or shrunk chara card sprite
function change_chara_card_size(is_expanded_chara_card) {
	sprite_index = find_chara_card_sprite(chara_card_data.class, is_expanded_chara_card)
	if(typeof(flexpanels) == "struct") {
		flexpanels.set_chara_card_type(is_expanded_chara_card)
	}
}