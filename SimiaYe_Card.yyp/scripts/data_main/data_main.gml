function data_main(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_main
	class = chara_class.mech
	player_max_health = 500
	chara_card_index = obj_main_chara_card
	chara_portrait = spr_player
	chara_attack = 100
	chara_description = "This is the most powerful creature in the world. If you see one, run as fast as you can and hope they feel merciful today."
	num_potion_slots = 3
}