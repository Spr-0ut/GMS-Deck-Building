/// @desc											Finds the distance from and the angle from the origin
///														to each of the given flexpanel's elements
/// @param {Pointer.FlexpanelNode} _flexpanel		The parent node of the card's flex panel
/// @param {Real} _origin_xoffset					The origin's offset in the x direction
/// @param {Real} _origin_yoffset					The origin's offset in the y direction
function card_element_position(_flexpanel, _origin_xoffset, _origin_yoffset) constructor{
	flexpanel = _flexpanel
	origin_xoffset = _origin_xoffset
	origin_yoffset = _origin_yoffset
	
	/// @desc									Calculates the distance and angle from the given flexpanel
	///												to the card's origin
	/// @param {Pointer.FlexpanelNode} panel	The flexpanel of the element find distance and angle for
	/// @param {Bool} center_element_in_panel	A flag to determine if the calculations should be based
	///												on the top left (false) or center (true) of the panel
	/// @returns {Array<Real, Real>}			The distance and angle, respectively, from the card's
	///												origin to the given element
	static calc_dist_and_angle_to_origin = function (panel, center_element_in_panel) {
		var x_dist_to_origin = origin_xoffset - panel.left - panel.paddingLeft
		var y_dist_to_origin = origin_yoffset - panel.top - panel.paddingTop
		if(center_element_in_panel) {
			x_dist_to_origin -= panel.width / 2
			y_dist_to_origin -= panel.height / 2
		}
		var dist_to_origin_dist = sqrt((x_dist_to_origin * x_dist_to_origin) +
											(y_dist_to_origin * y_dist_to_origin))
						
		var angle_from_origin_to_element = darccos(x_dist_to_origin / dist_to_origin_dist)
		return [dist_to_origin_dist, angle_from_origin_to_element]
	}
	
	var energy_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanel, "energy_box"), false)
	var energy_box_data = calc_dist_and_angle_to_origin(energy_box_panel, true)
	energy_box_to_origin_dist = energy_box_data[0]
	energy_box_base_angle = energy_box_data[1]
	
	var attacker_selected_icon_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanel, "attacker_selected_icon"), false)
	var attacker_selected_icon_data = calc_dist_and_angle_to_origin(attacker_selected_icon_panel, false)
	attacker_selected_icon_to_origin_dist = attacker_selected_icon_data[0]
	attacker_selected_icon_base_angle = attacker_selected_icon_data[1]
	
	var card_type_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanel, "card_type"), false)
	var card_type_data = calc_dist_and_angle_to_origin(card_type_panel, false)
	card_type_to_origin_dist = card_type_data[0]
	card_type_base_angle = card_type_data[1]
	
	var description_box_panel = flexpanel_node_layout_get_position(flexpanel_node_get_child(flexpanel, "description_box"), false)
	var description_box_data = calc_dist_and_angle_to_origin(description_box_panel, false)
	description_box_to_origin_dist = description_box_data[0]
	description_box_base_angle = description_box_data[1]
}