/// @description Insert description here
// You can write your code in this editor

image_xscale = 3.25;
image_yscale = 3.25;
//player controls
if(keyboard_check(ord("A")) and controls_enabled and knocked_out == false){ //if the player is pressing left and controls_enabled is true
	//subtract x_spd and move left
	x_spd -= 0.4;
} else if(keyboard_check(ord("D")) and controls_enabled and knocked_out == false){ //if the player is pressing right and controls_enabled is true
	//add x_spd and move right
	x += x_spd;
	x_spd += 0.4;
} else { //else slow down a bit
	x_spd *= 0.95;
}

//player can punch at any time when they are pressing down punch key but it wont count unless colliding
if(keyboard_check(ord("S")) == false){
	punching = false;
}
//player can kick at any time but kick will count if they are colliding and kicking at the same time
if(keyboard_check(ord("W")) == false){
	kicking = false;
}


if(keyboard_check(ord("S"))){
	sprite_index = spr_playerB_punch1; //switch to punching sprite
	punching = true;
} else if(keyboard_check(ord("W"))){
	sprite_index = spr_playerB_kick;
	kicking = true;
}else if(y_spd < 0){ //if not pressing space key and is moving up then 
	//sprite should be up animation
	sprite_index = spr_playerB_up;
} else {
	//sprite is still
	sprite_index = spr_playerB;
}




//reference to the other player so i can knock them away
var otherplayer = obj_pB; //get first instance of player A in the scene
if(object_index == obj_pB){ //im player A
	otherplayer = obj_pA; //then player B is other player
}

//if on the right side of the player then turn the sprite so it's facing the other player the right way
if(x > otherplayer.x){
	image_xscale = -3.25;
}

//use speed to set position
x += x_spd;
	
	
//as long as the stun_timer is still going (greater than 0) then 
//players should not be able to move left or right
//if(controls_enabled == false){ //player should not be able to use controls
	
//}
	

//collision with other player = small bounce away from each other in opposite directions
if(place_meeting(x, y, otherplayer) and (y < 530)){
	if(player_collide == false){
		audio_play_sound(snd_collide, 0, 0);
	
		//particle sprite
		collide_sprite = instance_create_layer(x, y, "Instances", obj_collide_part);
		collide_sprite.x = x-10;
		collide_sprite.y = y;
		collide_sprite.image_index = 0;
		collide_sprite.image_speed = 1;
	}
	player_collide = true;
}

if(controls_bool == true){
	controls_timer -= 1;
	if(controls_timer <= 0){
		controls_enabled = true;
		controls_bool = false;
	}
}


//setting what happens when two players collide
//what is this
if(player_collide == true){ 
	if(stun_timer > 0){ //if stun timer is greater than 0 then start the timer
		stun_timer -= 1;
		controls_enabled = false;
		
		if(stun_timer <= 0){ //if timer hits 0 then
			stun_timer = 5; //set timer back to 10
			player_collide = false;
			controls_timer = 40;
			controls_bool = true;
		}
	}
	
	
	if(x > otherplayer.x){ //to the right of other player and moving left
		x_spd = 8; //move right
		y_spd = -8; //shoot player up
		//otherplayer.x_spd = -8; //move left
		//otherplayer.y_spd = -8; //shoot player up
	} else if(x < otherplayer.x){ //to the left of the other player and moving right
		x_spd = -8; //move left
		y_spd = -8; //shoot player up
		//otherplayer.x_spd = 8; //move left
		//otherplayer.y_spd = -8; //shoot player up
	}
}




//ready to do something with this punching variable and the player collide variable
if(punching == true) and (player_collide){
	audio_play_sound(snd_punch, 0, 0);
	//if im punching AND touching the other player, then
	//knock me away because i am still alive by changing my x_spd away from knocked out player
	if(x > otherplayer.x){ //if im to the right of the other player when we collide
		//then ricochet to the right
		x_spd = 15;
	} else { //else i must be to the left of the other player
		x_spd = -15; //ricochet to the left
	}
	
	//if other player wasn't knocked out yet
	if(otherplayer.knocked_out == false){ //only add score once
		score_B += 1;
	}
	
	//tell the other player to be knocked out
	otherplayer.knocked_out = true;
	
	//particle effect when knocked out
	//setting condition
	show_playerwins = true;
}

//what to do when players collide and kicking!
if(kicking == true) and (player_collide){
	audio_play_sound(snd_kick, 0, 0);
	kicking = true;
	kick_sprite = instance_create_layer(x, y, "Instances", obj_kick_part);
	kick_sprite.x = otherplayer.x;
	kick_sprite.y = otherplayer.y;
	kick_sprite.image_index = 0;
	kick_sprite.image_speed = 1;
}


//if im kicking the other player then ricochet a liitle
if(kicking == true) and (player_collide){
	if(x > otherplayer.x){ //if im to the right of the other player when we collide
		//then ricochet to the right
		x_spd = 6;
		y_spd = -3;
	} else { //else i must be to the left of the other player
		x_spd = -6; //ricochet to the left
		y_spd = -3;
	}
}

//if im being kicked then ricochet a lot
if(otherplayer.kicking == true) and (player_collide){
	if(x > otherplayer.x){ //if im to the right of the other player when we collide
		//then ricochet to the right
		x_spd = 20;
	} else { //else i must be to the left of the other player
		x_spd = -20; //ricochet to the left
	}
}

//update the position of the player wins emitter every frame to match this instance position
part_emitter_region(playerwins, playerwins_emitter, otherplayer.x, otherplayer.x, y, y, ps_shape_rectangle, ps_distr_gaussian);
if (show_playerwins == true) {
//emit 1 per frame
//tell the new emitter to stream one particle every frame
part_emitter_stream(playerwins, playerwins_emitter, playerwinspart, -10); //negative number 1 in 5 chance that particle would spawn that frame
} else {
//emit 0 per frame
part_emitter_stream(playerwins, playerwins_emitter, playerwinspart, 0);
}

//setting condition of when particle effect should stop
if(otherplayer.y >= room_height - 50){
	show_playerwins = false;
}


//animations
//if(y_spd < 0 and !punching){
//	sprite_index = spr_playerA_up;
//} else if(y_spd > 0){
	//sprite_index = spr_playerA_down;
//}

event_inherited();