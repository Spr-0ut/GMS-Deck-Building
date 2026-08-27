function data_main(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_main
	class = chara_class.mech
	player_max_health = 10
	chara_card_index = obj_main_chara_card
}