function data_test_tank_class(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_test_tank_chara
	class = chara_class.tank
	player_max_health = 500
	chara_portrait = spr_test_tank_chara
	chara_attack = 1
	chara_description = "This is a temp character for the tank class"
	num_potion_slots = 1
}