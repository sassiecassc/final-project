/// @description Insert description here
// You can write your code in this editor

image_xscale = 3.25;
image_yscale = 3.25;
//player controls
if(keyboard_check(vk_left) and controls_enabled and knocked_out == false){ //if the player is pressing left and controls_enabled is true
	//then subtracting x_spd and move left
	x_spd -= 0.4;
} else if(keyboard_check(vk_right) and controls_enabled and knocked_out == false){ //if the player is pressing right and controls_enabled is true
	x += x_spd; //then add x_spd and move right
	x_spd += 0.4;
} else { //else slow down a bit
	x_spd *= 0.95;
}


//reset the attack timer
//if the player just attacked then
if(player_attacked == true){
	//players cannot use the attack controls
	attack_controls = false;
	
	//start the stun attack timer
	if(attack_timer > 0){
		attack_timer -= 1;
	}
	if(attack_timer <= 0){
		//after the timer the player can use the attack controls again
		attack_controls = true;
		//the player did not just attack
		player_attacked = false;
		//reset the attack timer
		attack_timer = 120;
	}
}

//if the punch key is NOT being pressed then the player is not punching
if(keyboard_check(vk_down) == false and attack_controls == true){
	punching = false;
}
//if the kick key is NOT being pressed then the player is not kicking
if(keyboard_check(vk_up) == false and attack_controls == true){
	kicking = false;
	
}

if(keyboard_check(vk_down)){
	if(attack_controls == true){
		//player can punch at any time buT if they are pressing down punch key AND colliding 
		//then a punch will count.
		sprite_index = spr_playerA_punch1; //switch to punching sprite
		punching = true;
		player_attacked = true;
	}
} else if(keyboard_check(vk_up)){
	if(attack_controls == true){
		//player can kick at any time 
		//but kick will count if they are colliding and kicking at the same time
		sprite_index = spr_playerA_kick;
		kicking = true;
		player_attacked = true;
	}
} else if(y_spd < 0){ //if not pressing space key and is moving up then 
	//sprite should be up animation
	sprite_index = spr_playerA_up;
} else if(y_spd > 0){
	//sprite should be down
	//how do i get animation smoothhhshshhshshshs
	sprite_index = spr_playerA;
}




//reference to the other player so i can knock them away
var otherplayer = obj_pA; //get first instance of player A in the scene
if(object_index == obj_pA){ //im player A
	otherplayer = obj_pB; //then player B is other player
}


//if on the left side of the player then turn the sprite so it's facing the other player the right way
if(x < otherplayer.x){
	image_xscale = -3.25;
}

//use speed to set position
x += x_spd;



//collision with other player = small bounce away from each other in opposite directions
if(place_meeting(x, y, otherplayer) and (y < 530)){
	if(player_collide == false){
		audio_play_sound(snd_collide, 0, 0);
	
		//particle sprite
		collide_sprite = instance_create_layer(x, y, "Instances", obj_collide_part);
		collide_sprite.x = x - 10;
		collide_sprite.y = y;
		collide_sprite.image_index = 0;
		collide_sprite.image_speed = 1;
	}
	player_collide = true;
}

//controls bool and timer to make sure players bounce down after collision with each other (no attacks)
if(controls_bool == true){
	controls_timer -= 1;
	if(controls_timer <= 0){
		controls_enabled = true;
		controls_bool = false;
	}
}

//setting what happens when two players collide
//stun timer is so the ricochet movement happens without player controls hindering that
if(player_collide == true){ 
	if(stun_timer > 0){ //if stun timer is greater than 0 then start the timer
		stun_timer -= 1;
		controls_enabled = false;
		
		if(stun_timer <= 0){ //if timer hits 0 then
			stun_timer = 5; //set timer back to 10
			player_collide = false;
			controls_timer = 40;
			controls_bool = true;
			//set kick sound bool to false
			played_kick_snd = false;
		}
	}
	
	if(kicking == false) and (punching == false){
		if(x > otherplayer.x){ //to the right of other player and moving left
			x_spd = 8; //move right
			y_spd = -8; //shoot player up
		} else if(x < otherplayer.x){ //to the left of the other player and moving right
			x_spd = -8; //move left
			y_spd = -8; //shoot player up
		}
	}
}


//ready to do something with this punching variable and the player collide variable
if(punching == true) and (player_collide and otherplayer.kicking == false){
	audio_play_sound(snd_punch, 0, 0);
	//if im punching AND touching the other player, then
	//knock the palyers away from each other by changing their speeds
	if(x > otherplayer.x){ //if im to the right of the other player when we collide
		//then i ricochet to the right
		x_spd = 15;
	} else { //else i must be to the left of the other player
		x_spd = -15; // i ricochet to the left
	}
	
	if(otherplayer.knocked_out == false){ //only add score once
		score_A += 1;
	}
	
	//tell the other player to be knocked out WHICH
	//lets knocked out player to fall past the bushes and no player controls
	otherplayer.knocked_out = true;
	//particle effect when knocked out
	knocked_out_part = instance_create_layer(otherplayer.x, otherplayer.y - 60, "Instances", obj_knocked_out_blue);
	knocked_out_part.image_index = 0;
	knocked_out_part.image_speed = 1;
	//setting condition for star particle effect
	show_playerwins = true;
}

//IF OTHER PLAYER IS KICKING WHILE I AM PUNCHING 
//THEN PUNCH DOES NOT WORK AND THE OTHER PLAYER HAS DEFENDED HIM/HERSELF
if(punching == true) and (player_collide and otherplayer.kicking == true){
	//they are just colliding
	audio_play_sound(snd_collide, 0, 0);
	
	if(x > otherplayer.x){ //if im to the right of the other player when we collide
		//then i ricochet to the right
		x_spd = 20;
	} else { //else i must be to the left of the other player
		x_spd = -20; // i ricochet to the left
	}
	
	blue_kick_part = instance_create_layer(x - 20, y, "Instances", obj_blue_kick);
	blue_kick_part.image_index = 0;
	blue_kick_part.image_speed = 1;
	
}


//what to do when players collide and kicking!
if(kicking == true) and (player_collide){
	//boolean if the kick sound has played or not
	//if false, play sound
	//set it false when the stun timer is 0
	if(played_kick_snd == false){
		audio_play_sound(snd_kick, 0, 0);
	}
	
	//particle sprite for kick (yellow)
	kick_sprite = instance_create_layer(x, y, "Instances", obj_kick_part);
	kick_sprite.x = otherplayer.x;
	kick_sprite.y = otherplayer.y;
	kick_sprite.image_index = 0;
	kick_sprite.image_speed = 1;
	//set kick sound bool true
	played_kick_snd = true;
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
part_emitter_region(playerwins, playerwins_emitter, otherplayer.x, otherplayer.x, y, y, 
ps_shape_diamond, ps_distr_gaussian);
if (show_playerwins == true) {
//emit 1 per frame
//tell the new emitter to stream one particle every frame
part_emitter_stream(playerwins, playerwins_emitter, playerwinspart, -10); //negative number 1 in 5 chance that particle would spawn that frame
} else {
//emit 0 per frame
part_emitter_stream(playerwins, playerwins_emitter, playerwinspart, 0);
}

//setting condition of when particle effect should stop
if(otherplayer.y >= room_height - 200){
	show_playerwins = false;
}

//animations
//if(y_spd < 0 and !punching){
//	sprite_index = spr_playerA_up;
//} else if(y_spd > 0){
	//sprite_index = spr_playerA_down;
//}






event_inherited();