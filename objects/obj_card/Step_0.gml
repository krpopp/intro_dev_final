/// @description Insert description here
// You can write your code in this editor

//if this card is in the player's hand and is not face up
if(in_player_hand && !face_up)
{
	//if the mouse is over this card and the player hasn't selected 2 cards
	if(position_meeting(mouse_x, mouse_y, id) && ds_list_size(obj_manager.player_face_up) < 2)
	{
		//bump up the card a little so the player knows they can select this card
		target_y = room_height * 0.75;
		
		//if they player presses the left mouse button
		if(mouse_check_button_pressed(mb_left))
		{
			//the card is now face up
			face_up = true;
			//add it to the face up list
			ds_list_add(obj_manager.player_face_up, id);
		}
	} 
	else
	{
		//if the player cannot select the card or isn't hovering on it, 
		//bump the card down to its original position
		target_y = room_height * 0.8;
	}
}

