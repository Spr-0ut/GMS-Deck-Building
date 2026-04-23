/// @desc											The struct containing the data required to hit an
///														enemy or player
/// @param {Real} _damage							Optional paramater containing the initial flat
///														damage the target will take
/// @param {Array<Array<card_debuff_effects, Real>>} _debuffs	Optional paramater containing the 
///																	initial debuffs to be applied
///																	to the target
function attack_data_struct(_damage = 0, _debuffs = []) constructor{
	damage = max(_damage, 0)
	debuffs = _debuffs
	
	/// @desc						Sets the damage to the given value
	/// @param {Real} new_damage	The new value for damage. NOTE: If this value is less than 0
	///									it will default to 0
	static set_damage = function(new_damage) {
		damage = max(new_damage, 0)
	}
	
	/// @desc							Adds the given value to the current damage
	/// @param {Real} damage_to_add		The value to add to this attack's damage. NOTE: If this
	///										value is less than 0 it will default to 0
	static add_to_damage = function(damage_to_add) {
		damage += max(damage_to_add, 0)
	}
	
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
	
	/// @desc							Removes the given value from the current damage
	/// @param {Real} damage_to_add		The value to remove from this attack's damage. NOTE: If this
	///										value is less than 0 it will default to 0
	static remove_from_damage = function(damage_to_remove) {
		damage -= max(damage_to_add, 0)
	}
	
	/// @desc							Reduces the amount of the given debuff by the amount given,
	///										removing the debuff if the amount would be less than 0
	/// @param {Array<card_debuff_effects, Real>} debuff_to_reduce		The debuff being reduced and
	///																		the amount to reduce it by
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
}