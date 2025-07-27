var battack = instance_create_layer(x,y,"Instances",obj_battack)
var hand_y_pos = display_get_gui_height() - obj_battack.sprite_height
var hand_x_pos = display_get_gui_width() / 2

battack.x = hand_x_pos;
battack.y = hand_y_pos;