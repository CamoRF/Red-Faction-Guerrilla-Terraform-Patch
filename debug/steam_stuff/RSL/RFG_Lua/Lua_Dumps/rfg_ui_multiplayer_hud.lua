TEXT_RIGHT_ALIGN			= 2
TEXT_CENTER_ALIGN			= 1
HUD_TEAM1_COLOR				= {R=0,G=0,B=0}
HUD_TEAM2_COLOR				= {R=0,G=0,B=0}
HUD_ORANGE				= {R=0.83,G=0.54,B=0}
HUD_BROWN				= {R=0.5,G=0.25,B=0}
HUD_GREEN				= {R=0.42,G=0.61,B=0.08}
DEMO_ORANGE				= {R=1.0,G=0.5,B=0}
HUD_HINT_PADDING			= 20
STAMP_PAD				= 20
GUERRILLA				= 0
EDF					= 1
NEUTRAL					= 2
DPAD_UP					= 0
DPAD_RIGHT				= 1
DPAD_DOWN				= 2
DPAD_LEFT				= 3
MP_GUERRILLA_DEMO_PLAYING		= false
MP_EDF_DEMO_PLAYING			= false
MESSAGE_FUDGE				= 25
MP_HUD_MIN_DISTANCE			= 20
Guerrila_flag_val			= -1
EDF_flag_val				= -1
Old_bagman_name				= -1
obj_handles_mphud			= {0,0}
demo_text_table				= {0,0,0}
mp_header_round_handle			= 0
mp_team_score_main_handle		= 0
mp_edf_score_handle			= 0
mp_guerilla_score_handle		= 0
mp_guerilla_hilite_handle		= 0
mp_edf_hilite_handle			= 0
mp_time_handle				= 0
mp_single_score_main_handle		= 0
mp_single_high_score_name_handle	= 0
mp_single_high_score_num_handle		= 0
mp_single_player_score_name_handle	= 0
mp_single_player_score_num_handle	= 0
prev_title				= 0
prev_subtext				= 0
prev_round_num				= 0
prev_team_id				= -1
prev_first_player_name			= 0
prev_second_player_name			= 0
mp_header_alpha_tween			= 0
mask_handle				= 0
mask_tween_handle			= 0
duration				= 0.8
prev_guerrilla_score			 = 0
prev_edf_score				 = 0
mp_header_main_handle			= 0
not_update				= false
Hud_mode_handle				= ""
Mode_info_visible			= false
Game_over				= false
Prev_destroy				= false

DISTANCE_GROUP_X = 0
DISTANCE_GROUP_Y = 0

function rfg_ui_multiplayer_hud_init()
	init_mp_hud_handles()
	vint_dataitem_add_subscription( "multiplayer_hud_main", "update", "mp_set_header" )
	vint_dataitem_add_subscription( "multiplayer_hud_timer", "update", "mp_set_timer" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_deathmatch", "update", "mp_deathmatch" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_team_deathmatch", "update", "mp_team_deathmatch" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_capture_the_flag", "update", "mp_ctf" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_bagman", "update", "mp_bagman" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_team_bagman", "update", "mp_team_bagman" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_king_of_the_hill", "update", "mp_damage_control" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_demolition", "update", "mp_demolition" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_info", "update", "mp_mode_info" )
	vint_dataitem_add_subscription( "multiplayer_hud_mode_siege","update", "mp_siege" )
	vint_dataitem_add_subscription( "multiplayer_hud_respawn", "update", "mp_set_respawn_time" )
	vint_dataevent_add_subscription("multiplayer_set_streak", "update", "mp_set_streak" )
	vint_dataevent_add_subscription("multiplayer_set_challenge", "update", "mp_set_challenge" )
	vint_dataitem_add_subscription( "multiplayer_hud_stamp_info", "update", "mp_set_stamp_info" )
	vint_dataitem_add_subscription( "multiplayer_hud_objective", "update", "mp_message_update" )
	vint_dataitem_add_subscription( "multiplayer_hud_demo_change", "update", "mp_demo_change" )
	Hud_mode_handle = rfg_get_multiplayer_mode_name()
end
function init_mp_hud_handles()
	obj_handles_mphud[1] = vint_object_find( "mp_header_text" )
	obj_handles_mphud[2] = vint_object_find( "mp_header_sub_text" )
	mask_handle = vint_object_find( "mp_subtext_mask" )
	mask_tween_handle = vint_object_find( "mp_subtext_mask_tween" )
	mp_header_alpha_tween = vint_object_find( "mp_header_alpha_tween" )
	mp_header_main_handle = vint_object_find( "mp_header_main" )
	mp_team_score_main_handle =  vint_object_find( "mp_team_score_board_main" )
	mp_edf_score_handle =  vint_object_find( "mp_edf_score" )
	mp_guerilla_score_handle =  vint_object_find( "mp_guerilla_score" )
	mp_guerilla_hilite_handle = vint_object_find( "mp_guerrilla_highlight" )
	mp_edf_hilite_handle = vint_object_find( "mp_edf_highlight" )
	mp_time_handle = vint_object_find( "mp_time" )
	mp_header_round_handle = vint_object_find( "mp_header_round" )
	mp_single_score_main_handle = vint_object_find( "mp_single_score_board_main" )
	mp_single_high_score_name_handle = vint_object_find( "mp_single_high_score_name" )
	mp_single_high_score_num_handle	= vint_object_find( "mp_single_high_score_num" )
	mp_single_player_score_name_handle = vint_object_find( "mp_single_player_score_name" )
	mp_single_player_score_num_handle = vint_object_find( "mp_single_player_score_num" )
	vint_set_property( mp_single_score_main_handle, "visible", false )
	vint_set_property( mp_team_score_main_handle, "visible", false )
	vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", false )
	vint_set_property( vint_object_find( "mp_mode_widget1" ), "visible", false )
	vint_set_property( vint_object_find( "mp_mode_widget2" ), "visible", false )
	vint_set_property( vint_object_find( "mp_demo_main" ), "visible", false )
	vint_set_property( vint_object_find( "mp_mode_info_main"), "visible", false)
	vint_set_property( vint_object_find( "mp_challenge_message" ), "visible", false )
	vint_set_child_tween_state( vint_object_find( "mp_challenge_anim" ), TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find( "mp_streak_message" ), "visible", false )
	vint_set_child_tween_state( vint_object_find( "mp_streak_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "timer_flash_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team1_flag_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team2_flag_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "game_over_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team1_head_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team2_head_anim" ), TWEEN_STATE_DISABLED )
	local team1_red, team1_green, team1_blue = rfg_get_mp_team_color(HUMAN_TEAM_GUERILLA)
	local team2_red, team2_green, team2_blue = rfg_get_mp_team_color(HUMAN_TEAM_EDF)
	HUD_TEAM1_COLOR = { R = team1_red, G = team1_green, B = team1_blue }
	HUD_TEAM2_COLOR = { R = team2_red, G = team2_green, B = team2_blue }
	vint_set_property( vint_object_find( "mp_edf_logo"), "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )
	vint_set_property( vint_object_find( "mp_guerilla_logo"), "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B )
	vint_set_property(vint_object_find( "demo_message_group"),"visible",false)
	vint_set_property( vint_object_find( "mp_game_over"), "visible", false)
	vint_set_property( vint_object_find( "mp_respawn_group" ),"visible", false )
	vint_set_property(vint_object_find( "mp_message_group" ), "visible", false )
	vint_set_child_tween_state( vint_object_find( "mp_message_main_anim" ), TWEEN_STATE_DISABLED )		
	DISTANCE_GROUP_X,DISTANCE_GROUP_Y = vint_get_property(vint_object_find("distance_group"),"anchor")
end
function mp_set_header(data_item_handle, event_name)	
	local mp_title, mp_subtext, mp_current_round, mp_num_rounds, score_limit, mp_icon = vint_dataitem_get(data_item_handle)
	if( mp_current_round >= mp_num_rounds )then
		Game_over = true
	end
	if ( not_update == false )then
		local mp_tween_handle = vint_object_find( "mp_header_tween" )
		vint_set_property( mp_tween_handle, "start_time", vint_get_time_index() )
		vint_set_property( mp_tween_handle, "state", TWEEN_STATE_RUNNING )
		not_update = true
	end
	vint_set_property( obj_handles_mphud[1], "text_tag", mp_title )
	vint_set_property( obj_handles_mphud[2], "visible", false )
	vint_set_property( mp_header_round_handle,"visible", false )--"text_tag", mp_current_round .. "/" .. mp_num_rounds )
	vint_set_property( mp_header_main_handle, "visible", true )
	vint_set_property( mp_header_main_handle, "alpha", 1.0 )
	if( mp_icon ~= nil )then
		vint_set_property(  vint_object_find( "mp_header_icon" ), "visible", true )
		vint_set_property(  vint_object_find( "mp_header_icon" ), "image", mp_icon )
	else
		vint_set_property(  vint_object_find( "mp_header_icon" ), "visible", false )
	end	
end
function mp_set_timer(data_item_handle, event_name)
	local mp_time = vint_dataitem_get(data_item_handle)
	local mp_time_num = rfg_tonumber( mp_time )
	if( mp_time_num < 1.0 and Mode_info_visible == false )then
		vint_set_property( mp_time_handle, "tint", 1,0.24,0.24 )
		vint_set_property(vint_object_find( "mp_time_icon"),"tint",1,0.24,0.24 )
		if(mp_time == "0:50")then
			vint_set_property(vint_object_find( "timer_flash_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "timer_flash_anim" ), TWEEN_STATE_RUNNING )
		end
	else
		vint_set_property( mp_time_handle, "tint", 0.94,0.70,0.01 )
		vint_set_property(vint_object_find( "mp_time_icon"),"tint",0.94,0.70,0.01 )
		vint_set_property( mp_time_handle, "alpha", 1.0 )
		vint_set_property( vint_object_find( "mp_time_icon"), "alpha", 1.0 )
		vint_set_child_tween_state( vint_object_find( "timer_flash_anim" ), TWEEN_STATE_DISABLED )
	end
	vint_set_property( mp_time_handle, "text_tag", mp_time )
end
function mp_set_streak(data_event_handle, event_name)
	local type = vint_dataevent_get(data_event_handle)
	vint_set_property( vint_object_find( "mp_streak_message" ), "visible", true )
	vint_set_property( vint_object_find( "streak_type" ), "text_tag", type )
	vint_set_property(vint_object_find( "mp_streak_anim" ), "start_time", vint_get_time_index() )
	vint_set_child_tween_state( vint_object_find( "mp_streak_anim" ), TWEEN_STATE_RUNNING )
end
function mp_set_challenge(data_event_handle, event_name)
	local title,info = vint_dataevent_get(data_event_handle)
	vint_set_property( vint_object_find( "mp_challenge_message" ), "visible", true )
	vint_set_property( vint_object_find( "challenge_type" ), "text_tag", title )
	vint_set_property( vint_object_find( "challenge_info" ), "text_tag", info )
	vint_set_property(vint_object_find( "mp_challenge_anim" ), "start_time", vint_get_time_index() )
	vint_set_child_tween_state( vint_object_find( "mp_challenge_anim" ), TWEEN_STATE_RUNNING )  
end
function mp_team_deathmatch(data_item_handle, event_name)
	local team_id, guerilla_score, edf_score  = vint_dataitem_get(data_item_handle)
	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", true )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
	end
	vint_set_property( mp_edf_score_handle, "text_tag", edf_score )
	vint_set_property( mp_guerilla_score_handle, "text_tag", guerilla_score )
	score_highlight(team_id,mp_edf_hilite_handle,mp_guerilla_hilite_handle)
end
function mp_siege(data_item_handle, event_name)
	local local_team,attack_team,defend_team,attack_score,defend_score = vint_dataitem_get(data_item_handle)
	local guerrilla_logo = vint_object_find("mp_guerilla_logo")
	local edf_logo = vint_object_find("mp_edf_logo")
	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", true )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
	end
	if( attack_team == GUERRILLA )then
		vint_set_property( mp_guerilla_score_handle, "text_tag", attack_score )
		vint_set_property( mp_edf_score_handle, "text_tag", defend_score )
		
		--dim the logo that is defending
		vint_set_property(guerrilla_logo, "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
		vint_set_property(edf_logo, "tint", HUD_TEAM2_COLOR.R * 0.33, HUD_TEAM2_COLOR.G * 0.33, HUD_TEAM2_COLOR.B * 0.33)
	else
		vint_set_property( mp_guerilla_score_handle, "text_tag", defend_score )
		vint_set_property( mp_edf_score_handle, "text_tag", attack_score )

		--dim the logo that is defending
		vint_set_property(guerrilla_logo, "tint", HUD_TEAM1_COLOR.R * 0.33, HUD_TEAM1_COLOR.G * 0.33, HUD_TEAM1_COLOR.B * 0.33)
		vint_set_property(edf_logo, "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
	end
	score_highlight(local_team,mp_edf_hilite_handle,mp_guerilla_hilite_handle)	
end
function mp_damage_control(data_item_handle, event_name)
	local team_id, guerilla_score, edf_score  = vint_dataitem_get(data_item_handle)
	local team1_group_handle = vint_object_find( "mp_mode_widget1" )
	local team2_group_handle = vint_object_find( "mp_mode_widget2" )
	vint_set_property( team1_group_handle, "visible", false )
	vint_set_property( team2_group_handle, "visible", false )
	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", true )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
	end
	vint_set_property( mp_edf_score_handle, "text_tag", edf_score )
	vint_set_property( mp_guerilla_score_handle, "text_tag", guerilla_score )
	score_highlight(team_id,mp_edf_hilite_handle,mp_guerilla_hilite_handle)
end
function mp_ctf(data_item_handle, event_name)
	local team_id, guerilla_score, guerilla_flag_status, guerilla_flag_carrier_name, local_player_has_guerrilla_flag, guerrilla_distance, guerrilla_rotation, 
		edf_score, edf_flag_status, edf_flag_carrier_name, local_player_has_edf_flag, edf_distance, edf_rotation  = vint_dataitem_get(data_item_handle)
	-- Flag statuses:0 = At base, 1 = Picked up (guerilla_flag_carrier_name will be valid in this instance), 2 = Dropped
	guerrilla_distance = ceil(guerrilla_distance)
	edf_distance = ceil(edf_distance)
	local team1_group_handle = vint_object_find( "mp_mode_widget1" )
	local team2_group_handle = vint_object_find( "mp_mode_widget2" )
	local team1_score_handle = vint_object_find( "widget_score", team1_group_handle )
	local team2_score_handle = vint_object_find( "widget_score", team2_group_handle )
	local team1_hilite_handle = vint_object_find( "widget_highlight", team1_group_handle )
	local team2_hilite_handle = vint_object_find( "widget_highlight", team2_group_handle )
	local team1_flag_handle = vint_object_find( "widget_flag", team1_group_handle )
	local team2_flag_handle = vint_object_find( "widget_flag2", team2_group_handle )
	local team1_flag_caution_handle = vint_object_find( "widget_flag_caution_1", team1_group_handle )
	local team2_flag_caution_handle = vint_object_find( "widget_flag_caution_2", team2_group_handle )
	local team1_flag_caution_handle_2 = vint_object_find( "widget_flag_caution_1_2", team1_group_handle )
	local team2_flag_caution_handle_2 = vint_object_find( "widget_flag_caution_2_2", team2_group_handle )
	local team1_distance_handle = vint_object_find( "widget_distance", team1_group_handle )
	local team1_distance_bg_handle = vint_object_find( "widget_distance_bg", team1_group_handle )
	local team1_distance_m_handle = vint_object_find( "widget_distance_m", team1_group_handle )
	local team2_distance_handle = vint_object_find( "widget_distance", team2_group_handle )
	local team2_distance_bg_handle = vint_object_find( "widget_distance_bg", team2_group_handle )
	local team2_distance_m_handle = vint_object_find( "widget_distance_m", team2_group_handle )
	local team1_arrow_handle = vint_object_find( "widget_arrow", team1_group_handle )
	local team1_arrow_handle2 = vint_object_find( "widget_arrow2", team1_group_handle )
	local team2_arrow_handle = vint_object_find( "widget_arrow", team2_group_handle )
	local team2_arrow_handle2 = vint_object_find( "widget_arrow2", team2_group_handle )
	local team1_player_handle = vint_object_find( "widget_player_flag_main", team1_group_handle )
	local team2_player_handle = vint_object_find( "widget_player_flag_main", team2_group_handle )
	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", false )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", false )
		vint_set_property( team1_group_handle, "visible", true )
		vint_set_property( team2_group_handle, "visible", true )
	end
	vint_set_property( team1_score_handle, "text_tag", edf_score )
	vint_set_property( team2_score_handle, "text_tag", guerilla_score )
	vint_set_property( team1_flag_handle, "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
	vint_set_property( vint_object_find( "widget_logo", team1_group_handle ), "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
	vint_set_property( team2_flag_handle, "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B )
	vint_set_property( vint_object_find( "widget_logo", team2_group_handle ), "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
	local flag_base_alpha = 0.75
	local flag_cap_alpha = 0.50
	if( EDF_flag_val ~= edf_flag_status )then
		if( edf_flag_status == 0 )then
			vint_set_property( team1_flag_handle, "alpha", flag_base_alpha)
			vint_set_property( team1_flag_caution_handle,"visible",false)
			vint_set_property( team1_flag_caution_handle_2,"visible",false)
			vint_set_child_tween_state( vint_object_find( "team1_flag_anim" ), TWEEN_STATE_DISABLED )
		elseif( edf_flag_status == 1 )then
			vint_set_property( team1_flag_handle, "alpha", flag_cap_alpha)
			vint_set_property( team1_flag_caution_handle,"visible",true)
			vint_set_property( team1_flag_caution_handle,"rotation",0)
			vint_set_property( team1_flag_caution_handle,"tint",HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
			vint_set_property( team1_flag_caution_handle_2,"visible",true)
			vint_set_property( team1_flag_caution_handle_2,"rotation",0)
			vint_set_property( team1_flag_caution_handle_2,"tint",HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
			vint_set_property(vint_object_find( "team1_flag_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team1_flag_anim" ), TWEEN_STATE_RUNNING )
		elseif( edf_flag_status == 2 )then
			vint_set_property( team1_flag_handle, "alpha", flag_cap_alpha)
			vint_set_property( team1_flag_caution_handle,"visible",true)
			vint_set_property( team1_flag_caution_handle,"rotation",180*DEG_TO_RAD)
			vint_set_property( team1_flag_caution_handle,"tint",HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
			vint_set_property( team1_flag_caution_handle_2,"visible",true)
			vint_set_property( team1_flag_caution_handle_2,"rotation",180*DEG_TO_RAD)
			vint_set_property( team1_flag_caution_handle_2,"tint",HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)
			vint_set_property(vint_object_find( "team1_flag_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team1_flag_anim" ), TWEEN_STATE_RUNNING )
		end
	end
	EDF_flag_val = edf_flag_status
	if( Guerrila_flag_val ~= guerilla_flag_status )then
		if( guerilla_flag_status == 0 )then
			vint_set_property( team2_flag_handle, "alpha", flag_base_alpha)
			vint_set_property( team2_flag_caution_handle,"visible",false)
			vint_set_property( team2_flag_caution_handle_2,"visible",false)
			vint_set_child_tween_state( vint_object_find( "team2_flag_anim" ), TWEEN_STATE_DISABLED )
		elseif( guerilla_flag_status == 1 )then
			vint_set_property( team2_flag_handle, "alpha", flag_cap_alpha)
			vint_set_property( team2_flag_caution_handle,"visible",true)
			vint_set_property( team2_flag_caution_handle,"rotation",0)
			vint_set_property( team2_flag_caution_handle,"tint",HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )
			vint_set_property( team2_flag_caution_handle_2,"visible",true)
			vint_set_property( team2_flag_caution_handle_2,"rotation",0)
			vint_set_property( team2_flag_caution_handle_2,"tint",HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )
			vint_set_property(vint_object_find( "team2_flag_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team2_flag_anim" ), TWEEN_STATE_RUNNING )
		elseif( guerilla_flag_status == 2 )then
			vint_set_property( team2_flag_handle, "alpha", flag_cap_alpha)
			vint_set_property( team2_flag_caution_handle,"visible",true)
			vint_set_property( team2_flag_caution_handle,"rotation",180*DEG_TO_RAD)
			vint_set_property( team2_flag_caution_handle,"tint",HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
			vint_set_property( team2_flag_caution_handle_2,"visible",true)
			vint_set_property( team2_flag_caution_handle_2,"rotation",180*DEG_TO_RAD)
			vint_set_property( team2_flag_caution_handle_2,"tint",HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
			vint_set_property(vint_object_find( "team2_flag_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team2_flag_anim" ), TWEEN_STATE_RUNNING )
		end
	end
	Guerrila_flag_val = guerilla_flag_status
	vint_set_property( team1_distance_handle,"text_tag", edf_distance )
	vint_set_property( team2_distance_handle,"text_tag", guerrilla_distance )
	vint_set_property( team1_arrow_handle,"rotation", edf_rotation )
	vint_set_property( team1_arrow_handle2,"rotation", edf_rotation )
	vint_set_property( team2_arrow_handle,"rotation", guerrilla_rotation )
	vint_set_property( team2_arrow_handle2,"rotation", guerrilla_rotation )
	if( edf_distance < MP_HUD_MIN_DISTANCE )then
		vint_set_property( team1_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team1_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team1_arrow_handle2,"visible",true )
	else
		vint_set_property( team1_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
		vint_set_property( team1_arrow_handle2,"visible",false )
	end
	if( guerrilla_distance < MP_HUD_MIN_DISTANCE )then
		vint_set_property( team2_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team2_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team2_arrow_handle2,"visible",true )
	else
		vint_set_property( team2_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
		vint_set_property( team2_arrow_handle2,"visible",false )
	end
	if( local_player_has_guerrilla_flag == true )then
		vint_set_property(team2_distance_handle, "visible", false)
		vint_set_property(team2_distance_bg_handle, "visible", false)
		vint_set_property(team2_distance_m_handle, "visible", false)
		vint_set_property( team2_arrow_handle,"alpha", 0 )
		vint_set_property( team2_arrow_handle2,"alpha", 0 )
		vint_set_property( team2_player_handle,"visible", true )
	else
		vint_set_property( team2_arrow_handle,"alpha", 1.0 )
		vint_set_property( team2_arrow_handle2,"alpha", 0.5 )
		vint_set_property( team2_player_handle,"visible", false )
		vint_set_property(team2_distance_handle, "visible", true)
		vint_set_property(team2_distance_bg_handle, "visible", true)
		vint_set_property(team2_distance_m_handle, "visible", true)
	end
	if( local_player_has_edf_flag == true )then
		vint_set_property(team1_distance_handle, "visible", false)
		vint_set_property(team1_distance_bg_handle, "visible", false)
		vint_set_property(team1_distance_m_handle, "visible", false)
		vint_set_property( team1_arrow_handle,"alpha", 0 )
		vint_set_property( team1_arrow_handle2,"alpha", 0 )
		vint_set_property( team1_player_handle,"visible", true )
	else
		vint_set_property( team1_arrow_handle,"alpha", 1.0 )
		vint_set_property( team1_arrow_handle2,"alpha", 0.5 )
		vint_set_property( team1_player_handle,"visible", false )
		vint_set_property(team1_distance_handle, "visible", true)
		vint_set_property(team1_distance_bg_handle, "visible", true)
		vint_set_property(team1_distance_m_handle, "visible", true)
	end
	score_highlight(team_id,team1_hilite_handle,team2_hilite_handle)
end
function mp_deathmatch(data_item_handle, event_name)
	local first_player_is_local, first_player_name, first_player_score, 
		second_player_is_local, second_player_name, second_player_score  = vint_dataitem_get(data_item_handle)

	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", false )
		vint_set_property( mp_single_score_main_handle, "visible", true )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
	end
	if (prev_first_player_name ~= first_player_name) then
		prev_first_player_name = first_player_name
		vint_set_property( mp_single_high_score_name_handle, "text_tag", first_player_name )
	end
	vint_set_property( mp_single_high_score_num_handle, "text_tag", first_player_score )
	
	if( prev_second_player_name ~= second_player_name )then
		prev_second_player_name = second_player_name
		vint_set_property( mp_single_player_score_name_handle, "text_tag", second_player_name )
	end
	vint_set_property( mp_single_player_score_num_handle, "text_tag", second_player_score )
	local highlight_handle = vint_object_find("single_score_highlight")
	if(first_player_is_local == true)then
		local leader_x,leader_y = vint_get_property( mp_single_high_score_num_handle, "anchor" )
		vint_set_property( highlight_handle, "anchor", leader_x,leader_y )
		vint_set_property(highlight_handle, "visible", true)
	elseif (second_player_is_local == true) then
		local user_x,user_y = vint_get_property( mp_single_player_score_num_handle, "anchor" )
		vint_set_property( highlight_handle, "anchor", user_x,user_y )
		vint_set_property(highlight_handle, "visible", true)
	else
		vint_set_property(highlight_handle, "visible", false)
	end
end
function mp_team_bagman(data_item_handle, event_name)
	local team_id, guerilla_score, edf_score, bag_is_held, local_player_has_bag, bagman_team, bagman_distance, bagman_rotation  = vint_dataitem_get(data_item_handle)
	bagman_distance = ceil(bagman_distance)
	local team1_group_handle = vint_object_find( "mp_mode_widget1" )
	local team2_group_handle = vint_object_find( "mp_mode_widget2" )
	local bag_score_handle = vint_object_find( "widget_score", team2_group_handle )
	local bag_hilite_handle = vint_object_find( "widget_highlight", team2_group_handle )
	local bag_flag_handle = vint_object_find( "widget_flag2", team2_group_handle )
	local bag_flag_caution_handle = vint_object_find( "widget_flag_caution_2", team2_group_handle )
	local bag_flag_caution_handle2 = vint_object_find( "widget_flag_caution_2_2", team2_group_handle )
	local bag_distance_handle = vint_object_find( "widget_distance", team2_group_handle )
	local bag_player_handle = vint_object_find( "widget_player_flag_main", team2_group_handle )
	local bag_arrow_handle = vint_object_find( "widget_arrow", team2_group_handle )
	local bag_arrow_handle2 = vint_object_find( "widget_arrow2", team2_group_handle )
	local bag_name_handle = vint_object_find( "widget_name", team2_group_handle )
	local bag_logo_handle = vint_object_find( "widget_logo", team2_group_handle )
	local bag_distance_handle = vint_object_find( "widget_distance", team2_group_handle )
	local bag_distance_bg_handle = vint_object_find( "widget_distance_bg", team2_group_handle )
	local bag_distance_m_handle = vint_object_find( "widget_distance_m", team2_group_handle )
	if(Mode_info_visible == false)then
		vint_set_property( team1_group_handle, "visible", false )
		vint_set_property( team2_group_handle, "visible", true )
		vint_set_property( mp_team_score_main_handle, "visible", false )
		vint_set_property( mp_single_score_main_handle, "visible", true )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		vint_set_property( bag_flag_handle, "visible", false )
		vint_set_property( bag_flag_caution_handle, "visible", false )
		vint_set_property( bag_flag_caution_handle2, "visible", false )
		vint_set_property( bag_score_handle, "visible", false )
		vint_set_property( vint_object_find( "widget_score_bg1", team2_group_handle ), "visible", false )
		vint_set_property( bag_hilite_handle, "visible", false )
		vint_set_property( bag_name_handle, "visible", false )
		vint_set_property( mp_team_score_main_handle, "visible", true )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
	end
	if( bagman_distance ~= nil )then
		vint_set_property( bag_distance_handle,"text_tag", bagman_distance )
		vint_set_property( bag_arrow_handle,"rotation", bagman_rotation )
		vint_set_property( bag_arrow_handle2,"rotation", bagman_rotation )
		if( bagman_distance < MP_HUD_MIN_DISTANCE )then
			vint_set_property( bag_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
			vint_set_property( bag_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
			vint_set_property( bag_arrow_handle2,"visible",true )
		else
			vint_set_property( bag_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
			vint_set_property( bag_arrow_handle2,"visible",false )
		end
		if (bag_is_held == true) then
			if(bagman_team == HUMAN_TEAM_GUERILLA)then
				vint_set_property( bag_logo_handle, "image", "ui_hud_guerilla_logo_white" )
				vint_set_property( bag_logo_handle, "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B )
			elseif(bagman_team == HUMAN_TEAM_EDF)then
				vint_set_property( bag_logo_handle, "image", "ui_hud_edf_logo_white" )
				vint_set_property( bag_logo_handle, "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )
			end
		else
			vint_set_property( bag_logo_handle, "image", "ui_map_icon_bagdown" )
			vint_set_property( bag_logo_handle, "tint", 1.0, 1.0, 1.0 )
		end
		if( local_player_has_bag == true )then
			vint_set_property( bag_arrow_handle,"alpha", 0 )
			vint_set_property( bag_arrow_handle2,"alpha", 0 )
			vint_set_property( bag_player_handle,"visible", true )
			local icon1 = vint_object_find( "widget_player_flag", team2_group_handle )
			local icon2 =  vint_object_find( "widget_player_flag_shadow", team2_group_handle )
			vint_set_property(icon1,"visible", false )
			vint_set_property( icon2,"visible", false )
			vint_set_property(bag_distance_handle, "visible", false)
			vint_set_property(bag_distance_bg_handle, "visible", false)
			vint_set_property(bag_distance_m_handle, "visible", false)
		else
			vint_set_property( bag_arrow_handle,"alpha", 1.0 )
			vint_set_property( bag_arrow_handle2,"alpha", 0.5 )
			vint_set_property( bag_player_handle,"visible", false )	
			vint_set_property(bag_distance_handle, "visible", true)
			vint_set_property(bag_distance_bg_handle, "visible", true)
			vint_set_property(bag_distance_m_handle, "visible", true)
		end

	else
		vint_set_property( team2_group_handle, "visible", false )	
	end
	vint_set_property( mp_edf_score_handle, "text_tag", edf_score )
	vint_set_property( mp_guerilla_score_handle, "text_tag", guerilla_score )
	score_highlight(team_id,mp_edf_hilite_handle,mp_guerilla_hilite_handle)
end
function mp_bagman(data_item_handle, event_name)
	local first_player_is_local, first_player_name, first_player_score, second_player_is_local, second_player_name, second_player_score,
		bag_is_held, local_player_has_bag, bagman_name, bagman_distance, bagman_rotation  = vint_dataitem_get(data_item_handle)
	
	-- don't try to set globals to nil
	if bagman_name == nil then
		bagman_name = ""
	end
	
	bagman_distance = ceil(bagman_distance)
	local team1_group_handle = vint_object_find( "mp_mode_widget1" )
	local team2_group_handle = vint_object_find( "mp_mode_widget2" )
	local bag_score_handle = vint_object_find( "widget_score", team2_group_handle )
	local bag_hilite_handle = vint_object_find( "widget_highlight", team2_group_handle )
	local bag_flag_handle = vint_object_find( "widget_flag2", team2_group_handle )
	local bag_flag_caution_handle = vint_object_find( "widget_flag_caution_2", team2_group_handle )
	local bag_flag_caution_handle2 = vint_object_find( "widget_flag_caution_2_2", team2_group_handle )
	local bag_distance_handle = vint_object_find( "widget_distance", team2_group_handle )
	local bag_arrow_handle = vint_object_find( "widget_arrow", team2_group_handle )
	local bag_arrow_handle2 = vint_object_find( "widget_arrow2", team2_group_handle )
	local bag_name_handle = vint_object_find( "widget_name", team2_group_handle )
	local bag_player_handle = vint_object_find( "widget_player_flag_main", team2_group_handle )
	local bag_distance_handle = vint_object_find( "widget_distance", team2_group_handle )
	local bag_distance_bg_handle = vint_object_find( "widget_distance_bg", team2_group_handle )
	local bag_distance_m_handle = vint_object_find( "widget_distance_m", team2_group_handle )
	local widget_arrow_group2 = vint_object_find( "widget_arrow_group2")
	local distance_group_handle = vint_object_find("distance_group")
	if(Mode_info_visible == false)then
		vint_set_property( team1_group_handle, "visible", false )
		vint_set_property( team2_group_handle, "visible", true )
		vint_set_property( mp_team_score_main_handle, "visible", false )
		vint_set_property( mp_single_score_main_handle, "visible", true )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		vint_set_property( bag_flag_handle, "visible", false )
		vint_set_property( bag_flag_caution_handle, "visible", false )
		vint_set_property( bag_flag_caution_handle2, "visible", false )
		vint_set_property( bag_score_handle, "visible", false )
		vint_set_property( vint_object_find( "widget_score_bg1", team2_group_handle ), "visible", false )
		vint_set_property( bag_hilite_handle, "visible", false )
		vint_set_property( vint_object_find( "widget_logo", team2_group_handle ), "visible", false )
		vint_set_property( bag_name_handle, "visible", true )
	end
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "mp_mode_widget2" ), "scale" )
	local arrow_x,arrow_y
	if( bag_is_held == true )then
		if(Old_bagman_name ~= bagman_name)then
			vint_set_property( bag_name_handle, "text_tag", bagman_name )
			local name_x,name_y = vint_get_property( bag_name_handle, "anchor" )
			local name_width,name_height = vint_get_property( bag_name_handle, "screen_size" )
			arrow_x,arrow_y = vint_get_property( widget_arrow_group2, "anchor" )
			local bg_width,bg_height = vint_get_property( vint_object_find( "widget_bg_group2"), "screen_size" )
			local parent_scalex,parent_scaley = vint_get_property( team2_group_handle, "scale" )
			vint_set_property(vint_object_find("widget_bg_group2"),"visible",true)
			vint_set_property(widget_arrow_group2,"anchor",(name_x-(name_width/parent_scalex)-30),arrow_y )
			vint_set_property(bag_player_handle,"anchor",(name_x-(name_width/parent_scalex)-30),arrow_y )
			vint_set_property(vint_object_find("widget_bg_group2"),"anchor",(name_x-(name_width/parent_scalex)-30),arrow_y )
			vint_set_property(distance_group_handle,"anchor",arrow_x + (35*parent_scalex), DISTANCE_GROUP_Y)
		end
	else
		Old_bagman_name = ""
		vint_set_property(bag_name_handle, "text_tag", "HM_FREE")
		vint_set_property(vint_object_find("widget_bg_group2"),"visible",false)
		local bg_x,bg_y = vint_get_property( vint_object_find( "widget_bg_group3"), "anchor" )
		vint_set_property(widget_arrow_group2,"anchor",(bg_x),bg_y )
		arrow_x,arrow_y = vint_get_property( widget_arrow_group2, "anchor" )
		vint_set_property(bag_player_handle,"anchor",(bg_x),bg_y )
		vint_set_property(distance_group_handle,"anchor",DISTANCE_GROUP_X, DISTANCE_GROUP_Y)
	end
	vint_set_property( bag_distance_handle,"text_tag", bagman_distance )
	vint_set_property( bag_arrow_handle,"rotation", bagman_rotation )
	vint_set_property( bag_arrow_handle2,"rotation", bagman_rotation )
	if( bagman_distance < MP_HUD_MIN_DISTANCE )then
		vint_set_property( bag_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( bag_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( bag_arrow_handle2,"visible",true )
	else
		vint_set_property( bag_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
		vint_set_property( bag_arrow_handle2,"visible",false )
	end
	if (prev_first_player_name ~= first_player_name) then
		prev_first_player_name = first_player_name
		vint_set_property( mp_single_high_score_name_handle, "text_tag", first_player_name )
	end
	vint_set_property( mp_single_high_score_num_handle, "text_tag", first_player_score )
	if( local_player_has_bag == true )then
		vint_set_property( bag_arrow_handle2,"alpha", 0 )
		vint_set_property( bag_arrow_handle,"alpha", 0 )
		vint_set_property( bag_player_handle,"visible", true )
		local icon1 = vint_object_find( "widget_player_flag", team2_group_handle )
		local icon2 =  vint_object_find( "widget_player_flag_shadow", team2_group_handle )
		vint_set_property(icon1,"visible", false )
		vint_set_property( icon2,"visible", false )
		vint_set_property(bag_distance_handle, "visible", false)
		vint_set_property(bag_distance_bg_handle, "visible", false)
		vint_set_property(bag_distance_m_handle, "visible", false)
	else
		vint_set_property( bag_arrow_handle,"alpha", 1.0 )
		vint_set_property( bag_arrow_handle2,"alpha", 0.5 )
		vint_set_property( bag_player_handle,"visible", false )	
		vint_set_property(bag_distance_handle, "visible", true)
		vint_set_property(bag_distance_bg_handle, "visible", true)
		vint_set_property(bag_distance_m_handle, "visible", true)
	end
	if( prev_second_player_name ~= second_player_name )then
		prev_second_player_name = second_player_name
		vint_set_property( mp_single_player_score_name_handle, "text_tag", second_player_name )
	end
	vint_set_property( mp_single_player_score_num_handle, "text_tag", second_player_score )
	local highlight_handle = vint_object_find("single_score_highlight")
	if(first_player_is_local == true)then
		local leader_x,leader_y = vint_get_property( mp_single_high_score_num_handle, "anchor" )
		vint_set_property( highlight_handle, "anchor", leader_x,leader_y )
		vint_set_property(highlight_handle, "visible", true)
	elseif (second_player_is_local == true) then
		local user_x,user_y = vint_get_property( mp_single_player_score_num_handle, "anchor" )
		vint_set_property( highlight_handle, "anchor", user_x,user_y )
		vint_set_property(highlight_handle, "visible", true)
	else
		vint_set_property(highlight_handle, "visible", false)
	end
	--vint_set_property(vint_object_find( "message_team_icon" ),"visible",false)
end
function mp_demolition(data_item_handle, event_name)
	local team_id, guerrilla_score, guerilla_demo_status, guerilla_demo_name,local_player_is_guerrilla_demo, guerrilla_distance,guerrilla_rotation, guerrilla_timer, edf_score, edf_demo_status, edf_demo_name, local_player_is_edf_demo, edf_distance, edf_rotation, edf_timer = vint_dataitem_get(data_item_handle)
	-- demo statuses:0 = location known, 1 = location unknown, 2 = demo man dead, 3 = countdown state
	guerrilla_distance = ceil(guerrilla_distance)
	edf_distance = ceil(edf_distance)
	local demo_hud_handle = vint_object_find( "mp_demo_main" )
	local team1_distance_handle = vint_object_find( "demo_team1_distance" )
	local team1_distance_bg_handle = vint_object_find( "demo_team1_distance_bg" )
	local team1_distance_m_handle = vint_object_find( "demo_team1_distance_m" )
	local team2_distance_handle = vint_object_find( "demo_team2_distance" )
	local team2_distance_bg_handle = vint_object_find("demo_team2_distance_bg" )
	local team2_distance_m_handle = vint_object_find("demo_team2_distance_m" )
	local team1_arrow_handle = vint_object_find( "demo_team1_arrow" )
	local team1_arrow_handle2 = vint_object_find( "demo_team1_arrow2" )
	local team2_arrow_handle = vint_object_find( "demo_team2_arrow" )
	local team2_arrow_handle2 = vint_object_find( "demo_team2_arrow2" )
	local team1_player_handle = vint_object_find( "demo_team1_player_head" )
	local team1_player_handle2 = vint_object_find( "demo_team1_player_head2" )
	local team2_player_handle = vint_object_find( "demo_team2_player_head" )
	local team2_player_handle2 = vint_object_find( "demo_team2_player_head2" )
	local team1_timer_handle = vint_object_find( "demo_team1_timer" )
	local team1_timer_handle2 = vint_object_find( "demo_team1_timer_bg" )
	local team2_timer_handle = vint_object_find(  "demo_team2_timer" )
	local team2_timer_handle2 = vint_object_find(  "demo_team2_timer_bg" )
	local team1_timer_icon_handle = vint_object_find( "demo_team1_timer_icon" )
	local team2_timer_icon_handle = vint_object_find( "demo_team2_timer_icon" )
	if(Mode_info_visible == false)then
		vint_set_property( mp_team_score_main_handle, "visible", true )
		vint_set_property( mp_single_score_main_handle, "visible", false )
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		vint_set_property( vint_object_find( "mp_mode_widget1" ), "visible", false )
		vint_set_property( vint_object_find( "mp_mode_widget2" ), "visible", false )
		vint_set_property( demo_hud_handle, "visible", true )
	end
	vint_set_property( mp_guerilla_score_handle, "text_tag", guerrilla_score )
	vint_set_property( mp_edf_score_handle, "text_tag", edf_score )
	vint_set_property( vint_object_find( "mp_guerilla_score2" ), "text_tag", guerrilla_score )
	vint_set_property( vint_object_find( "mp_edf_score2" ), "text_tag", edf_score )
	if( prev_guerrilla_score ~= guerrilla_score )then
		vint_set_property( vint_object_find( "guerilla_score_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "guerilla_score_anim" ), TWEEN_STATE_IDLE )
	end
	if( prev_edf_score ~= edf_score )then
		vint_set_property( vint_object_find( "edf_score_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "edf_score_anim" ), TWEEN_STATE_IDLE )
	end
	prev_guerrilla_score = guerrilla_score
	prev_edf_score = edf_score
	vint_set_property( team1_distance_handle,"text_tag", edf_distance )
	vint_set_property( team2_distance_handle,"text_tag", guerrilla_distance )
	vint_set_property( team1_arrow_handle,"rotation", edf_rotation )
	vint_set_property( team1_arrow_handle2,"rotation", edf_rotation )
	vint_set_property( team2_arrow_handle,"rotation", guerrilla_rotation )
	vint_set_property( team2_arrow_handle2,"rotation", guerrilla_rotation )
	if( edf_distance < MP_HUD_MIN_DISTANCE )then
		vint_set_property( team1_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team1_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team1_arrow_handle2,"visible",true )
	else
		vint_set_property( team1_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
		vint_set_property( team1_arrow_handle2,"visible",false )
	end
	if( guerrilla_distance < MP_HUD_MIN_DISTANCE )then
		vint_set_property( team2_arrow_handle,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team2_arrow_handle2,"tint", HUD_GREEN.R, HUD_GREEN.G, HUD_GREEN.B )
		vint_set_property( team2_arrow_handle2,"visible",true )
	else
		vint_set_property( team2_arrow_handle,"tint", HUD_ORANGE.R, HUD_ORANGE.G, HUD_ORANGE.B )
		vint_set_property( team2_arrow_handle2,"visible",false )
	end
	if( local_player_is_guerrilla_demo == true )then
		vint_set_property(team2_distance_handle, "visible", false)
		vint_set_property(team2_distance_bg_handle, "visible", false)
		vint_set_property(team2_distance_m_handle, "visible", false)
		vint_set_property( team2_arrow_handle,"alpha", 0 )
		vint_set_property( team2_arrow_handle2,"alpha", 0 )
		vint_set_property( team2_player_handle,"visible", true )
		vint_set_property( team2_player_handle2,"visible", true )
		vint_set_property( team2_player_handle,"tint",HUD_TEAM1_COLOR.R,HUD_TEAM1_COLOR.G,HUD_TEAM1_COLOR.B )
		vint_set_property( team2_player_handle,"image", "ui_hud_house_arrest_head_icon" )
		vint_set_property( team2_player_handle2,"image", "ui_hud_house_arrest_head_icon" )
		if(MP_GUERRILLA_DEMO_PLAYING == false)then
			vint_set_property( vint_object_find( "team2_head_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team2_head_anim" ), TWEEN_STATE_IDLE )
			MP_GUERRILLA_DEMO_PLAYING = true
		end
	else
		MP_GUERRILLA_DEMO_PLAYING = false
		vint_set_property( team2_arrow_handle,"alpha", 1.0 )
		vint_set_property( team2_arrow_handle2,"alpha", 0.5 )
		vint_set_property( team2_player_handle,"visible", false )
		vint_set_property( team2_player_handle2,"visible", false )
		vint_set_property(team2_distance_handle, "visible", true)
		vint_set_property(team2_distance_bg_handle, "visible", true)
		vint_set_property(team2_distance_m_handle, "visible", true)
	end
	if( local_player_is_edf_demo == true )then
		vint_set_property(team1_distance_handle, "visible", false)
		vint_set_property(team1_distance_bg_handle, "visible", false)
		vint_set_property(team1_distance_m_handle, "visible", false)
		vint_set_property( team1_arrow_handle,"alpha", 0 )
		vint_set_property( team1_arrow_handle2,"alpha", 0 )
		vint_set_property( team1_player_handle,"visible", true )
		vint_set_property( team1_player_handle2,"visible", true )
		vint_set_property( team1_player_handle,"tint",HUD_TEAM2_COLOR.R,HUD_TEAM2_COLOR.G,HUD_TEAM2_COLOR.B )
		vint_set_property( team1_player_handle,"image", "ui_hud_house_arrest_head_icon" )
		vint_set_property( team1_player_handle2,"image", "ui_hud_house_arrest_head_icon" )
		if(MP_EDF_DEMO_PLAYING == false)then
			vint_set_property( vint_object_find( "team1_head_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team1_head_anim" ), TWEEN_STATE_IDLE )
			MP_EDF_DEMO_PLAYING = true
		end
	else
		MP_EDF_DEMO_PLAYING = false
		vint_set_property( team1_arrow_handle,"alpha", 1.0 )
		vint_set_property( team1_arrow_handle2,"alpha", 0.5 )
		vint_set_property( team1_player_handle,"visible", false )
		vint_set_property( team1_player_handle2,"visible", false )
		vint_set_property(team1_distance_handle, "visible", true)
		vint_set_property(team1_distance_bg_handle, "visible", true)
		vint_set_property(team1_distance_m_handle, "visible", true)
	end
	vint_set_property( team2_timer_handle, "visible", false )
	vint_set_property( team2_timer_handle2, "visible", false )
	vint_set_property( team2_timer_icon_handle, "visible", false )
	if(guerilla_demo_status > 0 and local_player_is_guerrilla_demo == false)then
		vint_set_property(team2_distance_handle, "visible", false)
		vint_set_property(team2_distance_bg_handle, "visible", false)
		vint_set_property(team2_distance_m_handle, "visible", false)
		vint_set_property( team2_arrow_handle,"alpha", 0 )
		vint_set_property( team2_arrow_handle2,"alpha", 0 )
		vint_set_property( team2_player_handle,"visible", true )
		vint_set_property( team2_player_handle2,"visible", true )
		if(guerilla_demo_status == 1)then
			vint_set_property( team2_player_handle,"tint",1,1,1 )
			vint_set_property( team2_player_handle,"image", "ui_hud_tip_icon" )
			vint_set_property( team2_player_handle2,"image", "ui_hud_tip_icon" )
		elseif(guerilla_demo_status >= 2)then
			vint_set_property( team2_player_handle,"tint",HUD_TEAM1_COLOR.R,HUD_TEAM1_COLOR.G,HUD_TEAM1_COLOR.B )
			vint_set_property( team2_player_handle,"image", "ui_hud_weapon_icon_sm_skull" )
			vint_set_property( team2_player_handle2,"image", "ui_hud_weapon_icon_sm_skull" )
			if(guerilla_demo_status == 3)then
				vint_set_property( team2_timer_icon_handle, "visible", true )
				vint_set_property( team2_timer_handle, "visible", true )
				vint_set_property( team2_timer_handle2, "visible", true )
				vint_set_property( team2_timer_handle, "text_tag", guerrilla_timer )
			end
		end
	end
	vint_set_property( team1_timer_handle, "visible", false )
	vint_set_property( team1_timer_handle2, "visible", false )
	vint_set_property( team1_timer_icon_handle, "visible", false )
	if(edf_demo_status > 0 and local_player_is_edf_demo == false)then
		vint_set_property(team1_distance_handle, "visible", false)
		vint_set_property(team1_distance_bg_handle, "visible", false)
		vint_set_property(team1_distance_m_handle, "visible", false)
		vint_set_property(team1_arrow_handle,"alpha", 0 )
		vint_set_property(team1_arrow_handle2,"alpha", 0 )
		vint_set_property( team1_player_handle,"visible", true )
		vint_set_property( team1_player_handle2,"visible", true )
		if(edf_demo_status == 1)then
			vint_set_property( team1_player_handle,"tint",1,1,1 )
			vint_set_property( team1_player_handle,"image", "ui_hud_tip_icon" )
			vint_set_property( team1_player_handle2,"image", "ui_hud_tip_icon" )
		elseif(edf_demo_status >= 2)then
			vint_set_property( team1_player_handle,"tint",HUD_TEAM2_COLOR.R,HUD_TEAM2_COLOR.G,HUD_TEAM2_COLOR.B )
			vint_set_property( team1_player_handle,"image", "ui_hud_weapon_icon_sm_skull" )
			vint_set_property( team1_player_handle2,"image", "ui_hud_weapon_icon_sm_skull" )
			if(edf_demo_status == 3)then
				vint_set_property( team1_timer_icon_handle, "visible", true )
				vint_set_property( team1_timer_handle, "visible", true )
				vint_set_property( team1_timer_handle2, "visible", true )
				vint_set_property( team1_timer_handle, "text_tag", edf_timer )
			end
		end
	end
	score_highlight(team_id,mp_edf_hilite_handle,mp_guerilla_hilite_handle)
end
function mp_mode_info(data_item_handle, event_name)
	local is_visible, is_intro, title, info, stamp_text  = vint_dataitem_get(data_item_handle)
	Mode_info_visible = is_visible
	vint_set_property( vint_object_find( "mp_mode_info_main"), "visible", is_visible)
	vint_set_property(vint_object_find( "mp_message_group" ), "visible", false )
	if( title ~= nil )then
		vint_set_property( vint_object_find( "map_name"), "text_tag", title)
		vint_set_property( vint_object_find( "map_objective"), "text_tag", info)
		vint_set_property( vint_object_find( "map_winner"), "text_tag", info)
	end
	if( is_visible == true and is_intro == true )then
		vint_set_property( vint_object_find( "mp_mode_widget1"), "visible", false)
		vint_set_property( vint_object_find( "mp_mode_widget2"), "visible", false)
		vint_set_property( vint_object_find( "mp_single_score_board_main"), "visible", false)
		vint_set_property( vint_object_find( "mp_team_score_board_main"), "visible", false)
		vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", false )
		vint_set_property(vint_object_find( "mp_message_group" ), "visible", false )
		vint_set_property( vint_object_find( "map_objective"), "visible", true)
		vint_set_property( vint_object_find( "map_winner"), "visible", false)
		vint_set_property( vint_object_find( "mp_time" ), "tint", 0.94,0.70,0.01 )
		vint_set_property( vint_object_find( "mp_time_icon"),"tint",0.94,0.70,0.01 )	
	else
		if(Hud_mode_handle == "king_of_the_hill")then
			vint_set_property( vint_object_find( "mp_team_score_board_main"), "visible", true)
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		elseif(Hud_mode_handle == "bagman")then
			vint_set_property( vint_object_find( "mp_mode_widget2"), "visible", true )
			vint_set_property( vint_object_find( "mp_single_score_board_main"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		elseif(Hud_mode_handle == "team_bagman")then
			vint_set_property( vint_object_find( "mp_mode_widget2"), "visible", true )
			vint_set_property( vint_object_find( "mp_team_score_board_main"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		elseif(Hud_mode_handle == "deathmatch")then
			vint_set_property( vint_object_find( "mp_single_score_board_main"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		elseif(Hud_mode_handle == "team_deathmatch")then
			vint_set_property( vint_object_find( "mp_team_score_board_main"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		elseif(Hud_mode_handle == "capture_the_flag")then
			vint_set_property( vint_object_find( "mp_mode_widget1"), "visible", true )
			vint_set_property( vint_object_find( "mp_mode_widget2"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", false )
		elseif(Hud_mode_handle == "siege")then
			vint_set_property( vint_object_find( "mp_team_score_board_main"), "visible", true )
			vint_set_property( vint_object_find( "mp_dirt_bg_main" ), "visible", true )
		end
	end
	if( is_visible == true and is_intro == false and stamp_text ~= nil)then
		vint_set_property( vint_object_find( "map_objective"), "visible", false)
		vint_set_property(vint_object_find( "mp_message_group" ), "visible", false )
		vint_set_property( vint_object_find( "map_winner"), "visible", true)
		mp_stamp_magic(true, stamp_text)
	else
		mp_stamp_magic(false, stamp_text)
	end
end
function mp_stamp_magic(is_visible, stamp_text)
	if( is_visible == true )then
		local gamer_text_handle =  vint_object_find( "game_over_text")
		vint_set_property( vint_object_find( "mp_game_over"), "visible", true)
		vint_set_property( gamer_text_handle, "text_tag", stamp_text)
		local gamer_text_handle =  vint_object_find( "game_over_text")
		local outline_handle =  vint_object_find( "game_over_outline")
		local outline2_handle =  vint_object_find( "game_over_outline2")
		local parent_scalex,parent_scaley = vint_get_property(vint_object_find( "mp_game_over" ), "scale")
		local text_width,text_height = vint_get_property( gamer_text_handle, "screen_size")
		local text_x,text_y = vint_get_property( gamer_text_handle, "anchor")
		local x_to_set = text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD
		if(x_to_set<=90)then
			x_to_set = 102
		elseif(x_to_set>=198)then
			x_to_set = 198
		end
		vint_set_property(outline2_handle, "anchor", x_to_set,4)
		x_to_set = -1*(text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD)
		if(x_to_set>=-90)then
			x_to_set = -102
		elseif(x_to_set<=-198)then
			x_to_set = -198
		end
		vint_set_property( outline_handle, "anchor", x_to_set,4)
		vint_set_property( vint_object_find( "game_over_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "game_over_anim" ), TWEEN_STATE_RUNNING )
	else
		vint_set_property( vint_object_find( "mp_game_over"), "visible", false)
	end
end
function mp_set_respawn_time(data_item_handle, event_name)
	local is_visible, title, counter, remaining  = vint_dataitem_get(data_item_handle)
	vint_set_property( vint_object_find( "mp_respawn_group" ),"visible", is_visible )
	if (is_visible == true) then
		vint_set_property( vint_object_find( "respawn_title" ),"text_tag", title )
		vint_set_property( vint_object_find( "respawn_time" ),"text_tag", counter )
		if(remaining ~= nil)then
			vint_set_property( vint_object_find( "respawn_counter" ),"visible", true )
			vint_set_property( vint_object_find( "respawn_counter" ),"text_tag", remaining )
		else
			vint_set_property( vint_object_find( "respawn_counter" ),"visible", false )
		end
	end
end
function mp_set_stamp_info(data_item_handle, event_name)
	local is_visible, stamp_text  = vint_dataitem_get(data_item_handle)
	mp_stamp_magic(is_visible, stamp_text)
end
function mp_message_update(data_item_handle, event_name)
	local title,value,color_red,color_green,color_blue,team = vint_dataitem_get(data_item_handle)
	if(title ~= nil and Mode_info_visible == false)then
		vint_set_property(vint_object_find( "mp_message_group" ), "visible", true )
		vint_set_property( vint_object_find( "message_title" ), "text_tag", title )
		vint_set_property( vint_object_find( "message_text" ), "text_tag", value )
		vint_set_property(vint_object_find( "siege_message_main" ),"scale",1.0,1.0 )
		local team_icon_handle = vint_object_find( "message_team_icon" )
		local team_icon_bg_handle = vint_object_find( "message_team_group" )
		local text_group_handle = vint_object_find( "message_text_group" )
		local parent_scalex,parent_scaley = vint_get_property(vint_object_find( "mp_message_group" ), "scale")
		local text_width,text_height = vint_get_property(text_group_handle, "screen_size")
		local text_x,text_y = vint_get_property(text_group_handle, "anchor")
		local icon_x,icon_y = vint_get_property(team_icon_handle, "anchor")
		local icon_bg_x,icon_bg_y = vint_get_property(team_icon_bg_handle, "anchor")
		local x_toset = text_x - (text_width/parent_scalex)*0.5 - MESSAGE_FUDGE
		vint_set_property(team_icon_handle, "anchor", x_toset, icon_y )
		vint_set_property(team_icon_bg_handle, "anchor", x_toset, icon_bg_y )
		vint_set_property(team_icon_bg_handle,"visible",true)
		vint_set_property(team_icon_handle,"visible",true)
		--debug_print("vint","**********MESSAGE team = "..tostring(team).."\n")
		if(team == GUERRILLA)then
			vint_set_property(team_icon_handle,"image","ui_hud_guerilla_logo_white")
		elseif(team == EDF)then
			vint_set_property(team_icon_handle,"image","ui_hud_edf_logo_white")
		elseif(team == NEUTRAL)then
			vint_set_property(team_icon_handle,"image","ui_map_icon_bag")
		else
			vint_set_property(team_icon_handle,"visible",false)
		end
		vint_set_property(team_icon_handle,"tint",color_red,color_green,color_blue)
		vint_set_property(vint_object_find( "message_text" ),"tint",color_red,color_green,color_blue)
		vint_set_property(vint_object_find( "mp_message_group" ), "alpha", 1 )
		vint_set_property(vint_object_find( "mp_message_main_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "mp_message_main_anim" ), TWEEN_STATE_RUNNING )
	else
		vint_set_property(vint_object_find( "mp_message_group" ), "visible", false )
	end
end
function mp_demo_change(data_item_handle, event_name)
	local show_me,demo_title,demo_destroy,demo_info1_text,demo_info1_alpha,demo_info2_text,demo_info2_alpha,demo_info3_text,demo_info3_alpha = vint_dataitem_get(data_item_handle)
	vint_set_property(vint_object_find( "demo_message_group"),"visible",show_me)
	if(show_me == true)then
		vint_set_property(vint_object_find( "demo_title" ), "text_tag", demo_title )
		if(demo_info1_text ~= nil)then
			vint_set_property(vint_object_find( "demo_info_group1" ), "visible", true )
			vint_set_property(vint_object_find( "demo_info_group1" ), "alpha", demo_info1_alpha )
			if(demo_info1_alpha == 1 and demo_destroy == false)then
				vint_set_property(vint_object_find( "demo_info12_alpha_twn_1" ), "max_loops", 3 )
				vint_set_property(vint_object_find( "demo_info12_scale_twn_1" ), "max_loops", 3 )
				vint_set_property(vint_object_find( "destroyer_anim1" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "destroyer_anim1" ), TWEEN_STATE_RUNNING )
			end
			vint_set_property(vint_object_find( "demo_info1" ), "text_tag", demo_info1_text )
			vint_set_property(vint_object_find( "demo_info12" ), "text_tag", demo_info1_text )
		else
			vint_set_property(vint_object_find( "demo_info_group1" ), "visible", false )
		end
		if(demo_info2_text ~= nil) then
			vint_set_property(vint_object_find( "demo_info_group2" ), "visible", true )
			vint_set_property(vint_object_find( "demo_info_group2" ), "alpha", demo_info2_alpha )
			vint_set_property(vint_object_find( "demo_info2" ), "text_tag", demo_info2_text )
		else
			vint_set_property(vint_object_find( "demo_info_group2" ), "visible", false )
		end
		if(demo_info3_text ~= nil)then
			vint_set_property(vint_object_find( "demo_info_group3" ), "visible", true )
			vint_set_property(vint_object_find( "demo_info_group3" ), "alpha", demo_info3_alpha )
			vint_set_property(vint_object_find( "demo_info3" ), "text_tag", demo_info3_text )
		else
			vint_set_property(vint_object_find( "demo_info_group3" ), "visible", false )
		end
		if(demo_destroy == true)then
			if(Prev_destroy ~= true)then
				vint_set_property(vint_object_find( "demo_info1" ), "tint", COLOR_CONTROL.R,COLOR_CONTROL.G,COLOR_CONTROL.B )
				vint_set_property(vint_object_find( "demo_info12" ), "tint", COLOR_CONTROL.R,COLOR_CONTROL.G,COLOR_CONTROL.B )
				vint_set_property(vint_object_find( "destroyer_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "destroyer_anim" ), TWEEN_STATE_RUNNING )
				vint_set_property(vint_object_find( "demo_info12_alpha_twn_1" ), "max_loops", -1 )
				vint_set_property(vint_object_find( "demo_info12_scale_twn_1" ), "max_loops", -1 )
				vint_set_property(vint_object_find( "destroyer_anim1" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "destroyer_anim1" ), TWEEN_STATE_RUNNING )
			end
		else
			vint_set_property(vint_object_find( "demo_info1" ), "alpha", 1.0 )
			vint_set_property(vint_object_find( "demo_info1_bg" ), "alpha", 0.67 )
			vint_set_property(vint_object_find( "demo_info1" ), "tint", DEMO_ORANGE.R,DEMO_ORANGE.G,DEMO_ORANGE.B )
			vint_set_property(vint_object_find( "demo_info12" ), "tint", DEMO_ORANGE.R,DEMO_ORANGE.G,DEMO_ORANGE.B )
			vint_set_child_tween_state( vint_object_find( "destroyer_anim" ), TWEEN_STATE_DISABLED )
		end
		if(demo_destroy~=nil)then
			Prev_destroy = demo_destroy
		end
	end
end
function score_highlight(team_id,handle1,handle2)
	if( prev_team_id ~= team_id )then
		prev_team_id = team_id
		if(team_id == 0)then
			vint_set_property( handle1, "visible", false)
			vint_set_property( handle2, "visible", true)
		else
			vint_set_property( handle1, "visible", true)
			vint_set_property( handle2, "visible", false)	
		end
	end
end
function rfg_ui_multiplayer_hud_cleanup() end