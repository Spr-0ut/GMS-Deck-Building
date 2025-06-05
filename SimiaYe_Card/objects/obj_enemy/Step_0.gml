/// @description Insert description here
// You can write your code in this editor

// if in arena enemy comes alive
if (arena = true) {
	alive = true
	//(Insert sprite and animation)
	
	//round rotation
			if (attack = true) {
				health -= enemydmg
			}
	
			if (armour = true) {
				enemybar = enemyhealth + armour
			}
	
	//enemy dies
	if (enemybar <= 0) {
		alive = false 
		//(exit sprite and animation)
	}
}




