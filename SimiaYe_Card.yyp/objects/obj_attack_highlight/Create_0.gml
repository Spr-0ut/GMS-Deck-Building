#macro ATTACK_HIGHLIGHT_BACKGROUND_FADE 0.1
#macro ATTACK_HIGHLIGHT_MIN_BACKGROUND_ALPHA 0.01

fade_background_in = true
current_background_alpha = 0
hide_background_entities()

/// @desc								Hides the chara_targeted and the enemy_attacking
function hide_background_entities() {
	for(var chara_index = 0; chara_index < array_length(chara_targeted); chara_index++) {
		chara_targeted[chara_index].visible = false
	}
	enemy_attacking.visible = false
}

/// @desc								Copys the given array into the chara_targeted array,
///											hiding the new values and showing the old ones
/// @param {Array<Instance.Id>} charas	The array of characters to replace chara_targeted
function set_chara_targeted(charas) {
	for(var chara_index = 0; chara_index < array_length(chara_targeted); chara_index++) {
		chara_targeted[chara_index].visible = true
		if(chara_index < array_length(charas)) {
			chara_targeted[chara_index] = charas[chara_index]
			chara_targeted[chara_index].visible = false
		}
	}
	
	if(array_length(chara_targeted) < array_length(charas)) {
		for(var chara_index = array_length(chara_targeted) - 1; chara_index < array_length(charas); chara_index++) {
			chara_targeted[chara_index] = charas[chara_index]
			charas[chara_index].visible = false	
		}
	}
	else {
		array_resize(chara_targeted, array_length(charas))	
	}
}

/// @desc									Sets the enemy_attacking to the given enemy, hiding the
///												enemy and showing the previous enemy
/// @param {Array<Instance.Id>} enemy_id	The enemy to replace the current enemy_attacking
function set_enemy_attacking(enemy_id) {
	enemy_attacking.visible = true
	enemy_id.visible = false
	enemy_attacking = enemy_id
}

/// @desc									Sets the attack_indicators to the given indicators array
/// @param {Array<Instance.Id>} indicators	The indicators to replace attack_indicators
function set_attack_indicators(indicators) {
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		if(indicator_index < array_length(indicators)) {
			attack_indicators[indicator_index] = indicators[indicator_index]
		}
	}
	
	if(array_length(attack_indicators) < array_length(indicators)) {
		for(var indicator_index = array_length(attack_indicators) - 1; indicator_index < array_length(indicators); indicator_index++) {
			attack_indicators[indicator_index] = indicators[indicator_index]
		}
	}
	else {
		array_resize(attack_indicators, array_length(indicators))	
	}
}

/// @desc								Starts the process to fade out the attack highlight,
///											eventually deleting it
function remove_attack_highlight() {
	fade_background_in = false
}

/// @desc								Starts to process to fade the attack highlight in
function add_attack_highlight() {
	fade_background_in = true
}

/// @desc								Handles either fading in or fading out the background based
///											on fade_background_in, destroying this layer's instances
///											if it reaches the minimum opacity
function fade_background() {
	if(fade_background_in) {
		current_background_alpha = lerp(current_background_alpha, BACKGROUND_ALPHA, ATTACK_HIGHLIGHT_BACKGROUND_FADE)
	}
	else {
		current_background_alpha = lerp(current_background_alpha, 0, ATTACK_HIGHLIGHT_BACKGROUND_FADE)
		if(current_background_alpha < ATTACK_HIGHLIGHT_MIN_BACKGROUND_ALPHA) {
			for(var chara_index = 0; chara_index < array_length(chara_targeted); chara_index++) {
				chara_targeted[chara_index].visible = true
			}
			enemy_attacking.visible = true
			layer_destroy_instances(layer)
		}
	}
}

/// @desc									Draws a rectangle over the whole camera to dim the game
///												NOTE: this must be called in the Draw event or it won't
///												work correctly
function draw_target_selection_background() {
	draw_set_colour(c_black)
	draw_set_alpha(current_background_alpha)
	var screen_width = room_width
	var screen_height = room_height
	draw_rectangle(0, 0, screen_width, screen_height, false)
	draw_set_alpha(1)
}

/// @desc									Runs each of the chara_targeted's draw and draw GUI events
function draw_charas() {
	for(var chara_index = 0; chara_index < array_length(chara_targeted); chara_index++) {
		if(chara_targeted[chara_index] != enemy_attacking) {
			with(chara_targeted[chara_index]) {
				event_perform(ev_draw, ev_draw_normal)
				event_perform(ev_draw, ev_gui)
			}
		}
	}
}

/// @desc									Draws each of the attack_indicators' intentions for
///												the enemy_attacking
function draw_attack_indicators() {
	for(var indicator_index = 0; indicator_index < array_length(attack_indicators); indicator_index++) {
		attack_indicators[indicator_index].draw_attacks_intentions(enemy_attacking)
	}
}

/// @desc									Runs the enemy_attacking's draw and draw GUI events
function draw_enemy_attacking() {
	with(enemy_attacking) {
		event_perform(ev_draw, ev_draw_normal)
		event_perform(ev_draw, ev_gui)
	}
}