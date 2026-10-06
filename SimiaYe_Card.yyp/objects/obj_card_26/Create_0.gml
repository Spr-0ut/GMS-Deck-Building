// Inherit the parent event
event_inherited();

card_description = "Deal 1 damage and discard 1 card for each dmg character the on team"
num_damage_chara_on_team = 0
find_num_damage_chara()
num_cards_to_select = num_damage_chara_on_team

/// @desc											Each selected character deals 1 damage and 
///														discards a selected cards
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.charas_attack_enemies(num_damage_chara_on_team)
	card_action_struct.discard_selected_cards()
	card_action_struct.end_card_action()
}

/// @desc							Finds the number of damage characters currently on the team
function find_num_damage_chara() {
	var num_avaliable_charas = instance_number(obj_player)
	var allowed_attackers = array_create(0)
	for(var chara_index = 0; chara_index < num_avaliable_charas; chara_index++) {
		var chara_instance = instance_find(obj_player, chara_index)
		if(chara_instance.class == chara_class.damage) {
			num_damage_chara_on_team++;	
		}
	}	
}