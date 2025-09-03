
chosen = false;
main = false;

/// @desc								Removes health from the player equal to damage_taken and
///											check if player is still alive
/// @param {Real} damage_taken			The amount of damage the player is taking
function hit_by_enemy(damage_taken) {
	player_health -= damage_taken
	show_debug_message(player_health)
	if(player_health <= 0)
		show_debug_message("Player is dead")
}