if(instance_number(obj_card) <= 1 && variable_global_exists("card_surf")) {
	surface_free(global.card_surf)
}