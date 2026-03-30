#macro CARD_ENERGY_COST_FONT				fnt_energy_cost
#macro CARD_ATTACKER_SELECTION_TYPE_FONT	fnt_attacker_selection_type
#macro CARD_DESCRIPTION_FONT				fnt_card_description
#macro PLAY_CARD_ERROR_FONT					fnt_button_font
#macro PLAY_CARD_ERROR_COLOR				make_colour_rgb(174, 0, 0)

/// @description										Creates the flexpanels for the card, with nodes for
///															card_sprite, outside_border, background,
///															attacker_selected_icon, image_box, card_type
///															description_box, and energy_box
/// @param {Real} spr_width								The width of the card sprite
/// @param {Real} spr_height							The height of the card sprite
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
/// @returns											The parent node of the flex panel
function create_card_flexpanels(spr_width, spr_height, spr_xscale = 1, spr_yscale = 1) {
	var node = flexpanel_create_node({
		name : "card_sprite",
		width : spr_width,
		height : spr_height,
		nodes : [
			{
				name : "outside_border",
				borderVertical : 1 * spr_yscale,
				borderLeft : 5 * spr_xscale,
				borderRight : 1 * spr_xscale,
				nodes : [
				{
					name : "background",
					borderHorizontal : 1 * spr_xscale,
					borderVertical : 1 * spr_yscale,
					gap : 5 * spr_yscale,
					nodes : [
					{
						name : "attacker_selected_icon",
						height : 16 * spr_yscale,
						width : 20 * spr_xscale,
						top : 2 * spr_yscale,
						left : 53 * spr_xscale,
						positionType : "absolute"
					},
					{
						name : "image_box",
						top : 22 * spr_yscale,
						height : 49 * spr_yscale
					},
					{
						name : "card_type",
						width : 15 * spr_xscale,
						height : 15 * spr_yscale,
						left : 28 * spr_xscale,
						top : 63 * spr_yscale,
						positionType : "absolute"
					},
					{
						name : "description_box",
						top : 22 * spr_yscale,
						height : 37 * spr_yscale,
						paddingHorizontal : 2 * spr_xscale,
						paddingVertical : 2 * spr_yscale
					}]
				}]
			},
			{
				name : "energy_box",
				width : 15 * spr_xscale,
				height : 19  * spr_yscale,
				marginHorizontal : 4 * spr_xscale,
				marginVertical : 6 * spr_yscale,
				positionType : "absolute"
			} 
		]
	})
	
	flexpanel_calculate_layout(node, spr_width, spr_height, flexpanel_direction.LTR)
	return node
}

#region flexPanel debug code
//This is the flex panel translated for the debug menu flex panel, it should not be uncommented as it
//		will not work out of the box, but it is very useful for seeing what it looks like.
//	NOTE for some reason it adds a 4 pixle border around everything, so it looks like its falling off
//		the bottom when it's not actually
//
//To activate the debug menu run this code: show_debug_overlay(true)
/*
{
	"name" : "card_sprite",
	"width" : 81,
	"height" : 122,
	"nodes" : [	
	{
		"name" : "outside_border",
		"borderVertical" : 1,
		"borderLeft" : 5,
		"borderRight" : 1,
		"nodes" : [
		{
			"name" : "background",
			"borderHorizontal" : 1,
			"borderVertical" : 1,
			"gap" : 5,
			"nodes" : [
			{
				"name" : "attacker_selected_icon",
				"height" : 16,
				"width" : 20,
				"top" : 2,
				"left" : 53,
				"positionType" : "absolute"
			},
			{
				"name" : "image_box",
				"top" : 22,
				"height" : 49
			},
			{
				"name" : "card_type",
				"width" : 15,
				"height" : 15,
				"left" : 28,
				"top" : 63,
				"positionType" : "absolute"
			},
			{
				"name" : "description_box",
				"top" : 22,
				"height" : 37,
				"paddingHorizontal" : 2,
				"paddingVertical" : 2
			}],
		}]
	},
	{
		"name" : "energy_box",
		"width" : 15,
		"height" : 19,
		"marginHorizontal" : 4,
		"marginVertical" : 6,
		"positionType" : "absolute"
	}]
}
*/
#endregion

/// @description										Draws the amount of energy needed to play the card
/// 														in the top left hand corner. 
/// 														NOTE: This can only be called in the draw function
/// 														otherwise it will not work
/// @param {Real} energy_cost							The energy cost to be displayed in the top left corner
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
function draw_energy_cost(energy_cost, card_flexpanels) {
	if(energy_cost >= 0) {
		draw_set_colour(c_black)
		draw_set_alpha(1)
		draw_set_font(CARD_ENERGY_COST_FONT)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
	
		var energy_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "energy_box"), false)
		var text_x_pos = x + energy_box_panel.left + (energy_box_panel.width / 2)
		var text_y_pos = y + energy_box_panel.top + ceil(energy_box_panel.height / 2)
		var text_size_scale = find_energy_cost_text_scaling(energy_box_panel)
	
		draw_text_transformed(text_x_pos, text_y_pos, energy_cost, text_size_scale, text_size_scale, 0)
	}
}

/// @description										Finds the scaling needed for the energy cost text
/// @param {Array<Id.Instance>} energy_box_panel		The panel that the energy cost will be displayed in
/// @returns											The scaling factor of the text
function find_energy_cost_text_scaling(energy_box_panel) {
	var max_string_width = energy_box_panel.width -  energy_box_panel.paddingLeft
													- energy_box_panel.paddingRight
	var max_string_height = energy_box_panel.height - energy_box_panel.paddingTop
													- energy_box_panel.paddingBottom

	var text_size_x_scale = max_string_width / string_width(energy_cost)
	var text_size_y_scale = max_string_height / string_height(energy_cost)
	if (text_size_x_scale > text_size_y_scale) {
	    return text_size_y_scale
	}
	else {
		return text_size_x_scale	
	}
}

/// @description										Finds if the card requires selecting a character, and if so
///															displays an icon in the top left corner. NOTE: This can
///															only be called in the draw function otherwise it will not work
/// @param {card_selection_target} attacker_selection_type		The card_selection_target to determine if an attacker
///																	needs to be selected by the player
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
function draw_attacker_selected_icon(attacker_selection_type, card_flexpanels, x_scale = 1, y_scale = 1) {
	if(attacker_selection_type == card_selection_target.any_class || 
		attacker_selection_type == card_selection_target.selected_class) {
		var attacker_selected_icon_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "attacker_selected_icon"), false)
		var sprite_x_pos = x + attacker_selected_icon_panel.left
		var sprite_y_pos = y + attacker_selected_icon_panel.top

		draw_sprite_stretched(spr_chara_selected_icon, -1, sprite_x_pos, sprite_y_pos, attacker_selected_icon_panel.width, attacker_selected_icon_panel.height)
	}
}

/// @description										Draws the symbol indicating which type of card this is, if 
///															it's assigned NOTE: This can only be called in the draw 
///															function otherwise it will not work
/// @param {card_type} type_of_card						The type of card being played
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
function draw_card_type(type_of_card, card_flexpanels) {
	var card_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "card_type"), false)
	var sprite_x_pos = x + card_type_panel.left
	var sprite_y_pos = y + card_type_panel.top

	if(type_of_card == card_type.attack) {
		draw_sprite_stretched(spr_attack_symbol, -1, sprite_x_pos, sprite_y_pos, card_type_panel.width, card_type_panel.height)
	}
	else if(type_of_card == card_type.ability) {
		draw_sprite_stretched(spr_ability_symbol, -1, sprite_x_pos, sprite_y_pos, card_type_panel.width, card_type_panel.height)
	}
}

/// @description										Draws the text from card_description within the
///															description_box flex panel
///															NOTE: This can only be called in the draw
///															function otherwise it will not work
/// @param {String} card_description					The text to be displayed at the bottom of the card
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
function draw_description(card_description, card_flexpanels, x_scale = 1, y_scale = 1) {
	draw_set_colour(c_black)
	draw_set_alpha(1)
	draw_set_font(CARD_DESCRIPTION_FONT)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	var scale_to_fit_description_box = find_card_description_scaling(card_description, card_flexpanels, x_scale, y_scale)
	x_scale *= scale_to_fit_description_box
	y_scale *= scale_to_fit_description_box
	
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var text_x_pos = x + description_box_panel.paddingLeft + description_box_panel.left
	var text_y_pos = y + description_box_panel.paddingTop + description_box_panel.top
	var line_seperation = string_height(card_description) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	
	var text_max_width = (description_box_panel.width - description_box_panel.paddingLeft 
														- description_box_panel.paddingRight)
														/ x_scale
														
	draw_text_ext_transformed(text_x_pos, text_y_pos, card_description, line_seperation, text_max_width, x_scale, y_scale, 0)
}

/// @desc												Calculates the scaling needed for the card's
///															description to remain in the description box
/// @param {String} card_description					The text to be scaled
/// @param {Pointer.FlexpanelNode} card_flexpanels		The parent node of the card's flex panel
/// @param {Real} x_scale								Optional horizontal scaling argument, defaulting to 1
/// @param {Real} y_scale								Optional vertical scaling argument, defaulting to 1
/// @returns {Real}										The scaling needed to fit the text. A max of 1 and
///															minimum of 0.1. NOTE: This should be used for
///															X and Y scaling
function find_card_description_scaling(card_description, card_flexpanels, x_scale = 1, y_scale = 1) {
	draw_set_font(CARD_DESCRIPTION_FONT)
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(card_flexpanels, "description_box"), false)
	var line_seperation = string_height(card_description) + PADDING_BETWEEN_CARD_DESCRIPTION_LINES
	var text_max_width = (description_box_panel.width - description_box_panel.paddingLeft 
							- description_box_panel.paddingRight)
	
	var text_scale = 1
	var text_height = string_height_ext(card_description, line_seperation, text_max_width / (text_scale * x_scale)) * y_scale
	if(text_height > description_box_panel.height) {
		while(text_scale > 0.1 && text_height > description_box_panel.height / text_scale) {
			text_scale -= 0.1
			text_height = string_height_ext(card_description, line_seperation, text_max_width / (text_scale * x_scale)) * y_scale
		}
	}
	return text_scale
}

/// @description							Shows the error prompt for when a card is attempted to be
///												played, but the player does not have enough energy
///												NOTE: This can only be called in the draw function
///												otherwise it will not work
function show_error_message(error_text) {
	draw_set_colour(PLAY_CARD_ERROR_COLOR)
	draw_set_alpha(1)
	draw_set_halign(fa_center)
	draw_set_font(PLAY_CARD_ERROR_FONT)
	var text_x_pos = display_get_gui_width() / 2
	var text_y_pos = display_get_gui_height() / 3
	draw_text(text_x_pos, text_y_pos, error_text)
}