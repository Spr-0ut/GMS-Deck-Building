cards_in_hand = array_create(10)
is_hand_visible = true

add_card(obj_battack)

/// @desc							Adds a specified card to the player's hand and shows it in the UI
/// @param {Asset.GMObject} card	The card that is being added to the player's hand
function add_card(card) {
	var card_instance = instance_create_layer(x, y, "Instances", card)
	card_instance.x = display_get_gui_width() / 2
	card_instance.y = display_get_gui_height() - card.sprite_height
	
	var number_of_cards_in_hand = get_number_of_cards_in_hand()
	if(array_length(cards_in_hand) < number_of_cards_in_hand + 1)
		cards_in_hand += battack;
	else
		array_resize(cards_in_hand, array_length(cards_in_hand) + 10)
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