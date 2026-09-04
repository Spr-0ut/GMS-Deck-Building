#macro CHARA_CARD_HEALTH_FONT			fnt_chara_card_text
#macro CHARA_CARD_ATTACK_FONT			fnt_chara_card_text
#macro CHARA_CARD_DESCRIPTION_FONT		fnt_chara_card_text
#macro CHARA_CARD_FONT_COLOR			c_dkgray
#macro MIN_POTION_SLOTS					1
#macro MAX_POTION_SLOTS					3

/// @desc											Creates the character card flex panels, based on the
/// @param {Real} card_xscale						The optional horizontal sprite scaling, defaults to 1
/// @param {Real} card_yscale						The optional vertical sprite scaling, defaults to 1
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

/// @desc											Draws the given portrait in the flexpanel's image_box
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
/// @param {Asset.GMSprite} portrait				The portrait sprite to show on the character card
/// @param {Real} subimage							The optional frame of the portrait to draw defaults to 0
function draw_chara_card_portrait(card_flexpanels, portrait, subimage = 0) {
	var image_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "image_box"), false)
	var portrait_scale = find_chara_card_portrait_scaling(image_box_layout, portrait)
	var portrait_x_pos = x + image_box_layout.left + image_box_layout.paddingLeft +
							((image_box_layout.width +
							sprite_get_width(portrait) * portrait_scale) / 2) -
							sprite_get_xoffset(portrait) * portrait_scale
							
	var portrait_y_pos = y + image_box_layout.top + image_box_layout.height - image_box_layout.paddingBottom -
							(sprite_get_height(portrait) - sprite_get_yoffset(portrait)) * portrait_scale
							
	draw_sprite_ext(portrait, subimage, portrait_x_pos, portrait_y_pos, portrait_scale, portrait_scale, 0, c_white, 1)
}

/// @desc											Finds the scaling needed to fill the given image_box
/// @param {Asset.GMSprite} portrait				The portrait sprite being scaled
function find_chara_card_portrait_scaling(portrait_pos_data, portrait) {
	var portrait_horizontal_space = portrait_pos_data.width - portrait_pos_data.paddingLeft - 
										portrait_pos_data.paddingRight
	var portrait_vertical_space = portrait_pos_data.height - portrait_pos_data.paddingTop - 
										portrait_pos_data.paddingBottom
	
	if(portrait_horizontal_space - sprite_get_width(portrait) < 
		portrait_vertical_space - sprite_get_height(portrait)) {
			return portrait_horizontal_space / sprite_get_width(portrait)
	}
	else {
			return portrait_vertical_space / sprite_get_height(portrait)
	}
}

/// @desc											Draws the potion slots in the flexpanel's potions_box
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
/// @param {Real} num_potion_slots					The number of potion slots this character has
function draw_chara_card_potion_slots(card_flexpanels, num_potion_slots) {
	num_potion_slots = clamp(num_potion_slots, MIN_POTION_SLOTS, MAX_POTION_SLOTS)
	var potions_box_panel = flexpanel_node_get_child(card_flexpanels, "potions_box")
	
	var potion_slots_sprite = spr_one_potion_slot
	switch (num_potion_slots) {
		case 1:
			break
		case 2:
			potion_slots_sprite = spr_two_potion_slots
			break
		case 3:
			potion_slots_sprite = spr_three_potion_slots
			break
	}
	
	var card_flexpanel_width = flexpanel_node_style_get_width(card_flexpanels).value
	var card_flexpanel_height = flexpanel_node_style_get_height(card_flexpanels).value
	flexpanel_node_style_set_width(potions_box_panel, sprite_get_width(potion_slots_sprite), flexpanel_unit.point)
	flexpanel_calculate_layout(card_flexpanels, card_flexpanel_width, card_flexpanel_height, flexpanel_direction.LTR)
	
	var potions_box_layout = flexpanel_node_layout_get_position(potions_box_panel, false)
	var x_pos = x + potions_box_layout.left + potions_box_layout.paddingLeft
	var y_pos = y + potions_box_layout.top + potions_box_layout.paddingTop
	draw_sprite(potion_slots_sprite, 0, x_pos, y_pos)
}

/// @desc											Draws the health ratio in the flexpanel's health_box
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
/// @param {Real} chara_current_health				The amount of health the character currently has
/// @param {Real} chara_max_health					The max amount of health the character can have
function draw_chara_card_health(card_flexpanels, chara_current_health, chara_max_health) {
	draw_set_alpha(1)
	draw_set_colour(CHARA_CARD_FONT_COLOR)
	draw_set_font(CHARA_CARD_HEALTH_FONT)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	
	var health_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "health_box"), false)
	var text_x_pos = x + health_box_layout.left + health_box_layout.paddingLeft
	var text_y_pos = y + health_box_layout.top + health_box_layout.paddingTop + (health_box_layout.height / 2)
	var health_display_text = $"{chara_current_health} / {chara_max_health}"
	var text_size_scale = find_chara_card_health_text_scaling(health_box_layout, health_display_text)
	
	draw_text_transformed(text_x_pos, text_y_pos, health_display_text, text_size_scale, text_size_scale, 0)
}

/// @desc											Finds what the character card health text should be
///														scaled by to fit in the health_box panel
/// @param {Struct} health_box_layout				The position struct for the character card health_box
/// @param {string} health_display_text				The text being displayed in the health box
function find_chara_card_health_text_scaling(health_box_layout, health_display_text) {
	var max_string_width = health_box_layout.width - health_box_layout.paddingLeft - health_box_layout.paddingRight
	var max_string_height = health_box_layout.height - health_box_layout.paddingTop - health_box_layout.paddingBottom

	var text_size_x_scale = max_string_width / string_width(health_display_text)
	var text_size_y_scale = max_string_height / string_height(health_display_text)
	if (text_size_x_scale > text_size_y_scale) {
	    return text_size_y_scale
	}
	else {
		return text_size_x_scale	
	}
}

/// @desc											Draws the given attack in the flexpanel's attack_box
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
/// @param {Real} chara_current_health				The character's current attack
function draw_chara_card_attack(card_flexpanels, chara_attack) {
	draw_set_alpha(1)
	draw_set_colour(CHARA_CARD_FONT_COLOR)
	draw_set_font(CHARA_CARD_ATTACK_FONT)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	
	var attack_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "attack_box"), false)
	var text_x_pos = x + attack_box_layout.left + attack_box_layout.paddingLeft
	var text_y_pos = y + attack_box_layout.top + attack_box_layout.paddingTop + (attack_box_layout.height / 2)
	var text_size_scale = find_chara_card_attack_text_scaling(attack_box_layout, chara_attack)
	
	draw_text_transformed(text_x_pos, text_y_pos, chara_attack, text_size_scale, text_size_scale, 0)
}

/// @desc											Finds what the character card attack text should be
///														scaled by to fit in the attack_box panel
/// @param {Struct} attack_box_panel				The position struct for the character card attack_box
/// @param {string} attack_display_text				The text being displayed in the attack box
function find_chara_card_attack_text_scaling(attack_box_layout, attack_display_text) {
	var max_string_width = attack_box_layout.width - attack_box_layout.paddingLeft - attack_box_layout.paddingRight
	var max_string_height = attack_box_layout.height - attack_box_layout.paddingTop - attack_box_layout.paddingBottom

	var text_size_x_scale = max_string_width / string_width(attack_display_text)
	var text_size_y_scale = max_string_height / string_height(attack_display_text)
	if (text_size_x_scale > text_size_y_scale) {
	    return text_size_y_scale
	}
	else {
		return text_size_x_scale	
	}
}

/// @desc											Draws the given attack in the flexpanel's attack_box
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
/// @param {string} chara_description				The character's ability description
function draw_chara_card_description(card_flexpanels, chara_description) {
	draw_set_alpha(1)
	draw_set_colour(CHARA_CARD_FONT_COLOR)
	draw_set_font(CHARA_CARD_DESCRIPTION_FONT)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	var description_box_layout = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var max_string_width = description_box_layout.width - description_box_layout.paddingLeft - description_box_layout.paddingRight
	var text_x_pos = x + description_box_layout.left + description_box_layout.paddingLeft
	var text_y_pos = y + description_box_layout.top + description_box_layout.paddingTop
	
	var text_scale = find_chara_card_description_text_scaling(description_box_layout, chara_description)
	
	draw_text_ext_transformed(text_x_pos, text_y_pos, chara_description, string_height(chara_description), max_string_width / text_scale, text_scale, text_scale, 0)
}

/// @desc											Finds what the character card attack text should be
///														scaled by to fit in the description_box panel
/// @param {Struct} description_box_panel			The position struct for the chara card description_box
/// @param {string} description_display_text		The text being displayed in the description box
function find_chara_card_description_text_scaling(description_box_layout, description_display_text) {
	var max_string_width = description_box_layout.width - description_box_layout.paddingLeft - description_box_layout.paddingRight
	var max_string_height = description_box_layout.height - description_box_layout.paddingTop - description_box_layout.paddingBottom

	var description_height = string_height_ext(description_display_text, string_height(description_display_text), max_string_width)
	if(description_height > max_string_height) {
		return sqrt(max_string_height / description_height)
	}
	return 1
}

/// @desc											Draws all the character card's flexpanel as see through
///														boxes. NOTE: This is only meant for debugging and
///														should not be referanced anywhere else in the code
/// @param {Pointer.FlexpanelNode} card_flexpanels	Parent flexpanel of the character card
function draw_chara_card_flexpanels(card_flexpanels) {
	draw_set_alpha(0.5)
	
	var full_sprite_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "full_sprite"), false)
	var card_background_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "card_background"), false)
	var image_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "image_box"), false)
	var potions_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "potions_box"), false)
	var chara_stats_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "chara_stats"), false)
	var health_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "health_box"), false)
	var attack_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "attack_box"), false)
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var equipment_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "equipment_box"), false)
	
	draw_set_colour(c_fuchsia)
	draw_rectangle(x + full_sprite_panel.left, y + full_sprite_panel.top, x + full_sprite_panel.left + full_sprite_panel.width,
					  y + full_sprite_panel.top + full_sprite_panel.height, false)
					  
	draw_set_colour(c_green)
	draw_rectangle(x + card_background_panel.left, y + card_background_panel.top, x + card_background_panel.left + card_background_panel.width,
					  y + card_background_panel.top + card_background_panel.height, false)
					  
	draw_set_colour(c_navy)
	draw_rectangle(x + image_box_panel.left, y + image_box_panel.top, x + image_box_panel.left + image_box_panel.width,
					  y + image_box_panel.top + image_box_panel.height, false)
					  
	draw_set_colour(c_white)
	draw_rectangle(x + potions_box_panel.left, y + potions_box_panel.top, x + potions_box_panel.left + potions_box_panel.width,
					  y + potions_box_panel.top + potions_box_panel.height, false)
					  
	draw_set_colour(c_orange)
	draw_rectangle(x + chara_stats_panel.left, y + chara_stats_panel.top, x + chara_stats_panel.left + chara_stats_panel.width,
					  y + chara_stats_panel.top + chara_stats_panel.height, false)
					  
	draw_set_colour(c_red)
	draw_rectangle(x + health_box_panel.left, y + health_box_panel.top, x + health_box_panel.left + health_box_panel.width,
					  y + health_box_panel.top + health_box_panel.height, false)
					  
	draw_set_colour(c_lime)
	draw_rectangle(x + attack_box_panel.left, y + attack_box_panel.top, x + attack_box_panel.left + attack_box_panel.width,
					  y + attack_box_panel.top + attack_box_panel.height, false)
					  
	draw_set_colour(c_yellow)
	draw_rectangle(x + description_box_panel.left, y + description_box_panel.top, x + description_box_panel.left + description_box_panel.width,
					  y + description_box_panel.top + description_box_panel.height, false)
					  
	draw_set_colour(c_teal)
	draw_rectangle(x + equipment_box_panel.left, y + equipment_box_panel.top, x + equipment_box_panel.left + equipment_box_panel.width,
					  y + equipment_box_panel.top + equipment_box_panel.height, false)
	
	draw_set_alpha(1)
}