#macro MAX_PARTY_SIZE					5
#macro PARTY_CARD_BOX_TOP_BORDER		38
#macro PARTY_CARD_BOX_LEFT_BORDER		20
#macro PARTY_CARD_BOX_EDGE_DETAILS		4
#macro PARTY_BOX_SIZE_CHANGE_SPEED		0.5

starting_y_scale = image_yscale
target_y_scale = starting_y_scale
chara_card_sprite_scale_diff = sprite_get_height(spr_expanded_party_select_slots) / sprite_get_height(spr_shrunk_party_select_slots)
current_party_chara = array_create(MAX_PARTY_SIZE, noone)
is_expanded_party_box = true

/// @desc									Sets the given character card to the slot they were closest
///												to and saves it as one of the party members
/// @param {Id.Instance} chara_card_to_add	The card of the character to add to the player's party
function add_party_memeber(chara_card_to_add) {
	if(typeof(chara_card_to_add) == "ref") {
		if(is_expanded_party_box) {
			chara_card_to_add.sprite_index	= spr_expanded_chara_card
		}
		else {
			chara_card_to_add.sprite_index	= spr_shrunk_chara_card
		}
		
		var chara_slot_width = sprite_width / MAX_PARTY_SIZE
		var index_to_replace = clamp(floor((chara_card_to_add.x - x) / chara_slot_width), 0, MAX_PARTY_SIZE)
		
		if(current_party_chara[index_to_replace] == chara_card_to_add) {
			return	
		}
		
		shift_party_chara_cards(chara_card_to_add, index_to_replace)
		current_party_chara[index_to_replace] = chara_card_to_add
		set_party_chara_card_pos(chara_card_to_add, index_to_replace)
		if(instance_exists(obj_chara_card_grid)) {
			obj_chara_card_grid.empty_card_slot(chara_card_to_add)	
		}
	}
}

/// @desc									Checks if any existing character cards in the party need
///												to be moved to allow the given card to be placed
/// @param {Id.Instance} chara_card_to_add	The card of the character to add to the player's party
/// @param {Real} index_to_replace			The index where the new chara card will be placed
function shift_party_chara_cards(chara_card_to_add, index_to_replace) {
	var party_index = check_for_chara_card_in_party(chara_card_to_add)
	if(party_index >= 0) {
		current_party_chara[party_index] = current_party_chara[index_to_replace]
		set_party_chara_card_pos(current_party_chara[party_index], party_index)
	}
	else if(current_party_chara[index_to_replace] != noone) {
		var next_open_slot = check_for_open_party_slot(index_to_replace)
		if(next_open_slot > -1) {
			for(var chara_card_index = next_open_slot; chara_card_index > index_to_replace; chara_card_index--) {
				current_party_chara[chara_card_index] = current_party_chara[chara_card_index - 1]
				set_party_chara_card_pos(current_party_chara[chara_card_index], chara_card_index)
			}
		}
		else if(instance_exists(obj_chara_card_grid)) {
			obj_chara_card_grid.return_chara_card_to_grid(current_party_chara[index_to_replace])	
		}
	}
}

/// @desc									Checks the current_party_chara for the given chara card
///												and returns its index
/// @param {Id.Instance} chara_card			The character card to search for in the party
/// @returns {Real}							The index of the given chara card in the party or -1
///												if the card is not found
function check_for_chara_card_in_party(chara_card) {
	for(var party_index = 0; party_index < array_length(current_party_chara); party_index++) {
		if(current_party_chara[party_index] == chara_card) {
			return party_index
		}
	}
	return -1
}

/// @desc									Finds the first party slot after the given index that's empty
/// @param {Real} starting_index			The optional first index to check for an open slot, defaults
///												to 0
/// @returns {Real}							The next index without a character card, or -1 if all slots
///												are full
function check_for_open_party_slot(starting_index = 0) {
	for(var party_index = starting_index; party_index < array_length(current_party_chara); party_index++) {
		if(current_party_chara[party_index] == noone) {
			return party_index	
		}
	}
	return -1
}

/// @desc									Sets the given card to the position of the given index
/// @param {Id.Instance} chara_card			The chara card to set the position for
/// @param {Real} index_to_replace			The index where the chara card is being inserted
function set_party_chara_card_pos(chara_card, index_to_replace) {
	if(chara_card != noone && is_real(index_to_replace) && index_to_replace >= 0) {
		var background_x_border = PARTY_CARD_BOX_EDGE_DETAILS * image_xscale
		var initial_x_pos = x + background_x_border
		var chara_card_slot_width = (sprite_width - (2 * background_x_border)) / MAX_PARTY_SIZE
		chara_card.x = initial_x_pos + 
							(chara_card_slot_width * index_to_replace) + 
							(chara_card_slot_width - chara_card.sprite_width) / 2
		chara_card.y = y + PARTY_CARD_BOX_TOP_BORDER * image_yscale
		chara_card.chara_card_start_x_position = chara_card.x
		chara_card.chara_card_start_y_position = chara_card.y
	}
}

/// @desc									Removes the given card from the current_party_chara array
///												and places it back in the chara grid
/// @param {Id.Instance} chara_card			The chara card to remove from the party
function remove_from_party(chara_card) {
	var party_index = check_for_chara_card_in_party(chara_card)
	if(party_index != -1) {
		if(instance_exists(obj_chara_card_grid)) {
			obj_chara_card_grid.return_chara_card_to_grid(chara_card)
		}
		current_party_chara[party_index] = noone
	}
}

/// @desc							Alerts the party character card box to begin expanding
function expand_chara_card_box() {
	target_y_scale = starting_y_scale * chara_card_sprite_scale_diff
}

/// @desc							Alerts the party character card box to begin shrinking
function shrink_chara_card_box() {
	target_y_scale = starting_y_scale / chara_card_sprite_scale_diff
}

/// @desc							Handles shrinking or expanding the party character cards and
///										their box each frame
function change_party_box_size() {
	var dist_from_target_scale = image_yscale - target_y_scale
	if(dist_from_target_scale == 0) {
		return
	}
	else if(abs(dist_from_target_scale) < 0.0001) {
		is_expanded_party_box = dist_from_target_scale < 0
		party_box_resize_completed()
	}
	else {
		image_yscale = lerp(image_yscale, target_y_scale, PARTY_BOX_SIZE_CHANGE_SPEED)
		for(var party_index = 0; party_index < array_length(current_party_chara); party_index++) {
			if(current_party_chara[party_index] != noone) {
				current_party_chara[party_index].image_yscale = image_yscale
			}
		}
	}
}

/// @desc							Completes the party character card box changing size by setting
///										the correct sprites and reseting the sprite scaling
function party_box_resize_completed() {
	target_y_scale = starting_y_scale
	image_yscale = starting_y_scale
	sprite_index = spr_shrunk_party_select_slots
		
	var chara_card_sprite = spr_shrunk_chara_card
	if(is_expanded_party_box) {
		sprite_index = spr_expanded_party_select_slots
		chara_card_sprite = spr_expanded_chara_card
	}
		
	for(var party_index = 0; party_index < array_length(current_party_chara); party_index++) {
		if(current_party_chara[party_index] != noone) {
			current_party_chara[party_index].sprite_index = chara_card_sprite
			current_party_chara[party_index].image_yscale = starting_y_scale
		}
	}
}