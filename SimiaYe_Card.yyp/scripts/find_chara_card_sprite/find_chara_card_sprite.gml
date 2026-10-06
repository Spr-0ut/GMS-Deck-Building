/// @desc								Find the character card sprite for a given class, returning
///											either the expanded or shrunk version of the card
/// @param {enum.chara_class} class		The character class used to find the chara card sprite for
/// @param {bool} is_expanded_card		Flag to determines if the expanded character card or shrunk
///											character sprite is returned
/// @returns {Asset.GMSprite}			Either the expanded or shrunk character card sprite for the
///											given class
function find_chara_card_sprite(class, is_expanded_card){
	if(!is_int64(class) || class < 0) {
		return is_expanded_card ?
						spr_expanded_damage_chara_card :
						spr_shrunk_damage_chara_card
	}
	switch (class) {
		case chara_class.all_chara:
			return is_expanded_card ?
						spr_expanded_damage_chara_card :
						spr_shrunk_damage_chara_card
			
		case chara_class.science:
			return is_expanded_card ?
						spr_expanded_science_chara_card :
						spr_shrunk_science_chara_card
			
		case chara_class.damage:
			return is_expanded_card ?
						spr_expanded_damage_chara_card :
						spr_shrunk_damage_chara_card
			
		case chara_class.mech:
			return is_expanded_card ?
						spr_expanded_mech_chara_card :
						spr_shrunk_mech_chara_card
			
		case chara_class.potion:
			return is_expanded_card ?
						spr_expanded_potion_chara_card :
						spr_shrunk_potion_chara_card
			
		case chara_class.tank:
			return is_expanded_card ?
						spr_expanded_tank_chara_card :
						spr_shrunk_tank_chara_card
			
		default:
			return is_expanded_card ?
						spr_expanded_damage_chara_card :
						spr_shrunk_damage_chara_card
	}
}