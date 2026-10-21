/// @desc						The base class for each enemy's data. It is expected that each enemy
///									will inherit from this class and update values, or add enemy
///									specific values as needed
/// @param {Real} initial_x		The initial x position of the enemy where it spawns
/// @param {Real} initial_x		The initial y position of the enemy where it spawns
function data_enemy(initial_x, initial_y) constructor{
	object = obj_enemy
	max_health = 0
	current_health = 0
	is_alive = true
	initial_x_pos = initial_x
	initial_y_pos = initial_y
	encounter_data = [self]
}