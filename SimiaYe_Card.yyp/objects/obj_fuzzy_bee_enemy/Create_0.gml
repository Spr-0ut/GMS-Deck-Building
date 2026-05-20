// Inherit the parent event
event_inherited();

attack_charged = false

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