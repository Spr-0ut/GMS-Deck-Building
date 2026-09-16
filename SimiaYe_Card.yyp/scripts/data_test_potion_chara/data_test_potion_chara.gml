function data_test_potion_class(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_test_potion_chara
	class = chara_class.potion
	player_max_health = 5
	chara_card_index = obj_chara_card
	chara_portrait = spr_test_potion_chara
	chara_attack = 100
	chara_description = "This is a temp character for the potion class"
	num_potion_slots = 3
}