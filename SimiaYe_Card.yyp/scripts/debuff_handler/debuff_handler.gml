/// @desc							Translates the given debuff into damage taken
/// @param {struct} debuffs			The struct of all the debuff quantities applied to this entity
/// @param {string} debuff_name		The debuff being applied
/// @returns {Array<Any>, Array}	The amount of damage and color of the damage from the debuff. 
///										An empty array if no damage is applied
function get_debuff_damage(debuffs, debuff_name) {
	if(!struct_exists(debuffs, debuff_name)) {
		return []
	}
	else if(debuffs[$ debuff_name] <= 0) {
		struct_remove(debuffs, debuff_name)
		return []
	}
	
	var debuff_color = get_debuff_color(debuff_name)
	switch (debuff_name) {
		case card_debuff_effects.Poison:
			return [debuffs[$ debuff_name], debuff_color]
			
		case card_debuff_effects.Weakness:
			return [debuffs[$ debuff_name], debuff_color]
			
		case card_debuff_effects.Mark:
			debuffs[$ debuff_name] -= 1
			if(debuffs[$ debuff_name] < 1) {
				struct_remove(debuffs, debuff_name)
				return []
			}
			return [debuffs[$ debuff_name], debuff_color]
			
		case card_debuff_effects.Wound:
			debuffs[$ debuff_name] -= 1
			if(debuffs[$ debuff_name] < 1) {
				struct_remove(debuffs, debuff_name)
				return []
			}
			return [debuffs[$ debuff_name] + 1, debuff_color]
			
		default:
			return [debuffs[$ debuff_name], debuff_color]
	}
}

/// @desc							Applies the given debuff_name to the given debuffs
/// @param {struct} debuffs			The struct of all the debuffs applied to this entity
/// @param {string} debuff_name		The debuff being applied
/// @param {Real} debuff_amount		Amount of the debuff being applied (This should be >0)
/// @returns {Array<Any>, Array}	The amount and color of the debuff
function apply_debuff(debuffs, debuff_name, debuff_amount) {
	var debuff_color = get_debuff_color(debuff_name)
	if(debuff_amount <= 0) {
		return [0, debuff_color]
	}
	else if(struct_exists(debuffs, debuff_name)) {
		debuffs[$ debuff_name] += debuff_amount
	}
	else {
		debuffs[$ debuff_name] = debuff_amount
	}
		
	return [debuff_amount, debuff_color]
}

/// @desc							Finds the color to be used when displaying the given debuff
/// @param {string} debuff_name		The debuff being applied
/// @returns {Constant.Color}		The color of the given debuff
function get_debuff_color(debuff_name) {
	switch (debuff_name) {
		case card_debuff_effects.Poison:
			return c_purple
			
		case card_debuff_effects.Weakness:
			return c_dkgrey
			
		case card_debuff_effects.Mark:
			return c_green
			
		case card_debuff_effects.Wound:
			return c_red
			
		default:
			return c_orange
	}
}