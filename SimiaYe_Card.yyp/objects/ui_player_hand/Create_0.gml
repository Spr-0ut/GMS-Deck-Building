#macro SPACE_BETWEEN_CARDS_IN_HAND 1

cards_in_hand = array_create(10)
is_hand_visible = true

repeat(1)
	add_card(obj_battack)

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card)
	var hand_vars = get_hand_display_variables(card_instance)
	
	var number_of_cards_in_hand = hand_vars[0]
	var total_width_of_hand = hand_vars[1]
	
	var center_of_screen = display_get_gui_width() / 2
	for(i = 0; i < number_of_cards_in_hand; i++) {
		cards_in_hand[i].x = (center_of_screen - total_width_of_hand / 2) + ((card.sprite_width + SPACE_BETWEEN_CARDS_IN_HAND) * i)
		cards_in_hand[i].y = display_get_gui_height() - cards_in_hand[i].sprite_height
	}
}

/// @desc								Loop through the player's hand to find the data needed to display the cards while adding
///											the provided card into the first open spot
/// @param {Id.Instance} card_instance	The card that is being added to the player's hand
/// @returns							Array of the number of cards in hand and the total width of the crads in hand
function get_hand_display_variables(card_instance) {
	var number_of_cards_in_hand = 0
	var total_width_of_hand = 0
	var card_has_been_saved = false
	
	for(var hand_index = 0; hand_index < array_length(cards_in_hand); hand_index++) {
		total_width_of_hand += cards_in_hand[hand_index].sprite_width + SPACE_BETWEEN_CARDS_IN_HAND
		if(!card_has_been_saved && hand_index == array_length(cards_in_hand) - 1 && cards_in_hand[hand_index] != 0) {
			array_resize(cards_in_hand, array_length(cards_in_hand) + 10)
			cards_in_hand[hand_index + 1] = card_instance
			card_has_been_saved = true
			number_of_cards_in_hand++
			break
		}
		else if(cards_in_hand[hand_index] != 0) {
			number_of_cards_in_hand++
		}
		else if(!card_has_been_saved) {
			cards_in_hand[hand_index] = card_instance
			card_has_been_saved = true
			number_of_cards_in_hand++
		}
	}
	
	return [number_of_cards_in_hand, total_width_of_hand]
}

/// @desc		Checks cards_in_hand and returns the number of filled indexes
/// @returns	The number of indexes with a card in it
function get_number_of_cards_in_hand() {
	var number_of_cards_in_hand = 0
	for(var i = 0; i < array_length(cards_in_hand); i++) {
		if(cards_in_hand[i] != 0)
			number_of_cards_in_hand++;
	}
	return number_of_cards_in_hand
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