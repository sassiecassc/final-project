/// @description Insert description here
// You can write your code in this editor


cam_y = camera_get_view_y(view_camera[0]);

//clamp position to room boundaries
cam_y = max(cam_y, 0);
cam_y = min(cam_y, room_height - camera_get_view_height(view_camera[0]));

//set the position of the camera
camera_set_view_pos(view_camera[0], x, cam_y);
