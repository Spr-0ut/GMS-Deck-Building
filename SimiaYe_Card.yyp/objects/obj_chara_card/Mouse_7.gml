if(chara_card_selected) {
	var selected_chara_display = instance_place(x, y, obj_party_chara_card_box)
	if(selected_chara_display != noone) {
		selected_chara_display.add_party_memeber(id)
	}
	else if(instance_exists(obj_party_chara_card_box)) {
		obj_party_chara_card_box.remove_from_party(id)
		flexpanels.set_draw_to_surface(true)
	}
}