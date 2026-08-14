function data_main(_chara_id = create_chara_id()) : data_chara(_chara_id) constructor {
	chara_id = _chara_id
	object_index = obj_main
	player_max_health = 10
	chara_card_index = obj_main_chara_card
	expanded_card_sprite = spr_expanded_chara_card
	shrunk_card_sprite = spr_shrunk_chara_card
}