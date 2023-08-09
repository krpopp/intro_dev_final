/// @description Insert description here
// You can write your code in this editor

//if we have not reached out target potision
if(abs(x - target_x) > 1)
{
	//move our x pos towards that target position
	//and make it so our card is visually above all the other cards
	x = lerp(x, target_x, 0.2);
	depth = -1000;
} 
else
{
	//if we are close to our target pos
	//set our pos to the target pos
	//and set to our target depth
	x = target_x;
	depth = target_depth;
}

//y works the same as the x
if(abs(y - target_y) > 1)
{
	y = lerp(y, target_y, 0.2);
	depth = -1000;
}
else
{
	y = target_y;
	depth = target_depth;
}

//set the card's face based on the face_index we assigned in the manager
if(face_index == 0) sprite_index = spr_red;
if(face_index == 1) sprite_index = spr_blue;
if(face_index == 2) sprite_index = spr_yellow;

//if we're not face up, just show the back
if(face_up == false) sprite_index = spr_card;

//draw the sprite (we must manually draw the sprite if we've written in the draw event)
draw_sprite(sprite_index, image_index, x, y);
