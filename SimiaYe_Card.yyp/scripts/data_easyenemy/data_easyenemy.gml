/// @desc						The data required to create an obj_easyenemy
/// @param {Real} initial_x		The initial x position of the enemy where it spawns
/// @param {Real} initial_x		The initial y position of the enemy where it spawns
function data_easyenemy(initial_x, initial_y) : data_enemy(initial_x, initial_y) constructor {
	object = obj_easyenemy
	max_health = 1
	current_health = max_health
}