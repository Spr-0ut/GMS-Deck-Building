/// @desc							Subtracts the amount of damage_taken and checks if enemy is alive
/// @param {Real} damage_taken		The Amount of Health the enemy loses						
function hit_by_player(damage_taken) {
	Health -= damage_taken
	if(Health <= 0) {
		Is_alive = false
	}
}

/// @desc			Damages the player by enemy Attack_damage
function attack_player() {
	obj_player.hit_by_enemy(Attack_damage)
}