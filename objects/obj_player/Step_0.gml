/// @description Insert description here
// You can write your code in this editor

//image_xscale = 3.25;
image_yscale = 3.25;


//change x pos of player using spd variable
//x += x_spd;
y += y_spd;

//accelerate from gravity; player can fall down
y_spd += grav;


//slow down player a little every frame to make it easier to control
x_spd = x_spd * 0.9;



//wall collision (screen borders)
if(x < 20){ //left wall
x = 20; //put them on the left wall
x_spd = -1 * x_spd;
}

//wall collision (screen borders)
if(x > room_width-40){ //right wall
x = room_width-40 //put them on the right wall
x_spd = -1 * x_spd;
}



//collision with bushes
//when player bounces on bush, damage animation should play; should play after colliding and play fully 
if(y_spd > 0){ //if player is moving down
	if(place_meeting(x, y, obj_platform) and !knocked_out and !respawn){ //and if it overlaps the bush and the player hasn't been knocked out
		var bush = instance_place(x, y, obj_platform);
		//bush.damaged_bush = true;
		if(bush != noone){
			if(bush.bush_hp > 0){ //if this specific bush's hp is greater than 3
				bush.bush_hp -= 1; //then subtract one after colliding with it
				//then have the player bounce back up if the bush is "alive"
				y_spd = jump_spd;
			} if(bush.bush_hp == 1){
				//change sprite so it's damaged
				bush.sprite_index = spr_platform_damaged;
			}
		} //else {
			//bush.damaged_bush = false;
		//}
	}
}


//collision with floor after being knocked out; respawn player
//bool respawn pertains to after player is knocked out so it should include being shot back up but not the timer?


if(respawn == true){
	y_spd = jump_spd * 1.5; //this is condition of respawn = true;
}

if(place_meeting(x, y, obj_floor)){
	y_spd = 0;
	if(respawn_timer > 0){
		respawn_timer -= 1;
	}
	if(respawn_timer <= 0){
		respawn = true;
		respawn_timer = 60;
		//player comes back up
		y -= 20;
		//randomize x position of player 
		x = random_range(45, room_width-45);
	}
}

//when should respawn become false? this will lead to working player controls and regular bush collisions and have grav
if(y < 420) and (respawn == true){
	respawn = false;
	knocked_out = false;
}


//collision with ceiling
if(y <= 0){ //if player is moving up
	if(place_meeting(x, y, obj_ceiling)){
		y_spd = -jump_spd;
	}
}


