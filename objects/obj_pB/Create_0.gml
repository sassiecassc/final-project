/// @description Insert description here
// You can write your code in this editor

playerwins = part_system_create();

playerwins_emitter = part_emitter_create(playerwins);

show_playerwins = false;

playerwinspart = part_type_create();
part_type_shape(playerwinspart, pt_shape_star);
part_type_size(playerwinspart, 0.08, 0.2, 0.01, 0.1);
part_type_color1(playerwinspart, c_red); //other player gets knocked out