mask_index = sprite_index
hovering_over_card = false

if(global.card_being_hovered == id || 
		(global.card_being_hovered != noone &&
		!instance_exists(global.card_being_hovered))) {
	global.card_being_hovered = noone	
}