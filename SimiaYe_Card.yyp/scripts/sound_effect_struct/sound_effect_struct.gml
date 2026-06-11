#macro TIME_TO_FADE_SOUND_EFFECTS 3000

/// @desc									The struct used to manage sounds, containing all data required
///												to play and use the sound
/// @param {Asset.GMSound} _sound_effect	The sound effect to be tracked and played by this struct
/// @param {bool} _loop_sound_effect		Optional flag to determine if the sound effect should loop
/// @param {Real} _loop_start				Optional time in seconds to start the sound's loop at
/// @param {Real} _loop_end					Optional time in seconds where the sound should loop
function sound_effect_struct(_sound_effect, _loop_sound_effect = false, _loop_start = 0, _loop_end = 0) constructor {
	if(!audio_exists(_sound_effect)) {
		return
	}
	
	sound_effect = _sound_effect
	loop_start = clamp(_loop_start, 0, audio_sound_length(sound_effect))
	loop_end = clamp(_loop_end, loop_start, audio_sound_length(sound_effect))
	loop_sound_effect = _loop_sound_effect
	sound_id = undefined
	
	/// @desc					Plays this sound effect and sets up it's looping if needed
	/// @param {Real} priority	Determines which audio will be stopped in the case that the amount
	///								of sounds is greater than audio channles
	/// @param {bool} fade_in	Optional flag to determines if the audio is faded in when played
	static play_sound_effect = function(priority, fade_in = false) {
		if(is_real(priority)) {
			sound_id = audio_play_sound(sound_effect, priority, loop_sound_effect)
			audio_sound_loop_start(sound_id, loop_start)
			audio_sound_loop_end(sound_id, loop_end)
			
			if(fade_in) {
				audio_sound_gain(sound_id, 0)
				audio_sound_gain(sound_id, 1, TIME_TO_FADE_SOUND_EFFECTS)
			}
		}
	}
	
	/// @desc					Handles ending the sound effect
	/// @param {bool} fade_out	Optional flag to determines if the audio is faded out before stopping
	static end_sound_effect = function(fade_out = false) {
		if(fade_out) {
			audio_sound_gain(sound_id, 0, TIME_TO_FADE_SOUND_EFFECTS)
			call_later(TIME_TO_FADE_SOUND_EFFECTS / 1000, time_source_units_seconds, method(self, end_sound_effect))
		}
		else {
			audio_stop_sound(sound_id)
		}
	}
	
	/// @desc					Handles when this sound is ended through the "Audio Playback Ended" event
	static sound_ended = function() {
		sound_id = undefined
	}
	
	/// @desc					Determines if the sound still exists and returns the sound_id
	/// @returns {Id.Sound}		The index of this sound effect
	static get_sound_id = function() {
		if (!audio_exists(sound_id)) {
			sound_ended()
			return undefined
		}
		return sound_id
	}
}