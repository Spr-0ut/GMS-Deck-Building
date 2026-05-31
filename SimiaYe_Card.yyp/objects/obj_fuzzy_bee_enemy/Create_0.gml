// Inherit the parent event
event_inherited();

attack_charged = false
check_for_bee_summon = true

attack_options = [
	{
		attack : method(self, stinger_attack),
		attack_parameters : [],
		targeting_type : enemy_attack_target.random_chara
	},
	{
		attack : method(self, stinger_attack),
		attack_parameters : [],
		targeting_type : enemy_attack_target.all_chara
	},
	{
		attack : method(self, charge_up_attack),
		attack_parameters : [],
		targeting_type : enemy_attack_target.self
	},
	{
		attack : method(self, charge_up_attack),
		attack_parameters : [],
		targeting_type : enemy_attack_target.random_chara
	},
	{
		attack : method(self, eat_honey),
		attack_parameters : [],
		targeting_type : enemy_attack_target.self
	}]

/// @desc						Determines if a bee can be spawned and if so randomly selects one
///									of the alive bees that didnt summon one last turn to spawn it
check_for_conditional_attack = function() {
	if(!variable_global_exists("check_for_bee_summon") || global.check_for_bee_summon) {
		global.check_for_bee_summon = false
		if(instance_number(obj_fuzzy_bee_enemy) < 5) {
			var alive_bees = []
			for(var bee_index = 0; bee_index < instance_number(obj_fuzzy_bee_enemy); bee_index++) {
				var current_bee = instance_find(obj_fuzzy_bee_enemy, bee_index)
				var latest_attack_method = method_get_index(current_bee.attack_options[current_bee.next_attack_index].attack)
				if(current_bee.Is_alive && latest_attack_method != summon_fuzzy_bee) {
					array_push(alive_bees, current_bee)
				}
			}
			
			var bee_to_summon_bee = alive_bees[irandom(array_length(alive_bees) - 1)]
			with (bee_to_summon_bee) {
				array_insert(attack_options, next_attack_index + 1, 
				{
					attack : method(self, summon_fuzzy_bee),
					attack_parameters : [],
					targeting_type : enemy_attack_target.summon_enemy,
					is_temporary_attack : true
				})
			}
		}
		else {
			global.check_for_bee_summon = true
		}
	}
}

/// @desc						A weak attack that deals small amount of damage while poisoning
///									and applying weakness
function stinger_attack() {
	return new attack_data_struct(2, [[card_debuff_effects.Poison, 1], [card_debuff_effects.Weakness, 1]])
}

/// @desc						A large attack that takes a turn to charge up
function charge_up_attack() {
	if(!attack_charged) {
		attack_charged = true
		return new attack_data_struct(-1, [], [], true)
	}
	else {
		attack_charged = false
		return new attack_data_struct(3)
	}
}

/// @desc						Gains strength by consuming honey
function eat_honey() {
	return new attack_data_struct(-1, [], [[card_buff_effects.Strength, 2]])
}

/// @desc						Summons a single fuzzy bee enemy and allows a bee to be
///									summoned next turn
function summon_fuzzy_bee() {
	global.check_for_bee_summon = true
	return new attack_data_struct(-1, [], [], false, [obj_fuzzy_bee_enemy])
}