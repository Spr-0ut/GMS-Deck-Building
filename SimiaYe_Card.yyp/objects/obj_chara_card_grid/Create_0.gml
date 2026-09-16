#macro CHARA_CARD_GRID_PADDING		16
#macro CHARA_CARD_X_PADDING			6
#macro CHARA_CARD_Y_PADDING			6

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
create_chara_card_grid_view()

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
		unlocked_chara_cards = [new data_gilk(), new data_gilk(), new data_main()]
	}
	
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
				var chara_card_instance = instance_create_layer(0, 0, chara_card_grid_layer, chara_card_data.chara_card_index, {
					sprite_index : find_chara_card_sprite(chara_card_data.class, false),
					image_xscale,
					image_yscale,
					grid_index : chara_card_index,
					chara_card_data,
					flexpanels : new chara_card_drawn_elements(image_xscale, image_yscale)
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
		chara_card.change_chara_card_size(is_expanded_grid)
		chara_card_instances[chara_card.grid_index] = chara_card
		if(current_chara_card_filter == chara_class.all_chara) {	
			set_chara_cards_pos(chara_card_instances)
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
			set_chara_cards_pos(cards_to_show)
		}
		else {
			chara_card.visible = false
		}
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
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(y - target_grid_y < 1) {
			grid_is_moving = false
			is_expanded_grid = true
			set_chara_cards_size(false)
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
	}
	else if(grid_is_moving) {
		y = lerp(y, target_grid_y, 0.5)
		if(target_grid_y - y < 1) {
			is_expanded_grid = false
			grid_is_moving = false
			sprite_index = spr_shrunk_chara_select_grid
			set_chara_cards_size(true)
			if(instance_exists(obj_party_chara_card_box)) {
				obj_party_chara_card_box.expand_chara_card_box()
			}
		}
	}
}

/// @desc							Sets the character cards in the grid to the correct position
///										based on whether it is expanded or shrunk sprites
/// @param {Bool} shrunk_cards		Flag to determine if the cards will be the shrunk version or not
function set_chara_cards_size(shrunk_cards) {
	set_chara_cards_pos(chara_card_instances, method(self, 
		function(shrunk_cards, chara_card, chara_card_index) {
			if(chara_card != noone) {
				chara_card.change_chara_card_size(!shrunk_cards)
			}
		}), [shrunk_cards])
}

/// @desc								Removes the given character card from the grid, but leaves
///											the space open for the card to be added again later
/// @param {Id.Instance} chara_card		The character card to be removed from the grid
function empty_card_slot(chara_card) {
	if(chara_card != noone && chara_card.grid_index >= 0 && 
			chara_card.grid_index < array_length(chara_card_instances)) {
		chara_card_instances[chara_card.grid_index] = noone
	}
}

/// @desc								Filters the grid so only chara cards of the given class are shown
/// @param {Real} class_to_display		The chara_class that determines which chara cards are displayed
function filter_chara_cards(class_to_display) {
	var cards_to_show = []
	switch (class_to_display) {
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
		default:
			cards_to_show = chara_card_instances
			break
	}
	
	for(var chara_card_index = 0; chara_card_index < array_length(chara_card_instances); chara_card_index++) {
		if(chara_card_instances[chara_card_index] != noone &&
			chara_card_instances[chara_card_index].chara_card_data.class != class_to_display) {
				chara_card_instances[chara_card_index].visible = false
		}
	}
	
	set_chara_cards_pos(cards_to_show, method(self, 
		function(chara_card, chara_card_index) {
			if(!instance_exists(obj_party_chara_card_box) || 
				obj_party_chara_card_box.check_for_chara_card_in_party(chara_card) == -1) {
					chara_card.visible = true
				}
		}), [], false)
	current_chara_card_filter = class_to_display
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

/// @desc											Sets the position of the given chara cards in the grid.
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
	var first_chara_card_index = array_find_index(cards_to_position,
		function(_element, _index) {
			return  variable_instance_exists(_element, "object_index") &&
					(object_is_ancestor(_element.object_index, obj_chara_card) ||
					_element.object_index == obj_chara_card)
		})
	
	var card_sprite = spr_shrunk_damage_chara_card
	var card_x_scale = 1
	var card_y_scale = 1
	if(first_chara_card_index >= 0) {
		var first_chara_card = cards_to_position[first_chara_card_index]
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
	move_party_chara_cards = move_party_chara_cards || !instance_exists(obj_party_chara_card_box)
	
	var initial_x_pos = x + 2 * CHARA_CARD_GRID_PADDING * card_x_scale +
							(chara_card_grid_width % chara_card_width / num_columns)
	var initial_y_pos = y + (CHARA_CARD_GRID_PADDING + CHARA_CARD_Y_PADDING) * 
							card_y_scale
	
	var card_x_pos = initial_x_pos
	var card_y_pos = initial_y_pos
	for(var chara_card_index = 0; chara_card_index < array_length(cards_to_position); chara_card_index++) {
		if(is_method(on_card_index)) {
			var callback_args = array_create(array_length(on_card_index_args))
			array_copy(callback_args, 0, on_card_index_args, 0, array_length(on_card_index_args))
			array_push(callback_args, cards_to_position[chara_card_index], chara_card_index)
			
			method_call(on_card_index, callback_args)
		}
		
		var chara_card = cards_to_position[chara_card_index]
		if(chara_card != noone) {
			if(move_party_chara_cards || 
				obj_party_chara_card_box.check_for_chara_card_in_party(chara_card) == -1) {
					chara_card.x = card_x_pos
					chara_card.y = card_y_pos
					chara_card.chara_card_start_x_position = card_x_pos
					chara_card.chara_card_start_y_position = card_y_pos
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
}