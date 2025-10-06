// Inherit the parent event
event_inherited();

/// @desc								Sorts 2 cards by determining which costs more
/// @param {Asset.GMObject} card1		The card at the lower index
/// @param {Asset.GMObject} card2		The card at the higher index
/// @returns							Integer that determines the sort order (<= -1: card1 goes before card2,
///										0: card1 and card2 are equal price, >= 1: card1 goes after card2
function sort_cards(card1, card2) {
	//TODO right now this wont work due to cards not having an associated cost. once that is implemented
	//		this should be ready, but I havent tested it
	//if (is_sort_ascending) {
	//	return card2.cost - card1.cost 
	//}
	//else {
	//	return card1.cost - card2.cost 
	//}
	return 0
}