/// @description Insert description here
// You can write your code in this editor

if(bush_hp == 0){
	if(bush_disappear_timer > 0){
		//start timer
		bush_disappear_timer -= 1;
		//change animation to disappearing animation
		sprite_index = spr_platform_disappear;
	}	
}

//if player bounced on this bush 3 or more times then start timer
if(bush_hp <= 0) and (bush_disappear_timer <= 0){ 
	hp_timer -= 1;
	if(hp_timer <= 380){
		x = 1000; //move bush
	}
}

//hp timer is for the platform to come back when it hits 0 and platforms reappear at original position
//if its time to bring platform back
if(hp_timer <= 0){
	x = og_xpos;
	y = og_ypos;
	sprite_index = spr_platform;
	
	//reset everything
	bush_hp = 3;
	hp_timer = 400;
	bush_disappear_timer = 12;
}

