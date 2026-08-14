/// @desc						The parent struct that keeps track of all the characters created. Each
///									character should have a data struct that inherits from this one with
///									specific data for that character
/// @param {Real} chara_id		The unique id of the character recived from create_chara_id
///									NOTE: negative IDs are assumed to be errors and not added
function data_chara(chara_id) constructor {
	static chara = {}
	if(chara_id >= 0) {
		chara[$ chara_id] = self
	}
	
	/// @desc							Finds the data for all characters previously created
	/// @returns {Array<data_chara>}	An array containing the data_chara of all known characters
	static get_all_chara_data = function() {
		var chara_data_ids = struct_get_names(chara)
		var chara_data = array_create(array_length(chara_data_ids), noone)
		for(var chara_id_index = 0; chara_id_index < array_length(chara_data_ids); chara_id_index++) {
			chara_data[chara_id_index] = chara[$ chara_data_ids[chara_id_index]]
		}
		return chara_data
	}
}