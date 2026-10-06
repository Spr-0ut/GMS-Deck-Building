// Inherit the parent event
event_inherited();

card_description = "Deal 0.2 dmg times the amount of the character's shield"
/// @desc											A selected chara deal damage based on how much
///														shield they have
/// @param {struct_card_action} card_action_struct	The struct that contains all card actions
card_action = function (card_action_struct) {
	card_action_struct.deal_dmg_to_enemies_equal_to_shield(0.2)
	card_action_struct.end_card_action()
}