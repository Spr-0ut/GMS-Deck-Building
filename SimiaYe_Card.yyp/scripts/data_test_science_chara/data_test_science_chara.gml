function data_test_science_class(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_test_science_chara
	class = chara_class.science
	player_max_health = 50
	chara_portrait = spr_test_science_chara
	chara_attack = 5
	chara_description = "This is a temp character for the science class"
	num_potion_slots = 2
}