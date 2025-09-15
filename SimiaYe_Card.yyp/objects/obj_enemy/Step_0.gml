/// @desc								Displays the damage applied to the enemy, allowing for different amount
///											and color to show the source of the damage
/// @param {Real} TIME_BETWEEN_ATTACKS	A constant that determines how many frames between each text pop up
var TIME_BETWEEN_ATTACKS = 12

if(display_next_damage_text) {
	if(array_length(damageToDisplay) > 0) {
		var damage_data = array_shift(damageToDisplay)
		var amount_of_damage = damage_data[0]
		var damage_text_color = damage_data[1]
		instance_create_layer(x, y, "Instances", obj_damageText,
		{
			damage_taken : amount_of_damage,
			text_color : damage_text_color
		})
		alarm[0] = TIME_BETWEEN_ATTACKS
		display_next_damage_text = false
	}
}