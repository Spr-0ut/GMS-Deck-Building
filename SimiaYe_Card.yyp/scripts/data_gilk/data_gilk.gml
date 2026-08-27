function data_gilk(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_gilk
	class = chara_class.damage
	player_max_health = 10
	chara_card_index = obj_gilk_chara_card
}