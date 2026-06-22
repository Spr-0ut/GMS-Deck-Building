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
		current_party_chara[index_to_replace] = chara_card_to_add
	
		var background_x_border = PARTY_CARD_BOX_EDGE_DETAILS * image_xscale
		var initial_x_pos = x + background_x_border
		var chara_card_slot_width = (sprite_width - (2 * background_x_border)) / MAX_PARTY_SIZE
		chara_card_to_add.x = initial_x_pos + (chara_card_slot_width * index_to_replace) + 
								PARTY_CARD_BOX_LEFT_BORDER * image_xscale
		chara_card_to_add.y = y + PARTY_CARD_BOX_TOP_BORDER * image_yscale
		chara_card_to_add.chara_card_start_x_position = chara_card_to_add.x
		chara_card_to_add.chara_card_start_y_position = chara_card_to_add.y
	}
}