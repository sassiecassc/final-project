/// @description Insert description here
// You can write your code in this editor

image_xscale = 1.25;
image_yscale = 1.25;


alarm[0] = 3;

if(alarm[0] > 0){
	//get cam's old pos
	var camx = camera_get_view_x(view_camera[0]);
	var camy = camera_get_view_y(view_camera[0]);
	
	//make new position by adding random amount scaled with alarm's counter
	var newx = camx + irandom_range(-1, 1);
	var newy = camy + irandom_range(-1, 1);
	
	//set new camera position
	camera_set_view_pos(view_camera[0], newx, newy);
} else {
	camera_set_view_pos(view_camera[0],0, 0);
}
//-alarm[0]*2, alarm[0]*2