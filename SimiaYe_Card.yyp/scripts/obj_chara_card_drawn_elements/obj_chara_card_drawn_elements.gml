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
	expanded_chara_card_flexpanels = create_expanded_chara_card_flexpanels(card_xscale, card_yscale)
	shrunk_chara_card_flexpanels = create_shrunk_chara_card_flexpanels(card_xscale, card_yscale)
	chara_card_flexpanels = shrunk_chara_card_flexpanels
	is_expanded_chara_card = false
	x_pos = 0
	y_pos = 0
	
	potion_slots_sprite = spr_one_potion_slot_highlight
	num_potion_slots = 1
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
	
	/// @desc									Creates the expanded character card flex panels
	/// @param {Real} card_xscale				The optional horizontal sprite scaling, defaults to 1
	/// @param {Real} card_yscale				The optional vertical sprite scaling, defaults to 1
	function create_expanded_chara_card_flexpanels(card_xscale = 1, card_yscale = 1) {
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
					top : -22 * card_yscale
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
						paddingTop : 2 * card_yscale,
						paddingLeft : 20 * card_xscale,
						paddingRight : 6 * card_xscale
					},
					{
						name : "attack_box",
						flexGrow : 1,
						paddingTop : 4 * card_yscale,
						paddingBottom : 2 * card_yscale,
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

#region expanded chara card flexPanel debug code
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
				"top" : -22
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
					"paddingTop" : 4,
					"paddingBottom" : 2,
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

	/// @desc									Creates the shrunk character card flex panels
	/// @param {Real} card_xscale				The optional horizontal sprite scaling, defaults to 1
	/// @param {Real} card_yscale				The optional vertical sprite scaling, defaults to 1
	function create_shrunk_chara_card_flexpanels(card_xscale = 1, card_yscale = 1) {
		var spr_width = 198 * card_xscale
		var spr_height = 186 * card_yscale
		var node = flexpanel_create_node({
			name : "full_sprite",
			width : spr_width,
			height : spr_height,
			nodes : [
			{
				name : "card_background",
				height : 174 * card_yscale,
				marginLeft : 15 * card_xscale,
				marginRight : 9 * card_xscale,
				marginTop : 8 * card_yscale,
				marginBottom : 4 * card_yscale,
				gap : 8 * card_yscale,
				nodes : [
				{
					name : "potions_box",
					height : 42 * card_yscale,
					minWidth : 70 * card_xscale,
					maxWidth : 118 * card_xscale,
					alignSelf : "center",
					positionType : "absolute",
					top : -18 * card_yscale
				},
				{
					name : "image_box",
					height : 102 * card_yscale,
					marginTop : 18 * card_yscale,
					marginBottom : 8 * card_yscale,
					marginHorizontal : 18 * card_xscale,
					paddingTop : 10 * card_yscale
				},
				{
					name : "chara_stats",
					height : 18 * card_yscale,
					flexDirection : "row",
					paddingTop : 2 * card_yscale, 
					marginHorizontal : 14 * card_xscale,
					gap : 38 * card_xscale,
					nodes : [
					{
						name : "health_box",
						width : 54 * card_xscale,
						paddingLeft : 17 * card_xscale,
						paddingRight : 2 * card_xscale
					},
					{
						name : "attack_box",
						width : 54 * card_xscale,
						paddingVertical : 2 * card_yscale,
						paddingLeft : 21 * card_xscale,
						paddingRight : 8 * card_xscale
					}]
				}]
			}]
		})
		
		flexpanel_calculate_layout(node, spr_width, spr_height, flexpanel_direction.LTR)
		return node
	}

#region shrunk chara card debug code
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
			"height" : 186,
			"nodes" : [
			{
				"name" : "card_background",
				"height" : 174,
				"marginLeft" : 15,
				"marginRight" : 9,
				"marginTop" : 8,
				"marginBottom" : 4,
				"gap" : 8,
				"nodes" : [
				{
					"name" : "potions_box",
					"height" : 42,
					"minWidth" : 70,
					"maxWidth" : 118,
					"alignSelf" : "center",
					"positionType" : "absolute",
					"top" : -18
				},
				{
					"name" : "image_box",
					"height" : 102,
					"marginTop" : 18,
					"marginBottom" : 8,
					"marginHorizontal" : 18,
					"paddingTop" : 10
				},
				{
					"name" : "chara_stats",
					"height" : 18,
					"flexDirection" : "row",
					"paddingTop" : 2,
					"marginHorizontal" : 14,
					"gap" : 38,
					"nodes" : [
					{
						"name" : "health_box",
						"width" : 54,
						"paddingLeft" : 17,
						"paddingRight" : 2
					},
					{
						"name" : "attack_box",
						"width" : 54,
						"paddingVertical" : 2,
						"paddingLeft" : 21,
						"paddingRight" : 8
					}]
				}]
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
	
	/// @desc									Updates the chara card's flex panel position data
	///												to match the chara card sprite
	/// @param {Bool} is_expanded_card			Flag to determine if the chara card is expanded or not
	function set_chara_card_type(is_expanded_card) {
		is_expanded_chara_card = is_expanded_card
		if(is_expanded_card) {
			chara_card_flexpanels = expanded_chara_card_flexpanels
		}
		else {
			chara_card_flexpanels = shrunk_chara_card_flexpanels
		}
		update_chara_card_potion_slots_pos()
		update_chara_card_portrait_pos()
		update_chara_card_health_pos()
		update_chara_card_attack_pos()
		update_chara_card_description_pos()
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
			update_chara_card_portrait_pos()
		}
	}
	
	/// @desc									Updates the saved position data of the portrait
	function update_chara_card_portrait_pos() {
		var image_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "image_box")
		if(image_box_panel != undefined) {
			find_chara_card_portrait_scaling(portrait_sprite)
			var image_box_layout = flexpanel_node_layout_get_position(image_box_panel, false)
			portrait_x_in_card = image_box_layout.left + image_box_layout.paddingLeft +
									((image_box_layout.width +
									sprite_get_width(portrait_sprite) * portrait_scale) / 2) -
									sprite_get_xoffset(portrait_sprite) * portrait_scale
			portrait_y_in_card = image_box_layout.top + image_box_layout.height - image_box_layout.paddingBottom -
									(sprite_get_height(portrait_sprite) - sprite_get_yoffset(portrait_sprite)) * portrait_scale
		}
	}

	/// @desc									Finds the portrait_scale needed to fill the image_box
	///												with the given portrait sprite
	/// @param {Asset.GMSprite} portrait		The portrait sprite being scaled
	function find_chara_card_portrait_scaling(portrait) {
		var image_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "image_box")
		if(image_box_panel != undefined && sprite_get_width(portrait) != 0 && sprite_get_height(portrait) != 0) {
			var image_box_layout = flexpanel_node_layout_get_position(image_box_panel, false)
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
	
	/// @desc									Sets the number of potions slots to display and
	///												updates the slot's position
	/// @param {Real} num_potion_slots			The number of potion slots this character has
	function set_chara_card_potion_slots(num_chara_potion_slots) {
		if(is_numeric(num_chara_potion_slots)) {
			num_potion_slots = clamp(num_chara_potion_slots, MIN_POTION_SLOTS, MAX_POTION_SLOTS)
			update_chara_card_potion_slots_pos()
		}
	}

	/// @desc									Updates the saved position data of the potion slots
	function update_chara_card_potion_slots_pos() {
		var potions_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "potions_box")
		if(potions_box_panel != undefined) {
			set_potion_slot_width()
			var card_flexpanel_width = flexpanel_node_style_get_width(chara_card_flexpanels).value
			var card_flexpanel_height = flexpanel_node_style_get_height(chara_card_flexpanels).value
			flexpanel_node_style_set_width(potions_box_panel, sprite_get_width(potion_slots_sprite), flexpanel_unit.point)
			flexpanel_calculate_layout(chara_card_flexpanels, card_flexpanel_width, card_flexpanel_height, flexpanel_direction.LTR)
			
			var potions_box_layout = flexpanel_node_layout_get_position(potions_box_panel, false)
			potion_slots_x_in_card = potions_box_layout.left + potions_box_layout.paddingLeft
			potion_slots_y_in_card = potions_box_layout.top + potions_box_layout.paddingTop
		}
	}
	
	/// @desc									Finds the potion_slots_sprite for the given number of
	///												potions and sets the potions_box flexpanel width
	function set_potion_slot_width() {
		switch (num_potion_slots) {
			case 1:
				potion_slots_sprite = is_expanded_chara_card ? 
										spr_one_potion_slot : 
										spr_one_potion_slot_highlight
				break
			case 2:
				potion_slots_sprite = is_expanded_chara_card ? 
										spr_two_potion_slots : 
										spr_two_potion_slots_hightlight
				break
			case 3:
				potion_slots_sprite = is_expanded_chara_card ? 
										spr_three_potion_slots : 
										spr_three_potion_slots_hightlight
				break
		}
	
		var potions_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "potions_box")
		if(potions_box_panel != undefined) {
			var card_flexpanel_width = flexpanel_node_style_get_width(chara_card_flexpanels).value
			var card_flexpanel_height = flexpanel_node_style_get_height(chara_card_flexpanels).value
			flexpanel_node_style_set_width(potions_box_panel, sprite_get_width(potion_slots_sprite), flexpanel_unit.point)
			flexpanel_calculate_layout(chara_card_flexpanels, card_flexpanel_width, card_flexpanel_height, flexpanel_direction.LTR)
		}
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
			chara_current_health = max(chara_current_health, 0)
			chara_max_health = max(chara_max_health, 0)
			health_text = $"{chara_current_health}/{chara_max_health}"
			update_chara_card_health_pos()
		}
	}
	
	/// @desc									Updates the saved position data of the health text
	function update_chara_card_health_pos() {
		var health_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "health_box")
		if(health_box_panel != undefined) {
			find_chara_card_health_text_scaling(health_text)
			
			var health_box_layout = flexpanel_node_layout_get_position(health_box_panel, false)
			health_x_in_card = health_box_layout.left + health_box_layout.paddingLeft
			health_y_in_card = health_box_layout.top + health_box_layout.paddingTop + 
								(health_box_layout.height - health_box_layout.paddingTop - 
								health_box_layout.paddingBottom) / 2
		}
	}

	/// @desc									Finds the health_text_scale to fit the given text
	///												 into the health_box panel
	/// @param {string} health_display_text		The text being displayed in the health box
	function find_chara_card_health_text_scaling(health_display_text) {
		var health_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "health_box")
		if(health_box_panel != undefined && is_string(health_display_text) &&
			string_width(health_display_text) != 0 && string_height(health_display_text) != 0) {
				draw_set_font(CHARA_CARD_HEALTH_FONT)
				draw_set_halign(fa_left)
				draw_set_valign(fa_middle)
				var health_box_layout = flexpanel_node_layout_get_position(health_box_panel, false)
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
			update_chara_card_attack_pos()
		}
	}
	
	/// @desc									Updates the saved position data of the attack text
	function update_chara_card_attack_pos() {
		var attack_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "attack_box")
		if(attack_box_panel != undefined) {
			find_chara_card_attack_text_scaling(attack_text)
			var attack_box_layout = flexpanel_node_layout_get_position(attack_box_panel, false)
			attack_x_in_card = attack_box_layout.left + attack_box_layout.paddingLeft
			attack_y_in_card =  attack_box_layout.top + attack_box_layout.paddingTop + 
									(attack_box_layout.height - attack_box_layout.paddingTop -
									attack_box_layout.paddingBottom) / 2
		}
	}

	/// @desc									Finds the attack_text_scale to fit the given text
	///												 into the attack_box panel
	/// @param {string} attack_display_text		The text being displayed in the attack box
	function find_chara_card_attack_text_scaling(attack_display_text) {
		var attack_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "attack_box")
		if(attack_box_panel != undefined && is_string(attack_display_text) && 
			string_width(attack_display_text) != 0 && string_height(attack_display_text) != 0) {
				draw_set_font(CHARA_CARD_ATTACK_FONT)
				draw_set_halign(fa_left)
				draw_set_valign(fa_middle)
				var attack_box_layout = flexpanel_node_layout_get_position(attack_box_panel, false)
				var max_string_width = attack_box_layout.width - attack_box_layout.paddingLeft - attack_box_layout.paddingRight
				var max_string_height = attack_box_layout.height - attack_box_layout.paddingTop - attack_box_layout.paddingBottom

				var text_size_x_scale = max_string_width / string_width(attack_display_text)
				var text_size_y_scale = max_string_height / string_height(attack_display_text)
				if (text_size_x_scale > text_size_y_scale) {
				    attack_text_scale = sqrt(text_size_y_scale)
				}
				else {
					attack_text_scale = sqrt(text_size_x_scale)
				}
		}
	}
#endregion	
	
#region Description
	/// @desc									Draws the chara's ability description in the description_box
	function draw_chara_card_description() {
		if(is_expanded_chara_card) {
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
	}

	/// @desc									Sets the text, position, and scaling used to draw the
	///												character's ability description
	/// @param {string} chara_description		The character's ability description
	function set_chara_card_description(chara_description) {
		if(is_string(chara_description)) {
			description_text = chara_description
			update_chara_card_description_pos()
		}
	}
	
	/// @desc									Updates the saved position data of the description text
	function update_chara_card_description_pos() {
		var description_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "description_box")
		if(description_box_panel != undefined) {
			find_chara_card_description_text_scaling(description_text)
			
			var description_box_layout = flexpanel_node_layout_get_position(description_box_panel, false)
			description_x_in_card = description_box_layout.left + description_box_layout.paddingLeft
			description_y_in_card =  description_box_layout.top + description_box_layout.paddingTop
		}
	}

	/// @desc											Finds what the character card description should be
	///														scaled by to fit in the description_box panel
	///														and sets description_text_scale to this value
	/// @param {string} description_display_text		The text being displayed in the description box
	function find_chara_card_description_text_scaling(description_display_text) {
		var description_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "description_box")
		
		if(description_box_panel != undefined && is_string(description_display_text) && 
			string_height(description_display_text) != 0) {
				draw_set_font(CHARA_CARD_DESCRIPTION_FONT)
				draw_set_halign(fa_left)
				draw_set_valign(fa_top)
				
				var description_box_layout = flexpanel_node_layout_get_position(description_box_panel, false)
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
	
		var full_sprite_panel = flexpanel_node_get_child(chara_card_flexpanels, "full_sprite")
		if(full_sprite_panel != undefined) {
			var full_sprite_layout = flexpanel_node_layout_get_position(full_sprite_panel, false)
			draw_set_colour(c_fuchsia)
			draw_rectangle(x_pos + full_sprite_layout.left, y_pos + full_sprite_layout.top,
							x_pos + full_sprite_layout.left + full_sprite_layout.width,
							y_pos + full_sprite_layout.top + full_sprite_layout.height, false)
		}
					
		var card_background_panel = flexpanel_node_get_child(chara_card_flexpanels, "card_background")
		if(card_background_panel != undefined) {
			var card_background_layout = flexpanel_node_layout_get_position(card_background_panel, false)
			draw_set_colour(c_green)
			draw_rectangle(x_pos + card_background_layout.left, y_pos + card_background_layout.top,
							x_pos + card_background_layout.left + card_background_layout.width,
							y_pos + card_background_layout.top + card_background_layout.height, false)
		}
		
		var image_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "image_box")
		if(image_box_panel != undefined) {
			var image_box_layout = flexpanel_node_layout_get_position(image_box_panel, false)
			draw_set_colour(c_navy)
			draw_rectangle(x_pos + image_box_layout.left, y_pos + image_box_layout.top, 
							x_pos + image_box_layout.left + image_box_layout.width,
							y_pos + image_box_layout.top + image_box_layout.height, false)
		}
		
		var potions_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "potions_box")
		if(potions_box_panel != undefined) {
			var potions_box_layout = flexpanel_node_layout_get_position(potions_box_panel, false)
			draw_set_colour(c_white)
			draw_rectangle(x_pos + potions_box_layout.left, y_pos + potions_box_layout.top, 
							x_pos + potions_box_layout.left + potions_box_layout.width,
							y_pos + potions_box_layout.top + potions_box_layout.height, false)
		}
		
		var chara_stats_panel = flexpanel_node_get_child(chara_card_flexpanels, "chara_stats")
		if(chara_stats_panel != undefined) {
			var chara_stats_layout = flexpanel_node_layout_get_position(chara_stats_panel, false)
			draw_set_colour(c_orange)
			draw_rectangle(x_pos + chara_stats_layout.left, y_pos + chara_stats_layout.top,
							x_pos + chara_stats_layout.left + chara_stats_layout.width,
							y_pos + chara_stats_layout.top + chara_stats_layout.height, false)
		}
		
		var health_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "health_box")
		if(health_box_panel != undefined) {
			var health_box_layout = flexpanel_node_layout_get_position(health_box_panel, false)
			draw_set_colour(c_red)
			draw_rectangle(x_pos + health_box_layout.left, y_pos + health_box_layout.top,
							x_pos + health_box_layout.left + health_box_layout.width,
							y_pos + health_box_layout.top + health_box_layout.height, false)
		}
		
		var attack_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "attack_box")
		if(attack_box_panel != undefined) {
			var attack_box_layout = flexpanel_node_layout_get_position(attack_box_panel, false)
			draw_set_colour(c_lime)
			draw_rectangle(x_pos + attack_box_layout.left, y_pos + attack_box_layout.top,
							x_pos + attack_box_layout.left + attack_box_layout.width,
							y_pos + attack_box_layout.top + attack_box_layout.height, false)
		}
		
		var description_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "description_box")
		if(description_box_panel != undefined) {
			var description_box_layout = flexpanel_node_layout_get_position(description_box_panel, false)
			draw_set_colour(c_yellow)
			draw_rectangle(x_pos + description_box_layout.left, y_pos + description_box_layout.top, 
							x_pos + description_box_layout.left + description_box_layout.width,
							y_pos + description_box_layout.top + description_box_layout.height, false)
		}
		
		var equipment_box_panel = flexpanel_node_get_child(chara_card_flexpanels, "equipment_box")
		if(equipment_box_panel != undefined) {
			var equipment_box_layout = flexpanel_node_layout_get_position(equipment_box_panel, false)
			draw_set_colour(c_teal)
			draw_rectangle(x_pos + equipment_box_layout.left, y_pos + equipment_box_layout.top, 
							x_pos + equipment_box_layout.left + equipment_box_layout.width,
							y_pos + equipment_box_layout.top + equipment_box_layout.height, false)
		}
	
		draw_set_alpha(1)
	}
}