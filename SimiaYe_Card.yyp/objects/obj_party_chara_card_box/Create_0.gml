#macro MAX_PARTY_SIZE					5
#macro PARTY_CARD_BOX_TOP_BORDER		19
#macro PARTY_CARD_BOX_LEFT_BORDER		10
#macro PARTY_CARD_BOX_EDGE_DETAILS		2

current_party_chara = array_create(MAX_PARTY_SIZE, noone)

/// @desc									Sets the given character card to the slot they were closest
///												to and saves it as one of the party members
/// @param {Id.Instance} chara_card_to_add	The card of the character to add to the player's party
function add_party_memeber(chara_card_to_add) {
	if(typeof(chara_card_to_add) == "ref") {
		var chara_slot_width = sprite_width / MAX_PARTY_SIZE
		var index_to_replace = clamp(floor((chara_card_to_add.x - x) / chara_slot_width), 0, MAX_PARTY_SIZE)
		
		if(current_party_chara[index_to_replace] == chara_card_to_add) {
			return	
		}
		
		var party_index = check_for_chara_card_in_party(chara_card_to_add)
		if(party_index >= 0) {
			current_party_chara[party_index] = current_party_chara[index_to_replace]
			set_party_chara_card_pos(current_party_chara[party_index], party_index)
		}
		
		current_party_chara[index_to_replace] = chara_card_to_add
		set_party_chara_card_pos(chara_card_to_add, index_to_replace)
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

/// @desc									Sets the given card to the position of the given index
/// @param {Id.Instance} chara_card			The chara card to set the position for
/// @param {Real} index_to_replace			The index where the chara card is being inserted
function set_party_chara_card_pos(chara_card, index_to_replace) {
	if(chara_card != noone && is_real(index_to_replace) && index_to_replace >= 0) {
		var background_x_border = PARTY_CARD_BOX_EDGE_DETAILS * image_xscale
		var initial_x_pos = x + background_x_border
		var chara_card_slot_width = (sprite_width - (2 * background_x_border)) / MAX_PARTY_SIZE
		chara_card.x = initial_x_pos + (chara_card_slot_width * index_to_replace) + 
								PARTY_CARD_BOX_LEFT_BORDER * image_xscale
		chara_card.y = y + PARTY_CARD_BOX_TOP_BORDER * image_yscale
		chara_card.chara_card_start_x_position = chara_card.x
		chara_card.chara_card_start_y_position = chara_card.y
	}
}