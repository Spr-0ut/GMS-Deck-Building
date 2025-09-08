#macro SPACE_BETWEEN_CARDS_IN_HAND 1
#macro DEFAULT_PLAYER_HAND_SIZE 6
#macro MAX_PLAYER_HAND_SIZE 16

is_hand_visible = true
card_can_be_selected = true
player_hand_size = DEFAULT_PLAYER_HAND_SIZE
cards_in_hand = array_create(player_hand_size)

initial_hand_setup()

/// @desc			Setsup the player's initial hand, adding cards to fill the player_hand_size
function initial_hand_setup() {
	for (var card_index = 0; card_index < player_hand_size; card_index++) {
		var card = instance_create_layer(x, y, "Instances", obj_battack)
		cards_in_hand[card_index] = card
	}

	set_cards_in_hand_position()
}

/// @desc			Adds cards to the player's hand until they have player_hand_size amount
function fill_player_hand() {
	var number_of_cards_in_hand = array_length(cards_in_hand)
	var num_cards_needed = player_hand_size - number_of_cards_in_hand
	if(num_cards_needed > 0) {
		repeat(num_cards_needed) {
			add_card(obj_battack)
		}
	}
}

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card)
	var number_of_cards_in_hand = array_length(cards_in_hand)
	if(number_of_cards_in_hand < MAX_PLAYER_HAND_SIZE) {
		array_push(cards_in_hand, card_instance)
		set_cards_in_hand_position()
	}
}

/// @desc			Sets the position of all of the player's cards to be at the bottom center of the screen
function set_cards_in_hand_position() {
	var number_of_cards_in_hand = array_length(cards_in_hand)
	var total_width_of_hand = get_width_of_player_hand()
	var center_of_screen = display_get_gui_width() / 2
	var left_most_card_x_pos = center_of_screen - (total_width_of_hand / 2)
	
	for(var card_index = 0; card_index < number_of_cards_in_hand; card_index++) {
		var card_offset = (cards_in_hand[card_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND) * card_index
		
		cards_in_hand[card_index].x = left_most_card_x_pos + card_offset
		cards_in_hand[card_index].y = display_get_gui_height() - cards_in_hand[card_index].sprite_height
	}
}

/// @desc			Loop through the player's hand to find the total width of all card sprites
/// @returns		The total width of the player's current hand
function get_width_of_player_hand() {
	var total_width_of_hand = 0
	
	for(var hand_index = 0; hand_index < array_length(cards_in_hand); hand_index++) {
		if(cards_in_hand[hand_index] != 0) {
			total_width_of_hand += cards_in_hand[hand_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		}
		else {
			//This shouldnt ever happen, but it will cause issues if the array isn't kept in check
			array_delete(cards_in_hand, hand_index, 1)
			hand_index--
		}
	}
	return total_width_of_hand
}

/// @desc		Makes all the cards in the player's hand visible
function show_player_hand() {
	is_hand_visible = true
	array_foreach(cards_in_hand, function(_val, _index)
	{
        _val.visible = true
	});
}

/// @desc		Hides all of the cards in the player's hand
function hide_player_hand() {
	is_hand_visible = false
	array_foreach(cards_in_hand, function(_val, _index)
	{
        _val.visible = false
	});
}