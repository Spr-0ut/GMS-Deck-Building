/// @desc					Keeps track of all the unique characters created, giving each one an id
/// @returns {Real}			The unique id to be used for a specific character
function create_chara_id(){
	if(!variable_global_exists("chara_id")) {
		var num_chara = instance_number(obj_player)
		global.chara_id = num_chara
		if(num_chara > 0) {
			for(var chara_index = 0; chara_index > num_chara; chara_index++) {
				var cur_chara = instance_find(obj_player, chara_index)
				global.chara_id = max(global.chara_id, cur_chara.chara_id)
			}
		}
	}
	global.chara_id++
	return global.chara_id
}