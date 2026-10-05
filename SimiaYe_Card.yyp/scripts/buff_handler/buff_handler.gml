/// @desc										Applies a buff to the given buff struct
/// @param {struct} buffs						The struct containing the current buff data of the
///													entity having a buff applied to
/// @param {card_buff_effects} buff_type		The buff being applied
/// @param {Real} buff_amount					The amount of the buff being added
/// @returns {Array<Real, Constant.Color>}		An array containing the amount of buff currently
///													applied and the color of the buff
function apply_buff(buffs, buff_type, buff_amount) {
	if(buffs[$ buff_type] == undefined)
			buffs[$ buff_type] = buff_amount
	else
		buffs[$ buff_type] += buff_amount
	
	var buff_color = get_buff_color(buff_type)
	switch (buff_type) {
		case card_buff_effects.Strength:
			return [buffs[$ buff_type], buff_color]
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			return [buffs[$ buff_type], buff_color]
	}
}

/// @desc							Finds the color to be used when displaying the given buff
/// @param {string} buff_name		The buff being applied
/// @returns {Constant.Color}		The color of the given buff
function get_buff_color(buff_name) {
	switch (buff_name) {
		case card_buff_effects.Strength:
			return c_maroon
			
		case card_buff_effects.Gain_Strength_On_Any_Attack:
			return c_fuchsia
			
		default:
			return c_orange
	}
}