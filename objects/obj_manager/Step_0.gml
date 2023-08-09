/// @description Insert description here
// You can write your code in this editor

//this switch statement is like a very long if/else chain
//it allows our state machine to be a bit cleaner

switch(state)
{
	case state_deal:
		//wait a few frames between moving cards
		if(move_timer == 0)
		{
			//check how many cards are in the player's hand
			var _player_num = ds_list_size(player_hand);
			
			//if it's less than 4
			if(_player_num < 4)
			{
				//get the last card in the deck list
				//var _dealt_card = deck[| ds_list_size(deck) - 1];
				var _dealt_card = ds_list_find_value(deck, ds_list_size(deck) - 1);
		
				//remove the card from the deck
				ds_list_delete(deck, ds_list_size(deck) - 1);
				//add it to the player's hand
				ds_list_add(player_hand, _dealt_card);
		
				//set the card's taget positon in the player's hand area
				scr_set_pos(_dealt_card, room_width/4 + _player_num * hand_x_offset, room_height * 0.8);
		
				//let the card know it's now in the player's hand
				_dealt_card.in_player_hand = true;
			} else
			{
				//once the player has 4 cards, go to the match state
				state = state_match;
			}
		}
		break;
	case state_match:
		//if the player has selected two cards
		//(this is set in the card obj)
		if(ds_list_size(player_face_up) == 2)
		{
			//go to the compare state
			state = state_compare;
		}
		break;
	case state_compare:
		
		wait_timer++;
		
		//wait 30 frames to let the player see their selection
		if(wait_timer >= 30)
		{
			//if the cards match each other
			if(player_face_up[| 0].face_index == player_face_up[| 1].face_index)
			{
				//go to the clean up state
				state = state_clean;
			} 
			else
			{
				//if the cards do not match, flip them back over
				player_face_up[| 0].face_up = false;
				player_face_up[| 1].face_up = false;
				
				//clear the selected card list
				ds_list_clear(player_face_up);
				
				//return to the match state
				state = state_match;
			}
			//reset the wait timer
			wait_timer = 0;
		}
		break;
	case state_clean:
		
		wait_timer++;
		
		//wait to let the player see their selection
		//and wait between moving cards
		if(wait_timer >= 15 && move_timer == 0)
		{
			//check how many cards are in the player's hand
			var remaining_hand = ds_list_size(player_hand);
			//if there are still cards in the hand
			if(remaining_hand > 0)
			{
				//get the last card in the hand
				var return_card = player_hand[| remaining_hand - 1];
				//set the target position and depth of the card
				scr_set_pos(return_card, room_width - 100, y - (ds_list_size(discard) * 2));
				return_card .target_depth = -ds_list_size(discard);
				
				//if the card is face up, flip it back over
				if(return_card.face_up)
				{
					return_card.face_up = false;
				}
				
				//tell the card that it's not in the hand
				return_card.in_player_hand = false;
				
				//remove it from the hand and add it to the discard list
				ds_list_add(discard, return_card);
				ds_list_delete(player_hand, remaining_hand - 1);
			}
			//if the player's hand is empty
			if(remaining_hand == 0)
			{
				//clear out the hand list and face_up list
				ds_list_clear(player_hand);
				ds_list_clear(player_face_up);
				
				//reset the wait timer
				wait_timer = 0;
				
				//if the deck is empty
				if(ds_list_size(deck) == 0)
				{
					//go to the shuffling state
					state = state_shuffle;
				} 
				else 
				{
					//go to the dealing state
					state = state_deal;
				}
			}
		}
		break;
	case state_shuffle:
		
		//every 4 frames or so
		if(move_timer % 4 == 0)
		{
			//get the num of cards in the discard list
			var discard_pile = ds_list_size(discard);
			
			//if there are still cards in the discard list
			if(discard_pile > 0)
			{
				//get the last card in the discard list
				var return_card = discard[| discard_pile - 1];
				
				//set the target position of the card
				scr_set_pos(return_card, x, y);
				
				//remove the card from the discard list and add it to the deck list
				ds_list_delete(discard, discard_pile - 1);
				ds_list_add(deck, return_card);
				
				//if the deck is full
				if(ds_list_size(deck) == num_cards)
				{
					//shuffle the deck
					ds_list_shuffle(deck);
				}
			} 
			else
			{ 
				//before going into the deal state
				//we need to visually reshuffle the deck
				//so that it looks like a neat stack
				//perhaps that would happen here???
				state = state_deal;	
			}
		}
		break;
	case state_game_over:
		show_debug_message("game is over!");
		break;
	case state_game_menu:
		show_debug_message("game is at main menu!");
		break;
	default:
		//if something is wrong and we aren't in a recognizable state
		//we'll end up here
		show_debug_message(state);
		show_debug_message("oh no! something is wrong with the state");
		break;
}

//count and reset the move timer
move_timer++;
if(move_timer >= 16)
{
	move_timer = 0;
}