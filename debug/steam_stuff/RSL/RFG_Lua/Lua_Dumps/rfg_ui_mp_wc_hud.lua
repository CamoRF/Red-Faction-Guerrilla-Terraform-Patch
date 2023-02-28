
TWEEN_RUNNING				= 1
TWEEN_DISABLED				= 3

TEXT_RIGHT_ALIGN			= 2
TEXT_CENTER_ALIGN			= 1

WC_PLAYER_STATE_NORMAL			= 0
WC_PLAYER_STATE_DISABLED		= 1
WC_PLAYER_STATE_ACTIVE			= 2

WC_ICON_STATE_NORMAL			= 0
WC_ICON_STATE_PULSE			= 1
WC_ICON_STATE_FLASH			= 2

ORANGE					= {R=0.83,G=0.54,B=0}
BROWN					= {R=0.5,G=0.25,B=0}
GREY					= {R=0.37,G=0.37,B=0.37}
RED					= {R=1.0,G=0.24,B=0.24}
GREEN					= {R=0.41,G=0.60,B=0.30}

HUD_HINT_PADDING			= 20

wc_header_text_handle			= 0

wc_time_handle				= 0
wc_time2_handle				= 0

wc_score_label_handle			= 0
wc_score_value_handle			= 0
wc_goal_label_handle			= 0
wc_goal_value_handle			= 0

--wc_current_player_handle		= 0
wc_player1_handle			= 0
wc_player2_handle			= 0
wc_player3_handle			= 0
wc_player4_handle			= 0
wc_player1_value_handle			= 0
wc_player2_value_handle			= 0
wc_player3_value_handle			= 0
wc_player4_value_handle			= 0
wc_player_highlight_handle		= 0

wc_pack_icon_handle			= 0
wc_pack_ammo_handle			= 0
wc_weapon_icon_handle			= 0
wc_weapon_ammo_handle			= 0

wc_message_title_handle			= 0
wc_message_text_handle			= 0
wc_message_anim_handle			= 0
wc_message_group_handle			= 0
wc_message_text_group_handle		= 0
wc_message_icon_group_handle		= 0
wc_message_icon_handle			= 0

-- get stress system handles
Stress_system_handle			= 0
Stress_anim_handle			= 0
Stress_title_handle			= 0
Stress_label_handle			= 0
Stress_timer_handle			= 0

wc_counter_group_handle			= 0
wc_counter_anim_handle			= 0
wc_counter_text_handle			= 0

wc_counter_text_previous		= 0

--store the groups
wc_header_main_handle			= 0

Not_update				= false

-- ##############################################################
function rfg_ui_mp_wc_hud_cleanup()
end

-- ##############################################################
function rfg_ui_mp_wc_hud_init()

	-- get the handles
	init_mp_wc_hud_handles()

	vint_dataitem_add_subscription( "wrecking_crew_hud_header", "update", "wc_set_header" )
	vint_dataitem_add_subscription( "wrecking_crew_hud_timer", "update", "wc_set_timer" )
	vint_dataitem_add_subscription( "wrecking_crew_hud_players", "update", "wc_set_player_list" )
	vint_dataitem_add_subscription( "wrecking_crew_hud_score", "update", "wc_set_score" )
	vint_dataitem_add_subscription( "wrecking_crew_hud_weapons", "update", "wc_set_weapon_info" )

	vint_dataitem_add_subscription( "wrecking_crew_hud_stamp_info", "update", "wc_set_stamp_info" )

	vint_dataitem_add_subscription( "wrecking_crew_hud_message", "update", "wc_message_update" )
	vint_dataitem_add_subscription( "wrecking_crew_hud_stress", "update", "wc_stress_update" )

	vint_dataitem_add_subscription( "wrecking_crew_hud_counter", "update", "wc_counter_update" )


end

-- ##############################################################
function init_mp_wc_hud_handles()
	--mp text info
	wc_header_text_handle = vint_object_find( "mp_header_text" )

	wc_time_handle = vint_object_find( "mp_time" )
	wc_time2_handle = vint_object_find( "mp_time_copy" )

	wc_score_label_handle = vint_object_find( "score_label" )
	wc_score_value_handle = vint_object_find( "score_value" )
	wc_goal_label_handle = vint_object_find( "goal_label" )
	wc_goal_value_handle = vint_object_find( "goal_value" )
	
	--wc_current_player_handle = vint_object_find( "player_name_current" )
	wc_player1_handle = vint_object_find( "player1_name" )			
	wc_player2_handle = vint_object_find( "player2_name" )			
	wc_player3_handle = vint_object_find( "player3_name" )			
	wc_player4_handle = vint_object_find( "player4_name" )
	wc_player_highlight_handle = vint_object_find( "player_highlight_main" )
	
	wc_player1_value_handle =  vint_object_find( "player1_value" )
	wc_player2_value_handle =  vint_object_find( "player2_value" )
	wc_player3_value_handle =  vint_object_find( "player3_value" )
	wc_player4_value_handle =  vint_object_find( "player4_value" )

	wc_pack_icon_handle = vint_object_find( "pack_icon" )		
	wc_pack_ammo_handle = vint_object_find( "pack_num" )		
	wc_weapon_icon_handle = vint_object_find( "weapons_icon" )		
	wc_weapon_ammo_handle = vint_object_find( "weapons_num" )	
	
	wc_message_title_handle = vint_object_find( "message_title" )
	wc_message_text_handle = vint_object_find( "message_text" )
	wc_message_anim_handle = vint_object_find( "mp_message_main_anim" )
	wc_message_group_handle = vint_object_find( "mp_message_group" )
	wc_message_text_group_handle = vint_object_find( "message_text_group" )
	wc_message_icon_group_handle = vint_object_find( "message_icon_group" )
	wc_message_icon_handle = vint_object_find( "message_objective_icon" )

	-- get stress system handles
	Stress_system_handle = vint_object_find( "stress_system")
	Stress_anim_handle = vint_object_find( "stress_anim" )
	Stress_title_handle = vint_object_find( "stress_title" )
	Stress_label_handle = vint_object_find( "stress_label" )
	Stress_timer_handle = vint_object_find( "stress_timer" )

	--get the counter handles
	wc_counter_group_handle = vint_object_find( "mp_counter_group" )
	wc_counter_anim_handle = vint_object_find( "mp_counter_anim" )
	wc_counter_text_handle = vint_object_find( "counter_num" )
	
	vint_set_property( vint_object_find( "mp_game_over" ),"visible", false )
	vint_set_property( vint_object_find( "mp_mode_info_main" ),"visible", false )
	vint_set_property( vint_object_find( "mp_streak_message" ),"visible", false )

	--hide stress stuff
	vint_set_property(Stress_system_handle, "visible", false )

	-- alpha out the wc message group
	vint_set_property( wc_message_group_handle, "alpha", 0.0)

	vint_set_property( wc_counter_group_handle,"visible",false)
	
	--reset the high score
	vint_set_property( wc_goal_value_handle,"text_tag", 0 )

	--stop the flashing
	vint_set_child_tween_state( vint_object_find( "pack_ammo_flash_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "weapon_ammo_flash_anim" ), TWEEN_STATE_DISABLED )
end

-- ##############################################################
function wc_counter_update(data_item_handle, event_name)
	local visible, text, is_number = vint_dataitem_get(data_item_handle)
	
	vint_set_property( wc_counter_group_handle,"visible",visible)
	
	if (visible == true) then
		if( text ~= nil and wc_counter_text_previous ~= text )then
			if( is_number == true )then
				vint_set_property( wc_counter_text_handle,"font","font_numbers")
				vint_set_property( wc_counter_text_handle,"text_scale",3.0,3.0)
			else
				vint_set_property( wc_counter_text_handle,"font","font_header")
				vint_set_property( wc_counter_text_handle,"text_scale",1.5,1.5)
			end
			vint_set_property( wc_counter_text_handle,"text_tag",text)

			vint_set_property( wc_counter_anim_handle, "start_time", vint_get_time_index() )
			vint_set_child_tween_state( wc_counter_anim_handle, TWEEN_STATE_RUNNING)

			wc_counter_text_previous = text
		end
	end
end

-- ##############################################################
function wc_message_update(data_item_handle, event_name)

	local update, title, label = vint_dataitem_get(data_item_handle)

	if (update == true) then
		vint_set_property(wc_message_title_handle, "text_tag", title )
		vint_set_property(wc_message_text_handle, "text_tag", label )

		vint_set_property(wc_message_group_handle, "alpha", 1.0)
		vint_set_property(wc_message_anim_handle, "start_time", vint_get_time_index())
		vint_set_child_tween_state(wc_message_anim_handle, TWEEN_STATE_RUNNING)

		--scoot the icon over
		local parent_scalex,parent_scaley = vint_get_property(wc_message_group_handle, "scale")
		local text_width,text_height = vint_get_property(wc_message_text_group_handle, "screen_size")
		local text_x,text_y = vint_get_property(wc_message_text_group_handle, "anchor")
		local icon_x,icon_y = vint_get_property(wc_message_icon_group_handle, "anchor")
		local icon_bg_x,icon_bg_y = vint_get_property(wc_message_icon_handle, "anchor")

		local x_toset = text_x - (text_width/parent_scalex)*0.5 - 25

		vint_set_property( wc_message_icon_handle, "anchor", x_toset, icon_y )
		vint_set_property(wc_message_icon_group_handle, "anchor", x_toset, icon_bg_y )

	end
end

-- ##############################################################
function wc_stress_update( data_item_handle, event_name )
	local is_visible,stress_title,stress_label,stress_timer = vint_dataitem_get(data_item_handle)

	vint_set_property(Stress_title_handle, "text_tag", stress_title )
	vint_set_property(Stress_label_handle, "text_tag", stress_label )
	vint_set_property(Stress_timer_handle, "text_tag", stress_timer )

	if(is_visible == true)then
		vint_set_property(Stress_system_handle, "visible", true )
		vint_set_property(Stress_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state(Stress_anim_handle, TWEEN_STATE_RUNNING)
	else
		vint_set_property(Stress_system_handle, "visible", false )
		vint_set_child_tween_state(Stress_anim_handle, TWEEN_STATE_DISABLED)
	end
	
end

-- ##############################################################
function wc_set_score(data_item_handle, event_name)

	local score_label,score_value,goal_label,goal_value = vint_dataitem_get(data_item_handle)
	
	if( score_label ~= nil )then
		vint_set_property( vint_object_find( "wc_score_main" ),"visible", true )
		vint_set_property( wc_score_label_handle, "text_tag", score_label )
		vint_set_property( wc_score_value_handle, "text_tag", score_value )
	else
		vint_set_property( vint_object_find( "wc_score_main" ),"visible", false )
	end

	if( goal_label ~= nil )then
		vint_set_property( vint_object_find( "wc_goal_main" ),"visible", true )
		vint_set_property( wc_goal_label_handle, "text_tag", goal_label )
		vint_set_property( wc_goal_value_handle, "text_tag", goal_value )
	else
		vint_set_property( vint_object_find( "wc_goal_main" ),"visible", false )
	end
end

-- ##############################################################
function wc_set_timer(data_item_handle, event_name)
	local wc_formatted_time, wc_time_ms, wc_timer_state = vint_dataitem_get(data_item_handle)

	--set the timer
	if( wc_time_ms < 30000 )then
		--we have less than a minute, make the time red
		vint_set_property( wc_time_handle, "tint", RED.R,RED.G,RED.B )
		vint_set_property( wc_time2_handle, "tint", RED.R,RED.G,RED.B )
		vint_set_property(vint_object_find( "mp_time_icon"),"tint", RED.R,RED.G,RED.B )
	else
		vint_set_property( wc_time_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
		vint_set_property( wc_time2_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
		vint_set_property(vint_object_find( "mp_time_icon"),"tint", ORANGE.R,ORANGE.G,ORANGE.B )
		vint_set_property( wc_time_handle, "alpha", 1.0 )
		vint_set_property( vint_object_find( "mp_time_icon"), "alpha", 1.0 )
		vint_set_child_tween_state( vint_object_find( "timer_flash_anim" ), TWEEN_STATE_DISABLED )
	end
	
	if(wc_timer_state == WC_ICON_STATE_PULSE)then
		--start the anim
		vint_set_property(vint_object_find( "timer_pulse_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "timer_pulse_anim" ), TWEEN_STATE_RUNNING )
	elseif(wc_timer_state == WC_ICON_STATE_FLASH)then
		--start the anim
		vint_set_property(vint_object_find( "timer_flash_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "timer_flash_anim" ), TWEEN_STATE_RUNNING )
	end

	vint_set_property( wc_time_handle, "text_tag", wc_formatted_time )
	vint_set_property( wc_time2_handle, "text_tag", wc_formatted_time )
end

-- ##############################################################
function wc_set_header(data_item_handle, event_name)
	
	local wc_title = vint_dataitem_get(data_item_handle)

	--handle the header
	if ( Not_update == false )then

		--Reset time index
		local wc_tween_handle = vint_object_find( "mp_header_tween" )
		vint_set_property( wc_tween_handle, "start_time", vint_get_time_index() )
		vint_set_property( wc_tween_handle, "state", TWEEN_RUNNING )
		Not_update = true
	end

	-- set the title
	vint_set_property( wc_header_text_handle, "text_tag", wc_title )

	-- show/hide appropriate stuff
	vint_set_property( wc_header_main_handle, "visible", true )
	vint_set_property( wc_header_main_handle, "alpha", 1.0 )
	
end

function wc_set_player_width(player_name)
	--set the scale
	vint_set_property( player_name, "text_scale",0.7,0.6 )
	local text_scale_x,text_scale_y = vint_get_property( player_name, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "mp_wc_players_main" ), "scale" )

	local text_width,text_height = vint_get_property( player_name, "screen_size" )
	local name_max_width = 105.0 * parent_scalex
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( player_name, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( player_name, "text_scale",text_scale_x,text_scale_y )
	end
end

-- ##############################################################
function wc_set_player_list(data_item_handle, event_name)
	
	local is_visible, current_player_name,player1_name,player1_value,player1_state,
		player2_name,player2_value,player2_state,
		player3_name,player3_value,player3_state,
		player4_name,player4_value,player4_state = vint_dataitem_get(data_item_handle)

	vint_set_property(vint_object_find( "mp_wc_players_main"),"visible",is_visible)

	if (is_visible == true) then
		local player_x,player_y
		if( player1_name ~= nil )then
			vint_set_property( wc_player1_handle, "visible", true )
			vint_set_property( wc_player1_handle, "text_tag", player1_name )
			wc_set_player_width(wc_player1_handle)
			vint_set_property( wc_player1_value_handle, "visible", true )
			vint_set_property( wc_player1_value_handle, "text_tag", player1_value )
			--check the state
			if( player1_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( wc_player1_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( wc_player1_value_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
			elseif( player1_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( wc_player1_handle, "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( wc_player1_value_handle, "tint", GREY.R,GREY.G,GREY.B )
			else
				vint_set_property( wc_player1_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( wc_player1_value_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				player_x, player_y = vint_get_property(wc_player1_handle,"anchor")
				vint_set_property( wc_player_highlight_handle, "anchor", player_x, player_y )
			end
		else
			vint_set_property( wc_player1_handle, "visible", false )
			vint_set_property( wc_player1_value_handle, "visible", false )
		end
		
		if( player2_name ~= nil )then
			vint_set_property( wc_player2_handle, "visible", true )
			vint_set_property( wc_player2_handle, "text_tag", player2_name )
			wc_set_player_width(wc_player2_handle)
			vint_set_property( wc_player2_value_handle, "visible", true )
			vint_set_property( wc_player2_value_handle, "text_tag", player2_value )
			--check the state
			if( player2_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( wc_player2_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( wc_player2_value_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
			elseif( player2_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( wc_player2_handle, "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( wc_player2_value_handle, "tint", GREY.R,GREY.G,GREY.B )
			else
				vint_set_property( wc_player2_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( wc_player2_value_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				player_x, player_y = vint_get_property(wc_player2_handle,"anchor")
				vint_set_property( wc_player_highlight_handle, "anchor", player_x, player_y )
			end
		else
			vint_set_property( wc_player2_handle, "visible", false )
			vint_set_property( wc_player2_value_handle, "visible", false )
		end
		
		if( player3_name ~= nil )then
			vint_set_property( wc_player3_handle, "visible", true )
			vint_set_property( wc_player3_handle, "text_tag", player3_name )
			wc_set_player_width(wc_player3_handle)
			vint_set_property( wc_player3_value_handle, "visible", true )
			vint_set_property( wc_player3_value_handle, "text_tag", player3_value )
			--check the state
			if( player3_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( wc_player3_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( wc_player3_value_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
			elseif( player3_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( wc_player3_handle, "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( wc_player3_value_handle, "tint", GREY.R,GREY.G,GREY.B )
			else
				vint_set_property( wc_player3_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( wc_player3_value_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				player_x, player_y = vint_get_property(wc_player3_handle,"anchor")
				vint_set_property( wc_player_highlight_handle, "anchor", player_x, player_y )
			end
		else
			vint_set_property( wc_player3_handle, "visible", false )
			vint_set_property( wc_player3_value_handle, "visible", false )
		end
		
		if( player4_name ~= nil )then
			vint_set_property( wc_player4_handle, "visible", true )
			vint_set_property( wc_player4_handle, "text_tag", player4_name )
			wc_set_player_width(wc_player4_handle)
			vint_set_property( wc_player4_value_handle, "visible", true )
			vint_set_property( wc_player4_value_handle, "text_tag", player4_value )
			--check the state
			if( player4_state == WC_PLAYER_STATE_NORMAL )then
				vint_set_property( wc_player4_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
				vint_set_property( wc_player4_value_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
			elseif( player4_state == WC_PLAYER_STATE_DISABLED )then
				vint_set_property( wc_player4_handle, "tint", GREY.R,GREY.G,GREY.B )
				vint_set_property( wc_player4_value_handle, "tint", GREY.R,GREY.G,GREY.B )
			else
				vint_set_property( wc_player4_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				vint_set_property( wc_player4_value_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
				player_x, player_y = vint_get_property(wc_player4_handle,"anchor")
				vint_set_property( wc_player_highlight_handle, "anchor", player_x, player_y )
			end
		else
			vint_set_property( wc_player4_handle, "visible", false )
			vint_set_property( wc_player4_value_handle, "visible", false )
		end
	end
	
end

-- ##############################################################
function wc_set_weapon_info(data_item_handle, event_name)
	local pack_icon,pack_ammo,pack_state,weapon_icon,weapon_ammo,weapon_state = vint_dataitem_get(data_item_handle)
	
	--debug_print("vint","outside if pack_ammo = "..tostring(pack_ammo).."\n")

	if( pack_icon ~= nil and pack_icon ~= "" )then
		vint_set_property( vint_object_find( "wc_packs_main" ),"visible", true )
		vint_set_property( wc_pack_icon_handle, "image", pack_icon )
		vint_set_property( wc_pack_icon_handle, "scale", 0.8,0.8 )
		if( pack_ammo ~= nil and pack_ammo~= "" )then
			--debug_print("vint","inside if pack_ammo = "..tostring(pack_ammo).."\n")
			vint_set_property( wc_pack_ammo_handle, "visible", true )
			vint_set_property( vint_object_find( "pack_num_bg" ), "visible", true )
			vint_set_property( vint_object_find( "pack_bg" ), "visible", true )
			vint_set_property( wc_pack_ammo_handle, "text_tag", pack_ammo )
			vint_set_property( vint_object_find( "pack_num_copy" ), "text_tag", pack_ammo )
			if(pack_state == WC_ICON_STATE_PULSE)then
				--start the anim
				vint_set_property(vint_object_find( "pack_ammo_pulse_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "pack_ammo_pulse_anim" ), TWEEN_STATE_RUNNING )
			elseif( pack_state == WC_ICON_STATE_FLASH )then
				--start the anim
				vint_set_property(vint_object_find( "pack_ammo_flash_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "pack_ammo_flash_anim" ), TWEEN_STATE_RUNNING )
				--make the text red
				vint_set_property( wc_pack_ammo_handle, "tint", RED.R,RED.G,RED.B )
			elseif(pack_state == WC_ICON_STATE_NORMAL) then
				vint_set_property( wc_pack_ammo_handle, "tint", ORANGE.R, ORANGE.G, ORANGE.B )
			end
		else
			--debug_print("vint","inside else pack_ammo = "..tostring(pack_ammo).."\n")
			vint_set_property( wc_pack_ammo_handle, "visible", false )
			vint_set_property( vint_object_find( "pack_num_bg" ), "visible", false )
			vint_set_property( vint_object_find( "pack_bg" ), "visible", false )
		end
	else
		vint_set_property( vint_object_find( "wc_packs_main" ),"visible", false )
	end

	if( weapon_icon ~= nil and weapon_icon ~= "" )then
		vint_set_property( vint_object_find( "wc_weapons_main" ),"visible", true )
		vint_set_property( wc_weapon_icon_handle, "image", weapon_icon )
		vint_set_property( wc_weapon_icon_handle, "scale", 0.8,0.8 )
		if ( weapon_ammo ~= nil and weapon_ammo ~= "" ) then
			vint_set_property( wc_weapon_ammo_handle, "visible", true )
			vint_set_property( vint_object_find( "weapons_num_bg" ), "visible", true )
			vint_set_property( vint_object_find( "weapons_bg" ), "visible", true )
			vint_set_property( wc_weapon_ammo_handle, "text_tag", weapon_ammo )
			vint_set_property( vint_object_find( "weapons_num_copy" ), "text_tag", weapon_ammo )
			if(weapon_state == WC_ICON_STATE_PULSE)then
				--start the anim
				vint_set_property(vint_object_find( "weapon_ammo_pulse_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "weapon_ammo_pulse_anim" ), TWEEN_STATE_RUNNING )
			elseif( weapon_state == WC_ICON_STATE_FLASH )then
				--start the anim
				vint_set_property(vint_object_find( "weapon_ammo_flash_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "weapon_ammo_flash_anim" ), TWEEN_STATE_RUNNING )
				--make the text red
				vint_set_property( wc_weapon_ammo_handle, "tint", RED.R,RED.G,RED.B )
			elseif (weapon_state == WC_ICON_STATE_NORMAL )then
				vint_set_property( wc_weapon_ammo_handle, "tint", ORANGE.R, ORANGE.G, ORANGE.B )
			end
		else
			vint_set_property( wc_weapon_ammo_handle, "visible", false )
			vint_set_property( vint_object_find( "weapons_num_bg" ), "visible", false )
			vint_set_property( vint_object_find( "weapons_bg" ), "visible", false )
		end
	else
		vint_set_property( vint_object_find( "wc_weapons_main" ),"visible", false )
	end

end

-- ##############################################################
function wc_set_stamp_info(data_item_handle, event_name)
	local is_visible, stamp_text  = vint_dataitem_get(data_item_handle)

	if( is_visible == true )then
		
		--start the stamp animation
		vint_set_property( vint_object_find( "game_over_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "game_over_anim" ), TWEEN_STATE_RUNNING )
		
		--show the stamp
		vint_set_property( vint_object_find( "mp_game_over"), "visible", true)
		--set the text
		vint_set_property( vint_object_find( "game_over_text"), "text_tag", stamp_text)
	else
		--hide the stamp
		vint_set_property( vint_object_find( "mp_game_over"), "visible", false)
	end
end

