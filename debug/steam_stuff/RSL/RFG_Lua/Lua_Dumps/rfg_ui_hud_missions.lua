
LUA_MISSION_PARTYTIME			= -2
LUA_MISSION					= -1
LUA_MISSION_ACTIVITY_INVALID		= 0
LUA_ACTIVITY_RAID				= 1
LUA_ACTIVITY_HOUSE_ARREST		= 2
LUA_ACTIVITY_CONVOY			= 3
LUA_ACTIVITY_GUERILLA_EXPRESS		= 4
LUA_ACTIVITY_RIDING_SHOTGUN		= 5
LUA_ACTIVITY_DEMOLITIONS		= 6
LUA_ACTIVITY_CATCH_THE_COURIER	= 7
LUA_ACTIVITY_AREA_DEFENSE		= 8
LUA_ACTIVITY_RAID_OFFENSIVE		= 9

LUA_DIVERSION_MAYHEM			= 1
LUA_DIVERSION_PROPAGANDA		= 2
LUA_DIVERSION_KILLING_SPREE		= 3
LUA_DIVERSION_MINING			= 4
LUA_DIVERSION_CAR_BOMB			= 5 


Header_icon_images = { 
	"ui_map_icon_objective",	
	"ui_map_icon_raid",				
	"ui_map_icon_house_arrest",
	"ui_map_icon_convoy",
	"ui_map_icon_shotgun",
	"ui_map_icon_demo",
	"ui_map_icon_express",
	"ui_map_icon_raid_d",	
	"ui_map_icon_courier",
	"ui_map_icon_areadefense",
	"ui_map_icon_convoy_cap" }

OBJECT_HANDLES_DIVERSIONS		= 4
OBJECT_HANDLES_HOUSE_ARREST		= 3
STAMP_PAD					= 20

Timer_x					= 0
Timer_y					= 0
Timer_text_x				= 0
Timer_text_y				= 0
Target_x					= 0
Target_y					= 0

Diversion_total				= 0
Diversion_running_total			= 0
Diversion_group_size			= {0, 0}

-- handles
Obj_handles_miss	 			= {0,0,0,0,0,0}
Edf_logo_handle 				= 0

-- convoy handles
Convoy_group_handle 			= 0
Convoy_civilian_health_group	 	= 0
Convoy_civilian_damage_group 		= 0
Convoy_civilian_health 			= 0
Convoy_civilian_damage 			= 0
Convoy_civilian_bg1_handle		= 0
Convoy_civilian_bg2_handle 		= 0
Convoy_civilian_bg3_handle		= 0
Convoy_civilian_bg4_handle 		= 0
Convoy_civilian_bg5_handle		= 0
Convoy_timer_handle 			= 0
Convoy_strength_num_handle 		= 0
Convoy_target_group_handle 		= 0
Convoy_tween_handle			= 0
Convoy_strength_1_handle 		= 0
Convoy_strength_2_handle 		= 0
Convoy_target_text_handle 		= 0
Convoy_car_number_handle		= 0
Convoy_target_1_handle			= 0
Convoy_target_2_handle			= 0
Convoy_bg_group_handle			= 0
Convoy_car_group_handle			= 0
Convoy_edf_logo_handle			= 0
Convoy_car_icon_handle			= 0
Convoy_alpha_tween_handle		= 0
Ad_bg_group_handle				= 0

-- diversion handles
Diversion_group_handle	 		= {OBJECT_HANDLES_DIVERSIONS = 0}
Diversion_timer_tween_handle	 	= {OBJECT_HANDLES_DIVERSIONS = 0}

-- mission handles
Mission_header_main_handle 		= 0
Mission_header_anim_handle		= 0
Mission_message_anim_handle 		= 0
Mission_message_group_handle 		= 0
Mission_text_group_handle		= 0
Mission_mask_handle			= 0
Mission_text_cursor			= 0
Mission_cursor_twn_handle		= 0
Mission_cursor_mask_twn_handle	= 0
Mission_cursor_alpha_twn_handle	= 0
Mission_objective_icon_handle		= 0
Mission_icon_group_handle		= 0
Mission_alpha_tween_handle		= 0

-- house arrest handles
House_arrest_group_handle		= 0
House_arrest_tween_handle		= 0
House_arrest_alpha_tween		= 0
House_arrest_anim		 		= { OBJECT_HANDLES_HOUSE_ARREST = 0 }
House_arrest_head				= { OBJECT_HANDLES_HOUSE_ARREST = 0 }
House_arrest_lock				= { OBJECT_HANDLES_HOUSE_ARREST = 0 }
House_arrest_anim				= { OBJECT_HANDLES_HOUSE_ARREST = 0 }

-- raid handles
Raid_group_handle 			= 0
Raid_meter_handle				= 0
Raid_guerrilla_handle 			= 0
Raid_edf_handle 				= 0
Raid_guerrilla2_handle 			= 0
Raid_edf2_handle 				= 0
Raid_guerrilla_anim_handle 		= 0
Raid_edf_anim_handle 			= 0
Raid_guerrilla_logo_handle 		= 0
Raid_edf_logo_handle 			= 0
Raid_guerrilla_anim_handle 		= 0
Raid_edf_anim_handle 			= 0
Raid_alpha_tween_handle			= 0

-- riding shotgun handles
Shotgun_main_group_handle 		= 0
Shotgun_score_handle			= 0
Shotgun_flash_anim_handle 		= 0

-- stress system handles
Stress_system_handle 			= 0
Stress_anim_handle 			= 0
Stress_title_handle			= 0
Stress_label_handle			= 0

-- activity handles
Activity_stamp_handle 			= 0
Activity_tween_handle 			= 0
Activity_status_text_handle		= 0
Activity_complete_handle		= 0
Activity_complete2_handle		= 0
Activity_failed_handle			= 0
Activity_alpha_tween 			= 0

-- timer handles
Hud_timer_group_handle			= 0
Hud_timer_number_handle			= 0

-- misc. handles
Objective_complete_anim 		= 0
Header_icon_handle			= 0
Header_icon_handle2			= 0
Radio_text_mask_handle			= 0
Message_title_handle			= 0
Message_text_handle			= 0
Objective_icon_handle			= 0

Mission_objective_anim_handle		= 0


Not_update					= false
Not_update_diversion			= false
Mayhem_data_item_handle			= 0

Stamp_duration				= 0.5
Fade_duration				= 0.5
Activity_status				= 0
Bypass_sound				= false

Prev_shotgun_score			= 0.0

Previous_guerilla_num			= 0
Previous_edf_num				= 0


Widescreen					= false
Title_max_width				= 0
Objective_max_width			= 0

Prev_header_title				= ""
Prev_objective				= ""
Prev_mission_type				= LUA_MISSION_ACTIVITY_INVALID

-- ##############################################################
function rfg_ui_hud_missions_cleanup()
	local activity_tween_handle = vint_object_find( "activity_scale_tween" )
	remove_tween_end_callback(activity_tween_handle)
end

-- ##############################################################
function rfg_ui_hud_missions_init()

	-- get the handles
	init_mission_handles()

	-- subscribe to the data item whose name is MissionInfo, and we listen for updates, so that
	-- it then calls our function show_missions
	vint_dataitem_add_subscription( "MissionInfo", "update", "mission_info" )
	vint_dataitem_add_subscription( "MissionStatus", "update", "handle_activity_status" )
	vint_dataitem_add_subscription( "ObjectiveStatus", "update", "objective_change" )

	vint_datagroup_add_subscription( "DiversionInfo", "insert", "diversion_info" )
	vint_datagroup_add_subscription( "DiversionInfo", "update", "diversion_info" )
	vint_datagroup_add_subscription( "DiversionInfo", "remove", "diversion_remove" )

	vint_dataitem_add_subscription( "HudTimerInfo", "update", "timer_update")

	--we need to use the objective complete art for building destroyed also
	--adding the subscription in this file since it is always loaded and the art lives here
	--vint_dataitem_add_subscription( "BuildingStatus", "update", "building_destroyed" )

	--vint_datagroup_add_subscription( "MultiplayerFunctionName", "update", "mp_info" )
	local activity_tween_handle = vint_object_find( "activity_scale_tween" )
	vint_set_property( activity_tween_handle, "end_event", "stamp_tween_complete" )

end

-- ##############################################################
function init_mission_handles()
	--mission text info
	Obj_handles_miss[1] 			= vint_object_find( "mission_header_text" )
	Obj_handles_miss[2] 			= vint_object_find( "mission_header_sub_text" )
	Obj_handles_miss[3]			= vint_object_find( "convoy_strength_group" )
	Obj_handles_miss[4] 			= vint_object_find( "convoy_car_group" )
	Obj_handles_miss[5]			= vint_object_find( "convoy_target_title_1" )
	Obj_handles_miss[6]			= vint_object_find( "convoy_target_title_3" )

	Edf_logo_handle 			= vint_object_find( "convoy_edf_logo" )
	
	-- get convoy handles
	Convoy_group_handle 			= vint_object_find( "convoy_main" )
	--Convoy_civilian_health_group 		= vint_object_find( "convoy_civilian_group" )
	--Convoy_civilian_damage_group 		= vint_object_find( "convoy_civilian_group2" )
	--Convoy_civilian_health 		= vint_object_find( "convoy_civilian_health" )
	--Convoy_civilian_damage 		= vint_object_find( "convoy_civilian_damage" )
	Convoy_civilian_bg1_handle 		= vint_object_find( "convoy_bg_1" )
	Convoy_civilian_bg2_handle 		= vint_object_find( "convoy_bg_2" )
	Convoy_civilian_bg3_handle		= vint_object_find( "convoy_bg_3" )
	--Convoy_civilian_bg4_handle 		= vint_object_find( "convoy_bg_4" )
	Convoy_civilian_bg5_handle		= vint_object_find( "convoy_bg_5" )
	Convoy_timer_handle 			= vint_object_find( "convoy_timer" )
	Convoy_strength_num_handle 		= vint_object_find( "convoy_strength_number" )
	Convoy_target_group_handle 		= vint_object_find( "convoy_target_group" )
	Convoy_tween_handle 			= vint_object_find( "convoy_mask_tween" )
	Convoy_strength_1_handle 		= vint_object_find( "convoy_strength_title_1" )
	Convoy_strength_2_handle 		= vint_object_find( "convoy_strength_title_2" )
	Convoy_target_text_handle 		= vint_object_find( "convoy_target_distance" )
	Convoy_car_number_handle		= vint_object_find( "convoy_car_number" )
	Convoy_target_1_handle			= vint_object_find( "convoy_target_title_1" )
	Convoy_target_2_handle			= vint_object_find( "convoy_target_title_2" )
	Convoy_car_group_handle			= vint_object_find( "convoy_car_group" )
	Convoy_edf_logo_handle			= vint_object_find( "convoy_edf_logo" )
	Convoy_car_icon_handle			= vint_object_find( "convoy_car_icon" )
	Convoy_alpha_tween_handle		= vint_object_find( "convoy_alpha_tween" )
	Convoy_bg_group_handle			= vint_object_find( "convoy_bg_group" )
	Ad_bg_group_handle				= vint_object_find( "ad_bg_group" )

	-- get diversion handles
	Diversion_group_handle[1] 		= vint_object_find( "diversion_group" )
	Diversion_timer_tween_handle[1] 	= vint_object_find( "diversion_icon_alpha_tween" )

	-- get mission handles
	Mission_header_main_handle 		= vint_object_find( "mission_header_main" )
	Mission_header_anim_handle		= vint_object_find( "mission_header_anim" )
	Mission_message_anim_handle 		= vint_object_find( "mission_message_main_anim" )
	Mission_message_group_handle 		= vint_object_find( "mission_message_group" )
	Mission_text_group_handle		= vint_object_find( "message_text_group" )
	--Mission_mask_handle 			= vint_object_find( "mission_subtext_mask" )
	--Mission_text_cursor			= vint_object_find( "mission_text_cursor" )
	--Mission_cursor_twn_handle		= vint_object_find( "mission_subtext_cursor_tween" )
	--Mission_cursor_mask_twn_handle 	= vint_object_find( "mission_subtext_mask_tween" )
	--Mission_cursor_alpha_twn_handle	= vint_object_find( "mission_text_cursor_alpha_tween" )
	Mission_objective_icon_handle		= vint_object_find( "message_objective_icon" )
	Mission_icon_group_handle		= vint_object_find( "message_icon_group" )
	Mission_alpha_tween_handle		= vint_object_find( "mission_header_alpha_tween" )

	-- get house arrest handles
	House_arrest_group_handle		= vint_object_find( "house_arrest_main" )
	House_arrest_tween_handle		= vint_object_find( "house_arrest_tween" )
	House_arrest_alpha_tween		= vint_object_find( "house_arrest_alpha_tween" )

	for i=1,3 do
		House_arrest_anim[i]		= vint_object_find( "ha_anim_"..i )
		House_arrest_head[i]		= vint_object_find( "ha_head_"..i )
		House_arrest_lock[i]		= vint_object_find( "ha_lock_"..i )
		House_arrest_anim[i]		= vint_object_find( "ha_anim_"..i )
	end

	-- get raid handles
	Raid_group_handle 					= vint_object_find( "raid_main" )
	Raid_meter_handle 					= vint_object_find( "raid_meter_dial" )
	Raid_guerrilla_handle 				= vint_object_find( "raid_guerrilla_num" )
	Raid_edf_handle 						= vint_object_find( "raid_edf_num" )
	Raid_guerrilla2_handle 				= vint_object_find( "raid_guerrilla_num2" )
	Raid_edf2_handle 						= vint_object_find( "raid_edf_num2" )
	Raid_guerrilla_anim_handle 		= vint_object_find( "raid_guerrilla_score_anim" )
	Raid_edf_anim_handle 				= vint_object_find( "raid_edf_score_anim" )
	Raid_guerrilla_logo_handle 		= vint_object_find( "raid_guerilla_logo" )
	Raid_edf_logo_handle 				= vint_object_find( "raid_edf_logo" )
	Raid_guerrilla_anim_handle 		= vint_object_find( "raid_guerrilla_logo_anim" )
	Raid_edf_anim_handle 				= vint_object_find( "raid_edf_logo_anim" )
	Raid_alpha_tween_handle				= vint_object_find( "raid_alpha_tween" )

	-- get riding shotgun handles
	Shotgun_main_group_handle 			= vint_object_find( "shotgun_main" )
	Shotgun_score_handle					= vint_object_find( "shotgun_score" )
	Shotgun_flash_anim_handle 			= vint_object_find( "shotgun_score_flash_anim" )

	-- get stress system handles
	Stress_system_handle 				= vint_object_find( "stress_system")
	Stress_anim_handle 					= vint_object_find( "stress_anim" )
	Stress_title_handle					= vint_object_find( "stress_title" )
	Stress_label_handle					= vint_object_find( "stress_label" )

	-- get activity handles
	Activity_stamp_handle 				= vint_object_find( "activity_status_main" )
	Activity_tween_handle 				= vint_object_find( "activity_scale_tween" )
	Activity_status_text_handle		= vint_object_find( "activity_status_text" )
	Activity_complete_handle			= vint_object_find( "activity_complete" )
	Activity_complete2_handle			= vint_object_find( "activity_complete2" )
	Activity_failed_handle				= vint_object_find( "activity_failed" )
	Activity_alpha_tween 				= vint_object_find( "activity_alpha_tween" )

	-- get misc. handles
	Objective_complete_anim 			= vint_object_find( "mission_message_main_anim" )
	Header_icon_handle					= vint_object_find( "header_icon_target" )
	Header_icon_handle2					= vint_object_find( "header_icon_target2" )
	Radio_text_mask_handle				= vint_object_find( "radio_text_mask" )
	Message_title_handle					= vint_object_find( "message_title" )
	Message_text_handle					= vint_object_find( "message_text" )
	Objective_icon_handle				= vint_object_find( "objective_icon" )

	Mission_objective_anim_handle			= vint_object_find( "mission_objective_anim" )


	Hud_timer_group_handle				= vint_object_find("hud_timer_group")
	Hud_timer_number_handle				= vint_object_find("hud_timer_number")
	
	--------------------------------------
	-- Time to setup our initial state 
	--------------------------------------

	-- hide the edf logo
	vint_set_property( Edf_logo_handle,"visible",false)

	-- hide the convoy stuff
	--vint_set_property( Convoy_civilian_health_group,"visible",false )
	--vint_set_property( Convoy_civilian_damage_group,"visible",false )
	--vint_set_property( Convoy_civilian_bg4_handle, "visible",false )

	-- alpha out the mission message group
	vint_set_property(Mission_message_group_handle, "alpha", 0.0)

	--hide the shotgun group
	vint_set_property( Shotgun_main_group_handle, "visible", false )
	vint_set_child_tween_state(Shotgun_flash_anim_handle, TWEEN_STATE_DISABLED)

	--hide stress stuff
	vint_set_property(Stress_system_handle, "visible", false )
	vint_set_child_tween_state(Shotgun_flash_anim_handle, TWEEN_STATE_DISABLED)

	vint_set_child_tween_state( House_arrest_anim[1], TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( House_arrest_anim[2], TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( House_arrest_anim[3], TWEEN_STATE_DISABLED )

	-- hide diversion group
	vint_set_property( Diversion_group_handle[1], "visible", false )
	vint_set_property( vint_object_find( "Diversion_millions" ), "visible", false )

	Diversion_group_size[1], Diversion_group_size[2] = vint_get_property( Diversion_group_handle[1], "screen_size" )

	vint_set_property( Activity_stamp_handle, "visible", false )
	Stamp_duration = vint_get_property( Activity_tween_handle, "duration" )
	Fade_duration = vint_get_property( Activity_alpha_tween, "duration" )

	vint_set_child_tween_state( Mission_objective_anim_handle, TWEEN_STATE_DISABLED )

	vint_set_child_tween_state(Objective_complete_anim, TWEEN_STATE_DISABLED)

	vint_set_property( vint_object_find("convoy_target_title_3"), "visible", false )	

	local temp_x1,temp_y1 = vint_get_property( Convoy_timer_handle, "anchor" )
	Timer_x = temp_x1 - 30
	Timer_y = temp_y1 + 10
	
	local temp_x2, temp_y2 = vint_get_property( Convoy_strength_num_handle, "anchor" )
	Timer_text_x = temp_x1
	Timer_text_y = temp_y2 + 10

	local temp_x,temp_y = vint_get_property( Convoy_target_group_handle, "anchor" )
	Target_x = temp_x
	Target_y = temp_y - 30

end

-- ##############################################################
function mission_info(data_item_handle, event_name)

	-- get all the data items at once - note that this may have more than an item needs
	local mission_type, mission_title, mission_objective, activity_info, txt1, txt2, txt3 = vint_dataitem_get(data_item_handle)
	
	if ( ( mission_type ~= LUA_MISSION_ACTIVITY_INVALID ) and ( Not_update == false ) )then

		--Reset time index
		local start_time =  vint_get_time_index()
		vint_set_property( Mission_header_anim_handle, "is_paused", false )
		vint_set_child_tween_state( Mission_header_anim_handle, TWEEN_STATE_RUNNING )
		vint_set_property( Mission_header_anim_handle, "start_time", start_time )

		Not_update = true

	end
	
	vint_set_property( Convoy_strength_1_handle, "text_tag", "HM_CONVOY_TITLE" )
	vint_set_property( Convoy_strength_2_handle, "text_tag", "HM_CONVOY_STRENGTH" )

	if ( mission_type == LUA_MISSION ) then		-- mission by itself
	
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[1] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[1] )
	
		-- show/hide appropriate stuff
		vint_set_property( Mission_header_main_handle, "visible", true )
		vint_set_property( House_arrest_group_handle, "visible", false )
		vint_set_property( Convoy_group_handle, "visible", false )
		vint_set_property( Raid_group_handle, "visible", false )

		vint_set_property( Mission_header_main_handle, "alpha", 1.0 )
		
	elseif (mission_type == LUA_MISSION_PARTYTIME) then		-- mission partytime
		
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[1] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[1] )
		
		handle_partytime_info( mission_title, mission_objective, txt1, txt2, txt3)
	
	elseif (mission_type == LUA_ACTIVITY_RAID or mission_type == LUA_ACTIVITY_RAID_OFFENSIVE) then	-- raid
	
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		local icon_index = 8
		if (mission_type == LUA_ACTIVITY_RAID_OFFENSIVE) then
			icon_index = 2
		end

		vint_set_property( Header_icon_handle, "image", Header_icon_images[icon_index] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[icon_index] )
		
		-- do raid stuff
		handle_raid_info( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_HOUSE_ARREST) then		-- house arrest

		if( Not_update_diversion == false )then

			vint_set_property(House_arrest_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(House_arrest_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[3] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[3] )
		
		-- do house arrest stuff
		handle_house_arrest( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_CONVOY) then	-- convoy
		if( Not_update_diversion == false )then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		if (activity_info == 0) then		-- capture
			vint_set_property( Header_icon_handle, "image", Header_icon_images[11] )
			vint_set_property( Header_icon_handle2, "image", Header_icon_images[11] )
		else	
			vint_set_property( Header_icon_handle, "image", Header_icon_images[4] )
			vint_set_property( Header_icon_handle2, "image", Header_icon_images[4] )
		end



		-- do convoy stuff
		handle_convoy( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_RIDING_SHOTGUN) then	-- riding shotgun
		if( Not_update_diversion == false )then
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[5] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[5] )

		-- do shotgun stuff
		handle_shotgun( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_GUERILLA_EXPRESS) then	-- guerilla express
		if( Not_update_diversion == false )then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[7] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[7] )

		-- do express stuff
		handle_express( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_DEMOLITIONS) then	-- demolitions master
		if( Not_update_diversion == false )then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[6] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[6] )

		-- do demolitions stuff
		handle_demolitions( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )

	elseif (mission_type == LUA_ACTIVITY_CATCH_THE_COURIER) then	-- catch the courier 
		if( Not_update_diversion == false )then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[9] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[9] )

		-- do catch the courier 
		handle_catch_the_courier( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )
	
	elseif (mission_type == LUA_ACTIVITY_AREA_DEFENSE) then 		-- area defense
		if ( Not_update_diversion == false ) then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		--k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )

		vint_set_property( Header_icon_handle, "image", Header_icon_images[10] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[10] )

		handle_area_defense( mission_title, mission_objective, activity_info, txt1, txt2 )

	--[[
	elseif (mission_type == LUA_ACTIVITY_AIRSTRIKE_DEFENSE) then	-- airstrike defense
		if( Not_update_diversion == false )then
			vint_set_property(Convoy_tween_handle, "start_time", vint_get_time_index() )
			vint_set_property(Convoy_tween_handle, "state", TWEEN_STATE_RUNNING )
			Not_update_diversion = true
		end
		-- k, we always set the mission title and objective
		handle_title( mission_title )
		handle_objective( mission_objective )	

		vint_set_property( Header_icon_handle, "image", Header_icon_images[10] )
		vint_set_property( Header_icon_handle2, "image", Header_icon_images[10] )

		-- do air strike defense
		handle_airstrike_defense( mission_title, mission_objective, activity_info, txt1, txt2, txt3 )
	--]]	

	else
		-- we hide everything
		vint_set_property( Mission_header_main_handle, "visible", false )
		vint_set_property( Raid_group_handle, "visible", false )
		vint_set_property( House_arrest_group_handle, "visible", false )
		vint_set_property( Convoy_group_handle, "visible", false )
		vint_set_property( Activity_stamp_handle, "visible", false )
		vint_set_property( Shotgun_main_group_handle, "visible", false )
		Not_update = false
		Not_update_diversion = false
		vint_set_property( Stress_system_handle, "visible", false )
	end

	Prev_mission_type = mission_type
end

-- ##############################################################
function handle_cursor()
	--start cursor animation
	--store off the text box width after we set the text
	
	local text_width,text_height = vint_get_property( Obj_handles_miss[2], "screen_size" )
	if( text_height > 17 )then
		vint_set_property( vint_object_find("mission_cursor_main2"), "visible", true )
	else
		vint_set_property( vint_object_find("mission_cursor_main2"), "visible", false )
	end

	--play the anim
	vint_set_property( Mission_objective_anim_handle, "start_time", vint_get_time_index() )
	vint_set_child_tween_state( Mission_objective_anim_handle, TWEEN_STATE_RUNNING )
	
	
	rfg_play_audio("HUD_MIS_OBJECTIVE_TEXT")
	
	--end cursor animation
end

-- ##############################################################
function handle_title(title)

	if( Prev_header_title ~= title and title ~= "" )then
		--set the text
		vint_set_property( Obj_handles_miss[1], "text_tag", title )
		
		--make the mission name fit
		local text_width,text_height = vint_get_property( Obj_handles_miss[1], "screen_size" )
		--get the scale
		local text_scale_x,text_scale_y = vint_get_property( Obj_handles_miss[1], "text_scale" )
		local parent_scale_x, parent_scale_y = vint_get_property( Mission_header_main_handle, "scale")
		Title_max_width = 290.0 * parent_scale_x
		if( text_width > Title_max_width )then
			local new_scale = Title_max_width/text_width * text_scale_x
			vint_set_property( Obj_handles_miss[1], "text_scale", new_scale, 0.8 )
		else
			vint_set_property( Obj_handles_miss[1], "text_scale",text_scale_x,text_scale_y )
		end
	end
	Prev_header_title = title
end

-- ##############################################################
function handle_objective(objective)
	
	vint_set_property( Obj_handles_miss[2], "text_tag", objective )

	--if( Prev_objective ~= objective and objective ~= "" and objective ~= " " and objective ~= nil)then
		--set the text
		--vint_set_property( Obj_handles_miss[2], "text_tag", objective )
		
		local parent_scale_x, parent_scale_y = vint_get_property( Mission_header_main_handle, "scale")
		--move the bg to match longest string
		local new_width
		local bg_x,bg_y = vint_get_property( vint_object_find("mission_header_bg_main"), "anchor" )
		
		local objective_width,objetive_height = vint_get_property( Obj_handles_miss[2], "screen_size" )
		local title_width,title_height = vint_get_property( Obj_handles_miss[1], "screen_size" )
		local title_x,title_y = vint_get_property( Obj_handles_miss[1], "anchor" )
		
		if( title_width >= objective_width )then
			new_width = title_width
		else
			new_width = objective_width
		end

		local adjusted_width = title_x - (new_width/parent_scale_x) - 10

		vint_set_property( vint_object_find("mission_header_bg_main"), "anchor", adjusted_width, bg_y )
		--start the cursor animation in the right spot
		local cursor_x,cursor_y =  vint_get_property( vint_object_find("mission_cursor_main"), "anchor" )
		vint_set_property( vint_object_find("mission_cursor_main_anchor_twn_1"), "start_value", adjusted_width, cursor_y )

		cursor_x,cursor_y =  vint_get_property( vint_object_find("mission_cursor_main2"), "anchor" )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_2"), "start_value", adjusted_width, cursor_y )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_1"), "start_value", adjusted_width, cursor_y )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_1"), "end_value", adjusted_width, cursor_y )
		
		if( Prev_objective ~= objective and objective ~= "" and objective ~= " " and objective ~= nil)then
			handle_cursor()
		end

	--[[else
		debug_print("vint","******** WHOOPS \n")
		-- still have to update the width of the background to handle the title.
		local parent_scale_x, parent_scale_y = vint_get_property( Mission_header_main_handle, "scale")

		--move the bg to match longest string
		local bg_x,bg_y = vint_get_property( vint_object_find("mission_header_bg_main"), "anchor" )
		
		local title_width,title_height = vint_get_property( Obj_handles_miss[1], "screen_size" )
		local title_x,title_y = vint_get_property( Obj_handles_miss[1], "anchor" )
		
		local adjusted_width = title_x - (title_width/parent_scale_x) - 10

		vint_set_property( vint_object_find("mission_header_bg_main"), "anchor", adjusted_width, bg_y )
		--start the cursor animation in the right spot
		local cursor_x,cursor_y =  vint_get_property( vint_object_find("mission_cursor_main"), "anchor" )
		vint_set_property( vint_object_find("mission_cursor_main_anchor_twn_1"), "start_value", adjusted_width, cursor_y )

		cursor_x,cursor_y =  vint_get_property( vint_object_find("mission_cursor_main2"), "anchor" )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_2"), "start_value", adjusted_width, cursor_y )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_1"), "start_value", adjusted_width, cursor_y )
		vint_set_property( vint_object_find("mission_cursor_main2_anchor_twn_1"), "end_value", adjusted_width, cursor_y )

	end]]

	if(Prev_objective == objective)then
		Bypass_sound = true
	end
	Prev_objective = objective
	Bypass_sound = false
end

-- ##############################################################
function refresh()
	vint_set_property( Mission_header_main_handle,		"visible", false ) 
	vint_set_property( Raid_group_handle,					"visible", false )
	vint_set_property( House_arrest_group_handle,		"visible", false )
	vint_set_property( Shotgun_main_group_handle,		"visible", false )
	vint_set_property( Convoy_group_handle,				"visible", false )
	vint_set_property( Convoy_bg_group_handle,			"visible", false )
	vint_set_property( Convoy_civilian_bg1_handle,		"visible", false )
	vint_set_property( Convoy_civilian_bg2_handle,		"visible", false )
	vint_set_property( Convoy_civilian_bg3_handle,		"visible", false )
	vint_set_property( Convoy_civilian_bg5_handle,		"visible", false )
	vint_set_property( Obj_handles_miss[3],				"visible", false )  --convoy strength group
	vint_set_property( Obj_handles_miss[4],				"visible", false )  --convoy car group
	vint_set_property( Obj_handles_miss[5],				"visible", false )  --convoy target title 1
	vint_set_property( Obj_handles_miss[6],				"visible", false )  --convoy target title 3
	vint_set_property( Ad_bg_group_handle,					"visible", false )
	vint_set_property( Convoy_strength_2_handle,			"visible", false )
	vint_set_property( Convoy_strength_1_handle,			"visible", false )
	vint_set_property( Convoy_strength_num_handle,		"visible", false )
	vint_set_property( Convoy_timer_handle,				"visible", false )
	vint_set_property( Edf_logo_handle,						"visible", false ) 
	vint_set_property( Convoy_target_group_handle,		"visible", false )
	vint_set_property( Convoy_target_1_handle,			"visible", false )
	vint_set_property( Convoy_target_2_handle,			"visible", false )
	vint_set_property( Convoy_target_text_handle,		"visible", false )
end


-- ##############################################################
function handle_partytime_info(title, caption, distance, to_close, to_far)
	
	refresh()

	-- show/hide appropriate stuff
	vint_set_property( Mission_header_main_handle,		"visible", true )
	vint_set_property( Convoy_group_handle,				"visible", true )
	vint_set_property( Obj_handles_miss[3],				"visible", true )  --convoy strength group
	vint_set_property( Obj_handles_miss[4],				"visible", false)	 --convoy car group
	vint_set_property( Convoy_strength_1_handle,			"visible", true )
	vint_set_property( Convoy_strength_2_handle,			"visible", true )
	vint_set_property( Convoy_strength_num_handle,		"visible", true )
	vint_set_property( Convoy_bg_group_handle,			"visible", true )
	vint_set_property( Convoy_civilian_bg1_handle,		"visible", true )
	vint_set_property( Convoy_civilian_bg5_handle,		"visible", true )

	--set the strength text
	vint_set_property( Convoy_strength_1_handle, "text_tag", "HM_TARGET_TITLE" )
	vint_set_property( Convoy_strength_2_handle, "text_tag", "HM_TARGET_DISTANCE" )
	vint_set_property( Convoy_strength_num_handle, "text_tag", distance )

	vint_set_property( Convoy_group_handle, "alpha", 1.0 )
	vint_set_property( Mission_header_main_handle, "alpha", 1.0 )
	
	--set distance color/effects
	local target_far_r = 0.67
	local target_far_g = 0.15
	local target_far_b = 0.15
	if (to_close == "true") then
		--make distance text red
		vint_set_property( Convoy_strength_num_handle, "tint", target_far_r, target_far_g, target_far_b )
	elseif (to_far == "true") then
		--make distance text fade or overlay static on the text
		vint_set_property( Convoy_strength_num_handle, "tint", target_far_r, target_far_g, target_far_b )
	else
		local target_ok_r	= 0.98
		local target_ok_g	= 0.58
		local target_ok_b	= 0.02
		vint_set_property( Convoy_strength_num_handle, "tint", target_ok_r, target_ok_g, target_ok_b )
	end

end


-- ##############################################################
function handle_raid_info( title, objective, raid_info, guerrilla_num, edf_num, show_meter )
	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_RAID) then
		refresh()
		vint_set_property( Mission_header_main_handle,		"visible", true )
		vint_set_property( Raid_group_handle,					"visible", true )
		vint_set_property( Mission_header_main_handle, "alpha", 1.0 )
		vint_set_property( Raid_group_handle, "alpha", 1.0 )
	end

	-- Should we show the raid meter?
	if (show_meter == "T") then
		vint_set_property( Raid_group_handle, "visible", true )
	else
		vint_set_property( Raid_group_handle, "visible", false )
	end
	
	local meter_value = (-90.0 - 1.8 * (raid_info - 100.0)) * (3.14159/180.0)

	vint_set_property( Raid_guerrilla_handle, "text_tag", guerrilla_num )
	vint_set_property( Raid_edf_handle, "text_tag", edf_num )
	vint_set_property( Raid_guerrilla2_handle, "text_tag", guerrilla_num )
	vint_set_property( Raid_edf2_handle, "text_tag", edf_num )
	
	--check if numbers changed and do something special to alert the player if they have
	if( Previous_guerilla_num ~= guerrilla_num )then
		--play the anim
		vint_set_property( Raid_guerrilla_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Raid_guerrilla_anim_handle, TWEEN_STATE_RUNNING )
	end
	if( Previous_edf_num ~= edf_num )then
		--play the anim
		vint_set_property( Raid_edf_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Raid_edf_anim_handle, TWEEN_STATE_RUNNING )
	end
	
	--change the handles to work with guerrilla logos
	local num_to_compare = rfg_tonumber( guerrilla_num )--string needs to be a number to compare
	if( num_to_compare <= 3 )then
		--play the anim
		vint_set_property( Raid_guerrilla_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Raid_guerrilla_anim_handle, TWEEN_STATE_RUNNING )
		--set the color to red
		vint_set_property( Raid_guerrilla_logo_handle, "tint", 0.7, 0.19, 0.19 )
		vint_set_property( Raid_guerrilla_handle, "tint", 0.7, 0.19, 0.19 )
		vint_set_property( Raid_guerrilla2_handle, "tint", 0.7, 0.19, 0.19 )
	else
		vint_set_child_tween_state( Raid_guerrilla_anim_handle, TWEEN_STATE_DISABLED )
		--set color to white
		vint_set_property( Raid_guerrilla_logo_handle, "tint", 1, 1, 1 )
		vint_set_property( Raid_guerrilla_logo_handle, "alpha", 1 )
		--set the color to orange
		vint_set_property( Raid_guerrilla_handle, "tint", 1, 0.70, 0.08 )
		vint_set_property( Raid_guerrilla2_handle, "tint", 1, 0.70, 0.08 )
	end
	
	--change the handles to work with edf logos
	num_to_compare = rfg_tonumber( edf_num )--string needs to be a number to compare
	if( num_to_compare <= 3 )then
		--play the anim
		vint_set_property( Raid_edf_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Raid_edf_anim_handle, TWEEN_STATE_RUNNING )
		--set the color to red
		vint_set_property( Raid_edf_logo_handle, "tint", 0.7, 0.19, 0.19 )
		vint_set_property( Raid_edf_handle, "tint", 0.7, 0.19, 0.19 )
		vint_set_property( Raid_edf2_handle, "tint", 0.7, 0.19, 0.19 )
	else
		vint_set_child_tween_state( Raid_edf_anim_handle, TWEEN_STATE_DISABLED )
		--set color to white
		vint_set_property( Raid_edf_logo_handle, "tint", 1, 1, 1 )
		vint_set_property( Raid_edf_logo_handle, "alpha", 1 )
		--set the color to orange
		vint_set_property( Raid_edf_handle, "tint", 1, 0.70, 0.08 )
		vint_set_property( Raid_edf2_handle, "tint", 1, 0.70, 0.08 )
	end

	Previous_guerilla_num = guerrilla_num
	Previous_edf_num = edf_num
	
	--set the rotation of the meter
	vint_set_property( Raid_meter_handle, "rotation", meter_value )

end

-- ##############################################################
function handle_house_arrest(title, objective, icon_alpha, hostage_1, hostage_2, hostage_3 )

	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_HOUSE_ARREST) then
		refresh()
		vint_set_property( Mission_header_main_handle,	 "visible", true )
		vint_set_property( House_arrest_group_handle,	 "visible", true )
		vint_set_property( House_arrest_group_handle, "alpha", 1.0 )
		vint_set_property( Mission_header_main_handle, "alpha", 1.0 )
	end
	
	for i = 1, 3 do
		local hostage_state
		--convert the correct string to a number
		if( i == 1 )then
			hostage_state = rfg_tonumber( hostage_1 )
		elseif( i == 2 )then
			hostage_state = rfg_tonumber( hostage_2 )
		elseif( i == 3 )then
			hostage_state = rfg_tonumber( hostage_3 )
		end

		vint_set_property( House_arrest_head[i], "visible", true )
		vint_set_property( House_arrest_head[i], "image", "ui_hud_house_arrest_head_icon" )
		--hostage
		if( hostage_state == 0 )then
			vint_set_property( House_arrest_head[i], "alpha", 0.5)
			vint_set_property( House_arrest_lock[i], "visible", true )
			vint_set_property( House_arrest_lock[i], "image", "ui_hud_icon_lock" )
			vint_set_property( House_arrest_lock[i], "scale", 1.0, 1.0 )
			vint_set_property( House_arrest_lock[i], "tint", 1.0, 0.5, 0 )
			vint_set_property( House_arrest_head[i], "tint", 1.0, 0.5, 0 )
			vint_set_child_tween_state( House_arrest_anim[i], TWEEN_STATE_DISABLED )
		--following
		elseif( hostage_state == 1 )then
			vint_set_property( House_arrest_head[i], "alpha", 1.0)
			vint_set_property( House_arrest_lock[i], "visible", false )
		--rescued
		elseif( hostage_state == 2 )then
			vint_set_property( House_arrest_head[i], "alpha", 0.5)
			vint_set_property( House_arrest_lock[i], "visible", true )
			vint_set_property( House_arrest_lock[i], "image", "ui_map_icon_safe_house" )
			vint_set_property( House_arrest_lock[i], "scale", 0.6, 0.6 )
			vint_set_property( House_arrest_head[i], "tint", 1.0, 0.5, 0 )
			vint_set_child_tween_state( House_arrest_anim[i], TWEEN_STATE_DISABLED )
		--dead
		elseif( hostage_state == 3 )then
			vint_set_property( House_arrest_head[i], "alpha", 1.0)
			vint_set_property( House_arrest_lock[i], "visible", false )
			vint_set_property( House_arrest_head[i], "image", "ui_hud_weapon_icon_sm_skull")
			vint_set_property( House_arrest_head[i], "tint", 0.7, 0.19, 0.19 )
			vint_set_child_tween_state( House_arrest_anim[i], TWEEN_STATE_DISABLED )
		--in vehicle
		elseif( hostage_state == 4 )then
			vint_set_property( House_arrest_head[i], "alpha", 1.0)
			vint_set_property( House_arrest_lock[i], "visible", true )
			vint_set_property( House_arrest_lock[i], "image", "ui_hud_convoy_car_icon" )
			vint_set_property( House_arrest_lock[i], "scale", 0.6, 0.6 )
			vint_set_property( House_arrest_lock[i], "tint", 1.0, 1.0, 1.0 )
			vint_set_property( House_arrest_head[i], "tint", 1.0, 0.5, 0 )
		--injured
		elseif( hostage_state == 5 )then
			vint_set_property( House_arrest_head[i], "alpha", 1.0)
			vint_set_property( House_arrest_lock[i], "visible", false )
			vint_set_property( House_arrest_head[i], "tint", 0.7, 0.19, 0.19 )
			--start the anim
			vint_set_property( House_arrest_anim[i], "start_time", vint_get_time_index() )
			vint_set_child_tween_state( House_arrest_anim[i], TWEEN_STATE_RUNNING )

		--no valid hostage value, hide everything		
		else
			vint_set_property( House_arrest_head[i], "visible", false)
			vint_set_property( House_arrest_lock[i], "visible", false )
			vint_set_child_tween_state( House_arrest_anim[i], TWEEN_STATE_DISABLED )
		end
	end

end

-- ##############################################################
function handle_shotgun(shotgun_title, shotgun_objective, shotgun_health, shotgun_score, shotgun_goal, shotgun_display)

	-- show/hide appropriate stuff
	--local shotgun_health_percentage = ceil(shotgun_health*100)

	if( shotgun_display == "true") then 		-- Display everything
		refresh()
		vint_set_property( Shotgun_main_group_handle,	"visible", true )
		vint_set_property( Mission_header_main_handle , "visible", true )
		vint_set_property( Mission_header_main_handle, "alpha", 1.0 )

		--convert the core string to a number for comparison
		local shotgun_number = rfg_tonumber( shotgun_score )
		local shotgun_goal_number = rfg_tonumber( shotgun_goal )

		--format the string to display
		local shotgun_score_to_show
		if( shotgun_number >= shotgun_goal_number )then
			shotgun_score_to_show = "[color:#7ec851FF]"..shotgun_score.."/"..shotgun_goal
		else
			shotgun_score_to_show = shotgun_score.."/"..shotgun_goal
		end

		--did the score go up or down or change at all
		if( Prev_shotgun_score > shotgun_number )then
			--we just shot a civilian, play the penalty animation
			vint_set_property( Shotgun_score_handle, "text_tag", shotgun_score_to_show )
			vint_set_property( Shotgun_flash_anim_handle, "start_time", vint_get_time_index() )
			vint_set_child_tween_state(Shotgun_flash_anim_handle, TWEEN_STATE_RUNNING)
		elseif(Prev_shotgun_score <= shotgun_number)then
			--we did something good
			vint_set_property( Shotgun_score_handle, "text_tag", shotgun_score_to_show )
			vint_set_property( Shotgun_score_handle, "alpha", 1.0 )
			vint_set_property( Shotgun_score_handle, "tint", 1.0,0.5,0 )
			vint_set_child_tween_state(Shotgun_flash_anim_handle, TWEEN_STATE_DISABLED)
		end

		--store the score
		Prev_shotgun_score = shotgun_number
	else						-- Don't display anything
		vint_set_property( Shotgun_main_group_handle, "visible", false )
	end
end

-- ##############################################################
function handle_express(express_title, express_objective, activity_info, express_time, express_distance )

	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_GUERILLA_EXPRESS) then
		refresh()
		vint_set_property( Mission_header_main_handle,			"visible", true )
		vint_set_property( Convoy_group_handle,					"visible", true )
		vint_set_property( Convoy_timer_handle,					"visible", true )
		vint_set_property( Convoy_bg_group_handle,				"visible", true )
		vint_set_property( Convoy_civilian_bg1_handle,			"visible", true )
		vint_set_property( Convoy_civilian_bg5_handle,			"visible", true )
		vint_set_property( Convoy_civilian_bg2_handle,			"visible", true )
		vint_set_property( Convoy_civilian_bg3_handle,			"visible", true )
		vint_set_property( Convoy_target_group_handle,			"visible", true )
		vint_set_property( Convoy_target_text_handle,			"visible", true )
		vint_set_property( Convoy_target_2_handle,				"visible", true )
		vint_set_property( Obj_handles_miss[3],					"visible", true )  --convoy strength group
		vint_set_property( Convoy_strength_num_handle,			"visible", true )
		vint_set_property( Convoy_group_handle,					"alpha", 1.0 )
		vint_set_property( Mission_header_main_handle,			"alpha", 1.0 )
	end

	--do express stuff
	vint_set_property( Convoy_target_text_handle, "text_tag", express_distance )
	vint_set_property( Convoy_strength_num_handle, "text_tag", express_time )

	vint_set_property( Obj_handles_miss[6], "visible", true )	--convoy target title 3
end
-- ##############################################################
function handle_convoy(convoy_title, convoy_objective, activity_info, convoy_car_count, convoy_distance, convoy_strength, is_convoy_capture)

	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_CONVOY) then
		refresh()
		vint_set_property( Mission_header_main_handle,		"visible", true )
		vint_set_property( Convoy_group_handle,				"visible", true )
		vint_set_property( Convoy_bg_group_handle,			"visible", true )
		vint_set_property( Convoy_civilian_bg1_handle,		"visible", true )
		vint_set_property( Convoy_civilian_bg5_handle,		"visible", true )
		vint_set_property( Convoy_civilian_bg2_handle,		"visible", true )
		vint_set_property( Convoy_civilian_bg3_handle,		"visible", true )
		vint_set_property( Convoy_target_group_handle,		"visible", true )
		vint_set_property( Convoy_target_2_handle,			"visible", true )
		vint_set_property( Obj_handles_miss[4],				"visible", true )  --convoy car group
		vint_set_property( Obj_handles_miss[3],				"visible", true )  --convoy strength group
		vint_set_property( Convoy_strength_2_handle,			"visible", true )
		vint_set_property( Convoy_strength_1_handle,			"visible", true )
		vint_set_property( Convoy_strength_num_handle,		"visible", true )
		vint_set_property( Convoy_group_handle,				"alpha", 1.0 )
		vint_set_property( Mission_header_main_handle,		"alpha", 1.0 )
	end

	--do convoy stuff
	vint_set_property( Convoy_car_number_handle, "text_tag", convoy_car_count )
	vint_set_property( Convoy_target_text_handle, "text_tag", convoy_distance )
	vint_set_property( Convoy_target_text_handle, "visible", true )
	vint_set_property( Convoy_strength_num_handle, "text_tag", convoy_strength )
	--[[
	Obj_handles_miss[1] 	= vint_object_find( "mission_header_text" )
	Obj_handles_miss[2] 	= vint_object_find( "mission_header_sub_text" )
	Obj_handles_miss[3] 	= vint_object_find( "convoy_strength_group" )
	Obj_handles_miss[4] 	= vint_object_find( "convoy_car_group" )
	Obj_handles_miss[5]	= vint_object_find( "convoy_target_title_1" )
	Obj_handles_miss[6]	= vint_object_find( "convoy_target_title_3" )
	]]
	if (activity_info == 0) then		-- capture
		vint_set_property( Obj_handles_miss[4], "visible", false )
		--show the strength group
		vint_set_property( Convoy_target_group_handle, "visible", true )
		vint_set_property( Obj_handles_miss[3], "visible", true )
		vint_set_property( Obj_handles_miss[5], "visible", true )
		vint_set_property( Obj_handles_miss[6], "visible", true )
		--show the top title
		vint_set_property( Obj_handles_miss[5], "visible", true )
		--hide the bottom title
		vint_set_property( Obj_handles_miss[6], "visible", false )
	elseif (activity_info == 1) then	-- destroy
		--show the car icon for target health
		vint_set_property( Obj_handles_miss[4], "visible", true )
		--hide the strength label
		vint_set_property( Obj_handles_miss[3], "visible", false )
		--show the top title
		vint_set_property( Obj_handles_miss[5], "visible", true )
		--hide the bottom title
		vint_set_property( Obj_handles_miss[6], "visible", false )
		vint_set_property( Convoy_target_group_handle, "visible", true )
	else	-- unknown type, just show both
		vint_set_property( Obj_handles_miss[4], "visible", true )
		vint_set_property( Obj_handles_miss[3], "visible", true )
	end
end

-- ##############################################################
function handle_demolitions(demo_title, demo_objective, activity_info, demo_time, demo_stress_title, demo_stress_label )

	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_DEMOLITIONS) then
		refresh()
		vint_set_property( Mission_header_main_handle,		"visible", true )
		vint_set_property( Convoy_group_handle,				"visible", true )
		vint_set_property( Ad_bg_group_handle,					"visible", true )
		vint_set_property( Obj_handles_miss[3],				"visible", true )
		vint_set_property( Convoy_strength_num_handle,		"visible", true )
		vint_set_property( Convoy_timer_handle,				"visible", true )
		vint_set_property( Convoy_group_handle,				"alpha", 1.0 )
		vint_set_property( Mission_header_main_handle,		"alpha", 1.0 )
		--vint_set_property( Obj_handles_miss[5], "visible", false )
		--vint_set_property( Obj_handles_miss[6], "visible", false )
		--vint_set_property( Obj_handles_miss[4], "visible", false )
		--vint_set_property( Convoy_civilian_bg2_handle, "visible", false )

		--scoot over the timer
		--vint_set_property( Convoy_timer_handle, "anchor", Timer_x, Timer_y )

		--scoot over the timer text
		--vint_set_property( Convoy_strength_num_handle, "anchor", Timer_text_x, Timer_text_y )
	end
	
	--set the timer text
	vint_set_property( Convoy_strength_num_handle, "text_tag", demo_time )

	--stress system stuff
	stress_update( activity_info, demo_stress_title, demo_stress_label )
end


-- ##############################################################
function handle_catch_the_courier(ctc_title, ctc_objective, activity_info, ctc_health, ctc_timer )

	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_CATCH_THE_COURIER) then
		refresh()
		vint_set_property( Mission_header_main_handle,		"visible", true )
		vint_set_property( Convoy_group_handle,				"visible", true )
		vint_set_property( Convoy_target_group_handle,		"visible", true )
		vint_set_property( Convoy_target_text_handle,		"visible", true )
		vint_set_property( Convoy_edf_logo_handle,			"visible", true )
		vint_set_property( Convoy_group_handle,				"alpha", 1.0 )
		vint_set_property( Mission_header_main_handle,		"alpha", 1.0 )
		vint_set_property( Convoy_edf_logo_handle,			"image", "ui_hud_activity_timer" )
		--vint_set_property( Obj_handles_miss[3], "visible", false )
		--vint_set_property( Convoy_civilian_bg4_handle, "visible", false )
		--vint_set_property( Convoy_target_1_handle, "visible", false )
		--vint_set_property( Convoy_target_2_handle, "visible", false )
		--vint_set_property( Convoy_civilian_bg2_handle, "visible", false )
		--vint_set_property( Convoy_civilian_bg4_handle, "visible", false )
		--vint_set_property( Ad_bg_group_handle, "visible", false )
		--vint_set_property( Raid_group_handle, "visible", false )
		--vint_set_property( House_arrest_group_handle, "visible", false )
		--vint_set_property( Convoy_timer_handle, "visible", false )
	end

	--do catch the courier stuff
	if( ctc_health ~= "" )then
		--show convoy_bg_1
		vint_set_property( Convoy_bg_group_handle,			"visible", true )
		vint_set_property( Convoy_civilian_bg1_handle,		"visible", true )
		vint_set_property( Convoy_civilian_bg2_handle,		"visible", false)
		vint_set_property( Convoy_civilian_bg3_handle,		"visible", false)
		vint_set_property( Convoy_civilian_bg5_handle,		"visible", true )
		vint_set_property( Convoy_car_group_handle,			"visible", true )
		vint_set_property( Obj_handles_miss[4],				"visible", true )
		vint_set_property( Convoy_strength_2_handle,			"visible", true )
		vint_set_property( Convoy_strength_1_handle,			"visible", true )
		vint_set_property( Convoy_strength_num_handle,		"visible", true )
		vint_set_property( Convoy_timer_handle,				"visible", true )
	else
		vint_set_property( Convoy_car_group_handle,			"visible", false )
		vint_set_property( Obj_handles_miss[4],				"visible", false )
		vint_set_property( Convoy_bg_group_handle,			"visible", false )
	end
	
	--if the player is out of the chase zone then we show a timer
	if( ctc_timer ~= "" )then
		vint_set_property( Convoy_target_text_handle,		"text_tag", ctc_timer )
		vint_set_property( Convoy_target_text_handle,		"visible", true )
		vint_set_property( Convoy_target_group_handle,		"visible", true )
		vint_set_property( Convoy_civilian_bg3_handle,		"visible", true )
		vint_set_property( Convoy_edf_logo_handle,			"visible", true )
	else
		vint_set_property( Convoy_target_group_handle,		"visible", false )
		vint_set_property( Convoy_civilian_bg3_handle,		"visible", false )
		vint_set_property( Convoy_edf_logo_handle,			"visible", false )
	end

	--set the courier distance
	vint_set_property( Convoy_car_number_handle, "text_tag", ctc_health )		

end

-- ##############################################################
function handle_area_defense( ad_title, ad_objective, activity_info, num_vehicles )
	-- show/hide appropriate stuff
	if (Prev_mission_type ~= LUA_ACTIVITY_AREA_DEFENSE) then
		refresh()
		vint_set_property( Mission_header_main_handle,		"visible", true )
		vint_set_property( Convoy_group_handle,				"visible", true )
		vint_set_property( Obj_handles_miss[4],				"visible", true )  --convoy car group
		vint_set_property( Ad_bg_group_handle,					"visible", true )
		vint_set_property( Convoy_group_handle,				"alpha", 1.0 )
		vint_set_property( Mission_header_main_handle,		"alpha", 1.0 )
		--[[
		vint_set_property( Convoy_target_group_handle,		"visible", false )
		vint_set_property( Convoy_timer_handle,				"visible", false )
		vint_set_property( Convoy_strength_2_handle,			"visible", false )
		vint_set_property( Convoy_strength_1_handle,			"visible", false )
		vint_set_property( Convoy_strength_num_handle,		"visible", false )
		vint_set_property( Raid_group_handle,					"visible", false )
		vint_set_property( House_arrest_group_handle,		"visible", false )
		vint_set_property( Convoy_civilian_bg1_handle,		"visible", false )
		vint_set_property( Convoy_civilian_bg5_handle,		"visible", false )
		vint_set_property( Convoy_civilian_bg2_handle,		"visible", false )
		vint_set_property( Convoy_civilian_bg3_handle,		"visible", false )
		]]--

	end

	if(activity_info == 0)then
		vint_set_property( Convoy_car_icon_handle, "image", "ui_hud_convoy_car_icon")
	else
		vint_set_property( Convoy_car_icon_handle, "image", "ui_hud_house_arrest_head_icon")
		vint_set_property( Convoy_car_icon_handle, "tint", 0.86, 0.58, 0.0)
	end

	vint_set_property( Convoy_car_number_handle, "text_tag", num_vehicles)

end

-- ##############################################################
function handle_activity_status( data_item_handle, event_name )
	local status, value, time_left = vint_dataitem_get(data_item_handle)
	local curr_time_index = vint_get_time_index()

	if ( status < 0 ) then
		--hide text, disable stamp "fade-in" tween
		vint_set_property( Activity_stamp_handle, "visible", false )
		vint_set_property( Activity_tween_handle, "state", TWEEN_STATE_DISABLED )

		-- If our status is -1 but time left isn't, it means that the activity ended but we should show no stamp
		if ( time_left >= 0 ) then
			-- Just hide the groups, because they aren't needed anymore
			vint_set_property( Convoy_group_handle, "visible", false )
			vint_set_property( House_arrest_group_handle, "visible", false )
			vint_set_property( Mission_header_main_handle, "visible", false )
			vint_set_property( Raid_group_handle, "visible", false )
		else
			-- make sure alphas are at 1.0
			vint_set_property( Activity_stamp_handle, "alpha", 1.0 )
			vint_set_property( Convoy_group_handle, "alpha", 1.0 )
			vint_set_property( House_arrest_group_handle, "alpha", 1.0 )
			vint_set_property( Mission_header_main_handle, "alpha", 1.0 )
			vint_set_property( Raid_group_handle, "alpha", 1.0 )

			vint_set_property( Activity_alpha_tween, "state", TWEEN_STATE_DISABLED)
			vint_set_property( Convoy_alpha_tween_handle, "state", TWEEN_STATE_DISABLED)
			vint_set_property( House_arrest_alpha_tween, "state", TWEEN_STATE_DISABLED)
			vint_set_property( Mission_alpha_tween_handle, "state", TWEEN_STATE_DISABLED)
			vint_set_property( Raid_alpha_tween_handle, "state", TWEEN_STATE_DISABLED)
		end
	else

		--set the text value that goes inside the stamp (localized)
		vint_set_property( Activity_status_text_handle, "text_tag", value )

		--show the stamp
		vint_set_property( Activity_stamp_handle, "visible", true )

		--set the correct outline image and color
		local r,g,b = 0
		if( status == 1 )then
			--complete
			r = 0.99
			g = 0.60
			b = 0.02
			Activity_status = 1		
		else -- status must be 0
			--failed
			r = 0.50
			g = 0.00
			b = 0.06
			Activity_status = 0
		end
		--set the color for the status text
		vint_set_property( Activity_status_text_handle, "tint", r, g, b )
		vint_set_property( Activity_complete_handle, "tint", r, g, b )
		vint_set_property( Activity_complete2_handle, "tint", r, g, b )

		local parent_scalex,parent_scaley = vint_get_property(Activity_stamp_handle, "scale")
		local text_width,text_height = vint_get_property( Activity_status_text_handle, "screen_size")
		local text_x,text_y = vint_get_property( Activity_status_text_handle, "anchor")
		local x_to_set = text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD
		if(x_to_set<=90)then
			x_to_set = 102
		elseif(x_to_set>=198)then
			x_to_set = 198
		end
		vint_set_property(Activity_complete2_handle, "anchor", x_to_set,0)
		x_to_set = -1*(text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD)
		if(x_to_set>=-90)then
			x_to_set = -102
		elseif(x_to_set<=-198)then
			x_to_set = -198
		end
		vint_set_property( Activity_complete_handle, "anchor", x_to_set,0)

		-- k, figure out the start time for this anim and tween!
		local total_time = 3.0
		local stamp_end_time = total_time - Stamp_duration
		
		--start handle fade in stuff
		if ( time_left < stamp_end_time ) then
			--we just show the item as is, as our time is passed and we don't have to "stamp" it anymore - with a scale of 1.0,1.0
			vint_set_property( Activity_tween_handle, "state", TWEEN_STATE_DISABLED )
			vint_set_property( Activity_stamp_handle, "scale", 1.0, 1.0 )
		else
			-- we have time, so play the tween (or what we can, anyways)!
			local offset = Stamp_duration - (total_time - stamp_end_time)
			local time_to_set = curr_time_index + offset
			vint_set_property( Activity_tween_handle, "start_time", time_to_set )
			vint_set_property( Activity_tween_handle, "state", TWEEN_STATE_RUNNING )
			vint_set_property( Activity_tween_handle, "duration", Stamp_duration )
		end
		--end handle fade in stuff
		--start handle fade out
		local start_time_to_set
		if ( time_left < Fade_duration ) then
			-- k, we can go ahead and do our fade out tween, but the time left for showing us
			-- is less than our fade out time.  So, we simply set our start time to a time "before" now,
			-- and it will fade us out correctly
			start_time_to_set = curr_time_index - (Fade_duration - time_left)

		else
			-- k, we simply have to set the appropriate start time for all of the tweens, which is:
			local diff = time_left - Fade_duration
			start_time_to_set = curr_time_index + diff

			vint_set_property( Activity_stamp_handle, "alpha", 1.0 )

			--alpha everyone else out
			local ACTIVITY_ENDED_ALPHA	= 0.50
			vint_set_property( Convoy_group_handle, "alpha", ACTIVITY_ENDED_ALPHA )
			vint_set_property( House_arrest_group_handle, "alpha", ACTIVITY_ENDED_ALPHA )
			vint_set_property( Mission_header_main_handle, "alpha", ACTIVITY_ENDED_ALPHA )
			vint_set_property( Raid_group_handle, "alpha", ACTIVITY_ENDED_ALPHA )
		end
		--end handle fade out
		vint_set_property( Activity_alpha_tween, "start_time", start_time_to_set)
		vint_set_property( Convoy_alpha_tween_handle, "start_time", start_time_to_set)
		vint_set_property( House_arrest_alpha_tween, "start_time", start_time_to_set)
		vint_set_property( Mission_alpha_tween_handle, "start_time", start_time_to_set)
		vint_set_property( Raid_alpha_tween_handle, "start_time", start_time_to_set)

		vint_set_property( Activity_alpha_tween, "state", TWEEN_STATE_RUNNING)
		vint_set_property( Convoy_alpha_tween_handle, "state", TWEEN_STATE_RUNNING)
		vint_set_property( House_arrest_alpha_tween, "state", TWEEN_STATE_RUNNING)
		vint_set_property( Mission_alpha_tween_handle, "state", TWEEN_STATE_RUNNING)
		vint_set_property( Raid_alpha_tween_handle, "state", TWEEN_STATE_RUNNING)
		
	end

end

-- ##############################################################
function diversion_info( data_item_handle, event_name )

	-- get all the data items at once - note that this may have more than an item needs
	local which_one, diversion_type, fade_this_in, flash_this, header_text, status_text, value_text = vint_dataitem_get(data_item_handle)

	if ( event_name == "insert" ) then
		diversion_add()
	end

	-- get our diversion group handle
	local diversion_group_handle		= Diversion_group_handle[which_one]
	local diversion_header_handle		= vint_object_find( "diversion_header_text", diversion_group_handle )
	local diversion_status_handle		= vint_object_find( "diversion_status_text", diversion_group_handle )
	local diversion_value_handle		= vint_object_find( "diversion_value_text", diversion_group_handle )
	local diversion_icon_handle		= vint_object_find( "diversion_icon", diversion_group_handle )
	local diversion_text_bg_handle	= vint_object_find( "diversion_text_bg", diversion_group_handle )
	local diversion_text_bg2_handle	= vint_object_find( "diversion_text_bg2", diversion_group_handle )
	local diversion_millions_handle	= vint_object_find( "diversion_millions", diversion_group_handle )

	if ( fade_this_in ) then
		-- do fade in tween?  or can be triggered on the add
		vint_set_property( diversion_header_handle, "visible", true )
		vint_set_property( diversion_status_handle, "visible", true )
		vint_set_property( diversion_text_bg_handle, "visible", true )
		vint_set_property( diversion_text_bg2_handle, "visible", true )

	elseif ( flash_this ) then
		-- flash this on and off
		vint_set_property( Diversion_timer_tween_handle[which_one], "state", TWEEN_STATE_RUNNING )
	else
		vint_set_property( Diversion_timer_tween_handle[which_one], "state", TWEEN_STATE_DISABLED )
		vint_set_property( diversion_icon_handle, "alpha", 1.0 )

	end

	if( status_text ~= "" )then
		vint_set_property( diversion_header_handle, "visible", true )
		vint_set_property( diversion_status_handle, "visible", true )
		vint_set_property( diversion_text_bg_handle, "visible", true )
		vint_set_property( diversion_text_bg2_handle, "visible", true )
	else
		vint_set_property( diversion_header_handle, "visible", false )
		vint_set_property( diversion_status_handle, "visible", false )
		vint_set_property( diversion_text_bg_handle, "visible", false )
		vint_set_property( diversion_text_bg2_handle, "visible", false )
	end

	vint_set_property( diversion_header_handle, "text_tag", header_text )
	vint_set_property( diversion_status_handle, "text_tag", status_text )
	vint_set_property( diversion_value_handle, "text_tag", value_text )

	if(diversion_type == LUA_DIVERSION_MAYHEM)then
		vint_set_property( diversion_icon_handle, "image","ui_hud_diversion_icon_mayhem")
		vint_set_property( diversion_millions_handle, "visible", true )
		--cache off mayhem handle
		Mayhem_data_item_handle = data_item_handle

	elseif(diversion_type == LUA_DIVERSION_KILLING_SPREE)then
		vint_set_property( diversion_icon_handle, "image","ui_hud_diversion_icon_killspree")
		vint_set_property( diversion_millions_handle, "visible", false )
	elseif(diversion_type == LUA_DIVERSION_CAR_BOMB)then
		vint_set_property( diversion_icon_handle, "image","ui_hud_diversion_icon_carbomb")
		vint_set_property( diversion_millions_handle, "visible", false )
	end

end

-- ##############################################################
function diversion_add()
	
	local cnt = Diversion_total
	local new_cnt = cnt + 1
	if ( new_cnt > 1 ) then

		local prev = Diversion_total

		-- bump diversion cnt
		local add_one = Diversion_running_total + 1
		Diversion_running_total = add_one

		-- k, clone the icon and text stuff
		Diversion_group_handle[new_cnt] = vint_object_clone_rename(Diversion_group_handle[1], "diversion_group"..Diversion_running_total )
		Diversion_timer_tween_handle[new_cnt] = vint_object_clone_rename(Diversion_timer_tween_handle[1], "diversion_icon_alpha_tween"..Diversion_running_total )

		local diversion_group_handle_prev		= Diversion_group_handle[prev]
		local diversion_group_handle_new		= Diversion_group_handle[new_cnt]
		local diversion_icon_handle_new			= vint_object_find( "diversion_icon", diversion_group_handle_new )

		local offset = Diversion_group_size[2] + 6
		-- k, setup the positions - get the previous item's position
		local anchor_x, anchor_y = vint_get_property( diversion_group_handle_prev, "anchor" )
		local new_y = anchor_y + offset
		vint_set_property( diversion_group_handle_new, "anchor", anchor_x, new_y )

		--pause the animation and set the alpha to 100%
		vint_set_property( Diversion_timer_tween_handle[new_cnt], "target_handle", diversion_icon_handle_new )
		vint_set_property( Diversion_timer_tween_handle[new_cnt], "state", TWEEN_STATE_DISABLED )
		vint_set_property( diversion_icon_handle_new, "alpha", 1.0 )

	else 
		-- k, we just make sure it is visible
		vint_set_property( Diversion_group_handle[1], "visible", true )
	end

	-- bump cnt
	Diversion_total = new_cnt
end

-- ##############################################################
function diversion_remove(data_item_handle, event_name)

	if ( Mayhem_data_item_handle == data_item_handle ) then
		-- hide the millions tag
		local diversion_millions = vint_object_find( "Diversion_millions" )
		vint_set_property( diversion_millions, "visible", false )
	end

	-- here we would delete the appropriate item, and then decrement our count of these
	local cnt = Diversion_total
	if ( cnt - 1 > 0 ) then

		-- here we simply delete the last items - that is it
		vint_object_destroy( Diversion_group_handle[Diversion_total] )
		vint_object_destroy( Diversion_timer_tween_handle[Diversion_total] )

	else
		vint_set_property( Diversion_group_handle[1], "visible", false )
	end

	Diversion_total = cnt - 1
	if ( Diversion_total < 0 ) then
		Diversion_total = 0
	end
end

-- ##############################################################
function stamp_tween_complete()

	if ( Activity_status == 0 ) then
		rfg_play_audio("HUD_ACT_FAIL")
	else
		rfg_play_audio("HUD_ACT_COMPLETE")
	end
end

-- ##############################################################
function objective_change(data_item_handle, event_name)

	local update, title, label, image = vint_dataitem_get(data_item_handle)
	
	if (update == true) then
		vint_set_property(Message_title_handle, "text_tag", title )
		vint_set_property(Message_text_handle, "text_tag", label )

		--debug_print("vint","Mission_objective_icon_handle:: image = "..image.."\n")
		
		if(image ~= nil and image ~= "")then
			vint_set_property(Mission_objective_icon_handle, "visible", true )
			vint_set_property(Mission_objective_icon_handle, "image", image )
			if(image == "ui_map_icon_pmedium")then
				vint_set_property(Mission_objective_icon_handle, "scale", 1.3,1.2 )
			end
		else
			vint_set_property(Mission_objective_icon_handle, "visible", false )
		end

		vint_set_property(Mission_message_group_handle, "alpha", 1.0)
		vint_set_property(Objective_complete_anim, "start_time", vint_get_time_index())
		vint_set_child_tween_state(Objective_complete_anim, TWEEN_STATE_RUNNING)

		--scoot the icon over
		local parent_scalex,parent_scaley = vint_get_property(Mission_message_group_handle, "scale")
		local group_scalex,group_scaley = vint_get_property(vint_object_find( "mission_message_main" ), "scale")
		local text_width,text_height = vint_get_property(Mission_text_group_handle, "screen_size")
		local text_x,text_y = vint_get_property(Mission_text_group_handle, "anchor")
		local icon_x,icon_y = vint_get_property(Mission_objective_icon_handle, "anchor")
		local icon_bg_x,icon_bg_y = vint_get_property(Mission_icon_group_handle, "anchor")

		local x_toset = text_x - (text_width/parent_scalex/group_scalex)*0.5 - 25/parent_scalex

		vint_set_property(Mission_objective_icon_handle, "anchor", x_toset, icon_y )
		vint_set_property(Mission_icon_group_handle, "anchor", x_toset, icon_bg_y )

		x_toset = text_x + (text_width/parent_scalex/group_scalex)*0.5 + 25/parent_scalex

		local tail_handle = vint_object_find("message_bg_tail")
		local tail_x,tail_y =  vint_get_property( tail_handle, "anchor")
		vint_set_property(tail_handle, "anchor", x_toset, tail_y )

		--debug_print("vint","Group_scalex = "..group_scalex.."\n")
	end
end

-- ##############################################################
function stress_update(is_visible,stress_title,stress_label)
	vint_set_property(Stress_title_handle, "text_tag", stress_title )
	vint_set_property(Stress_label_handle, "text_tag", stress_label )

	if(is_visible > 0)then
		vint_set_property(Stress_system_handle, "visible", true )
		vint_set_property(Stress_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state(Stress_anim_handle, TWEEN_STATE_RUNNING)
	else
		vint_set_property(Stress_system_handle, "visible", false )
		vint_set_child_tween_state(Stress_anim_handle, TWEEN_STATE_DISABLED)
	end
	
end

function timer_update(data_item_handle, event_name)
	local visible, timer_text = vint_dataitem_get(data_item_handle)
	
	vint_set_property(Hud_timer_group_handle, "visible", visible)
	if visible == false then
		return
	end
	
	vint_set_property(Hud_timer_number_handle, "text_tag", timer_text)
end