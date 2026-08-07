/// @desc						The parent struct that keeps track of all the characters created. Each
///									character should have a data struct that inherits from this one with
///									specific data for that character
/// @param {Real} chara_id		The unique id of the character recived from create_chara_id
function data_chara(chara_id) constructor {
	static chara = {}
	chara[$ chara_id] = self
}