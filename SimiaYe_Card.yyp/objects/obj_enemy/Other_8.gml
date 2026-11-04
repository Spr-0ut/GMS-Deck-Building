if(!enemy_returning_to_start && enemy_can_move) {
	display_enemy_loses_player_symbol = true
	alarm[1] = game_get_speed(gamespeed_fps) * SECONDS_ENEMY_SEARCHS_FOR_PLAYER
}