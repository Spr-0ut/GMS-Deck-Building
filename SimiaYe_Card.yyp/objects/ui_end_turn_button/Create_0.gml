button_can_be_pressed = true

/// @desc			Controls the end of a players turn, filling the player's hand with cards
function end_player_turn() {
	if(instance_exists(ui_player_hand) && ui_player_hand.is_hand_visible) {
		ui_player_hand.fill_player_hand()
	}
}

/// @desc			Finds all the enemies that currently exist and allows them to take their turn
function start_enemy_turn() {
	var num_enemies = instance_number(obj_enemy)
	var enemies = array_create(num_enemies)
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		enemies[enemy_index] = instance_find(obj_enemy, enemy_index)
	}
	
	array_sort(enemies, sort_enemies)
	
	for(var enemy_index = 0; enemy_index < num_enemies; enemy_index++) {
		//TODO implement the enemy attacking the player and getting hurt by debuffs
		//This is already done, but it's on a different branch that needs to be merged
	}
	//This is a temporary solution to stop the player pressing the button multiple times.
	//Eventually this should be replaced with waiting for the enemy to finish their animation
	alarm[0] = 60
}

/// @desc			Basic enemy sorting algorithm to determine the farthest left enemy
function sort_enemies(enemy1, enemy2) {
	return enemy1.x - enemy2.x
}