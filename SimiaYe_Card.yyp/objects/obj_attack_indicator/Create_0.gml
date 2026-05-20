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

/// @desc										Finds the index of the attack from the given enemy
/// @param {Id.Instance} enemy_id				The enemy whos attack is being searched for
/// @returns {Real}								The index of the enemy's attack or undefined if no
///													attack is found
function find_enemy_attack(enemy_id) {
	for(var attack_index = array_length(attacks_to_display) - 1; attack_index >= 0; attack_index--) {
		if(attacks_to_display[attack_index].enemy_id == enemy_id) {
			return attack_index
		}
	}
	return undefined
}

/// @desc										Executes the prepared attacks so long as the entity
///													preparing the attack and the one being attacked
///													are alive and able to act
function attack_target_character() {
	if(target != noone  && display_attack_intentions) {
		for(var attack_index = 0; attack_index < array_length(attacks_to_display); attack_index++) {
			if(object_is_ancestor(target.object_index, obj_player)) {
				if(target.player_current_health > 0 &&
						attacks_to_display[attack_index].enemy_id.Is_alive) {
					target.hit_by_enemy(attacks_to_display[attack_index].attack)
				}
			}
			else if(object_is_ancestor(target.object_index, obj_enemy)) {
				if(attacks_to_display[attack_index].enemy_id.Is_alive) {
					target.hit_by_player(attacks_to_display[attack_index].enemy_id, attacks_to_display[attack_index].attack)
				}
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

/// @desc									Checks to see if the mouse is hovering over the text drawn
///												by this indicator, and tells obj_enemy_attack_manager
///												to highlight the attack
function check_for_mouse_hover() {
	var text_height = (string_height(attacks_to_display[0].attack.damage) + ATTACK_INDICATOR_PADDING)
	var mouse_within_indicator_x = mouse_x >= x && mouse_x < x + target_sprite_width
	var mouse_within_indicator_y = mouse_y < y && mouse_y > y - (text_height * array_length(attacks_to_display))
	
	if(mouse_within_indicator_x && mouse_within_indicator_y) {
		for(var attack_index = 0; attack_index < array_length(attacks_to_display); attack_index++) {
			var attack_text_bottom = y - (text_height * attack_index)
			var attack_text_top = attack_text_bottom - text_height
			if(mouse_y <= attack_text_bottom && mouse_y > attack_text_top) {
				obj_enemy_attack_manager.highlight_attack(attacks_to_display[attack_index].enemy_id)
				break
			}
		}
	}
}

/// @desc										Draws each attack intention vertically, with each
///													attack's damage and debuffs displayed in line
/// @param {Id.Instance} enemy_id				An optional ID to specify which enemy's attack should
///													be drawn, ignoring the other ones. If no ID is
///													given all of the attacks will be drawn
function draw_attacks_intentions(enemy_id = noone) {
	draw_set_halign(fa_right)
	draw_set_valign(fa_bottom)
	draw_set_font(ATTACK_INDICATOR_TEXT_FONT)
	
	var intent_y_pos = y
	for(var attack_index = 0; attack_index < array_length(attacks_to_display); attack_index++) {
		var attack_data = attacks_to_display[attack_index].attack
		if(enemy_id == noone || attacks_to_display[attack_index].enemy_id == enemy_id) {
			var x_pos_increment = target_sprite_width / 
						(array_length(attack_data.debuffs) +
						 array_length(attack_data.buffs) +
						(attack_data.damage >= 0) +
						(attack_data.charging_up_attack) + 1)
			intent_x_pos = x + x_pos_increment
		
			draw_damage(attack_data.damage, intent_y_pos, x_pos_increment)
			draw_debuffs(attack_data.debuffs, intent_y_pos, x_pos_increment)
			draw_buffs(attack_data.buffs, intent_y_pos, x_pos_increment)
			draw_attack_charge(attack_data.charging_up_attack, intent_y_pos, x_pos_increment)
		}
		
		intent_y_pos -= string_height(attack_data.damage) + ATTACK_INDICATOR_PADDING
	}	
}

/// @desc								Draws all the damage being applied at intent_x_pos
///											and adds the x_pos_increment to intent_x_pos
/// @param {Real} damage_to_draw 		Amount of damage to draw
/// @param {Real} y_pos 				The y position to draw the damage
/// @param {Real} x_pos_increment 		The amount to adjust intent_x_pos after drawing damage
function draw_damage(damage_to_draw, y_pos, x_pos_increment) {
	if(damage_to_draw > -1) {
		draw_set_colour(ATTACK_INDICATOR_TEXT_COLOR)
		draw_text(intent_x_pos, y_pos, damage_to_draw)
		intent_x_pos += x_pos_increment
	}
}

/// @desc									Draws all the given debuffs in line, starting at
///												intent_x_pos and moving to the right by 
///												x_pos_increment for each debuff
/// @param {Array<Array>} debuffs_to_draw 	All of the debuffs and amount of debuff to be drawn
/// @param {Real} y_pos 					The y position to draw the debuff
/// @param {Real} x_pos_increment 			The amount to adjust intent_x_pos after drawing debuff
function draw_debuffs(debuffs_to_draw, y_pos, x_pos_increment) {
	for(var debuff_index = 0; debuff_index < array_length(debuffs_to_draw); debuff_index++) {
		draw_set_colour(get_debuff_color(debuffs_to_draw[debuff_index][0]))
		
		var debuff_x_pos = intent_x_pos + (string_width(debuffs_to_draw[debuff_index][1]) * 
							(debuff_index + 2) / (array_length(debuffs_to_draw) + 2))
		draw_text(debuff_x_pos, y_pos, debuffs_to_draw[debuff_index][1])
		intent_x_pos += x_pos_increment
	}
}

/// @desc									Draws all the given buffs in line, starting at
///												intent_x_pos and moving to the right by 
///												x_pos_increment for each debuff
/// @param {Array<Array>} buffs_to_draw 	All of the buffs and amount of buff to be drawn
/// @param {Id.Instance} y_pos 				The y position to draw the buff
/// @param {Id.Instance} x_pos_increment 	The amount to adjust intent_x_pos after drawing buff
function draw_buffs(buffs_to_draw, y_pos, x_pos_increment) {
	for(var buff_index = 0; buff_index < array_length(buffs_to_draw); buff_index++) {
		draw_set_colour(get_buff_color(buffs_to_draw[buff_index][0]))
			
		var buff_x_pos = intent_x_pos + (string_width(buffs_to_draw[buff_index][1]) * 
							(buff_index + 2) / (array_length(buffs_to_draw) + 2))
		draw_text(buff_x_pos, y_pos, buffs_to_draw[buff_index][1])
		intent_x_pos += x_pos_increment
	}
}

/// @desc								Draws the charging attack symbol at the given position
/// @param {Bool} is_charging_attack 	Flag determining if the charging symbol should be drawn
/// @param {Real} y_pos 				The y position to draw the charging attack symbol
/// @param {Real} x_pos_increment 		The amount to adjust intent_x_pos after drawing the symbol
function draw_attack_charge(is_charging_attack, y_pos, x_pos_increment) {
	if(is_charging_attack) {
		draw_sprite(spr_charge_attack_symbol, 0, intent_x_pos, y_pos)
		intent_x_pos += x_pos_increment
	}
}