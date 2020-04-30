/// @description Insert description here
// You can write your code in this editor

if(bush_hp <= 0){ //if player bounced on this bush 5 or more times then start timer
	hp_timer -= 1;
	if(hp_timer <= 380){
		x = 1000; //move bush
	}
	
	if(start_animation == false){ //if we havent started the disappearing animation then start the animation
		start_animation = true;
		sprite_index = spr_platform_disappear;
	}
}

if(hp_timer <= 0){
	start_animation = false;
	x = og_xpos;
	y = og_ypos;
	bush_hp = 3;
	hp_timer = 400;
	sprite_index = spr_platform;
}
