#macro CHARA_CARD_GRID_PADDING		16
#macro CHARA_CARD_X_PADDING			6
#macro CHARA_CARD_Y_PADDING			16

chara_card_instances = []
damage_chara_cards = []
mech_chara_cards = []
potion_chara_cards = []
science_chara_cards = []
tank_chara_cards = []

current_chara_card_filter = chara_class.all_chara
chara_cards_to_display = get_unlocked_chara_cards()
chara_card_grid_layer = layer_create(layer_get_depth(layer) - 1, "chara_card_grid_instance")
is_expanded_grid = false
grid_is_moving = false
target_grid_y = y
chara_card_grid_scroll_bar = noone
chara_card_grid_surface = surface_create(sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale),
										 sprite_height - (CHARA_CARD_GRID_PADDING * image_yscale))
create_chara_card_grid_view()
remove_unused_chara_card_filters()

/// @desc							Finds if there has been any data_chara created before, and if so returns
///										the chara's data. Otherwise returns a default set of data
/// @returns {Array<data_chara>}	The data structs for the currently unlocked characters
function get_unlocked_chara_cards() {
	var chara_data_struct = new data_chara(-1)
	var unlocked_chara_cards = []
	if(struct_exists(chara_data_struct, "chara") && array_length(chara_data_struct.get_all_chara_data()) > 0) {
		unlocked_chara_cards = chara_data_struct.get_all_chara_data()
	}
	else {
		unlocked_chara_cards = [
		new data_test_tank_class(), new data_test_tank_class(),
		new data_test_tank_class(), new data_test_tank_class(), new data_test_tank_class(),
		new data_test_science_class(), new data_test_science_class(), 
		new data_test_potion_class(), new data_test_potion_class(), new data_test_potion_class(),
		new data_main(),
		new data_gilk(), new data_gilk(), 
		]
	}
	
	array_sort(unlocked_chara_cards, function(current, next) {
		if(is_instanceof(current, data_chara) && is_instanceof(next, data_chara)) {
			return current.chara_id - next.chara_id
		}
		else {
			return is_instanceof(next, data_chara) - is_instanceof(current, data_chara)
		}
	})
	return unlocked_chara_cards
}

/// @desc							Creates a grid of the character cards in chara_cards_to_display
///										and saves them to chara_card_instances
function create_chara_card_grid_view() {
	if(array_length(chara_cards_to_display) > 0) {
		if(chara_card_grid_layer == -1) {
			var chara_card_layer_name = "chara_card_grid_instance"
			chara_card_grid_layer = layer_get_id(chara_card_layer_name)
			if(chara_card_grid_layer == -1) {
				chara_card_grid_layer = layer_create(layer_get_depth(layer) - 1, chara_card_layer_name)
			}
		}
		
		chara_card_instances = array_create(array_length(chara_cards_to_display))
		set_chara_cards_pos(chara_card_instances, method(self, 
			function(chara_card, chara_card_index) {
				var chara_card_data = chara_cards_to_display[chara_card_index]
				var chara_card_instance = instance_create_layer(0, 0, chara_card_grid_layer, obj_chara_card, {
					sprite_index : find_chara_card_sprite(chara_card_data.class, false),
					image_xscale,
					image_yscale,
					grid_index : chara_card_index,
					chara_card_data,
					flexpanels : new chara_card_drawn_elements(image_xscale, image_yscale, chara_card_grid_surface, x + (CHARA_CARD_GRID_PADDING * image_xscale), y + (CHARA_CARD_GRID_PADDING * image_yscale)),
					card_is_expanded : false
				})
			
				chara_card_instances[chara_card_index] = chara_card_instance
			
				switch (chara_card_data.class) {
					case chara_class.science:
						array_push(science_chara_cards, chara_card_instance)
						break
					case chara_class.damage:
						array_push(damage_chara_cards, chara_card_instance)
						break
					case chara_class.mech:
						array_push(mech_chara_cards, chara_card_instance)
						break
					case chara_class.potion:
						array_push(potion_chara_cards, chara_card_instance)
						break
					case chara_class.tank:
						array_push(tank_chara_cards, chara_card_instance)
						break
				}
			}))
	}
}

/// @desc									Creates the scroll bar for the chara card grid
/// @param {Real} chara_card_height			The height of each row of the grid scrolled
/// @param {Real} grid_height				The total height of the grid being scrolled
/// @param {Real} num_columns				The number of columns in the grid
function create_chara_card_scroll_bar(chara_card_height, grid_height, num_columns, scrollable_objects = chara_card_instances) {
	var bar_sprite_height = sprite_get_height(object_get_sprite(ui_obj_grid_scrollbar))
	var bar_sprite_y_scale = (sprite_height - SCROLL_BAR_PADDING) / bar_sprite_height
	var bar_x_pos = x + sprite_width + SCROLL_BAR_PADDING
	var bar_y_pos = y + (SCROLL_BAR_PADDING * bar_sprite_y_scale)
	
	var scrollable_objects_copy = array_create(array_length(scrollable_objects))
	array_copy(scrollable_objects_copy, 0, scrollable_objects, 0, array_length(scrollable_objects))
	scrollable_objects = scrollable_objects_copy
	
	if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
		chara_card_grid_scroll_bar.objects_to_move = scrollable_objects
		var num_rows = ceil(array_length(scrollable_objects) / num_columns)
		resize_chara_card_scroll_bar(y, num_rows, chara_card_height)
	}
	else {
		var scroll_bar_layer_name = "chara_card_scroll_instance"
		var scroll_bar_layer_id = layer_get_id(scroll_bar_layer_name)
		if(scroll_bar_layer_id == -1) {
			var scroll_bar_grid_depth = layer_get_depth(layer) - 1
			scroll_bar_layer_id = layer_create(scroll_bar_grid_depth, scroll_bar_layer_name)
		}
	
		chara_card_grid_scroll_bar = instance_create_layer(bar_x_pos, bar_y_pos, scroll_bar_layer_id, ui_obj_grid_scrollbar, {
			image_yscale : bar_sprite_y_scale,
			objects_to_move: scrollable_objects,
			scrollable_list_height : grid_height,
			row_height : chara_card_height,
			num_columns,
			viewable_window_height : surface_get_height(chara_card_grid_surface)
		})
	}
}

/// @desc									Updates the scrollbar to a new size and updates its scroll
/// @param {Real} scroll_bar_y				New y position of the scrollbar
/// @param {Real} num_rows					The number of rows the scroll bar moves
/// @param {Real} row_height				The height of each row of the grid scrolled
function resize_chara_card_scroll_bar(scroll_bar_y, num_rows, row_height) {
	if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
		var bar_sprite_height = sprite_get_height(object_get_sprite(ui_obj_grid_scrollbar))
		var bar_sprite_y_scale = (room_height - scroll_bar_y - 2 * SCROLL_BAR_PADDING) / bar_sprite_height
		var bar_y_pos = scroll_bar_y + (SCROLL_BAR_PADDING * bar_sprite_y_scale)
		var scroll_view_window = room_height - scroll_bar_y - (CHARA_CARD_GRID_PADDING * image_yscale)
		
		chara_card_grid_scroll_bar.update_scroll_data(bar_y_pos, bar_sprite_y_scale,
														row_height * num_rows, row_height,
														undefined, scroll_view_window)
	}
}

/// @desc									Adds the given chara_card to it's appropriate class array
/// @param {Id.Instance} chara_card			The character card being added to the class array
/// @param {Real} chara_card_class			The character's class
function add_chara_card_to_class_array(chara_card, chara_card_class) {
	switch (chara_card_class) {
		case chara_class.science:
			array_push(science_chara_cards, chara_card)
			break
		case chara_class.damage:
			array_push(damage_chara_cards, chara_card)
			break
		case chara_class.mech:
			array_push(mech_chara_cards, chara_card)
			break
		case chara_class.potion:
			array_push(potion_chara_cards, chara_card)
			break
		case chara_class.tank:
			array_push(tank_chara_cards, chara_card)
			break
	}
}

/// @desc									Destroys the class filters that have no chara cards
function remove_unused_chara_card_filters() {
	if(array_length(science_chara_cards) == 0 && instance_exists(obj_science_chara_cards_filter)) {
		instance_destroy(obj_science_chara_cards_filter)
	}
	if(array_length(damage_chara_cards) == 0 && instance_exists(obj_damage_chara_cards_filter)) {
		instance_destroy(obj_damage_chara_cards_filter)
	}
	if(array_length(mech_chara_cards) == 0 && instance_exists(obj_mech_chara_cards_filter)) {
		instance_destroy(obj_mech_chara_cards_filter)
	}
	if(array_length(potion_chara_cards) == 0 && instance_exists(obj_potion_chara_cards_filter)) {
		instance_destroy(obj_potion_chara_cards_filter)
	}
	if(array_length(tank_chara_cards) == 0 && instance_exists(obj_tank_chara_cards_filter)) {
		instance_destroy(obj_tank_chara_cards_filter)
	}
}

/// @desc									Searches the chara_card_instances to find any character cards
///												with this given character ids
/// @param {Array<Real>} chara_ids_to_find	The ids of the character to match the card to
/// @returns {Array<Id.Instance>}			An array of all the character cards that match the given ids
function find_chara_cards_by_chara_id(chara_ids_to_find) {
	var chara_cards_found = array_create(array_length(chara_ids_to_find), noone)
	for(var chara_card_index = 0; chara_card_index < array_length(chara_card_instances); chara_card_index++) {
		var cur_chara_card = chara_card_instances[chara_card_index]
		for(var chara_id_index = 0; chara_id_index < array_length(chara_ids_to_find); chara_id_index++) {
			if(chara_ids_to_find[chara_id_index].chara_id == cur_chara_card.chara_card_data.chara_id) {
				chara_cards_found[chara_id_index] = cur_chara_card
			}
		}
	}
	return chara_cards_found
}

/// @desc								Returns the given card back into the chara card grid display,
///											hiding it if its class does not match the active filter.
///											NOTE: This assumes it existed in the grid before and is
///											being placed back into the grid, NOT adding a new card
/// @param {Id.Instance} chara_card		The chara card to be placed in the grid
function return_chara_card_to_grid(chara_card) {
	if(typeof(chara_card) == "ref" && chara_card != noone && instance_exists(chara_card)) {
		chara_card.set_chara_card_size(is_expanded_grid)
		chara_card_instances[chara_card.grid_index] = chara_card
		chara_card.flexpanels.set_draw_to_surface(true, chara_card_grid_surface)
		if(current_chara_card_filter == chara_class.all_chara) {
			set_chara_card_grid_pos(chara_card, chara_card.grid_index)
		}
		else if(current_chara_card_filter == chara_card.chara_card_data.class) {
			var cards_to_show = []
			switch (current_chara_card_filter) {
				case chara_class.science:
					cards_to_show = science_chara_cards
					break
				case chara_class.damage:
					cards_to_show = damage_chara_cards
					break
				case chara_class.mech:
					cards_to_show = mech_chara_cards
					break
				case chara_class.potion:
					cards_to_show = potion_chara_cards
					break
				case chara_class.tank:
					cards_to_show = tank_chara_cards
					break
			}
			var card_index = array_get_index(cards_to_show, chara_card)
			set_chara_card_grid_pos(chara_card, card_index)
		}
		else {
			chara_card.visible = false
		}
	}
}

/// @desc								Sets the chara_card's position based on it's chara_card_index
/// @param {Id.Instance} chara_card		The character card to positon
/// @param {Real} chara_card_index		The index in the grid to position the chara_card at
function set_chara_card_grid_pos(chara_card, chara_card_index) {
	if(typeof(chara_card) == "ref" && typeof(chara_card_index) == "number" && chara_card_index >= 0) {
		var chara_card_pos_data = find_chara_card_pos_data()
		var y_shift_from_scroll = 0
		if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
			y_shift_from_scroll = chara_card_grid_scroll_bar.find_y_shift_from_scroll()
			chara_card_grid_scroll_bar.objects_to_move[chara_card_index] = chara_card
		}
	
		var column_index = chara_card_index % chara_card_pos_data.num_columns
		var row_index = floor((chara_card_index) / chara_card_pos_data.num_columns)
		var card_x_pos = chara_card_pos_data.initial_x_pos + column_index * chara_card_pos_data.x_shift_per_card
		var card_y_pos = chara_card_pos_data.initial_y_pos + row_index * chara_card_pos_data.y_shift_per_card
								
		chara_card.x = card_x_pos
		chara_card.y = card_y_pos - y_shift_from_scroll
		chara_card.chara_card_start_x_position = card_x_pos
		chara_card.chara_card_start_y_position = card_y_pos - y_shift_from_scroll
		chara_card.xstart = card_x_pos
		chara_card.ystart = card_y_pos
		chara_card.flexpanels.set_chara_card_surface_pos(
							x + (CHARA_CARD_GRID_PADDING * image_xscale),
							target_grid_y + (CHARA_CARD_GRID_PADDING * image_yscale))
	}
}

/// @desc							Handles expanding the character card grid each frame
function expand_chara_card_grid() {
	if(!grid_is_moving && !is_expanded_grid) {
		sprite_index = spr_expanded_chara_select_grid
		var amount_grid_grows = (sprite_get_height(spr_expanded_chara_select_grid) -
								 sprite_get_height(spr_shrunk_chara_select_grid)) *
								 image_yscale
		target_grid_y = y - amount_grid_grows
		grid_is_moving = true
		set_chara_cards_size(true, target_grid_y)
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(y - target_grid_y < 1) {
			grid_is_moving = false
			is_expanded_grid = true
			y = target_grid_y
			if(surface_exists(chara_card_grid_surface)) {
				surface_resize(chara_card_grid_surface, sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale),
									sprite_height - (CHARA_CARD_GRID_PADDING * image_yscale))
			}
			else {
				chara_card_grid_surface = surface_create(sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale),
										 sprite_height - (CHARA_CARD_GRID_PADDING * image_yscale))	
			}
			
			if(instance_exists(obj_party_chara_card_box)) {
				obj_party_chara_card_box.shrink_chara_card_box()
			}
		}
	}
}

/// @desc							Handles shrinking the character card grid each frame
function shrink_chara_card_grid() {
	if(!grid_is_moving && is_expanded_grid) {
		var amount_grid_shrinks = (sprite_get_height(spr_expanded_chara_select_grid) - sprite_get_height(spr_shrunk_chara_select_grid)) *
									image_yscale
		target_grid_y = y + amount_grid_shrinks
		grid_is_moving = true
		set_chara_cards_size(false, target_grid_y)
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(target_grid_y - y < 1) {
			is_expanded_grid = false
			grid_is_moving = false
			y = target_grid_y
			sprite_index = spr_shrunk_chara_select_grid
			if(surface_exists(chara_card_grid_surface)) {
				surface_resize(chara_card_grid_surface, sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale),
									sprite_height - (CHARA_CARD_GRID_PADDING * image_yscale))
			}
			else {
				chara_card_grid_surface = surface_create(sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale),
										 sprite_height - (CHARA_CARD_GRID_PADDING * image_yscale))	
			}
			if(instance_exists(obj_party_chara_card_box)) {
				obj_party_chara_card_box.expand_chara_card_box()
			}
		}
	}
}

/// @desc							Alerts the character cards that they are changing size and finds
///										their new positions
/// @param {Bool} expand_cards		Flag to determine if the cards will be the shrunk version or not
/// @param {Real} target_grid_y		The y position of the grid once it is done moving
function set_chara_cards_size(expand_cards, target_grid_y) {
	//Please note: This function was copied and modified from set_chara_cards_pos, the changes here
	///					were too significant to work with this function, but changes to one should
	///					be considered in the other. Otherwise changing the grid size will cause issues
	var card_sprite = find_chara_card_sprite(chara_class.all_chara, expand_cards)
	var cards_to_show = find_class_filtered_cards(current_chara_card_filter)

	var first_chara_card_index = array_find_index(cards_to_show,
		function(_element, _index) {
			return  variable_instance_exists(_element, "object_index") &&
					(object_is_ancestor(_element.object_index, obj_chara_card) ||
					_element.object_index == obj_chara_card)
		})
	var card_x_scale = cards_to_show[first_chara_card_index].image_xscale
	var card_y_scale = cards_to_show[first_chara_card_index].image_yscale
	
	//This assumes the cards will always be the same size. As of right now that's true and to make it
	//	more generic would result in a potentially worse solution
	var chara_card_width = (sprite_get_width(card_sprite) + (2 * CHARA_CARD_X_PADDING)) * card_x_scale
	var chara_card_height = (sprite_get_height(card_sprite) + (2 * CHARA_CARD_Y_PADDING)) * card_y_scale
	var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
	var num_columns = floor(chara_card_grid_width / chara_card_width)
	
	var initial_x_pos = x + CHARA_CARD_GRID_PADDING * card_x_scale +
							(chara_card_grid_width % chara_card_width / num_columns)
	var initial_y_pos = target_grid_y + (CHARA_CARD_GRID_PADDING + CHARA_CARD_Y_PADDING) * 
							card_y_scale
							
	var party_cards = []
	if(instance_exists(obj_party_chara_card_box)) {
		party_cards = instance_find(obj_party_chara_card_box, 0).current_party_chara	
	}
	
	for(var chara_card_index = 0; chara_card_index < array_length(chara_card_instances); chara_card_index++) {
		var cur_chara_card = chara_card_instances[chara_card_index]
		
		if(cur_chara_card != noone && !array_contains(cards_to_show, cur_chara_card)) {
			cur_chara_card.change_chara_card_size(expand_cards, 0, 0)
			cur_chara_card.flexpanels.set_chara_card_surface_pos(x + (CHARA_CARD_GRID_PADDING * image_xscale), target_grid_y + (CHARA_CARD_GRID_PADDING * image_yscale))
		}
	}
	
	var card_x_pos = initial_x_pos
	var card_y_pos = initial_y_pos
	for(var chara_card_index = 0; chara_card_index < array_length(cards_to_show); chara_card_index++) {
		var chara_card = cards_to_show[chara_card_index]
		if(chara_card != noone && !array_contains(party_cards, chara_card)) {
			chara_card.change_chara_card_size(expand_cards, card_x_pos, card_y_pos)
			if(typeof(chara_card.flexpanels) == "struct") {
				chara_card.flexpanels.set_chara_card_surface_pos(x + (CHARA_CARD_GRID_PADDING * image_xscale),
													target_grid_y + (CHARA_CARD_GRID_PADDING * image_yscale))
			}
		}
		
		if((chara_card_index + 1) % num_columns == 0) {
			card_x_pos = initial_x_pos
			card_y_pos += chara_card_height
		}
		else {
			card_x_pos += chara_card_width + (chara_card_grid_width % chara_card_width / num_columns)	
		}
	}
	
	var num_rows = ceil(array_length(cards_to_show) / num_columns)
	resize_chara_card_scroll_bar(target_grid_y, num_rows, chara_card_height)
}

/// @desc								Removes the given character card from the grid, but leaves
///											the space open for the card to be added again later
/// @param {Id.Instance} chara_card		The character card to be removed from the grid
function empty_card_slot(chara_card) {
	if(chara_card != noone && chara_card.grid_index >= 0 && 
			chara_card.grid_index < array_length(chara_card_instances)) {
		chara_card_instances[chara_card.grid_index] = noone
		if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
			var chara_card_scroll_index = array_get_index(chara_card_grid_scroll_bar.objects_to_move, chara_card)
			chara_card_grid_scroll_bar.objects_to_move[chara_card_scroll_index] = noone
		}
	}
}

/// @desc								Filters the grid so only chara cards of the given class are shown
/// @param {Real} class_to_display		The chara_class that determines which chara cards are displayed
function filter_chara_cards(class_to_display) {
	for(var chara_card_index = 0; chara_card_index < array_length(chara_card_instances); chara_card_index++) {
		if(chara_card_instances[chara_card_index] != noone &&
			chara_card_instances[chara_card_index].chara_card_data.class != class_to_display) {
				chara_card_instances[chara_card_index].visible = false
		}
	}
	
	var cards_to_show = find_class_filtered_cards(class_to_display)
	set_chara_cards_pos(cards_to_show, method(self, 
		function(chara_card, chara_card_index) {
			if(!instance_exists(obj_party_chara_card_box) || 
				obj_party_chara_card_box.check_for_chara_card_in_party(chara_card) == -1) {
					chara_card.visible = true
				}
		}), [], false)
	current_chara_card_filter = class_to_display
}

/// @desc								Finds an array of all the chara_card_instances of the given class
/// @param {Real} class_to_find			The chara_class to find the character cards for
/// @returns {Array<Id.Instance>}		The array of all the character cards of the given class
function find_class_filtered_cards(class_to_find) {
	switch (class_to_find) {
		case chara_class.science:
			return science_chara_cards
		case chara_class.damage:
			return damage_chara_cards
		case chara_class.mech:
			return mech_chara_cards
		case chara_class.potion:
			return potion_chara_cards
		case chara_class.tank:
			return tank_chara_cards
		default:
			return chara_card_instances
	}	
}

/// @desc								Clears any active filters, and displays all chara cards
function clear_filter() {
	set_chara_cards_pos(chara_card_instances, method(self, 
		function(chara_card, chara_card_index) {
			if(chara_card != noone) {
				chara_card.visible = true
			}
		}), [], false)
	current_chara_card_filter = chara_class.all_chara
}

/// @desc											Sets the position of the given chara cards in the grid
///														and resets the scroll with the updated card grid.
///														NOTE: This assumes that the only cards in the grid
///														are the ones given in cards_to_position
/// @param {Array<Id.Instance>} cards_to_position	The array of cards to be positioned in order
/// @param {Method} on_card_index					The optional call back function right before the card
///														is moved
/// @param {Array} on_card_index_args				The parameters for on_card_index call back function.
///														NOTE: The chara card and its cards_to_position  
///														index will be added to the end of this array
/// @param {Bool} move_party_chara_cards			Optional flag to determine if the cards are allowed
///														to move if it's in the party. Defaults to true
function set_chara_cards_pos(cards_to_position, on_card_index = noone, on_card_index_args = [], move_party_chara_cards = true) {
	var card_pos_data = find_chara_card_pos_data()
	move_party_chara_cards = move_party_chara_cards || !instance_exists(obj_party_chara_card_box)
	
	var card_x_pos = card_pos_data.initial_x_pos
	var card_y_pos = card_pos_data.initial_y_pos
	for(var chara_card_index = 0; chara_card_index < array_length(cards_to_position); chara_card_index++) {
		if(is_method(on_card_index)) {
			var callback_args = array_create(array_length(on_card_index_args))
			array_copy(callback_args, 0, on_card_index_args, 0, array_length(on_card_index_args))
			array_push(callback_args, cards_to_position[chara_card_index], chara_card_index)
			
			method_call(on_card_index, callback_args)
		}
		
		var chara_card = cards_to_position[chara_card_index]
		if(chara_card != noone) {
			if(!move_party_chara_cards && obj_party_chara_card_box.check_for_chara_card_in_party(chara_card) != -1) {
				cards_to_position[chara_card_index] = noone
			}
			else {
				chara_card.x = card_x_pos
				chara_card.y = card_y_pos
				chara_card.chara_card_start_x_position = card_x_pos
				chara_card.chara_card_start_y_position = card_y_pos
				chara_card.xstart = card_x_pos
				chara_card.ystart = card_y_pos
				chara_card.flexpanels.set_chara_card_surface_pos(
									x + (CHARA_CARD_GRID_PADDING * image_xscale),
									target_grid_y + (CHARA_CARD_GRID_PADDING * image_yscale))
			}
		}
		
		if((chara_card_index + 1) % card_pos_data.num_columns == 0) {
			card_x_pos = card_pos_data.initial_x_pos
			card_y_pos += card_pos_data.y_shift_per_card
		}
		else {
			card_x_pos += card_pos_data.x_shift_per_card
		}
	}
	
	var grid_height = card_y_pos + card_pos_data.y_shift_per_card - card_pos_data.initial_y_pos
	if(grid_height > surface_get_height(chara_card_grid_surface)) {
		create_chara_card_scroll_bar(card_pos_data.y_shift_per_card, grid_height, card_pos_data.num_columns, cards_to_position)
	}
	else if(chara_card_grid_scroll_bar != noone && instance_exists(chara_card_grid_scroll_bar)) {
		instance_destroy(chara_card_grid_scroll_bar)
		chara_card_grid_scroll_bar = noone
	}
}

/// @desc								Finds or calculates the required data to position character
///											cards on the grid
/// @returns {Struct}					The struct containing the initial_x_pos, initial_y_pos,
///											x_shift_per_card, y_shift_per_card, and num_columns
function find_chara_card_pos_data() {
	var first_chara_card_index = array_find_index(chara_card_instances,
		function(_element, _index) {
			return  variable_instance_exists(_element, "object_index") &&
					(object_is_ancestor(_element.object_index, obj_chara_card) ||
					_element.object_index == obj_chara_card)
		})
	
	var card_sprite = spr_shrunk_damage_chara_card
	var card_x_scale = 1
	var card_y_scale = 1
	if(first_chara_card_index >= 0) {
		var first_chara_card = chara_card_instances[first_chara_card_index]
		card_sprite = first_chara_card.sprite_index
		card_x_scale = first_chara_card.image_xscale
		card_y_scale = first_chara_card.image_yscale
	}
	
	//This assumes the cards will always be the same size. As of right now that's true and to make it
	//	more generic would result in a potentially worse solution
	var chara_card_width = (sprite_get_width(card_sprite) + (2 * CHARA_CARD_X_PADDING)) * card_x_scale
	var chara_card_height = (sprite_get_height(card_sprite) + (2 * CHARA_CARD_Y_PADDING)) * card_y_scale
	var chara_card_grid_width = sprite_width - (2 * CHARA_CARD_GRID_PADDING * image_xscale)
	var num_columns = floor(chara_card_grid_width / chara_card_width)
	
	var initial_x_pos = x + CHARA_CARD_GRID_PADDING * card_x_scale +
							(chara_card_grid_width % chara_card_width / num_columns)
	var initial_y_pos = target_grid_y + (CHARA_CARD_GRID_PADDING + CHARA_CARD_Y_PADDING) * 
							card_y_scale
	var x_shift_per_card = chara_card_width + (chara_card_grid_width % chara_card_width / num_columns)
	var y_shift_per_card = chara_card_height
							
	return {initial_x_pos, initial_y_pos, x_shift_per_card, y_shift_per_card, num_columns}
}