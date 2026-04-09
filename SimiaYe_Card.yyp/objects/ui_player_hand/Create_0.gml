#macro SPACE_BETWEEN_CARDS_IN_HAND 0
#macro DEFAULT_PLAYER_HAND_SIZE 6
#macro MAX_PLAYER_HAND_SIZE 16
#macro CARD_DEFAULT_SCALE 3
#macro DEGREES_PER_CARD_IN_ARC 17

player_hand_size = DEFAULT_PLAYER_HAND_SIZE
cards_in_hand = array_create(0)
is_hand_visible = true
total_width_of_hand = 0
run_card_drawn_functions = false

initial_hand_setup()

/// @desc			Setsup the player's initial hand, adding cards to fill the player_hand_size
function initial_hand_setup() {
	global.player_current_deck = undefined
	global.card_min_y = infinity
	global.cards_in_hand_x_pos = array_create(MAX_PLAYER_HAND_SIZE, -1)
	global.cards_in_hand_y_pos = array_create(MAX_PLAYER_HAND_SIZE, -1)
	global.cards_in_hand_angle = array_create(MAX_PLAYER_HAND_SIZE, -1)
	fill_player_hand()
}

/// @desc			Adds cards to the player's hand until they have player_hand_size amount
function fill_player_hand() {
	var number_of_cards_in_hand = array_length(cards_in_hand)
	var num_cards_needed = player_hand_size - number_of_cards_in_hand
	if(num_cards_needed > 0) {
		if(num_cards_needed > 1) {
			var cards_to_add = array_create(num_cards_needed, -1)
			for(var card_num = 0; card_num < num_cards_needed; card_num++) {
				var drawn_card = draw_card()
				if(drawn_card == -1) {
					array_resize(cards_to_add, card_num)
					break;
				}
				else {
					cards_to_add[card_num] = drawn_card
				}
			}
			add_multiple_cards(cards_to_add)
		}
		else {
			var drawn_card = draw_card()
			if(drawn_card != -1)
				add_card(drawn_card)
		}
	}
}

/// @desc								Removes all cards from the player's hand one at a time
///											allowing the discard to finish before using this
///											function as a call back to discard the next card
/// @param {function} on_hand_emptied	Call back function triggered when the last card in the
///											player's hand is discarded
/// @param {Real} card_index			The current cards_in_hand card index
function empty_player_hand(on_hand_emptied, card_index = array_length(cards_in_hand) - 1) {
	if(card_index >= 0) {
		if(cards_in_hand[card_index].card_is_discarded_when_turn_end) {
			cards_in_hand[card_index].discard_card(
				method(self, empty_player_hand),
				[on_hand_emptied, --card_index])
		}
		else if(cards_in_hand[card_index].card_is_exhausted_when_turn_end) {
			cards_in_hand[card_index].exhaust_card(
				method(self, empty_player_hand),
				[on_hand_emptied, --card_index])
		}
		else {
			empty_player_hand(on_hand_emptied, --card_index)
		}
	}
	else {
		if(on_hand_emptied != undefined && is_method(on_hand_emptied))
			method_call(on_hand_emptied, [])
	}
}

/// @desc							Finds all the cards in the player's current hand
/// @returns						An array of the cards currently in the player's hand
function get_player_current_hand() {
	return cards_in_hand
}

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
/// @returns {bool}					True if the card was added to the player's hand or false and it was
///										returned to the top of the player's deck
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card, {
		image_xscale : CARD_DEFAULT_SCALE,
		image_yscale : CARD_DEFAULT_SCALE
	})
	var number_of_cards_in_hand = array_length(cards_in_hand)
	if(number_of_cards_in_hand < MAX_PLAYER_HAND_SIZE) {
		array_push(cards_in_hand, card_instance)
		set_cards_in_hand_position()
		card_instance.card_drawn_action()
		return true
	}
	else {
		add_card_to_top_of_player_current_deck(card)
		return false
	}
}

/// @desc							Adds multiple specified cards to the player's hand 
///										and shows it in the UI
/// @param {Array} cards			The cards that are being added to the player's hand
function add_multiple_cards(cards) {
	var current_num_cards_in_hand = array_length(cards_in_hand)
	var new_array_length = current_num_cards_in_hand + array_length(cards)
	array_resize(cards_in_hand, new_array_length)
	for(var card_index = 0; card_index < array_length(cards); card_index++) {
		var card_instance = instance_create_layer(x, y, "Instances", cards[card_index], {
		image_xscale : CARD_DEFAULT_SCALE,
		image_yscale : CARD_DEFAULT_SCALE
		})
		cards_in_hand[card_index + current_num_cards_in_hand] = card_instance
	}
	run_card_drawn_functions = true
	set_cards_in_hand_position()
}

/// @desc							Creates a copy of the given card in the player's hand
/// @param {Id.Instance} card		The card that is being copied
function add_copy_of_card_to_hand(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card.object_index, {
		image_xscale : CARD_DEFAULT_SCALE,
		image_yscale : CARD_DEFAULT_SCALE
	})
	var number_of_cards_in_hand = array_length(cards_in_hand)
	if(number_of_cards_in_hand < MAX_PLAYER_HAND_SIZE) {
		var card_index = array_get_index(cards_in_hand, card)
		if(card_index != -1)
			array_insert(cards_in_hand, card_index + 1, card_instance)
		else
			array_push(cards_in_hand, card_instance)
		set_cards_in_hand_position()
		return true
	}
	else {
		add_card_to_top_of_player_current_deck(card)
		return false
	}
}

/// @desc							Removes the given card from the players hand if it exists
/// @param {Id.Instance} card		The card that is being removed from the player's hand
function remove_card(card) {
	for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
		if (cards_in_hand[card_index].id == card.id) {
			instance_destroy(card)
			array_delete(cards_in_hand, card_index, 1)
			global.cards_in_hand_x_pos[card_index] = -1
			global.cards_in_hand_y_pos[card_index] = -1
			global.cards_in_hand_angle[card_index] = -1
			break
		}
	}
	set_cards_in_hand_position()
}

/// @desc			Sets the position of all of the player's cards to be in an arc at the bottom 
///						center of the screen, and set their image_angle to follow the arc
function set_cards_in_hand_position() {
	if(array_length(cards_in_hand) > 0) {
		get_width_of_player_hand()
		var card_initial_pos = (display_get_gui_width() - total_width_of_hand + cards_in_hand[0].sprite_width) / 2
		var cards_starting_angle = (180 - (DEGREES_PER_CARD_IN_ARC * (array_length(cards_in_hand) - 1))) / 2
		var amount_card_showing = (3 / 4 * cards_in_hand[0].sprite_height)
		
		var next_card_x = card_initial_pos
		for(var card_index = 0; card_index < array_length(cards_in_hand); card_index++) {
			if( array_length(global.cards_in_hand_x_pos) < card_index || 
				array_length(global.cards_in_hand_y_pos) < card_index ||
				array_length(global.cards_in_hand_angle) < card_index) {
					break		
			}
			
			var arc_angle_of_card = (DEGREES_PER_CARD_IN_ARC * card_index) + cards_starting_angle
			global.cards_in_hand_x_pos[card_index] = next_card_x
			global.cards_in_hand_y_pos[card_index] = display_get_gui_height() - (amount_card_showing * dsin(arc_angle_of_card))
			global.cards_in_hand_angle[card_index] = dcos(arc_angle_of_card) * DEGREES_PER_CARD_IN_ARC
			
			if(global.card_min_y > global.cards_in_hand_y_pos[card_index]) {
				global.card_min_y = global.cards_in_hand_y_pos[card_index]
			}
			
			if(cards_in_hand[card_index] != 0) {
				cards_in_hand[card_index].card_index_in_hand = card_index
				cards_in_hand[card_index].x = global.cards_in_hand_x_pos[card_index]
				cards_in_hand[card_index].y = global.cards_in_hand_y_pos[card_index]
				cards_in_hand[card_index].image_angle = global.cards_in_hand_angle[card_index]
				
				next_card_x += cards_in_hand[card_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
			}
			else {
				next_card_x += SPACE_BETWEEN_CARDS_IN_HAND	
			}
		}
	}
}

/// @desc			Loop through the player's hand to find the total width of all card sprites
function get_width_of_player_hand() {
	total_width_of_hand = 0
	
	for(var hand_index = 0; hand_index < array_length(cards_in_hand); hand_index++) {
		if(cards_in_hand[hand_index] != 0) {
			total_width_of_hand += cards_in_hand[hand_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
		else {
			//This shouldnt ever happen, but it will cause issues if the array isn't kept in check
			array_delete(cards_in_hand, hand_index, 1)
			global.cards_in_hand_x_pos[hand_index] = -1
			global.cards_in_hand_y_pos[hand_index] = -1
			global.cards_in_hand_angle[hand_index] = -1
			hand_index--
		}
	}
}

/// @desc							Runs the card_drawn_action for each of the cards in hand. This
///										is intended to only be called when the player is drawing a
///										completely new hand.
function run_card_drawn_code() {
	for(var card_index = array_length(cards_in_hand) - 1; card_index >= 0; card_index--) {
		cards_in_hand[card_index].card_drawn_action()
	}
}

/// @desc							Makes all the cards in the player's hand visible
function show_player_hand() {
	is_hand_visible = true
	array_foreach(cards_in_hand, function(_card, _index)
	{
        _card.visible = true
	});
}

/// @desc							Hides all of the cards in the player's hand
function hide_player_hand() {
	is_hand_visible = false
	array_foreach(cards_in_hand, function(_card, _index)
	{
        _card.visible = false
	});
}

/// @desc								Checks to see if any cards need to be shifted as the player moves
///											the card around in their hand
/// @param {Real} selected_card_index	The index in cards_in_hand of the card being moved around
/// @param {Real} card_x_pos			The current x position of the card being moved around
function check_for_card_swap(selected_card_index, card_x_pos) {
	if(global.cards_in_hand_x_pos[selected_card_index] < card_x_pos) {
		for(var card_index = selected_card_index + 1; card_index < array_length(cards_in_hand); card_index++) {
			if(global.cards_in_hand_x_pos[card_index] < card_x_pos) {
				swap_cards(card_index, card_index - 1)
			}
			else {
				break	
			}
		}
	}
	else if(global.cards_in_hand_x_pos[selected_card_index] > card_x_pos) {
		for(var card_index = selected_card_index - 1; card_index >= 0; card_index--) {
			if(global.cards_in_hand_x_pos[card_index] > card_x_pos) {
				swap_cards(card_index, card_index + 1)
			}
			else {
				break
			}
		}
	}
}

/// @desc								Swaps the position and angle of the cards at the given indicies,
///											as well as the position of the cards in cards_in_hand
/// @param {Real} current_index			The index of the first card to swap in cards_in_hand
/// @param {Real} index_to_swap_with	The index of the second card to swap in cards_in_hand
function swap_cards(current_index, index_to_swap_with) {
	cards_in_hand[index_to_swap_with].card_index_in_hand = current_index
	cards_in_hand[current_index].card_index_in_hand = index_to_swap_with
	
	var prev_card = cards_in_hand[index_to_swap_with]
	cards_in_hand[index_to_swap_with] = cards_in_hand[current_index]
	cards_in_hand[current_index] = prev_card
}