#macro CHARA_CARD_HEALTH_FONT			fnt_chara_card_text
#macro CHARA_CARD_ATTACK_FONT			fnt_chara_card_text
#macro CHARA_CARD_DESCRIPTION_FONT		fnt_chara_card_text
#macro CHARA_CARD_FONT_COLOR			c_dkgray
#macro MIN_POTION_SLOTS					1
#macro MAX_POTION_SLOTS					3

/// @desc							The struct to be used to draw the character cards
/// @param {Real} card_xscale		The horizontal scaling of the character card being drawn
/// @param {Real} card_yscale		The vertical scaling of the character card being drawn
function chara_card_drawn_elements(card_xscale = 1, card_yscale = 1) constructor {
	chara_card_flexpanels = create_chara_card_flexpanels(card_xscale, card_yscale)
	x_pos = 0
	y_pos = 0
	
	potion_slots_sprite = spr_one_potion_slot
	potion_slots_x_in_card = 0
	potion_slots_y_in_card = 0
	
	portrait_sprite = spr_gilk_portrait
	portrait_scale = 1
	portrait_x_in_card = 0
	portrait_y_in_card = 0
	
	health_text = ""
	health_text_scale = 1
	health_x_in_card = 0
	health_y_in_card = 0
	
	attack_text = ""
	attack_text_scale = 1
	attack_x_in_card = 0
	attack_y_in_card = 0
	
	description_text = ""
	description_text_scale = 1
	description_x_in_card = 0
	description_y_in_card = 0
	max_description_width = 1
	
	/// @desc									Creates the character card flex panels, based on the
	/// @param {Real} card_xscale				The optional horizontal sprite scaling, defaults to 1
	/// @param {Real} card_yscale				The optional vertical sprite scaling, defaults to 1
	function create_chara_card_flexpanels(card_xscale = 1, card_yscale = 1) {
		var spr_width = 198 * card_xscale
		var spr_height = 332 * card_yscale
		var node = flexpanel_create_node({
			name : "full_sprite",
			width : spr_width,
			height : spr_height,
			nodes : [
			{
				name : "card_background",
				height : 290 * card_yscale,
				marginHorizontal : 10 * card_xscale,
				marginVertical : 10 * card_yscale,
				gap : 6 * card_yscale,
				nodes : [
				{
					name : "potions_box",
					height : 38 * card_yscale,
					minWidth : 62 * card_xscale,
					maxWidth : 118 * card_xscale,
					alignSelf : "center",
					positionType : "absolute",
					top : -14 * card_yscale
				},
				{
					name : "image_box",
					height : 122 * card_yscale,
					marginHorizontal : 8 * card_xscale,
					marginVertical : 8 * card_yscale,
					paddingTop : 10 * card_yscale
				},
				{
					name : "chara_stats",
					height : 18 * card_yscale,
					flexDirection : "row",
					marginHorizontal : 6 * card_xscale,
					gap : 30 * card_xscale,
					nodes : [
					{
						name : "health_box",
						flexGrow : 1,
						paddingVertical : 2 * card_yscale,
						paddingLeft : 20 * card_xscale,
						paddingRight : 6 * card_xscale
					},
					{
						name : "attack_box",
						flexGrow : 1,
						paddingVertical : 2 * card_yscale,
						paddingLeft : 24 * card_xscale,
						paddingRight : 6 * card_xscale
					}]
				},
				{
					name : "description_box",
					marginHorizontal : 4 * card_xscale,
					marginTop : 2 * card_yscale,
					paddingHorizontal : 6 * card_xscale,
					paddingTop : 22 * card_yscale,
					paddingBottom : 30 * card_yscale,
					height : 120 * card_yscale
				}]
			},
			{
				name : "equipment_box",
				height : 60 * card_yscale,
				width : 142 * card_xscale,
				top : -38 * card_yscale,
				marginHorizontal : 28 * card_xscale,
				paddingHorizontal : 10 * card_xscale,
				paddingVertical : 10 * card_yscale
			}]
		})
	
		flexpanel_calculate_layout(node, spr_width, spr_height, flexpanel_direction.LTR)
		return node
	}

#region flexPanel debug code
	//This is the flex panel translated for the debug menu flex panel, it should not be uncommented
	//		as it will not work out of the box, but it is very useful for seeing what it looks like.
	//	NOTE: for some reason it adds a 4 pixle border around everything, so it can look like the
	//		panels positions are wrong when they are correct
	//
	//To activate the debug menu run this code: show_debug_overlay(true)
	/*
	{
		"name" : "full_sprite",
		"width" : 198,
		"height" : 332,
		"nodes" : [
		{
			"name" : "card_background",
			"height" : 290,
			"marginHorizontal" : 10,
			"marginVertical" : 10,
			"gap" : 6,
			"nodes" : [
			{
				"name" : "potions_box",
				"height" : 38,
				"minWidth" : 62,
				"maxWidth" : 110,
				"alignSelf" : "center",
				"positionType" : "absolute",
				"top" : -14
			},
			{
				"name" : "image_box",
				"height" : 122,
				"marginHorizontal" : 8,
				"marginVertical" : 8,
				"paddingTop" : 10
			},
			{
				"name" : "chara_stats",
				"height" : 18,
				"flexDirection" : "row",
				"marginHorizontal" : 6,
				"gap" : 30,
				"nodes" : [
				{
					"name" : "health_box",
					"flexGrow" : 1,
					"paddingVertical" : 2,
					"paddingLeft" : 20,
					"paddingRight" : 6
				},
				{
					"name" : "attack_box",
					"flexGrow" : 1,
					"paddingVertical" : 2,
					"paddingLeft" : 24,
					"paddingRight" : 6
				}]
			},
			{
				"name" : "description_box",
				"marginHorizontal" : 4,
				"marginTop" : 2,
				"paddingHorizontal" : 6,
				"paddingTop" : 22,
				"paddingBottom" : 30,
				"height" : 120
			}]
		},
		{
			"name" : "equipment_box",
			"height" : 60,
			"width" : 142,
			"top" : -38,
			"marginHorizontal" : 28,
			"paddingHorizontal" : 10,
			"paddingVertical" : 10
		}]
	}
	*/
#endregion

	/// @desc									Sets up all of the data needed to draw card elements
	/// @param {Real} num_potion_slots			The number of potions this character can hold
	/// @param {Asset.GMSprite} portrait		The portrait sprite to show on the character card
	/// @param {Real} chara_current_health		The amount of health the character currently has
	/// @param {Real} chara_max_health			The max amount of health the character can have
	/// @param {Real} chara_attack				The character's current attack
	/// @param {Real} chara_description			The character's ability description
	function setup_chara_card_drawn_data(num_potion_slots, portrait, chara_current_health,
										chara_max_health, chara_attack, chara_description) {
		set_chara_card_potion_slots(num_potion_slots)
		set_chara_card_portrait(portrait)
		set_chara_card_health(chara_current_health, chara_max_health)
		set_chara_card_attack(chara_attack)
		set_chara_card_description(chara_description)
	}
	
	/// @desc									Handles drawing the character card and it's elements
	/// @param {Method} draw_self_method		The draw_self() method for this character card.
	///												NOTE: There is no validation done for this call
	///												to maximize fps, and as such may crash the game
	///												if the wrong data is sent
	function draw_chara_card(draw_self_method){
		draw_chara_card_portrait()
		method_call(draw_self_method)
		draw_chara_card_potion_slots()
		draw_chara_card_health()
		draw_chara_card_attack()
		draw_chara_card_description()
	}
	
	/// @desc									Sets the cooridinates that will be used to draw the card
	///												elements from. NOTE: This needs to be run before the
	///												elements are drawn to ensure the correct positions
	/// @param {Real} card_x_pos				The horizontal position of the character card's origin
	/// @param {Real} card_y_pos				The vertical position of the character card's origin
	function set_chara_card_pos(card_x_pos, card_y_pos) {
		x_pos = card_x_pos
		y_pos = card_y_pos
	}
	
#region Portrait
	/// @desc									Draws the given portrait in the flexpanel's image_box
	/// @param {Real} subimage					The optional frame of the portrait to draw, defaults to 0
	function draw_chara_card_portrait(subimage = 0) {							
		draw_sprite_ext(portrait_sprite, subimage,  x_pos + portrait_x_in_card, y_pos + portrait_y_in_card,
							portrait_scale, portrait_scale, 0, c_white, 1)
	}
	
	/// @desc									Sets the sprite, position, and scaling used to draw the
	///												card's portrait
	/// @param {Asset.GMSprite} portrait		The portrait sprite to show on the character card
	function set_chara_card_portrait(portrait) {
		if(typeof(portrait) == "ref" && sprite_exists(portrait)) {
			portrait_sprite = portrait
			var image_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "image_box"), false)
			find_chara_card_portrait_scaling(portrait)
			portrait_x_in_card = image_box_layout.left + image_box_layout.paddingLeft +
									((image_box_layout.width +
									sprite_get_width(portrait) * portrait_scale) / 2) -
									sprite_get_xoffset(portrait) * portrait_scale
			portrait_y_in_card = image_box_layout.top + image_box_layout.height - image_box_layout.paddingBottom -
									(sprite_get_height(portrait) - sprite_get_yoffset(portrait)) * portrait_scale
		}
	}

	/// @desc									Finds the portrait_scale needed to fill the image_box
	///												with the given portrait sprite
	/// @param {Asset.GMSprite} portrait		The portrait sprite being scaled
	function find_chara_card_portrait_scaling(portrait) {
		if(sprite_get_width(portrait) != 0 && sprite_get_height(portrait) != 0) {
			var image_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "image_box"), false)
			var portrait_horizontal_space = image_box_layout.width - image_box_layout.paddingLeft - 
												image_box_layout.paddingRight
			var portrait_vertical_space = image_box_layout.height - image_box_layout.paddingTop - 
												image_box_layout.paddingBottom
	
			if(portrait_horizontal_space - sprite_get_width(portrait) < 
				portrait_vertical_space - sprite_get_height(portrait)) {
					portrait_scale = portrait_horizontal_space / sprite_get_width(portrait)
			}
			else {
					portrait_scale = portrait_vertical_space / sprite_get_height(portrait)
			}
		}
	}
#endregion
	
#region Potion Slots
	/// @desc									Draws the potion slots in the flexpanel's potions_box
	function draw_chara_card_potion_slots() {
		draw_sprite(potion_slots_sprite, 0, x_pos + potion_slots_x_in_card, y_pos + potion_slots_y_in_card)
	}
	
	/// @desc									Sets the sprite, position, and potion slot width used
	///												to draw the card's potion slots
	/// @param {Real} num_potion_slots			The number of potion slots this character has
	function set_chara_card_potion_slots(num_potion_slots) {
		if(is_numeric(num_potion_slots)) {
			num_potion_slots = clamp(num_potion_slots, MIN_POTION_SLOTS, MAX_POTION_SLOTS)
			set_potion_slot_width(num_potion_slots)
			var potions_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "potions_box"), false)
		
			potion_slots_x_in_card = potions_box_layout.left + potions_box_layout.paddingLeft
			potion_slots_y_in_card = potions_box_layout.top + potions_box_layout.paddingTop
		}
	}

	
	
	/// @desc									Finds the potion_slots_sprite for the given number of
	///												potions and sets the potions_box flexpanel width
	/// @param {Real} num_potion_slots			The number of potions this character can hold
	function set_potion_slot_width(num_potion_slots) {
		num_potion_slots = clamp(num_potion_slots, MIN_POTION_SLOTS, MAX_POTION_SLOTS)
		switch (num_potion_slots) {
			case 1:
				potion_slots_sprite = spr_one_potion_slot
				break
			case 2:
				potion_slots_sprite = spr_two_potion_slots
				break
			case 3:
				potion_slots_sprite = spr_three_potion_slots
				break
		}
	
		var potions_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "potions_box")
		var card_flexpanel_width = flexpanel_node_style_get_width(chara_card_flexpanels).value
		var card_flexpanel_height = flexpanel_node_style_get_height(chara_card_flexpanels).value
		flexpanel_node_style_set_width(potions_box_panel, sprite_get_width(potion_slots_sprite), flexpanel_unit.point)
		flexpanel_calculate_layout(chara_card_flexpanels, card_flexpanel_width, card_flexpanel_height, flexpanel_direction.LTR)
	}
#endregion

#region Health	
	/// @desc									Draws the health ratio in the flexpanel's health_box
	function draw_chara_card_health() {
		draw_set_alpha(1)
		draw_set_colour(CHARA_CARD_FONT_COLOR)
		draw_set_font(CHARA_CARD_HEALTH_FONT)
		draw_set_halign(fa_left)
		draw_set_valign(fa_middle)
	
		draw_text_transformed(x_pos + health_x_in_card, y_pos + health_y_in_card, health_text, health_text_scale, health_text_scale, 0)
	}

	/// @desc									Sets the text, position, and scaling used to draw the
	///												character's health
	/// @param {Real} chara_current_health		The amount of health the character currently has
	/// @param {Real} chara_max_health			The max amount of health the character can have
	function set_chara_card_health(chara_current_health, chara_max_health) {
		if(is_numeric(chara_current_health) && is_numeric(chara_max_health)) {
			var health_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "health_box"), false)
			chara_current_health = max(chara_current_health, 0)
			chara_max_health = max(chara_max_health, 0)
			health_text = $"{chara_current_health} / {chara_max_health}"
			find_chara_card_health_text_scaling(health_text)
			health_x_in_card = health_box_layout.left + health_box_layout.paddingLeft
			health_y_in_card = health_box_layout.top + health_box_layout.paddingTop + (health_box_layout.height / 2)
		}
	}

	/// @desc									Finds the health_text_scale to fit the given text
	///												 into the health_box panel
	/// @param {string} health_display_text		The text being displayed in the health box
	function find_chara_card_health_text_scaling(health_display_text) {
		if(is_string(health_display_text) && string_width(health_display_text) != 0 && string_height(health_display_text) != 0) {
			draw_set_font(CHARA_CARD_HEALTH_FONT)
			draw_set_halign(fa_left)
			draw_set_valign(fa_middle)
			var health_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "health_box"), false)
			var max_string_width = health_box_layout.width - health_box_layout.paddingLeft - health_box_layout.paddingRight
			var max_string_height = health_box_layout.height - health_box_layout.paddingTop - health_box_layout.paddingBottom

			var text_size_x_scale = max_string_width / string_width(health_display_text)
			var text_size_y_scale = max_string_height / string_height(health_display_text)
			if (text_size_x_scale > text_size_y_scale) {
			    health_text_scale = text_size_y_scale
			}
			else {
				health_text_scale = text_size_x_scale	
			}
		}
	}
#endregion

#region Attack
	/// @desc									Draws the chara's attack in the flexpanel's attack_box
	function draw_chara_card_attack() {
		draw_set_alpha(1)
		draw_set_colour(CHARA_CARD_FONT_COLOR)
		draw_set_font(CHARA_CARD_ATTACK_FONT)
		draw_set_halign(fa_left)
		draw_set_valign(fa_middle)
	
		draw_text_transformed(x_pos + attack_x_in_card, y_pos + attack_y_in_card, attack_text, attack_text_scale, attack_text_scale, 0)
	}
	
	/// @desc									Sets the text, position, and scaling used to draw the
	///												character's attack
	/// @param {Real} chara_arrack				The character's current attack
	function set_chara_card_attack(chara_attack) {
		if(is_numeric(chara_attack)) {
			chara_attack = max(chara_attack, 0)
			attack_text = $"{chara_attack}"
			find_chara_card_attack_text_scaling(attack_text)
			var attack_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "attack_box"), false)
			attack_x_in_card = attack_box_layout.left + attack_box_layout.paddingLeft
			attack_y_in_card =  attack_box_layout.top + attack_box_layout.paddingTop + (attack_box_layout.height / 2)
		}
	}

	/// @desc									Finds the attack_text_scale to fit the given text
	///												 into the attack_box panel
	/// @param {string} attack_display_text		The text being displayed in the attack box
	function find_chara_card_attack_text_scaling(attack_display_text) {
		if(is_string(attack_display_text) && string_width(attack_display_text) != 0 && string_height(attack_display_text) != 0) {
			draw_set_font(CHARA_CARD_ATTACK_FONT)
			draw_set_halign(fa_left)
			draw_set_valign(fa_middle)
			var attack_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "attack_box"), false)
			var max_string_width = attack_box_layout.width - attack_box_layout.paddingLeft - attack_box_layout.paddingRight
			var max_string_height = attack_box_layout.height - attack_box_layout.paddingTop - attack_box_layout.paddingBottom

			var text_size_x_scale = max_string_width / string_width(attack_display_text)
			var text_size_y_scale = max_string_height / string_height(attack_display_text)
			if (text_size_x_scale > text_size_y_scale) {
			    attack_text_scale = text_size_y_scale
			}
			else {
				attack_text_scale = text_size_x_scale	
			}
		}
	}
#endregion	
	
#region Description
	/// @desc									Draws the chara's ability description in the description_box
	function draw_chara_card_description() {
		draw_set_alpha(1)
		draw_set_colour(CHARA_CARD_FONT_COLOR)
		draw_set_font(CHARA_CARD_DESCRIPTION_FONT)
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)
	
		draw_text_ext_transformed(x_pos + description_x_in_card, y_pos + description_y_in_card,
									description_text, string_height(description_text),
									max_description_width / description_text_scale, description_text_scale,
									description_text_scale, 0)
	}

	/// @desc									Sets the text, position, and scaling used to draw the
	///												character's ability description
	/// @param {string} chara_description		The character's ability description
	function set_chara_card_description(chara_description) {
		if(is_string(chara_description)) {
			description_text = chara_description
			find_chara_card_description_text_scaling(description_text)
			var description_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "description_box"), false)
			description_x_in_card = description_box_layout.left + description_box_layout.paddingLeft
			description_y_in_card =  description_box_layout.top + description_box_layout.paddingTop
		}
	}

	/// @desc											Finds what the character card description should be
	///														scaled by to fit in the description_box panel
	///														and sets description_text_scale to this value
	/// @param {string} description_display_text		The text being displayed in the description box
	function find_chara_card_description_text_scaling(description_display_text) {
		if(is_string(description_display_text) && string_height(description_display_text) != 0) {
			draw_set_font(CHARA_CARD_DESCRIPTION_FONT)
			draw_set_halign(fa_left)
			draw_set_valign(fa_top)
			var description_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "description_box"), false)
			max_description_width = description_box_layout.width - description_box_layout.paddingLeft - description_box_layout.paddingRight
			var max_string_height = description_box_layout.height - description_box_layout.paddingTop - description_box_layout.paddingBottom

			var description_height = string_height_ext(description_display_text, string_height(description_display_text), max_description_width)
			if(description_height > max_string_height) {
				description_text_scale = sqrt(max_string_height / description_height)
			}
			else {
				description_text_scale = 1
			}
		}
	}
#endregion

	/// @desc									Draws all the character card's flexpanel as see through
	///												boxes. NOTE: This is only meant for debugging and
	///												should not be referanced anywhere else in the code
	function draw_chara_card_flexpanels() {
		draw_set_alpha(0.5)
	
		var full_sprite_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "full_sprite"), false)
		var card_background_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "card_background"), false)
		var image_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "image_box"), false)
		var potions_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "potions_box"), false)
		var chara_stats_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "chara_stats"), false)
		var health_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "health_box"), false)
		var attack_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "attack_box"), false)
		var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "description_box"), false)
		var equipment_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(chara_card_flexpanels, "equipment_box"), false)
	
		draw_set_colour(c_fuchsia)
		draw_rectangle(x_pos + full_sprite_panel.left, y_pos + full_sprite_panel.top, x_pos + full_sprite_panel.left + full_sprite_panel.width,
						  y_pos + full_sprite_panel.top + full_sprite_panel.height, false)
					  
		draw_set_colour(c_green)
		draw_rectangle(x_pos + card_background_panel.left, y_pos + card_background_panel.top, x_pos + card_background_panel.left + card_background_panel.width,
						  y_pos + card_background_panel.top + card_background_panel.height, false)
					  
		draw_set_colour(c_navy)
		draw_rectangle(x_pos + image_box_panel.left, y_pos + image_box_panel.top, x_pos + image_box_panel.left + image_box_panel.width,
						  y_pos + image_box_panel.top + image_box_panel.height, false)
					  
		draw_set_colour(c_white)
		draw_rectangle(x_pos + potions_box_panel.left, y_pos + potions_box_panel.top, x_pos + potions_box_panel.left + potions_box_panel.width,
						  y_pos + potions_box_panel.top + potions_box_panel.height, false)
					  
		draw_set_colour(c_orange)
		draw_rectangle(x_pos + chara_stats_panel.left, y_pos + chara_stats_panel.top, x_pos + chara_stats_panel.left + chara_stats_panel.width,
						  y_pos + chara_stats_panel.top + chara_stats_panel.height, false)
					  
		draw_set_colour(c_red)
		draw_rectangle(x_pos + health_box_panel.left, y_pos + health_box_panel.top, x_pos + health_box_panel.left + health_box_panel.width,
						  y_pos + health_box_panel.top + health_box_panel.height, false)
					  
		draw_set_colour(c_lime)
		draw_rectangle(x_pos + attack_box_panel.left, y_pos + attack_box_panel.top, x_pos + attack_box_panel.left + attack_box_panel.width,
						  y_pos + attack_box_panel.top + attack_box_panel.height, false)
					  
		draw_set_colour(c_yellow)
		draw_rectangle(x_pos + description_box_panel.left, y_pos + description_box_panel.top, x_pos + description_box_panel.left + description_box_panel.width,
						  y_pos + description_box_panel.top + description_box_panel.height, false)
					  
		draw_set_colour(c_teal)
		draw_rectangle(x_pos + equipment_box_panel.left, y_pos + equipment_box_panel.top, x_pos + equipment_box_panel.left + equipment_box_panel.width,
						  y_pos + equipment_box_panel.top + equipment_box_panel.height, false)
	
		draw_set_alpha(1)
	}
}