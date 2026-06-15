#macro MUSIC_PRIORITY			100

music_playing = []
sound_effects_playing = []

if(!variable_global_exists("room_is_arena") || typeof(global.room_is_arena) != "bool") {
	global.room_is_arena = false
}

/// @desc							Sets the gain on all playing sounds to the given percent
/// @param {Real} volume_percent	The percent to set the sounds gain to
function set_main_volume(volume_percent) {
	for(var music_index = 0; music_index < array_length(music_playing); music_index++) {
		audio_sound_gain(music_playing[music_index].sound_id, volume_percent)
	}
	
	for(var sound_effect_index = 0; sound_effect_index < array_length(sound_effects_playing); sound_effect_index++) {
		audio_sound_gain(sound_effects_playing[sound_effect_index].sound_id, volume_percent)
	}
}

/// @desc						Determines if the player is in the arena room and plays the fight music
function play_arena_music() {
	if(global.room_is_arena) {
		var arena_music = new sound_effect_struct(snd_basic_fight_music, true, 1, 175)
		arena_music.play_sound_effect(MUSIC_PRIORITY)
		array_push(music_playing, arena_music)
	}
}

/// @desc						Handles any sound that triggers the "Audio Playback Ended" event,
///									cleaning up the referances to the sound
function handle_sound_effect_ended() {
	var audio_ended_id = ds_map_find_value(async_load, "sound_id")

	for(var sound_index = 0; sound_index < array_length(sound_effects_playing); sound_index++) {
		if(sound_effects_playing[sound_index].sound_id == audio_ended_id) {
			sound_effects_playing[sound_index].sound_ended()
			array_delete(sound_effects_playing, sound_index, 1)
			return
		}
	}

	for(var sound_index = 0; sound_index < array_length(music_playing); sound_index++) {
		if(music_playing[sound_index].sound_id == audio_ended_id) {
			music_playing[sound_index].sound_ended()
			array_delete(music_playing, sound_index, 1)
			return
		}
	}
}