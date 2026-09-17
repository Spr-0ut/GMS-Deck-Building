chara_card_selected = false
chara_card_is_changing_size = false
chara_card_start_x_position = x
chara_card_start_y_position = y

target_sprite = sprite_index
chara_card_start_xscale = image_xscale
chara_card_start_yscale = image_yscale
target_chara_card_x_scale = image_xscale
target_chara_card_y_scale = image_yscale
target_chara_card_x_pos = x
target_chara_card_y_pos = y

flexpanels.set_chara_card_pos(x, y)
flexpanels.setup_chara_card_drawn_data(chara_card_data.num_potion_slots,
										chara_card_data.chara_portrait,
										chara_card_data.player_max_health,
										chara_card_data.player_max_health,
										chara_card_data.chara_attack,
										chara_card_data.chara_description)

/// @desc									Sets this chara card to either be expanded or shrunk without
///												any animation
/// @param {Bool} is_expanded_chara_card	Flag that determines if this chara card should use its expanded
///												or shrunk chara card sprite
function set_chara_card_size(is_expanded_chara_card) {
	sprite_index = find_chara_card_sprite(chara_card_data.class, is_expanded_chara_card)
	if(typeof(flexpanels) == "struct") {
		flexpanels.set_chara_card_type(is_expanded_chara_card)
	}
}

/// @desc									Alerts this card to begin expanding or shrinking its sprite
/// @param {Bool} is_expanded_chara_card	Flag that determines if this chara card should use its
///												expanded or shrunk chara card sprite
/// @param {Real} target_x					The x position the card will move to while changing sprites
/// @param {Real} target_y					The y position the card will move to while changing sprites
function change_chara_card_size(is_expanded_chara_card, target_x, target_y) {
	target_sprite = find_chara_card_sprite(chara_card_data.class, is_expanded_chara_card)
	card_is_expanded = is_expanded_chara_card
	target_chara_card_x_scale = (sprite_get_width(target_sprite) * chara_card_start_xscale) / sprite_width
	target_chara_card_y_scale = (sprite_get_height(target_sprite) * chara_card_start_yscale) / sprite_height
	chara_card_is_changing_size = true
	target_chara_card_x_pos = target_x
	target_chara_card_y_pos = target_y
	if(typeof(flexpanels) == "struct" && !is_expanded_chara_card) {
		flexpanels.set_chara_card_type(false)
	}
}

/// @desc									Animates the chara card by adjusting it's scale and position
///												each frame before updating it's sprite
function animate_chara_card_change_size() {
	image_xscale = lerp(image_xscale, target_chara_card_x_scale, 0.5)
	image_yscale = lerp(image_yscale, target_chara_card_y_scale, 0.5)
	x = lerp(x, target_chara_card_x_pos, 0.5)
	y = lerp(y, target_chara_card_y_pos, 0.5)
	
	if(abs(sprite_width - (sprite_get_width(target_sprite) * chara_card_start_xscale)) < 1 &&
		abs(sprite_height - (sprite_get_height(target_sprite) * chara_card_start_yscale)) < 1) {
			chara_card_is_changing_size = false
			sprite_index = target_sprite
			image_xscale = chara_card_start_xscale
			image_yscale = chara_card_start_yscale
			if(typeof(flexpanels) == "struct" && card_is_expanded) {
				flexpanels.set_chara_card_type(true)
			}
	}
}