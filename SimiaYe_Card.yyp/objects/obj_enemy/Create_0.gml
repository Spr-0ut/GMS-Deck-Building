#macro ENEMY_CHASE_SPEED	WALK_SPEED * 1.5
#macro SECONDS_ENEMY_SEARCHS_FOR_PLAYER		2
#macro ENEMY_LOSES_PLAYER_SPRITE			spr_enemy_loses_player_symbol
#macro ENEMY_LOSES_PLAYER_SYMBOL_PADDING	5

active_debuffs = {}
active_buffs = {}
display_next_damage_text = true
damage_to_display = []
next_attack_index = 0
check_for_dist_to_target = false
enemy_start_x = x
enemy_start_y = y
enemy_returning_to_start = true
display_enemy_loses_player_symbol = false
collidable_items = find_room_collision_items(room)
enemy_path = path_add()

#region Implement in each enemy type

attack_options = [{attack : method(self, basic_attack), attack_parameters : [], targeting_type : enemy_attack_target.first_closest_chara}]

/// @desc							Assesses the current state of the fight and determines if an
///										attack should be added or not
check_for_conditional_attack = function() {
	// Only add an implement if the enemy can change or add an attack immediately before declaring it
}

/// @desc							This is a basic example of an enemy's attack. It is expected that there
///										will be multiple attack functions implemented in each enemy type
/// @returns {attack_data_struct}	The return value of attack functions must be an attack_data_struct
function basic_attack() {
	return new attack_data_struct(irandom(10) + 1)
}

#endregion

/// @desc							Alerts this enemy to begin tracking the player position to attack them
function activate_player_tracking() {
	check_for_dist_to_target = true
}

/// @desc							Checks if this enemy has summon sickness from just being summoned
///										and adds a temporary attack that clears the summon sickness
function check_for_summon_sickness() {
	if(has_summon_sickness) {
		array_insert(attack_options, next_attack_index + 1, 
		{
			attack : method(self, summon_sickness_attack),
			attack_parameters : [],
			targeting_type : enemy_attack_target.self_target,
			is_temporary_attack : true
		})
	}
}

/// @desc						Clears the enemy's summon sickness
function summon_sickness_attack() {
	has_summon_sickness = false
	return new attack_data_struct(-1, [], [], false, [], true)
}

/// @desc										Handles player attacks by applying debuffs and removing
///													attack_data.damage from their health
/// @param {Id.Instance} attacking_chara		The character attacking this enemy			
/// @param {stuct} attack_data					The struct containting the "damage", "debuffs", and buffs
///													from the character's attack
function hit_by_player(attacking_chara, attack_data) {
	if(struct_exists(attack_data, "damage") && attack_data.damage > -1) {
		take_damage(attack_data.damage)
		array_push(damage_to_display, [attack_data.damage, c_white])
		
		if(struct_exists(active_debuffs, card_debuff_effects.Mark) &&
			active_debuffs[$ card_debuff_effects.Mark] > 0) {
				attacking_chara.add_shield(1)
		}
	}
	
	if(struct_exists(attack_data, "debuffs")) {
		for(var attack_debuff_index = 0; attack_debuff_index < array_length(attack_data.debuffs); attack_debuff_index++) {
			var debuff_type = attack_data.debuffs[attack_debuff_index][0]
			var debuff_amount = attack_data.debuffs[attack_debuff_index][1]
			apply_debuff_to_enemy(debuff_type, debuff_amount)
		}
	}
	
	if(struct_exists(attack_data, "buffs")) {
		for(var attack_buff_index = 0; attack_buff_index < array_length(attack_data.buffs); attack_buff_index++) {
			var buff_type = attack_data.buffs[attack_buff_index][0]
			var buff_amount = attack_data.buffs[attack_buff_index][1]
			apply_buff_to_enemy(buff_type, buff_amount)
		}
	}
}

/// @desc										Debuffs this enemy through the debuff_handler and adds it
///													to the damage_to_display
/// @param {card_debuff_effects} debuff_type	The debuff being applied to this enemy
/// @param {Real} debuff_amount					The amount of the debuff being added
function apply_debuff_to_enemy(debuff_type, debuff_amount) {
	var debuff_damage = apply_debuff(active_debuffs, debuff_type, debuff_amount)
	if(array_length(debuff_damage) == 2) {
		array_push(damage_to_display, debuff_damage)
	}
}

/// @desc										Applies, or adds to, a buff for this character and
///													displays it
/// @param {card_debuff_effects} debuff_type	The buff being applied to this enemy
/// @param {Real} debuff_amount					The amount of the buff being added
function apply_buff_to_enemy(buff_type, buff_amount) {
	var buff_damage = apply_buff(active_buffs, buff_type, buff_amount)
	if(array_length(buff_damage) == 2) {
		array_push(damage_to_display, buff_damage)
	}
}

/// @desc							Determines if the previous attack was a temporary attack,
///										and if so it removes the attack from attack_options
function remove_temporary_attack() {
	if(next_attack_index >= 0 &&
			next_attack_index < array_length(attack_options) &&
			struct_exists(attack_options[next_attack_index], "is_temporary_attack") &&
			attack_options[next_attack_index].is_temporary_attack) {
		array_delete(attack_options, next_attack_index, 1)
		next_attack_index--
	}
}

/// @desc							Determines the current attack and sets the it as the
///										attack intent for this enemy
function select_next_attack() {
	if(next_attack_index >= array_length(attack_options) || next_attack_index < 0) {
		next_attack_index = 0
	}
	
	if(instance_exists(obj_enemy_attack_manager)) {
		var enemy_attack_data = get_next_attack()
		var enemy_attack = method_call(enemy_attack_data.attack, enemy_attack_data.attack_parameters)
		obj_enemy_attack_manager.add_enemy_intent(id, enemy_attack, enemy_attack_data.targeting_type)
	}
}

/// @desc							Finds this enemy's next attack based on next_attack_index
///										NOTE: This function does NOT handle incrementing next_attack_index
/// @returns {Struct}				A struct with the attack function and targeting_type for the enemy's
///										next attack
function get_next_attack() {
	if(array_length(attack_options) < 1 || next_attack_index >= array_length(attack_options)) {
		return noone	
	}
	
	var attack_option = attack_options[next_attack_index]
	if(attack_option.attack == noone || !is_method(attack_option.attack) || 
			attack_option.targeting_type < 0) {
		array_delete(attack_options, next_attack_index, 1)
		attack_option = get_next_attack()
	}
	
	return attack_option
}

/// @desc							Formats a number by removing any trailing 0s or decimals
/// @param {Real} num_to_format		The number to be returned after formatting
/// @returns						A string representation of the given number with trailing 0s and if
///										if needed decimal point removed
function format_display_number(num_to_format) {
	var num_string = string(num_to_format)
	var decimal_pos = string_pos(num_string, ".")
	if(decimal_pos == 0) {
		return num_string
	}
	
	for(var char_index = string_length(num_string); char_index > decimal_pos - 1; char_index--) {
		if(string_ends_with(num_string, "0")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
		}
		else if (string_ends_with(num_string, ".")) {
			num_string = string_delete(num_string, string_length(num_string), 1)
			break;
		}
		else {
			break;	
		}
	}
	if(string_length(num_string) == 0) {
		num_string = "0"
	}
	return num_string
}

/// @desc							Loops through the debuffs currently active on this enemy and
///										applys the damage
function trigger_end_of_turn_debuffs() {
	struct_foreach(active_debuffs, function (debuff_name, debuff_amount) {
		var debuff_data = get_debuff_damage(active_debuffs, debuff_name)
		if(array_length(debuff_data) == 2) {
			array_push(damage_to_display, debuff_data)
			take_damage(debuff_data[0])
		}
	})
}

/// @desc							Removes health from this enemy and checks if they die
/// @param {Real} health_damage		The amount of health to remove from this enemy
function take_damage(health_damage) {
	Health -= health_damage
	if(Health <= 0 && Is_alive) {
		Is_alive = false
		show_debug_message("This enemy is dead")
		if(instance_exists(obj_enemy_attack_manager)) {
			obj_enemy_attack_manager.remove_enemy_intent(id)
		}
	}
}

/// @desc									Finds how far this enemy is away from the target_to_chase
///												and determines its next action based on that distance
/// @param {Id.Instance} target_to_chase	The target instance to determine the distance from
function determine_enemy_chase_action(target_to_chase) {
	var center_of_enemy_x = bbox_left + (bbox_right - bbox_left) / 2
	var center_of_enemy_y = bbox_top + (bbox_bottom - bbox_top) / 2
	var center_of_target_x = target_to_chase.bbox_left + (target_to_chase.bbox_right - target_to_chase.bbox_left) / 2
	var center_of_target_y = target_to_chase.bbox_top + (target_to_chase.bbox_bottom -  target_to_chase.bbox_top) / 2
	var dist_to_target_sqr = sqr(center_of_target_x - center_of_enemy_x) + sqr(center_of_target_y - center_of_enemy_y)
	
	if(place_meeting(x, y, target_to_chase)) {
		display_enemy_loses_player_symbol = false
		swap_to_arena()
	}
	else if(dist_to_target_sqr < sqr(dist_to_chase_target)) {
		display_enemy_loses_player_symbol = false
		find_enemy_path(target_to_chase, center_of_enemy_x, center_of_enemy_y, center_of_target_x, center_of_target_y)
	}
	else {
		check_for_dist_to_target = false
	}
}

/// @desc									Swaps the player into the Arena room to begin a fight
function swap_to_arena() {
	global.room_is_arena = true
	room_goto(Arena)
}

/// @desc									Finds whether this enemy will chase the given target or return
///												to it's original position
/// @param {Id.Instance} target_to_chase	The target this enemy will path towards
/// @param {Real} center_of_enemy_x			The x position of the center of this enemy's bounding box
/// @param {Real} center_of_enemy_y			The y position of the center of this enemy's bounding box
/// @param {Real} center_of_target_x		The x position of the center of the target's bounding box
/// @param {Real} center_of_target_y		The y position of the center of the target's bounding box
function find_enemy_path(target_to_chase, center_of_enemy_x, center_of_enemy_y, center_of_target_x, center_of_target_y) {
	if(check_target_can_be_seen(target_to_chase)) {
		path_enemy_to_target(center_of_enemy_x, center_of_enemy_y, center_of_target_x, center_of_target_y)
	}
}

/// @desc									Determines if the top or bottom of this enemy is able to see
///												the top or the bottom of the given target's bounding box
/// @param {Id.Instance} target_to_chase	The instance this enemy is attempting to see
/// @returns {Bool}							A flag for if the enemy can see the given character
function check_target_can_be_seen(target_to_chase) {
	var top_left_visible = collision_line(bbox_left, bbox_top, target_to_chase.bbox_left,  target_to_chase.bbox_top, collidable_items, false, true) == noone
	var top_right_visible = collision_line(bbox_right, bbox_top, target_to_chase.bbox_right,  target_to_chase.bbox_top, collidable_items, false, true) == noone
	var bottom_left_visible = collision_line(bbox_left, bbox_bottom, target_to_chase.bbox_left, target_to_chase.bbox_bottom, collidable_items, false, true) == noone
	var bottom_right_visible = collision_line(bbox_right, bbox_bottom, target_to_chase.bbox_right, target_to_chase.bbox_bottom, collidable_items, false, true) == noone

	return top_left_visible || top_right_visible || bottom_left_visible || bottom_right_visible
}

/// @desc									Attempts to find an enemy_path from the center of the enemy
///												the the center of the target on global.pathing_grid
/// @param {Real} center_of_enemy_x			The x position of the center of this enemy's bounding box
/// @param {Real} center_of_enemy_y			The y position of the center of this enemy's bounding box
/// @param {Real} center_of_target_x		The x position of the center of the target's bounding box
/// @param {Real} center_of_target_y		The y position of the center of the target's bounding box
function path_enemy_to_target(center_of_enemy_x, center_of_enemy_y, center_of_target_x, center_of_target_y) {
	if(mp_grid_path(global.pathing_grid, enemy_path, center_of_enemy_x, center_of_enemy_y, center_of_target_x, center_of_target_y, true)) {
		enemy_returning_to_start = false
		path_start(enemy_path, ENEMY_CHASE_SPEED, path_action_stop, false)
	}	
}

/// @desc									Attempts to find an enemy_path from the enemy's current
///												position to the enemy_start_ position
function path_enemy_to_start() {
	if(!enemy_returning_to_start &&
		mp_grid_path(global.pathing_grid, enemy_path, x, y, enemy_start_x, enemy_start_y, true)) {
			enemy_returning_to_start = true
			path_start(enemy_path, ENEMY_CHASE_SPEED, path_action_stop, false)
	}
}