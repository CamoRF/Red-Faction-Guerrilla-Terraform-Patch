
ORANGE					= {R=0.83,G=0.54,B=0}
BROWN					= {R=0.5,G=0.25,B=0}
GREY					= {R=0.37,G=0.37,B=0.37}
GREEN					= {R=0.41,G=0.60,B=0.30}
RED					= {R=0.7,G=0.11,B=0.11}

WC_PLAYER_STATE_NORMAL			= 0
WC_PLAYER_STATE_DISABLED		= 1
WC_PLAYER_STATE_ACTIVE			= 2
WC_INFO_PAD				= 110
Splash_vis = false
Splash_sound_tween = 0


-- ##############################################################
function rfg_ui_mp_wc_splash_cleanup()
end

-- ##############################################################
function rfg_ui_mp_wc_splash_init()

	-- get the handles
	init_wc_splash_handles()

	vint_dataitem_add_subscription( "mp_wc_splash_info", "update", "mp_wc_splash_info" )
	vint_dataitem_add_subscription( "mp_wc_splash_title", "update", "mp_wc_splash_title" )
	vint_dataitem_add_subscription( "mp_wc_splash_barrels", "update", "mp_wc_splash_barrels" )
	vint_dataitem_add_subscription( "mp_wc_splash_turn_end", "update", "mp_wc_splash_turn_end" )
	vint_dataitem_add_subscription( "mp_wc_splash_players", "update", "mp_wc_splash_players" )
	vint_dataitem_add_subscription( "mp_wc_splash_hints", "update", "mp_wc_splash_hints" )
	vint_dataitem_add_subscription( "mp_wc_splash_veto", "update", "mp_wc_update_splash" )
end

-- ##############################################################
function init_wc_splash_handles()
	--mp_wc_splash handles
	
	--hide everyone
	vint_set_property( vint_object_find( "wc_stamp_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_barrel_result_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_info1_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_info2_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_info3_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_result_main" ), "visible", false )
	vint_set_property( vint_object_find( "wc_round_main" ), "visible", false )
	 vint_set_property( vint_object_find( "mp_splash_main" ), "visible", false )
	vint_set_child_tween_state( vint_object_find( "header_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "barrel_result_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "result_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "info_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "round_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "splash_anim" ), TWEEN_STATE_DISABLED )
end

-- ##############################################################
function mp_wc_splash_title(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local title,sub_title = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "wc_header_text" ), "text_tag", title )
	vint_set_property( vint_object_find( "wc_info_text_1" ), "text_tag", sub_title )
	
end

-- ##############################################################
function mp_wc_splash_hints(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local hint_button,hint_text = vint_dataitem_get(data_item_handle)

	local hint_a_handle = vint_object_find("wc_hint_a")
	local hint_text_2_handle = vint_object_find("wc_hint_text_2")

	if (hint_button ~= nil and hint_text ~= nil) then
		vint_set_property(vint_object_find("wc_hint_main"), "visible", true )
		vint_set_property( hint_a_handle, "image", hint_button )
		vint_set_property( hint_text_2_handle, "text_tag", hint_text )
	else
		vint_set_property(vint_object_find("wc_hint_main"), "visible", false )
	end
end

-- ##############################################################
function mp_wc_splash_barrels(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local visible, label_1,value_1_1,value_1_2,value_1_3,
	      bonus_label_1,bonus_value_1_1,bonus_value_1_2,bonus_value_1_3,
	      label_2,value_2_1,value_2_2,value_2_3,
	      bonus_label_2,bonus_value_2_1,bonus_value_2_2,bonus_value_2_3,
	      label_3,value_3_1,value_3_2,value_3_3,
	      label_4,value_4_1= vint_dataitem_get(data_item_handle)

	 vint_set_property( vint_object_find( "wc_barrel_result_main" ), "visible", visible )
	
	if (visible == true) then
		vint_set_property( vint_object_find( "wc_header_main" ), "visible", true )
		--set row 1 values
		vint_set_property( vint_object_find( "stat1_label" ), "text_tag", label_1 )
		vint_set_property( vint_object_find( "stat1_value" ), "text_tag", value_1_1 )
		vint_set_property( vint_object_find( "stat1_value2" ), "text_tag", value_1_2 )
		vint_set_property( vint_object_find( "stat1_value3" ), "text_tag", value_1_3 )

		--set row 2 values
		vint_set_property( vint_object_find( "stat2_label" ), "text_tag", label_2 )
		vint_set_property( vint_object_find( "stat2_value" ), "text_tag", value_2_1 )
		vint_set_property( vint_object_find( "stat2_value2" ), "text_tag", value_2_2 )
		vint_set_property( vint_object_find( "stat2_value3" ), "text_tag", value_2_3 )

		--set row 3 values
		vint_set_property( vint_object_find( "stat3_label" ), "text_tag", label_3 )
		vint_set_property( vint_object_find( "stat3_value" ), "text_tag", value_3_1 )
		vint_set_property( vint_object_find( "stat3_value2" ), "text_tag", value_3_2 )
		vint_set_property( vint_object_find( "stat3_value3" ), "text_tag", value_3_3 )

		--set total row values
		vint_set_property( vint_object_find( "stat4_label" ), "text_tag", label_4 )
		vint_set_property( vint_object_find( "stat4_value3" ), "text_tag", value_4_1 )

		--set bonus row values
		vint_set_property( vint_object_find( "bonus1_label" ), "text_tag", bonus_label_1 )
		vint_set_property( vint_object_find( "bonus1_value" ), "text_tag", bonus_value_1_1 )
		vint_set_property( vint_object_find( "bonus1_value2" ), "text_tag", bonus_value_1_2 )
		vint_set_property( vint_object_find( "bonus1_value3" ), "text_tag", bonus_value_1_3 )

		vint_set_property( vint_object_find( "bonus2_label" ), "text_tag", bonus_label_2 )
		vint_set_property( vint_object_find( "bonus2_value" ), "text_tag", bonus_value_2_1 )
		vint_set_property( vint_object_find( "bonus2_value2" ), "text_tag", bonus_value_2_2 )
		vint_set_property( vint_object_find( "bonus2_value3" ), "text_tag", bonus_value_2_3 )

		--start the animate in tween
		vint_set_property(vint_object_find("wc_header_main"),"alpha",0)
		vint_set_property(vint_object_find("wc_barrel_result_main"),"alpha",0)
		vint_set_property(vint_object_find("wc_result_main"),"alpha",0)

		local new_duration = vint_get_anim_duration(vint_object_find( "header_anim" ))
		local result_duration = new_duration + vint_get_anim_duration(vint_object_find( "barrel_result_anim" ))
		
		vint_set_property(vint_object_find( "header_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "header_anim" ), TWEEN_STATE_IDLE )
		
		vint_set_property( vint_object_find( "barrel_result_anim" ), "start_time", (vint_get_time_index() + new_duration) )
		vint_set_child_tween_state( vint_object_find( "barrel_result_anim" ), TWEEN_STATE_IDLE )
		
		vint_set_property( vint_object_find( "result_anim" ), "start_time", (vint_get_time_index() + result_duration) )
		vint_set_child_tween_state( vint_object_find( "result_anim" ), TWEEN_STATE_IDLE )

		--hide info
		vint_set_property(vint_object_find("wc_info1_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info2_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info3_main"),"visible",false)

		vint_set_property(vint_object_find("wc_round_main"),"visible",false)
	end
	
	
end

-- ##############################################################
function mp_wc_splash_turn_end(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local visible,label_1,value_1,label_2,value_2,value_1_is_green,letters,letters_total,player_name,message,player_image = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "wc_round_main" ), "visible", visible )

	if (visible == true) then
		vint_set_property( vint_object_find( "wc_header_main" ), "visible", true )
		--set row 1 values
		if (label_1 ~= nil )then
			vint_set_property( vint_object_find( "round1_group" ), "visible", true )
			vint_set_property( vint_object_find( "round1_label" ), "text_tag", label_1 )
			vint_set_property( vint_object_find( "round1_value" ), "text_tag", value_1 )
		else
			vint_set_property( vint_object_find( "round1_group" ), "visible", false )
		end

		if( label_2 ~= nil )then
			vint_set_property( vint_object_find( "round2_group" ), "visible", true )
			vint_set_property( vint_object_find( "round2_label" ), "text_tag", label_2 )
			vint_set_property( vint_object_find( "round2_value" ), "text_tag", value_2 )
		else
			vint_set_property( vint_object_find( "round2_group" ), "visible", false )
		end

		if (value_1 ~= nil and value_2 ~= nil) then
			if( value_1_is_green )then
				vint_set_property( vint_object_find( "round1_value" ), "tint", GREEN.R,GREEN.G,GREEN.B )
			else 
				vint_set_property( vint_object_find( "round1_value" ), "tint", RED.R,RED.G,RED.B )
			end
		else
			vint_set_property( vint_object_find( "round1_value" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
		end

		vint_set_property( vint_object_find( "round1_group" ), "alpha", 0 )
		vint_set_property( vint_object_find( "round2_group" ), "alpha", 0 )
		vint_set_property( vint_object_find( "wc_result_main" ), "alpha", 0 )
		vint_set_property(vint_object_find("wc_header_main"),"alpha",0)
		local new_duration = vint_get_anim_duration(vint_object_find( "header_anim" ))
		local result_duration = new_duration + vint_get_anim_duration(vint_object_find( "barrel_result_anim" ))
		
		vint_set_property(vint_object_find( "header_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "header_anim" ), TWEEN_STATE_IDLE )
		
		vint_set_property( vint_object_find( "round_anim" ), "start_time", (vint_get_time_index() + new_duration) )
		vint_set_child_tween_state( vint_object_find( "round_anim" ), TWEEN_STATE_IDLE )

		vint_set_property( vint_object_find( "result_anim" ), "start_time", (vint_get_time_index() + result_duration) )
		vint_set_child_tween_state( vint_object_find( "result_anim" ), TWEEN_STATE_IDLE )
		
		Splash_sound_tween = vint_object_find("wc_result_main_scale_twn_1")
		vint_set_property(Splash_sound_tween, "end_event", "mp_wc_splash_sound_hit")

		if( letters ~= nil )then
			vint_set_property( vint_object_find( "round_failed_main" ), "visible", true )
			vint_set_property( vint_object_find( "round_letters" ), "text_tag", letters )
			vint_set_property( vint_object_find( "round_letters_bg" ), "text_tag", letters_total )
			--start the anim
			vint_set_property(vint_object_find( "letter_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "letter_anim" ), TWEEN_STATE_IDLE )
		else
			vint_set_property( vint_object_find( "round_failed_main" ), "visible", false )
		end

		if( player_name ~= nil )then
			vint_set_property( vint_object_find( "round_failed_notice" ), "visible", true )
			vint_set_property( vint_object_find( "failed_name" ), "text_tag", player_name )
			vint_set_property( vint_object_find( "failed_text" ), "text_tag", message )
			--set the player image
			if(player_image ~= nil)then
				vint_set_property( vint_object_find( "mp_round_char_image" ), "visible", true )
				vint_set_property( vint_object_find( "mp_round_char_image" ), "image", player_image )
			
				-- MW: Hack to fix interface scaling
				local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_round_char_image" ))
				vint_set_property(vint_object_find( "mp_round_char_image" ), "image_size", size_x * scale_x, size_y * scale_y )
			else
				vint_set_property( vint_object_find( "mp_round_char_image" ), "visible", false )
			end
			--start the anim
			vint_set_property(vint_object_find( "player_notice_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "player_notice_anim" ), TWEEN_STATE_IDLE )

			vint_set_child_tween_state( vint_object_find( "header_anim" ), TWEEN_STATE_DISABLED )
			vint_set_child_tween_state( vint_object_find( "round_anim" ), TWEEN_STATE_DISABLED )
			vint_set_child_tween_state( vint_object_find( "result_anim" ), TWEEN_STATE_DISABLED )
			vint_set_property(vint_object_find("wc_header_main"),"alpha",1)
			vint_set_property(vint_object_find("wc_header_main"),"scale",0.8,0.8)
			vint_set_property( vint_object_find( "wc_result_main" ), "alpha", 1 )
			vint_set_property( vint_object_find( "wc_result_main" ), "scale", 1,1 )
			vint_set_property( vint_object_find( "round1_group" ), "visible", false )
			vint_set_property( vint_object_find( "round2_group" ), "visible", false )
		else
			vint_set_property( vint_object_find( "round_failed_notice" ), "visible", false )
		end
		--hide info
		vint_set_property(vint_object_find("wc_info1_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info2_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info3_main"),"visible",false)
	end
	
end

-- ##############################################################
function mp_wc_splash_players(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local visible, title,label_1,value_1_1,player1_state,
	      label_2,value_2_1,player2_state,
	      label_3,value_3_1,player3_state,
	      label_4,value_4_1,player4_state = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "wc_result_main" ), "visible", visible )

	if (visible == true) then
		--set the title for the section header
		vint_set_property( vint_object_find( "wc_header_main" ), "visible", true )
		vint_set_property( vint_object_find( "wc_result_label" ), "text_tag", title )
		
		local player_x,player_y
		local active_highlight = false

		if( label_1 ~= nil )then
			--set row 1 values
			vint_set_property( vint_object_find( "player1_group" ), "visible", true )
			vint_set_property( vint_object_find( "player1_label" ), "text_tag", label_1 )
			vint_set_property( vint_object_find( "player1_value" ), "text_tag", value_1_1 )
			
			--check the state
			if( player1_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( vint_object_find( "player1_label" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( vint_object_find( "player1_value" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				
			elseif( player1_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( vint_object_find( "player1_label" ), "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( vint_object_find( "player1_value" ), "tint", GREY.R,GREY.G,GREY.B )
				
			else
				vint_set_property( vint_object_find( "player1_label" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( vint_object_find( "player1_value" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				
				
				player_x, player_y = vint_get_property( vint_object_find( "player1_group" ),"anchor")
				active_highlight = true

				--retarget the tween
				vint_set_property( vint_object_find( "player1_label_alpha_twn_1" ), "target_name", "player1_label" )
				vint_set_property( vint_object_find( "player1_value_alpha_twn_1" ), "target_name", "player1_value" )
			end
		else
			vint_set_property( vint_object_find( "player1_group" ), "visible", false )
		end

		if( label_2 ~= nil )then
			--set row 2 values
			vint_set_property( vint_object_find( "player2_group" ), "visible", true )
			vint_set_property( vint_object_find( "player2_bg" ), "visible", true )
			vint_set_property( vint_object_find( "player2_bg2" ), "visible", true )
			vint_set_property( vint_object_find( "player2_label" ), "text_tag", label_2 )
			vint_set_property( vint_object_find( "player2_value" ), "text_tag", value_2_1 )
			
			--check the state
			if( player2_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( vint_object_find( "player2_label" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( vint_object_find( "player2_value" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				
			elseif( player2_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( vint_object_find( "player2_label" ), "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( vint_object_find( "player2_value" ), "tint", GREY.R,GREY.G,GREY.B )
				
			else
				vint_set_property( vint_object_find( "player2_label" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( vint_object_find( "player2_value" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				
				
				player_x, player_y = vint_get_property( vint_object_find( "player2_group" ),"anchor")
				active_highlight = true

				--retarget the tween
				vint_set_property( vint_object_find( "player1_label_alpha_twn_1" ), "target_name", "player2_label" )
				vint_set_property( vint_object_find( "player1_value_alpha_twn_1" ), "target_name", "player2_value" )
			end
		else
			vint_set_property( vint_object_find( "player2_bg" ), "visible", false )
			vint_set_property( vint_object_find( "player2_bg2" ), "visible", false )
			vint_set_property( vint_object_find( "player2_group" ), "visible", false )
		end

		if( label_3 ~= nil )then
			--set row 3 values
			vint_set_property( vint_object_find( "player3_group" ), "visible", true )
			vint_set_property( vint_object_find( "player3_bg" ), "visible", true )
			vint_set_property( vint_object_find( "player3_bg2" ), "visible", true )
			vint_set_property( vint_object_find( "player3_label" ), "text_tag", label_3 )
			vint_set_property( vint_object_find( "player3_value" ), "text_tag", value_3_1 )
			
			--check the state
			if( player3_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( vint_object_find( "player3_label" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( vint_object_find( "player3_value" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				
			elseif( player3_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( vint_object_find( "player3_label" ), "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( vint_object_find( "player3_value" ), "tint", GREY.R,GREY.G,GREY.B )
				
			else
				vint_set_property( vint_object_find( "player3_label" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( vint_object_find( "player3_value" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				
				
				player_x, player_y = vint_get_property( vint_object_find( "player3_group" ),"anchor")
				active_highlight = true

				--retarget the tween
				vint_set_property( vint_object_find( "player1_label_alpha_twn_1" ), "target_name", "player3_label" )
				vint_set_property( vint_object_find( "player1_value_alpha_twn_1" ), "target_name", "player3_value" )
			end
		else
			vint_set_property( vint_object_find( "player3_bg" ), "visible", false )
			vint_set_property( vint_object_find( "player3_bg2" ), "visible", false )
			vint_set_property( vint_object_find( "player3_group" ), "visible", false )
		end

		if( label_4 ~= nil )then
			--set row 4 values
			vint_set_property( vint_object_find( "player4_group" ), "visible", true )
			vint_set_property( vint_object_find( "player3_bg" ), "visible", true )
			vint_set_property( vint_object_find( "player3_bg2" ), "visible", true )
			vint_set_property( vint_object_find( "player4_label" ), "text_tag", label_4 )
			vint_set_property( vint_object_find( "player4_value" ), "text_tag", value_4_1 )
			
			--check the state
			if( player4_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( vint_object_find( "player4_label" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( vint_object_find( "player4_value" ), "tint", BROWN.R,BROWN.G,BROWN.B )
				
			elseif( player4_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( vint_object_find( "player4_label" ), "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( vint_object_find( "player4_value" ), "tint", GREY.R,GREY.G,GREY.B )
				
			else
				vint_set_property( vint_object_find( "player4_label" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( vint_object_find( "player4_value" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( vint_object_find( "player4_value2" ), "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				
				player_x, player_y = vint_get_property( vint_object_find( "player4_group" ),"anchor")
				active_highlight = true

				--retarget the tween
				vint_set_property( vint_object_find( "player1_label_alpha_twn_1" ), "target_name", "player4_label" )
				vint_set_property( vint_object_find( "player1_value_alpha_twn_1" ), "target_name", "player4_value" )
			end
		else
			--vint_set_property( vint_object_find( "player3_bg" ), "visible", false )
			--vint_set_property( vint_object_find( "player3_bg2" ), "visible", false )
			vint_set_property( vint_object_find( "player4_group" ), "visible", false )
		end

		if (active_highlight == true) then
			vint_set_property( vint_object_find( "result_highlight_main" ), "anchor", player_x, player_y )
			vint_set_property(vint_object_find("result_highlight_main"), "visible", true)
		else
			vint_set_property(vint_object_find("result_highlight_main"), "visible", false)
		end

		--hide info
		vint_set_property(vint_object_find("wc_info1_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info2_main"),"visible",false)
		vint_set_property(vint_object_find("wc_info3_main"),"visible",false)
	end
end

-- ##############################################################
function mp_wc_splash_info(data_item_handle, event_name)
	vint_set_property( vint_object_find( "wc_header_main" ), "visible", true )
	-- get all the data items at once - note that this may have more than an item needs
	local info_text1,info_text2,info_text3, play_hit = vint_dataitem_get(data_item_handle)
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "demo_screen_main" ), "scale" )
	local height_fudge = 20
	if( info_text1 ~= "" )then
		vint_set_property( vint_object_find( "wc_info1_main" ), "visible", true )
		vint_set_property( vint_object_find( "wc_info1_body" ), "text_tag", info_text1 )
				
		local text_width,text_height = vint_get_property( vint_object_find( "wc_info1_body" ), "screen_size" )
		local bg_width,bg_height = vint_get_property( vint_object_find( "wc_info1_bg3" ), "screen_size" )
		local new_height = (text_height - height_fudge) / parent_scaley
		vint_set_property( vint_object_find( "wc_info1_bg3" ), "scale", bg_width, new_height )

		local infobg_x,infobg_y = vint_get_property( vint_object_find( "wc_info1_bg3" ), "anchor" )
		local cap_x,cap_y = vint_get_property( vint_object_find( "wc_info1_bg_cap" ), "anchor" )
		local new_y = infobg_y + (new_height/parent_scaley)
		vint_set_property( vint_object_find( "wc_info1_bg_cap" ), "anchor", cap_x, new_y )
	else
		vint_set_property( vint_object_find( "wc_info1_bg3" ), "visible", false )
	end
	
	if( info_text2 ~= "" )then
		vint_set_property( vint_object_find( "wc_info2_main" ), "visible", true )
		vint_set_property( vint_object_find( "wc_info2_body" ), "text_tag", info_text2 )
		
		local prev_x,prev_y = vint_get_property( vint_object_find( "wc_info1_main" ), "anchor" )
		local prev_width,prev_height = vint_get_property( vint_object_find( "wc_info1_bg3" ), "screen_size" )
		local text_width,text_height = vint_get_property( vint_object_find( "wc_info2_body" ), "screen_size" )
		local bg_width,bg_height = vint_get_property( vint_object_find( "wc_info2_bg3" ), "screen_size" )
		local new_height = (text_height - height_fudge) / parent_scaley
		vint_set_property( vint_object_find( "wc_info2_bg3" ), "scale", bg_width, new_height )
		vint_set_property( vint_object_find( "wc_info2_main" ), "anchor", prev_x, ((prev_y + (prev_height/parent_scaley)) + (WC_INFO_PAD / parent_scaley)) )

		local infobg_x,infobg_y = vint_get_property( vint_object_find( "wc_info2_bg3" ), "anchor" )
		local cap_x,cap_y = vint_get_property( vint_object_find( "wc_info2_bg_cap" ), "anchor" )
		local new_y = infobg_y + (new_height/parent_scaley)
		vint_set_property( vint_object_find( "wc_info2_bg_cap" ), "anchor", cap_x, new_y )
	else
		vint_set_property( vint_object_find( "wc_info2_main" ), "visible", false )
	end

	if( info_text3 ~= "" )then
		vint_set_property( vint_object_find( "wc_info3_main" ), "visible", true )
		vint_set_property( vint_object_find( "wc_info3_body" ), "text_tag", info_text3 )

		local prev_x,prev_y = vint_get_property( vint_object_find( "wc_info2_main" ), "anchor" )
		local prev_width,prev_height = vint_get_property( vint_object_find( "wc_info2_bg3" ), "screen_size" )
		local text_width,text_height = vint_get_property( vint_object_find( "wc_info3_body" ), "screen_size" )
		local bg_width,bg_height = vint_get_property( vint_object_find( "wc_info3_bg3" ), "screen_size" )
		local new_height = (text_height - height_fudge) / parent_scaley
		vint_set_property( vint_object_find( "wc_info3_bg3" ), "scale", bg_width, new_height )
		vint_set_property( vint_object_find( "wc_info3_main" ), "anchor", prev_x, ((prev_y + (prev_height/parent_scaley))+ (WC_INFO_PAD / parent_scaley)) )

		local infobg_x,infobg_y = vint_get_property( vint_object_find( "wc_info3_bg3" ), "anchor" )
		local cap_x,cap_y = vint_get_property( vint_object_find( "wc_info3_bg_cap" ), "anchor" )
		local new_y = infobg_y + (new_height/parent_scaley)
		vint_set_property( vint_object_find( "wc_info3_bg_cap" ), "anchor", cap_x, new_y )
	else
		vint_set_property( vint_object_find( "wc_info3_main" ), "visible", false )
	end

	--start the animate in tween
	vint_set_property(vint_object_find("wc_info1_main"),"alpha",0)
	vint_set_property(vint_object_find("wc_info2_main"),"alpha",0)
	vint_set_property(vint_object_find("wc_info3_main"),"alpha",0)
	vint_set_property(vint_object_find("wc_header_main"),"alpha",0)

	local new_duration = vint_get_anim_duration(vint_object_find( "header_anim" ))

	vint_set_property(vint_object_find( "header_anim" ), "start_time", vint_get_time_index() )
	vint_set_child_tween_state( vint_object_find( "header_anim" ), TWEEN_STATE_IDLE )
	
	vint_set_property( vint_object_find( "info_anim" ), "start_time", (vint_get_time_index() + new_duration) )
	vint_set_child_tween_state( vint_object_find( "info_anim" ), TWEEN_STATE_IDLE )

	if play_hit == true then
		Splash_sound_tween = vint_object_find("wc_header_main_scale_twn_1")
		vint_set_property(Splash_sound_tween, "end_event", "mp_wc_splash_sound_hit")
	end
	
end

-- ##############################################################
function wc_set_text_width( text_handle, max_width )
	--resize the text if it is too big
	--get the scale
	local text_scale_x,text_scale_y = vint_get_property( text_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "wc_screen_main" ), "scale" )

	local text_width,text_height = vint_get_property( text_handle, "screen_size" )
	local text_max_width = max_width * parent_scalex
	local new_scale = text_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > text_max_width )then
		vint_set_property( text_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( text_handle, "text_scale",text_scale_x,text_scale_y )
	end
end

-- ##############################################################
function mp_wc_update_splash(data_item_handle, event_name)
	local is_visible,round_label,round_value,pack_icon,pack_name,pack_hint,weapon_icon,weapon_name,weapon_hint,player_hint,player_image  = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "mp_splash_main" ), "visible", is_visible )

	if (is_visible == true) then
		vint_set_property( vint_object_find( "wc_header_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_stamp_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_barrel_result_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_info1_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_info2_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_info3_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_result_main" ), "visible", false )
		vint_set_property( vint_object_find( "wc_round_main" ), "visible", false )

		vint_set_property( vint_object_find( "mp_splash_round" ), "text_tag", round_label )
		vint_set_property( vint_object_find( "mp_splash_round_num" ), "text_tag", round_value )

		if (pack_icon == nil and pack_name == nil) then
			vint_set_property(vint_object_find("splash_packs_main"), "visible", false)
		else
			vint_set_property(vint_object_find("splash_packs_main"), "visible", true)

			vint_set_property( vint_object_find( "splash_pack_label" ), "text_tag", pack_name )
			vint_set_property( vint_object_find( "splash_pack_icon" ), "image", pack_icon )
			
			if(pack_hint ~= nil)then
				vint_set_property( vint_object_find( "splash_pack_hint" ), "visible", true )
				vint_set_property( vint_object_find( "splash_pack_hint" ), "text_tag", pack_hint )
			else
				vint_set_property( vint_object_find( "splash_pack_hint" ), "visible", false )
			end
		end
		
		if (weapon_icon == nil and weapon_name == nil) then
			vint_set_property(vint_object_find("splash_weapons_main"), "visible", false)
		else
			vint_set_property(vint_object_find("splash_weapons_main"), "visible", true)

			vint_set_property( vint_object_find( "splash_weapons_label" ), "text_tag", weapon_name )
			vint_set_property( vint_object_find( "splash_weapons_icon" ), "image", weapon_icon )
			
			if(weapon_hint ~= nil)then
				vint_set_property( vint_object_find( "splash_weapons_hint" ), "visible", true )
				vint_set_property( vint_object_find( "splash_weapons_hint" ), "text_tag", weapon_hint )
			else
				vint_set_property( vint_object_find( "splash_weapons_hint" ), "visible", false )
			end
		end

		vint_set_property( vint_object_find( "mp_splash_player" ), "text_tag", player_hint )

		if(player_image ~= nil)then
			vint_set_property( vint_object_find( "mp_splash_char_image" ), "visible", true )
			vint_set_property( vint_object_find( "mp_splash_char_image" ), "image", player_image )
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_splash_char_image" ))
			vint_set_property(vint_object_find( "mp_splash_char_image" ), "image_size", size_x * scale_x, size_y * scale_y )
		else
			vint_set_property( vint_object_find( "mp_splash_char_image" ), "visible", false )
		end

		if(is_visible ~= Splash_vis)then
			vint_set_child_tween_state( vint_object_find( "splash_anim" ), TWEEN_STATE_IDLE )
			vint_set_property(vint_object_find( "splash_anim" ), "start_time", vint_get_time_index() )
		end	
	end
	
	Splash_vis = is_visible
end

function mp_wc_splash_sound_hit()
	vint_set_property(Splash_sound_tween, "end_event", nil)
	rfg_play_audio("HUD_MIS_COMPLETE_TEXT_HIT")
end
