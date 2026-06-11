if(global.room_is_arena) {
	play_arena_music()	
}
else {
	for(var music_index = 0; music_index < array_length(music_playing); music_index++) {
		music_playing[music_index].end_sound_effect()
	}
}