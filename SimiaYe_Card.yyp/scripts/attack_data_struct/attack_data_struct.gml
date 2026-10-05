/// @desc											The struct containing the data required to hit an
///														enemy or player
/// @param {Real} _damage							Optional parameter containing the initial flat
///														damage the target will take
/// @param {Array<Array<card_debuff_effects, Real>>} _debuffs	Optional parameter containing the 
///																	initial debuffs to be applied
///																	to the target
/// @param {Array<Array<card_debuff_effects, Real>>} _buffs		Optional parameter containing the 
///																	initial buffs to be applied
///																	to the target
/// @param {Bool} _charging_up_attack				Optional flag to determine if this attack is
///														charging up for a stronger attack later
/// @param {Array<Asset.GMObject>} _enemies_to_spawn			Optional parameter containing the
///																	enemies that will spawn from
///																	this attack
function attack_data_struct(_damage = -1, _debuffs = [], _buffs = [], _charging_up_attack = false,
							_enemies_to_spawn = [], _has_summon_sickness = false) constructor{
	damage = max(_damage, -1)
	debuffs = _debuffs
	buffs = _buffs
	charging_up_attack = _charging_up_attack
	enemies_to_spawn = _enemies_to_spawn
	has_summon_sickness = _has_summon_sickness
	
	#region damage
		/// @desc						Sets the damage to the given value
		/// @param {Real} new_damage	The new value for damage. NOTE: If this value is less than -1
		///									it will default to -1, and not be displayed
		static set_damage = function(new_damage) {
			damage = max(new_damage, -1)
		}
	
		/// @desc							Adds the given value to the current damage
		/// @param {Real} damage_to_add		The value to add to this attack's damage. NOTE: If this
		///										value is less than 0 it will default to 0
		static add_to_damage = function(damage_to_add) {
			damage += max(damage_to_add, 0)
		}
	
		/// @desc							Removes the given value from the current damage
		/// @param {Real} damage_to_remove	The value to remove from this attack's damage. NOTE: If
		///										this value is less than 0 it will default to 0
		static remove_from_damage = function(damage_to_remove) {
			damage -= max(damage_to_remove, 0)
		}
	
	#endregion
	
	#region debuffs
		/// @desc							Adds the given debuff to the list of debuffs. If the debuff
		///										already exists the value of the debuff is added instead
		/// @param {Array<card_debuff_effects, Real>} debuff_to_add		The debuff to add to this attack
		static add_debuff = function(debuff_to_add) {
			if(array_length(debuff_to_add) != 2 ||
				typeof(debuff_to_add[1]) != "number" ||
				debuff_to_add[1] < 1) {
					return		
			}
			for(var debuff_index = 0; debuff_index < array_length(debuffs); debuff_index++) {
				if(debuffs[debuff_index][0] == debuff_to_add[0]) {
					debuffs[debuff_index][1] += debuff_to_add[1]
					return
				}
			}
			array_push(debuffs, debuff_to_add)
		}
	
		/// @desc							Reduces the amount of the given debuff by the amount given,
		///										removing the debuff if the amount would be less than 0
		/// @param {Array<card_debuff_effects, Real>} debuff_to_reduce	The debuff being reduced and
		///																	the amount to reduce it by
		static remove_from_debuff = function(debuff_to_reduce) {
			if(array_length(debuff_to_reduce) != 2 ||
				typeof(debuff_to_reduce[1]) != "number" ||
				debuff_to_reduce[1] < 1) {
					return		
			}
			for(var debuff_index = 0; debuff_index < array_length(debuffs); debuff_index++) {
				if(debuffs[debuff_index][0] == debuff_to_reduce[0]) {
					debuffs[debuff_index][1] -= debuff_to_reduce[1]
					if(debuffs[debuff_index][1] <= 0) {
						array_delete(debuffs, debuff_index, 1)
					}
					return
				}
			}
		}
	#endregion
	
	#region buffs
	
		/// @desc							Adds the given buff to the list of enemy buffs. If the buff
		///										already exists the value of the buff is added instead
		/// @param {Array<card_buff_effects, Real>} buff_to_add		The buff to add to this attack
		static add_buff = function(buff_to_add) {
			if(array_length(buff_to_add) != 2 ||
				typeof(buff_to_add[1]) != "number" ||
				buff_to_add[1] < 1) {
					return		
			}
			for(var debuff_index = 0; debuff_index < array_length(buffs); debuff_index++) {
				if(buffs[debuff_index][0] == buff_to_add[0]) {
					buffs[debuff_index][1] += buff_to_add[1]
					return
				}
			}
			array_push(buffs, buff_to_add)
		}
	
		/// @desc							Reduces the amount of the given buff by the amount given,
		///										removing the buff if the amount would be less than 0
		/// @param {Array<card_buff_effects, Real>} buff_to_reduce	The buff being reduced and the
		///																	amount to reduce it by
		static remove_from_buff = function(buff_to_reduce) {
			if(array_length(buff_to_reduce) != 2 ||
				typeof(buff_to_reduce[1]) != "number" ||
				buff_to_reduce[1] < 1) {
					return		
			}
			for(var buff_index = 0; buff_index < array_length(buffs); buff_index++) {
				if(buffs[buff_index][0] == buff_to_reduce[0]) {
					buffs[buff_index][1] -= buff_to_reduce[1]
					if(buffs[buff_index][1] <= 0) {
						array_delete(buffs, buff_index, 1)
					}
					return
				}
			}
		}
	
	#endregion
	
	#region charging attack
	
	/// @desc								Sets the charging_up_attack flag to the given value
	/// @param {bool} is_charging_attack	The flag determining if this attack will be a charge turn
	static set_charging_up_attack = function(is_charging_attack) {
		charging_up_attack = is_charging_attack
	}
	
	#endregion
	
	#region spawn enemy
	
	/// @desc									Sets the enemies_to_spawn array to the given value
	/// @param {Array<Asset.GMObject>} enemy	The enemies to be spawned in for this attack
	static set_enemy_to_spawn = function(enemy) {
		if(typeof(enemy) == "array") {
			enemies_to_spawn = enemy
		}
	}
	
	#endregion
	
	#region summon sickness
	
	/// @desc									Sets the has_summon_sickness flag to the given value
	/// @param {Boolean} _has_summon_sickness	The flag to determine if this attack is summon sickness
	static set_summon_sickness = function(_has_summon_sickness) {
		if(typeof(_has_summon_sickness) == "bool") {
			has_summon_sickness = _has_summon_sickness
		}
	}
	
	#endregion
}