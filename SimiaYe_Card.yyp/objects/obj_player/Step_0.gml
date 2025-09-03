
if (chosen = true) {

//make this character the main player
	if (main = true) {
		object_get_parent(obj_main)
	}
	else {
		object_get_parent(obj_player)
	}

//arena
	if (arena = true) {
		//health
		if (health <= 0)
			chosen = false
	}
}
//if out of arena you follow main player
else if (main = false) {
	x = (obj_main.x)
	y = (obj_main.y)
		
	if (place_meeting(x, y, obj_wall)) {
		x -= (obj_main.x)
		y -= (obj_main.y)
	}
}


 //selecting characters in the select screen
 //if place_meeting(x+10,y+10,ui_charaselect){
	//x = ui_charaselect.x
	//y = ui_charaselect.y
	
	//chosen = true