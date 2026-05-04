#macro ATTACK_INDICATOR_TEXT_COLOR c_orange
#macro ATTACK_INDICATOR_TEXT_FONT fnt_attack_indicator

attacks_to_display = []
display_attack_intentions = true

/// @desc										Removes any attack the given enemy was already preparing
///													and adds the given attack to display
/// @param {Id.Instance} enemy_id 				The enemy preparing this attack
/// @param {attack_data_struct} enemy_attack 	The struct containing the required data for this attack
function add_attack(enemy_id, enemy_attack) {
	remove_attack(enemy_id)
	array_push(attacks_to_display, { enemy_id, attack : enemy_attack })
}

/// @desc										Removes the given enemy's attack so it's no longer shown
/// @param {Id.Instance} enemy_id 				The enemy whos attack is being removed
function remove_attack(enemy_id) {
	for(var attack_index = array_length(attacks_to_display) - 1; attack_index >= 0; attack_index--) {
		if(attacks_to_display[attack_index].enemy_id == enemy_id) {
			array_delete(attacks_to_display, attack_index, 1)
		}
	}
}

/// @desc										Executes the prepared attacks from the enemy so long as
///													the enemy and chara are alive and able to attack
function attack_target_character() {
	if(chara_targeted != noone && chara_targeted.player_current_health > 0 && display_attack_intentions) {
		for(var attack_index = 0; attack_index < array_length(attacks_to_display); attack_index++) {
			if(attacks_to_display[attack_index].enemy_id.Is_alive) {
				chara_targeted.hit_by_enemy(attacks_to_display[attack_index].attack)
			}
		}
	}
}

/// @desc										Hides the attack indicators from the player.
///													NOTE: The attacks still remain in this indicator
///													so if the attack intents are shown again the
///													existing attacks will be shown again
function hide_attack_intents() {
	display_attack_intentions = false
}

/// @desc										Removes the attack to be displayed and sets 
///													any furture attacks added to be visible
function clear_attacks() {
	attacks_to_display = []
	display_attack_intentions = true
}

/// @desc										Draws each attack intention, with each one above the
///													previous one
function draw_attacks_intentions() {
	var intent_y_pos = y
	for(var attack_index = 0; attack_index < array_length(attacks_to_display); attack_index++) {
		if(attacks_to_display[attack_index].attack.damage > 0) {
			draw_set_halign(fa_center)
			draw_set_valign(fa_bottom)
			draw_set_colour(ATTACK_INDICATOR_TEXT_COLOR)
			draw_set_font(ATTACK_INDICATOR_TEXT_FONT)
			draw_text(x, intent_y_pos, attacks_to_display[attack_index].attack.damage)
			intent_y_pos -= string_height(attacks_to_display[attack_index].attack.damage) + ATTACK_INDICATOR_PADDING
		}
	}	
}