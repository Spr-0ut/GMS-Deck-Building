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
function add_party_memeber(chara_card_to_add, index_to_replace = -1) {
	if(typeof(chara_card_to_add) == "ref") {
		if(typeof(index_to_replace) != "number" || index_to_replace < 0 || index_to_replace >= MAX_PARTY_SIZE) {
			var chara_slot_width = sprite_width / MAX_PARTY_SIZE
			index_to_replace = floor((chara_card_to_add.x - x + (chara_card_to_add.sprite_width / 2)) / 
										chara_slot_width)
		}
		
		if(index_to_replace < 0 || index_to_replace >= MAX_PARTY_SIZE) {
			remove_from_party(chara_card_to_add)
		}
		else if(current_party_chara[index_to_replace] != chara_card_to_add) {
			chara_card_to_add.set_chara_card_size(is_expanded_party_box)
			chara_card_to_add.flexpanels.set_draw_to_surface(false)
			chara_card_to_add.visible = true
			
			shift_party_chara_cards(chara_card_to_add, index_to_replace)
			current_party_chara[index_to_replace] = chara_card_to_add
			set_party_chara_card_pos(chara_card_to_add, index_to_replace)
		
			if(instance_exists(obj_chara_card_grid)) {
				obj_chara_card_grid.empty_card_slot(chara_card_to_add)	
			}
		
			update_follower_order()
		}
	}
}

/// @desc							Alerts the obj_follower_order_manager that the party has changed
///										to ensure the changes are used outside of the chara select
function update_follower_order() {
	if(instance_exists(obj_follower_order_manager)) {
		var new_chara_order = []
		for(var chara_index = 0; chara_index < array_length(current_party_chara); chara_index++) {
			if(current_party_chara[chara_index] != noone) {
				var current_chara_data = current_party_chara[chara_index].chara_card_data
				current_chara_data.is_controlled_chara = false
				array_push(new_chara_order, current_chara_data)
			}
		}
		if(array_length(new_chara_order) > 0) {
			new_chara_order[0].is_controlled_chara = true
		}
		obj_follower_order_manager.update_chara_order(new_chara_order)
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
		update_follower_order()
	}
}

/// @desc							Finds if there was a party previously created and if so sets
///										their cards in the correct order in the party box
function find_current_party() {
	if(instance_exists(obj_follower_order_manager)) {
		var charas_ordered = obj_follower_order_manager.chara_order
		if(array_length(charas_ordered) > 0 && instance_exists(obj_chara_card_grid)) {
			var party_chara_cards = obj_chara_card_grid.find_chara_cards_by_chara_id(charas_ordered)
			var max_index = min(array_length(party_chara_cards), MAX_PARTY_SIZE)
			for(var chara_card_index = 0; chara_card_index < max_index; chara_card_index++) {
				if(party_chara_cards[chara_card_index] != noone) {
					add_party_memeber(party_chara_cards[chara_card_index], chara_card_index)
				}
			}
		}
	}	
}

/// @desc							Alerts the party character card box to begin expanding
function expand_chara_card_box() {
	target_y_scale = starting_y_scale * chara_card_sprite_scale_diff
	
	for(var party_index = 0; party_index < array_length(current_party_chara); party_index++) {
		var chara_card = current_party_chara[party_index]
		if(chara_card != noone) {
			chara_card.change_chara_card_size(true, chara_card.x, chara_card.y)
		}
	}
}

/// @desc							Alerts the party character card box to begin shrinking
function shrink_chara_card_box() {
	target_y_scale = starting_y_scale / chara_card_sprite_scale_diff
	
	for(var party_index = 0; party_index < array_length(current_party_chara); party_index++) {
		var chara_card = current_party_chara[party_index]
		if(chara_card != noone) {
			chara_card.change_chara_card_size(false, chara_card.x, chara_card.y)
		}
	}
}

/// @desc							Handles shrinking or expanding the party box each frame
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
	}
}

/// @desc							Completes the party character card box changing size by setting
///										the correct sprite and reseting the sprite scaling
function party_box_resize_completed() {
	target_y_scale = starting_y_scale
	image_yscale = starting_y_scale
	sprite_index = spr_shrunk_party_select_slots
	if(is_expanded_party_box) {
		sprite_index = spr_expanded_party_select_slots
	}
}