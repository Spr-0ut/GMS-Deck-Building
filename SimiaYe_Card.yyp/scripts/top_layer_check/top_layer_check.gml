/// @desc									Checks if the provided layer is the top layer the player clicked on
/// @param {String, Id.Layer} layer_id		Your current layer (should just be able to use "layer")
/// @returns								True if provided layer is the closest layer to the camera
function is_top_layer(layer_id){
	var all_layers = layer_get_all()
	var layer_above_exists = false
	for(var layer_index = 0; layer_index < array_length(all_layers); layer_index++) {
		if(layer_get_depth(layer_id) > layer_get_depth(all_layers[layer_index])) {
			layer_above_exists = true;
			break;
		}
	}
	return !layer_above_exists
}