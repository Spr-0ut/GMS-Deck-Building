/// @desc						The data required to create an obj_fuzzy_bee_enemy
/// @param {Real} initial_x		The initial x position of the enemy where it spawns
/// @param {Real} initial_x		The initial y position of the enemy where it spawns
function data_fuzzy_bee(initial_x, initial_y) : data_enemy(initial_x, initial_y) constructor {
	object = obj_fuzzy_bee_enemy
	max_health = 15
	current_health = max_health
}