/// @description Insert description here
// You can write your code in this editor
if(card_selected) {
	x = mouse_x - (sprite_width / 2)
	y = mouse_y - (sprite_height / 2)
}

if (arena = true && cardchosen = true) {
	playable = true
}
else { 
	//card dissapears on screen
}

if (playable = true) {
	if (mouse_check_button_pressed(1)){
		x = mouse_x
		y = mouse_y
	}
	if (mouse_check_button_released(1) && place_meeting(x,y,obj_enemy)){
		play = true
	}
}
//playing cards/card ef
if (play = true) {
		//actions 
				//attack
				if (attack = true) {
				enemybar -= dmg;
				attack = false
				}
				//armour
				if (armour = true) {
					health = heart + armour
					armour = false
				}
				//shield
				if (shield = true) {
					shield += shieldgain
					shield = false
				}
				//buff
				if (buff = true) {
					dmg += dmggain
				}
}
	
	


