
DISTRICT_OPEN = false
HUD_GRAY			= {R=0.31,G=0.31,B=0.31}

-- control handles
Control_meter_handle = 0
Control_number_handle = 0
Control_change_number_handle = 0
Control_fill_handle = 0
Control_animation_handle = 0
Control_change_animation_handle = 0
Control_meter_animation_handle = 0
Control_start_time = 0
Control_duration = -1

-- mission icon handles
Mission_icon_handle = {0,0,0,0,0,0}
Mission_outline_handle = {0,0,0,0,0,0}
Mission_lock_handle = {0,0,0,0,0,0}
Mission_unlock_anim_handle = 0
Mission_complete_anim_handle = 0
Mission_active_anim_handle = 0

-- morale handles
Morale_meter_handle = 0
Morale_number_handle = 0
Morale_change_number_handle = 0
Morale_change_group_handle = 0
Morale_fill_handle = 0
Morale_animation_handle = 0
Morale_change_animation_handle = 0
Morale_meter_animation_handle = 0
Morale_start_time = 0
Morale_duration = -1
Morale_last_percent = 0

-- radio handles
Radio_handle = 0
Radio_group = 0
Header_text_handle = 0
Body_text_handle = 0
Icon_handle = 0
Left_shadow_handle = 0
Right_shadow_handle = 0
Tween_handle = 0
Group_anchor_tween_handle = 0
Radio_header_anim_handle = 0
Radio_body_text_anim_handle = 0
Radio_meter_1_handle = 0
Radio_meter_2_handle = 0
Radio_meter_3_handle = 0
Radio_meter_4_handle = 0
Radio_fade_alpha = 0
Radio_fade_anchor = 0
Radio_fade_out_anim = 0
Radio_bg_handle = 0
Radio_bg_cap_handle =  0
Radio_top_bg_handle = 0
Radio_bottom_bg_handle = 0
Radio_channel_text_handle = 0
Radio_wrap_width = 0
Radio_header_bg_handle = 0
Radio_shadow_handle = 0

-- alert level handles
Alert_handle = 0
Alert_shine_handle = 0
District_name_handle = 0
Alert_group = 0
Alert_alpha_tween_handle = 0
Alert_scale_tween_handle = 0
Alert_anim_handle = 0
District_name_anim_handle = 0

--new action handles
Action_group_handle = 0
Action_icon_handle = 0
Action_text1_handle = 0
Action_text2_handle = 0
Action_text3_handle = 0

-- choice on menu screen
Text_xtoset_hud = 0
Text_ytoset_hud = 0
Text_speed_hud = 7.0
Last_radio_visible = false
Last_warning_toggle = 0

Control_went_down = false
Morale_went_down = false
Control_done = false
Morale_done = false
Previous_district = 0

-- ##############################################################
function init_handles_hud()
	--control handles
	Control_meter_handle = vint_object_find( "control_meter" )
	Control_number_handle = vint_object_find( "control_number" )
	Control_change_number_handle = vint_object_find( "control_change_number" )
	Control_fill_handle = vint_object_find( "meter_fill" )
	Control_animation_handle = vint_object_find( "control_meter_anim" )
	Control_change_animation_handle = vint_object_find( "control_change_anim" )
	Control_meter_animation_handle = vint_object_find( "meter_fill_anim" )

	--mission handles
	for i=1,6 do
		Mission_icon_handle[i] = vint_object_find( "mission_icon"..i )
		Mission_outline_handle[i] = vint_object_find( "mission_outline"..i )
		Mission_lock_handle[i] = vint_object_find( "mission_lock"..i )
		vint_set_property( Mission_icon_handle[i], "visible", false )
		vint_set_property( Mission_outline_handle[i], "visible", false )
		vint_set_property( Mission_outline_handle[i], "alpha", 0.33 )
		vint_set_property( Mission_lock_handle[i], "visible", false )
	end

	Mission_unlock_anim_handle = vint_object_find( "mission_unlock_anim" )
	Mission_complete_anim_handle = vint_object_find( "mission_complete_anim" )
	Mission_active_anim_handle = vint_object_find( "mission_active_anim" )

	--morale handles
	Morale_meter_handle = vint_object_find( "morale_meter" )
	Morale_number_handle = vint_object_find( "morale_number" )
	Morale_change_number_handle = vint_object_find( "morale_change_number" )
	Morale_change_group_handle = vint_object_find( "morale_change" )
	Morale_fill_handle = vint_object_find( "morale_meter_fill" )
	Morale_animation_handle = vint_object_find( "morale_meter_anim" )
	Morale_change_animation_handle = vint_object_find( "morale_change_anim" )
	Morale_meter_animation_handle = vint_object_find( "morale_meter_fill_anim" )

	--radio handles
	Radio_handle = vint_object_find( "radio_main" )
	Radio_group = vint_object_find( "radio_group" )
	Header_text_handle = vint_object_find( "radio_header_text" )
	Body_text_handle = vint_object_find( "radio_body_text" )
	Icon_handle = vint_object_find( "radio_header_icon" )
	Left_shadow_handle = vint_object_find( "radio_text_left_shadow" )
	Right_shadow_handle = vint_object_find( "radio_text_right_shadow" )
	Tween_handle = vint_object_find( "radio_body_text_tween" )
	Group_anchor_tween_handle = vint_object_find( "radio_main_anchor_twn_1" )
	Radio_header_anim_handle = vint_object_find( "radio_header_anim" )
	Radio_body_text_anim_handle = vint_object_find( "radio_body_text_anim" )
	Radio_meter_1_handle = vint_object_find( "radio_meter_1" )
	Radio_meter_2_handle = vint_object_find( "radio_meter_2" )
	Radio_meter_3_handle = vint_object_find( "radio_meter_3" )
	Radio_meter_4_handle = vint_object_find( "radio_meter_4" )
	Radio_fade_alpha = vint_object_find( "radio_fade_alpha" )
	Radio_fade_anchor = vint_object_find( "radio_fade_anchor" )
	Radio_fade_out_anim = vint_object_find( "radio_fade_out_anim" )
	Radio_bg_handle = vint_object_find( "radio_bg_group" )
	Radio_bg_cap_handle =  vint_object_find( "radio_bg_cap" )
	Radio_top_bg_handle = vint_object_find( "radio_bg3" )
	Radio_bottom_bg_handle = vint_object_find( "radio_bg5" )
	Radio_channel_text_handle = vint_object_find( "radio_channel_text")
	Radio_header_bg_handle = vint_object_find( "radio_header_bg" )
	Radio_shadow_handle = vint_object_find( "radio_header_shadow")

	--alert level handles
	Alert_handle = vint_object_find( "mini_map_alert_level" )
	Alert_shine_handle = vint_object_find( "mini_map_alert_shine" )
	District_name_handle = vint_object_find( "mini_map_district" )
	Alert_group = vint_object_find( "alert_level_group" )
	Alert_alpha_tween_handle = vint_object_find( "mini_map_alert_alpha_tween" )
	Alert_scale_tween_handle = vint_object_find( "mini_map_alert_scale_tween" )
	Alert_anim_handle = vint_object_find( "mini_map_alert_anim" )
	District_name_anim_handle = vint_object_find( "district_name_anim" )
	
	--set the new action handles
	Action_group_handle = vint_object_find( "action_group" )
	Action_icon_handle = vint_object_find( "action_icon" )
	Action_text1_handle = vint_object_find( "action_text1" )
	Action_text2_handle = vint_object_find( "action_text2" )
	Action_text3_handle = vint_object_find( "action_text3" )

	-- Disable control meter tween
	vint_set_property( Control_meter_handle, "visible", false )
	vint_set_child_tween_state( Control_animation_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Control_change_animation_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Control_meter_animation_handle, TWEEN_STATE_DISABLED)

	vint_set_child_tween_state( Mission_unlock_anim_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Mission_complete_anim_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Mission_active_anim_handle, TWEEN_STATE_DISABLED)

	-- Disable morale meter tween
	vint_set_property( Morale_meter_handle, "visible", false )
	vint_set_child_tween_state( Morale_animation_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Morale_change_animation_handle, TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( Morale_meter_animation_handle, TWEEN_STATE_DISABLED)
	
	--change start to call function first sound for control HUD_CONTROL_CHANGE
	local handle = vint_object_find("bg1_alpha_twn_1")
	vint_set_property( handle, "start_event", "play_control_sound_change" )

	--end event for control_number_group_anchor_twn HUD_CONTROL_LOWER only if it lowers
	handle = vint_object_find("meter_fill_scale_twn_2")
	vint_set_property( handle, "end_event", "play_control_sound_lower" )

	--start event for morale_bg1_alpha_twn_1 HUD_MORALE_CHANGE
	handle = vint_object_find("morale_bg1_alpha_twn_1")
	vint_set_property( handle, "start_event", "play_morale_sound_change" )
	
	-- HUD_MORALE_LOWER or HUD_MORALE_RAISE
	handle = vint_object_find("morale_change_anchor_twn_1")
	vint_set_property( handle, "end_event", "play_morale_sound_alter" )

	-- function for notifying done with anim
	handle = vint_object_find("control_meter_alpha_twn_2")
	vint_set_property( handle, "end_event", "end_control" )
	
	handle = vint_object_find("morale_meter_alpha_twn_2")
	vint_set_property( handle, "end_event", "end_morale" )
	
	--stop the district name anim
	vint_set_child_tween_state( District_name_anim_handle, TWEEN_STATE_DISABLED )

	--stop the action anim
	local action_anim_handle = vint_object_find("action_anim")
	vint_set_child_tween_state( action_anim_handle, TWEEN_STATE_DISABLED)
	vint_set_property( Action_group_handle,"visible",false)

	--get the radio text wrap width
	local parent_scalex,parent_scaley = vint_get_property(Radio_handle, "scale" )
	local old_wrap = vint_get_property( Body_text_handle, "wrap_width" )
	Radio_wrap_width = old_wrap * parent_scalex

	--set morale and control colors
	local handle = vint_object_find( "morale_noise" )
	vint_set_property( handle, "tint", COLOR_MORALE.R, COLOR_MORALE.G, COLOR_MORALE.B )
	handle = vint_object_find( "noise" )
	vint_set_property( handle, "tint", COLOR_CONTROL.R, COLOR_CONTROL.G, COLOR_CONTROL.B )

end


-- ##############################################################
function set_fade_tween_state(state)

	if ( state == true ) then	-- running
		vint_set_property( Radio_fade_alpha, "state", TWEEN_STATE_RUNNING )
		vint_set_property( Radio_fade_anchor, "state", TWEEN_STATE_RUNNING )
	else
		vint_set_property( Radio_fade_alpha, "state", TWEEN_STATE_DISABLED )
		vint_set_property( Radio_fade_anchor, "state", TWEEN_STATE_DISABLED )		
	end
end

-- ##############################################################
function rfg_ui_hud_cleanup()

	local handle = vint_object_find("bg1_alpha_twn_1")
	remove_tween_start_callback(handle)

	handle = vint_object_find("meter_fill_scale_twn_2")
	remove_tween_start_callback(handle)

	handle = vint_object_find("morale_bg1_alpha_twn_1")
	remove_tween_end_callback(handle)

	handle = vint_object_find("morale_change_anchor_twn_1")
	remove_tween_end_callback(handle)

	handle = vint_object_find("control_meter_alpha_twn_2")
	remove_tween_end_callback(handle)

	handle = vint_object_find("morale_meter_alpha_twn_2")
	remove_tween_end_callback(handle)

	handle = vint_object_find( "district_group_anchor_twn_2" )
	remove_tween_end_callback(handle)

	remove_tween_end_callback(Tween_handle)

	remove_tween_end_callback(Radio_fade_alpha)
end

-- ##############################################################
function rfg_ui_hud_init()

	-- get the handles
	init_handles_hud()

	-- subscribe to the data item whose name is ButtonAStatus, and we listen for updates, so that
	-- it then calls our function button_a_status_change
	vint_dataitem_add_subscription( "MoraleUpdate", "update", "both_morale_update" )
	vint_dataitem_add_subscription( "RadioUpdate", "update", "radio_show" )
	vint_dataitem_add_subscription( "AlertLevel", "update", "alert_level" )
	vint_dataitem_add_subscription( "NewAction", "update", "hud_set_new_action" )

	-- subscribe to when this tween finishes
	local radio_text_tween_handle = vint_object_find( "radio_body_text_tween" )
	vint_set_property( Tween_handle, "end_event", "radio_text_tween_end" )
	vint_set_property( Radio_fade_alpha, "end_event", "radio_fade_tween_end" )
	
	set_fade_tween_state(false)	

end

-- ##############################################################
function both_morale_update(data_item_handle, event_name)

	local curr_control, delta_control, curr_control_pct, delta_control_pct, curr_civ_pct, last_civ_pct, civ_change, missions_complete, new_mission_completed, num_disctrict_missions, num_missions_locked, num_missions_unlocked, active_mission, control_changed, morale_changed, district_hash  = vint_dataitem_get(data_item_handle)
	local diff_morale = round(100*(curr_civ_pct - last_civ_pct))

	local curr_time = vint_get_time_index()
	if (control_changed == true or new_mission_completed == true or num_missions_unlocked > 0) then
		-- k, control morale has changed - is civilian morale playing?
		local civilian_end_time = Morale_start_time + Morale_duration

		if (delta_control < 0) then
			Control_went_down = true

			if ( Control_done ) then
				rfg_play_audio("HUD_CONTROL_LOWER")
			end
		else
			Control_went_down = false
		end

		if ( curr_time > civilian_end_time ) then
			-- trigger it
			control_update(curr_control, delta_control, curr_control_pct, delta_control_pct, 0, missions_complete, new_mission_completed, num_disctrict_missions, num_missions_locked, num_missions_unlocked, active_mission, district_hash)
		else
			-- queue it up
			control_update(curr_control, delta_control, curr_control_pct, delta_control_pct, civilian_end_time - curr_time, missions_complete, new_mission_completed, num_disctrict_missions, num_missions_locked, num_missions_unlocked, active_mission, district_hash)
		end
	end

	if ( morale_changed == true ) then
		-- k, civilian morale has changed - is control morale playing?
		local control_end_time = Control_start_time + Control_duration

		if (civ_change < 0 ) then
			Morale_went_down = true
		elseif (civ_change > 0 ) then
			Morale_went_down = false
		end

		if(Morale_done)then
			if ( Morale_went_down ) then
				rfg_play_audio("HUD_MORALE_LOWER")
			else
				rfg_play_audio("HUD_MORALE_RAISE")
			end
		end

		if ( curr_time > control_end_time ) then
			-- trigger it
			morale_update(curr_civ_pct, last_civ_pct, civ_change, 0, district_hash)
		else
			-- queue it up
			morale_update(curr_civ_pct, last_civ_pct, civ_change, control_end_time - curr_time, district_hash)
		end
	end

end

-- ##############################################################
function morale_update(current_pct, last_pct, civ_change, offset_time, district_hash)

	-- k, our data items are (bool is visible, float alpha, bool is_guerilla, float pct)
	local rounded_pct, meterfill_pct, meterfill_value, morale_change, rounded_change, morale_end_time = 0

	-- bump percent to be in the range of 0-100
	current_pct = current_pct * 100
	last_pct = last_pct * 100

	local curr_time = vint_get_time_index()
	local end_time = Morale_start_time + Morale_duration

	-- determine how much control has changed then display it as either 
	-- positive or negative
	
	morale_change = current_pct - last_pct
	rounded_change = round(morale_change)	
	rounded_pct = round(current_pct)

	if(civ_change > 0) then		
		vint_set_property( Morale_change_number_handle, "text_tag", "+"..civ_change)
	else
		vint_set_property( Morale_change_number_handle, "text_tag", civ_change)
	end

	vint_set_property( Morale_number_handle, "text_tag", rounded_pct )


	--multipy pct by MORALE_METER_MAX/100 to treat the image size as 1-100	
	
	local MORALE_METER_MAX = 192
	local last_meterfill_inverse, curr_meterfill_inverse		
	
	rounded_pct = round(last_pct)
	
	meterfill_pct = rounded_pct * (MORALE_METER_MAX * .01) 

	last_meterfill_inverse = (MORALE_METER_MAX - meterfill_pct) * -1				
	
	rounded_pct = round(current_pct)
	
	meterfill_pct = rounded_pct * (MORALE_METER_MAX * .01) 

	curr_meterfill_inverse = (MORALE_METER_MAX - meterfill_pct) * -1
	
	vint_set_property( Morale_fill_handle, "scale", 24, last_meterfill_inverse  )

	vint_set_property( Morale_meter_handle, "visible", true )
	vint_set_property( Morale_meter_handle, "alpha", 0 )
	
	--show and play morale meter animation
	local meter_tween1 = vint_object_find("morale_meter_fill_scale_twn_1")
	local meter_tween2 = vint_object_find("morale_meter_fill_scale_twn_2")

	vint_set_property( meter_tween1, "start_value",		24, last_meterfill_inverse )
	vint_set_property( meter_tween1, "end_value",		24, last_meterfill_inverse )
	vint_set_property( meter_tween2, "start_value",		24, last_meterfill_inverse )
	vint_set_property( meter_tween2, "end_value",		24, curr_meterfill_inverse )	
	
	--set the y value of the control change number group
	local change_tween1 = vint_object_find("morale_change_anchor_twn_1")
	local change_tween2 = vint_object_find("morale_change_anchor_twn_2")
	local change_tween3 = vint_object_find("morale_change_anchor_twn_3")

	vint_set_property( change_tween1, "start_value",	-10, (last_meterfill_inverse * -1) )
	vint_set_property( change_tween1, "end_value",		-22, (last_meterfill_inverse * -1) )
	vint_set_property( change_tween2, "start_value",	-22, (last_meterfill_inverse * -1) )
	vint_set_property( change_tween2, "end_value",		-22, (curr_meterfill_inverse * -1) )
	vint_set_property( change_tween3, "start_value",	-22, (curr_meterfill_inverse * -1) )
	vint_set_property( change_tween3, "end_value",		-10, (curr_meterfill_inverse * -1) )

	--unpause morale tween
	local anim_handle = vint_object_find( "morale_fade_out_anim" )
	if ( Morale_duration <= 0 ) then
		Morale_duration = vint_get_anim_duration(anim_handle)
		end_time = -1
	end

	Morale_start_time = curr_time + offset_time

	--set fade out start to current time
	local morale_fade_out = vint_object_find("morale_fade_out_anim")
	vint_set_child_tween_state( morale_fade_out, TWEEN_STATE_IDLE)
	vint_set_property( morale_fade_out, "start_time", Morale_start_time )

	vint_set_child_tween_state( Morale_meter_animation_handle, TWEEN_STATE_IDLE)
	vint_set_property( Morale_meter_animation_handle, "start_time", Morale_start_time )

	vint_set_property(Morale_change_group_handle, "visible", true)
	vint_set_child_tween_state( Morale_change_animation_handle, TWEEN_STATE_IDLE)
	vint_set_property( Morale_change_animation_handle, "start_time", Morale_start_time )
	
	if ( end_time < curr_time ) then
		vint_set_child_tween_state( Morale_animation_handle, TWEEN_STATE_IDLE)
		vint_set_property( Morale_animation_handle, "start_time", Morale_start_time )
	end

	--show the district name
	set_district_info( true, district_hash, Previous_district )
	
end

-- ##############################################################
function control_update(current_control, delta_control, current_pct, delta_pct, offset_time, missions_complete, new_mission_completed, num_district_missions, num_missions_locked, num_missions_unlocked, active_mission, district_hash)
	
	debug_print("vint","\n\nNUM MISSIONS ---------- "..num_district_missions.."\n\nNUM MISSIONS LOCKED ---------------"..num_missions_locked.."\n\nMISSIONS COMPLETE ------------- "..missions_complete)

	-- k, our data items are (bool is visible, float alpha, bool is_guerilla, float pct)
	local rounded_pct, meterfill_pct, meterfill_value, control_change, rounded_change, control_end_time

	local curr_time = vint_get_time_index()
	local end_time = Control_start_time + Control_duration

	-- handle the control change number
	if (delta_control == 0) then
		-- control didn't change, so hide this widget
		vint_set_property( vint_object_find("control_change"), "visible", false )
	else
		-- control did change, so show the widget and set the text tag
		vint_set_property( vint_object_find("control_change"), "visible", true )
		if (delta_control > 0) then
			vint_set_property( Control_change_number_handle, "text_tag", "+"..delta_control)
		else 
			vint_set_property( Control_change_number_handle, "text_tag", delta_control)
		end
	end

	vint_set_property( Control_number_handle, "text_tag", current_control )

	local CONTROL_METER_MAX = 192
	local last_pct = (current_pct - delta_pct)
	local meter_mask_start = (1.0 - last_pct) * CONTROL_METER_MAX * -1
	local meter_mask_end = (1.0 - current_pct) * CONTROL_METER_MAX * -1
		
	vint_set_property( Control_fill_handle, "scale", 24, meter_mask_start )
	vint_set_property( Control_meter_handle, "visible", true )
	vint_set_property( Control_meter_handle, "alpha", 0 )
	
	--show and play control meter animation
	local meter_tween = vint_object_find("meter_fill_scale_twn_2")
	vint_set_property( meter_tween, "start_value",	24, meter_mask_start )
	vint_set_property( meter_tween, "end_value",	24, meter_mask_end )
	vint_set_property( meter_tween, "state", TWEEN_STATE_RUNNING )

	--set the y value of the control change number group
	local change_tween1 = vint_object_find("control_change_anchor_twn_1")
	local change_tween2 = vint_object_find("control_change_anchor_twn_2")
	local change_tween3 = vint_object_find("control_change_anchor_twn_3")

	vint_set_property( change_tween1, "start_value", 	12, (meter_mask_start * -1) )
	vint_set_property( change_tween1, "end_value", 		-22, (meter_mask_start * -1) )
	vint_set_property( change_tween2, "start_value", 	-22, (meter_mask_start * -1) )
	vint_set_property( change_tween2, "end_value", 		-22, (meter_mask_end * -1) )
	vint_set_property( change_tween3, "start_value", 	-22, (meter_mask_end * -1) )
	vint_set_property( change_tween3, "end_value", 		12, (meter_mask_end * -1) )

	--unpause control tween
	local anim_handle = vint_object_find( "control_fade_out_anim" )
	if ( Control_duration <= 0 ) then
		Control_duration = vint_get_anim_duration(anim_handle)
		end_time = -1
	end

	Control_start_time = curr_time + offset_time

	--set fade out start to current time
	local control_fade_out = vint_object_find("control_fade_out_anim")
	vint_set_child_tween_state( control_fade_out, TWEEN_STATE_IDLE)
	vint_set_property( control_fade_out, "start_time", Control_start_time )

	vint_set_child_tween_state( Control_change_animation_handle, TWEEN_STATE_IDLE)
	vint_set_property( Control_change_animation_handle, "start_time", Control_start_time )

	vint_set_child_tween_state( Control_meter_animation_handle, TWEEN_STATE_IDLE)
	vint_set_property( Control_meter_animation_handle, "start_time", Control_start_time )
	
	if ( end_time < curr_time ) then

		vint_set_child_tween_state( Control_animation_handle, TWEEN_STATE_IDLE)
		vint_set_property( Control_animation_handle, "start_time", Control_start_time )

	end

	--handle mission icons

	-- turn everybody off and reset all properties back to their start values
	for i=1,6 do 
		vint_set_property( Mission_icon_handle[i], "visible", false )
		vint_set_property( Mission_outline_handle[i], "visible", false )
		vint_set_property( Mission_lock_handle[i], "visible", false )

		vint_set_property( Mission_icon_handle[i], "alpha", 1.0 )
		vint_set_property( Mission_outline_handle[i], "alpha", 1.0 )
		vint_set_property( Mission_lock_handle[i], "alpha", 1.0 )

		vint_set_property( Mission_icon_handle[i], "scale", 0.75, 0.75 )
		vint_set_property( Mission_outline_handle[i], "scale", 1.0, 1.0 )
		vint_set_property( Mission_lock_handle[i], "scale", 1.0, 1.0 )
	end

	-- turn on the outlines for how many missions there are in this district
	for i=1,num_district_missions do
		vint_set_property( Mission_outline_handle[i], "visible", true )
	end

	-- now turn on the mission icons for the number of missions remaining
	local num_missions_to_show = num_district_missions - missions_complete
	if ( new_mission_completed == true ) then
		-- there was just a mission completed, so we need to show one more mission, so that we can animate him
		num_missions_to_show = num_missions_to_show + 1
	end
	for i=1, num_missions_to_show do
		vint_set_property( Mission_icon_handle[i], "visible", true )
		vint_set_property( Mission_icon_handle[i], "tint", 1.0,1.0,1.0 )
	end

	-- now turn on the locks
	local num_locks_to_show = num_missions_locked
	if (num_missions_unlocked > 0) then
		num_locks_to_show = num_locks_to_show + 1
	end
	for i=1, num_locks_to_show do
		vint_set_property( Mission_lock_handle[i], "visible", true )
		vint_set_property( Mission_icon_handle[i], "tint", HUD_GRAY.R,HUD_GRAY.G,HUD_GRAY.B )
	end
			
	--handle when mission is active
	if(active_mission == true) then
		
		local active_mission_twn = vint_object_find("mission_active_twn_1")

		--the graphics for the mission are reversed in Vinny
		--so remap the active_mission to the correct icon
		local active_mission_target = (num_district_missions - missions_complete)

		vint_set_property(active_mission_twn, "target_name", "mission_outline"..active_mission_target)

		vint_set_child_tween_state( Mission_active_anim_handle, TWEEN_STATE_RUNNING)

	else
		vint_set_child_tween_state( Mission_active_anim_handle, TWEEN_STATE_DISABLED)
	end
	
	local num_unlocked_missions = num_district_missions - num_missions_locked
	
	--handle when mission is unlocked
	if(num_missions_unlocked > 0) then

		--handle unlock animation
		--assign icon tweens 1-4
		for i=0,4 do
			vint_set_property( vint_object_find("mission_unlock_twn_"..i), "target_name", "mission_icon"..num_locks_to_show)
		end

		--assign lock tweens 5-9
		for i=5,9 do
			vint_set_property( vint_object_find("mission_unlock_twn_"..i), "target_name", "mission_lock"..num_locks_to_show)
		end

		--assign outline tweens 9-17
		for i=10,17 do
			vint_set_property( vint_object_find("mission_unlock_twn_"..i), "target_name", "mission_outline"..num_locks_to_show)
		end

	end


	--handle when new mission is complete
	if(new_mission_completed == true) then
	
		--handle mission complete animation
		--assign icon tweens 1-6
		for i=1,6 do
			vint_set_property( vint_object_find("mission_complete_twn_"..i), "target_name", "mission_icon"..num_missions_to_show)
		end

		--assign outline tweens 7-15
		for i=7,15 do
			vint_set_property( vint_object_find("mission_complete_twn_"..i), "target_name", "mission_outline"..num_missions_to_show)
		end
		
	end

	if(missions_complete > 0) then
			
		for i=(num_missions_to_show + 1), num_district_missions do 
			vint_set_property( Mission_icon_handle[i], "visible", false )
			vint_set_property( Mission_outline_handle[i], "visible", true )
			vint_set_property( Mission_outline_handle[i], "alpha", 0.33 )	
		end

	end

	--queue up mission animations
	local delay_anim = 0
	
	if(new_mission_completed == true) then

		vint_set_child_tween_state( Mission_complete_anim_handle, TWEEN_STATE_IDLE)
		vint_set_property( Mission_complete_anim_handle, "start_time", Control_start_time )	

		delay_anim = vint_get_anim_duration(Mission_complete_anim_handle)
		play_mission_completed_sound()
	else
		vint_set_child_tween_state( Mission_complete_anim_handle, TWEEN_STATE_DISABLED)
	end

	if(num_missions_unlocked > 0) then
	
		if (new_mission_completed == false) then
			play_mission_unlocked_sound()
		end
		
		vint_set_child_tween_state( Mission_unlock_anim_handle, TWEEN_STATE_IDLE)
		vint_set_property( Mission_unlock_anim_handle, "start_time", Control_start_time + delay_anim )	
	else
		vint_set_child_tween_state( Mission_unlock_anim_handle, TWEEN_STATE_DISABLED)
	end

	--show the district name
	set_district_info( true, district_hash, Previous_district )
	
end


-- ##############################################################
function radio_show(data_item_handle, event_name)
	-- k, our data items are (bool is visible, float alpha, bool is_guerilla, float pct)
	local visible, header_text, body_text, duration, radio_icon, body_crc, show_msg_txt, show_as_radio, radio_freq_hi, radio_freq_lo, rmi  = vint_dataitem_get(data_item_handle)
	
	--debug_print("vint","visible = "..tostring(visible)..", header_text = "..tostring(header_text)..", duration = "..tostring(duration).."\n")
	
	vint_set_property(Body_text_handle, "visible", show_msg_txt)
	vint_set_property(vint_object_find( "radio_bg_group" ), "visible", show_msg_txt)
	vint_set_property( vint_object_find("radio_bg10"),"visible",false )
	vint_set_property( vint_object_find("radio_bg_cap10"),"visible",false )

	local radio_scalex, radio_scaley = vint_get_property( Radio_handle, "scale" )
	local min_width = 370 * radio_scalex
	
	vint_set_property( Radio_handle, "alpha", 1.0 )
	vint_set_property( Radio_group, "alpha", 1.0 )
	vint_set_property( Radio_handle, "visible", show_as_radio )
	vint_set_property( Header_text_handle, "text_tag", header_text )
	if (body_crc == 0) then
		vint_set_property( Body_text_handle, "text_tag", body_text )
		vint_set_property( vint_object_find("radio_subtitle_text"), "text_tag", body_text )
		vint_set_property( vint_object_find("radio_subtitle_text_shadow"), "text_tag", body_text )
	else
		vint_set_property( Body_text_handle, "text_tag_crc", body_crc )
		vint_set_property( vint_object_find("radio_subtitle_text"), "text_tag_crc", body_crc )
		vint_set_property( vint_object_find("radio_subtitle_text_shadow"), "text_tag_crc", body_crc )
	end

	--set the wrap width
	vint_set_property( Body_text_handle,"wrap_width", Radio_wrap_width )

	--set the icon to show
	if ( radio_icon ~= "" ) then
		vint_set_property( Radio_meter_1_handle, "visible", false )
		vint_set_property( Radio_meter_2_handle, "visible", false )
		vint_set_property( Radio_meter_3_handle, "visible", false )
		vint_set_property( Radio_meter_4_handle, "visible", false )
		vint_set_property( Icon_handle, "visible", show_as_radio )
		vint_set_property( Icon_handle, "image", radio_icon )
		vint_set_property( Icon_handle, "scale", 1.2,1.2 )
	else
		vint_set_property( Radio_meter_1_handle, "visible", show_as_radio )
		vint_set_property( Radio_meter_2_handle, "visible", show_as_radio )
		vint_set_property( Radio_meter_3_handle, "visible", show_as_radio )
		vint_set_property( Radio_meter_4_handle, "visible", show_as_radio )
		vint_set_property( Icon_handle, "visible", false )
	end

	--store off the text box width after we set the text
	local text_box_width, text_box_height = vint_get_property( Body_text_handle, "screen_size" )
	--check to see if we scrolled past the range
	if (( Last_radio_visible ~= visible ) and (visible == true)) then
	
		local adjusted_text_box_width = text_box_width/radio_scalex
		if( text_box_height > 25 ) then

			local start_x = Text_xtoset_hud
			local text_end_value = Text_xtoset_hud-text_box_width
			local start_time = vint_get_time_index() + 1
			
			--vint_set_property(Tween_handle, "start_value", Text_xtoset_hud, Text_ytoset_hud)
			vint_set_property(Tween_handle, "duration", duration)
			--vint_set_property(Tween_handle, "end_value", text_end_value, Text_ytoset_hud)
			
			--Reset time index
			vint_set_property(Radio_body_text_anim_handle, "start_time", start_time )
			vint_set_property(Radio_header_anim_handle, "start_time", vint_get_time_index() )

			-- Can't set tween states on animations, set it on the child tweens instead
			--vint_set_property(Radio_header_anim_handle, "state", TWEEN_STATE_RUNNING)
			vint_set_child_tween_state(Radio_header_anim_handle, TWEEN_STATE_RUNNING)

			vint_set_child_tween_state(Radio_body_text_anim_handle, TWEEN_STATE_RUNNING)
			
			--vint_set_child_tween_state(Radio_fade_out_anim, TWEEN_STATE_DISABLED )
		else
				
			local start_x = Text_xtoset_hud
			local text_end_value = Text_xtoset_hud
			local start_time = vint_get_time_index()
			
			vint_set_property(Tween_handle, "duration", duration)

			--Reset time index
			vint_set_property(Radio_body_text_anim_handle, "start_time", start_time )
			vint_set_property(Radio_header_anim_handle, "start_time", start_time )

			-- Can't set tween states on animations, set it on the child tweens instead
			vint_set_child_tween_state(Radio_header_anim_handle, TWEEN_STATE_RUNNING)
			vint_set_child_tween_state(Radio_body_text_anim_handle, TWEEN_STATE_RUNNING)
			--vint_set_child_tween_state(Radio_fade_out_anim, TWEEN_STATE_DISABLED )
		end
		if( show_as_radio ) then
			vint_set_property( Radio_group ,"visible", true)
			vint_set_property( vint_object_find("mini_map_bg_2"),"visible",false )
			vint_set_property( vint_object_find("mini_map_bg_3"),"visible",false )
			if(show_msg_txt == true)then
				vint_set_property( vint_object_find("radio_bg10"),"visible", true )
				vint_set_property( vint_object_find("radio_bg_cap10"),"visible", true)
			else
				vint_set_property( vint_object_find("radio_bg10"),"visible", false )
				vint_set_property( vint_object_find("radio_bg_cap10"),"visible", false)
			end
		else
			vint_set_property( Radio_group ,"visible", false)
			vint_set_property( vint_object_find("mini_map_bg_2"),"visible",true )
			vint_set_property( vint_object_find("mini_map_bg_3"),"visible",true )
			vint_set_property( vint_object_find("radio_bg10"),"visible", false )
			vint_set_property( vint_object_find("radio_bg_cap10"),"visible", false)
		end

		set_fade_tween_state(false)	

	elseif ( visible == false ) then
	
		set_fade_tween_state(false)	
		
		vint_set_property( Radio_group ,"anchor", -900, 80)
		vint_set_property( Radio_group ,"visible", false)
		radio_fade_tween_end()
		--[[if( duration <= 0 ) then
			-- we really want to kill this one, post haste! Stat, even!
			vint_set_property(Tween_handle, "state", TWEEN_STATE_DISABLED )
			radio_fade_tween_end()
			return
		else
			vint_set_property(Tween_handle, "state", TWEEN_STATE_IDLE )
			radio_fade_tween_end()
		end]]

	end

	if( text_box_width < min_width )then
		text_box_width = min_width
	end

	local radio_bg_x,radio_bg_y = vint_get_property(Radio_bg_handle, "anchor" )
	local text_x,text_y = vint_get_property(Body_text_handle, "anchor" )
	local parent_scalex,parent_scaley = vint_get_property(Radio_handle, "scale" )
	
	local new_x = text_x + (text_box_width/parent_scalex) + 10
	vint_set_property(Radio_bg_handle, "anchor", new_x, radio_bg_y)

	--position the header bg based on header text width
	local header_x,header_y = vint_get_property( Radio_header_bg_handle, "anchor" )
	local header_text_x,header_text_y = vint_get_property( Header_text_handle, "anchor" )
	local header_text_width,header_text_height = vint_get_property( Header_text_handle, "screen_size" )
	
	new_x = header_text_x + ( header_text_width/parent_scalex ) + 10
	vint_set_property(Radio_header_bg_handle, "anchor", new_x, header_y)

	local shadow_width,shadow_height = vint_get_property( Radio_shadow_handle,"screen_size" )
	local new_width = ( header_text_width ) + 2
	vint_set_property(Radio_shadow_handle, "screen_size", new_width, shadow_height)
	--local shadow_scalex,shadow_scaley = vint_get_property( Radio_shadow_handle,"scale" )
	--vint_set_property(Radio_shadow_handle, "anchor", new_width, shadow_height)

	--debug_print("vint","RADIO::header_text_x = "..header_text_x..", header_text_width = "..header_text_width..", new_x = "..new_x.."\n")

	--make and set the radio station number
	local first_number = rfg_rand(100,999)
	local second_number = rfg_rand(0,9)
	local number_to_set = first_number.."."..second_number
	if( radio_freq_hi > 0 and radio_freq_lo > 0 ) then
		number_to_set = radio_freq_hi.."."..radio_freq_lo
	end

	vint_set_property(Radio_channel_text_handle,"text_tag",number_to_set)

	-- only show this for radio messages
	if( visible ) then
		if (show_as_radio) then
			vint_set_property( vint_object_find("radio_main"),"visible", true )
			vint_set_property( vint_object_find("radio_subtitle_group"),"visible", false )
		elseif (show_msg_txt ) then
			vint_set_property( vint_object_find("radio_main"),"visible", false )
			vint_set_property( vint_object_find("radio_subtitle_group"),"visible", true )
		else
			-- no subtitles, no nothing!
			vint_set_property( vint_object_find("radio_main"),"visible", false )
			vint_set_property( vint_object_find("radio_subtitle_group"),"visible", false )
		end
	else
		vint_set_property( vint_object_find("radio_main"),"visible", false )
		vint_set_property( vint_object_find("radio_subtitle_group"),"visible", false )
	end
	
	Last_radio_visible = visible
end

-- ##############################################################
function radio_text_tween_end()
	vint_set_property( Radio_fade_out_anim, "start_time", vint_get_time_index() )
	set_fade_tween_state(true)
	vint_set_property( vint_object_find("mini_map_bg_2"),"visible",true )
	vint_set_property( vint_object_find("mini_map_bg_3"),"visible",true )
	vint_set_property( vint_object_find("radio_bg10"),"visible",false )
	vint_set_property( vint_object_find("radio_bg_cap10"),"visible",false )
end

-- ##############################################################
function radio_fade_tween_end()
	Last_radio_visible = false
	set_fade_tween_state(false)
end

-- ##############################################################
function alert_level(data_item_handle, event_name)

	local visible_usability, visible_alert, alert_level_value, district_hash, fallback_name = vint_dataitem_get(data_item_handle)
	
	--do we need to show the stuff?	
	local alert_visible = visible_alert and visible_usability
	
	vint_set_property( Alert_group, "visible", alert_visible )
	
	local warning_toggle = 0

	--set the alert level colors
	if(alert_level_value >= 0 ) and (alert_level_value <= 25 )then
		--green
		vint_set_property( Alert_handle,"tint",0.01,0.64,0.01)
		vint_set_property( Alert_shine_handle,"tint",0.01,0.64,0.01)
		warning_toggle = 20
		--stop the shine anim
		vint_set_child_tween_state( Alert_anim_handle, TWEEN_STATE_DISABLED )
		vint_set_property( Alert_shine_handle, "alpha", 0 )
		vint_set_property( Alert_shine_handle, "scale", 0.8, 0.8 )

	elseif(alert_level_value <= 50 )then
		--yellow
		vint_set_property( Alert_handle,"tint",0.98,0.90,0.02 )
		vint_set_property( Alert_shine_handle,"tint",0.98,0.90,0.02)
		warning_toggle = 45
		--start the shine anim
		vint_set_property( Alert_alpha_tween_handle, "duration", 1.0 )
		vint_set_property( Alert_scale_tween_handle, "duration", 1.0 )
		vint_set_property( Alert_alpha_tween_handle, "end_value", 0.33 )
		vint_set_property( Alert_scale_tween_handle, "end_value", 1.0,1.0 )
		vint_set_property( Alert_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Alert_anim_handle,TWEEN_STATE_RUNNING )

	elseif(alert_level_value <= 75 )then
		--orange
		vint_set_property( Alert_handle,"tint",1.0,0.40,0.0 )
		vint_set_property( Alert_shine_handle,"tint",1.0,0.40,0.0 )
		warning_toggle = 70
		--start the shine anim
		vint_set_property( Alert_alpha_tween_handle, "duration", 0.75 )
		vint_set_property( Alert_scale_tween_handle, "duration", 0.75 )
		vint_set_property( Alert_alpha_tween_handle, "end_value", 0.50 )
		vint_set_property( Alert_scale_tween_handle, "end_value", 1.2,1.2 )
		vint_set_property( Alert_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Alert_anim_handle, TWEEN_STATE_RUNNING )

	else
		--red
		vint_set_property( Alert_handle,"tint",0.70,0.08,0.08)
		vint_set_property( Alert_shine_handle,"tint",0.70,0.08,0.08)
		warning_toggle = 105
		--start the shine anim
		vint_set_property( Alert_alpha_tween_handle, "duration", 0.50 )
		vint_set_property( Alert_scale_tween_handle, "duration", 0.50 )
		vint_set_property( Alert_alpha_tween_handle, "end_value", 0.75 )
		vint_set_property( Alert_scale_tween_handle, "end_value", 1.5,1.5 )
		vint_set_property( Alert_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Alert_anim_handle,TWEEN_STATE_RUNNING )
	end

	-- save last warning toggle
	Last_warning_toggle = warning_toggle
	--set the district name
	if((district_hash ~= 0 and Previous_district ~= district_hash) or (district_hash == 0 and Previous_district ~= fallback_name)) then
		set_district_info( visible_usability, district_hash, fallback_name )
	end
	
end

-- ##############################################################
function set_district_info( visible_usability, district_hash, fallback_name )
	vint_set_property( District_name_handle, "visible", visible_usability )
	--district_group_anchor_twn_2
	if( DISTRICT_OPEN == false )then
		--start the anim
		vint_set_property(District_name_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( District_name_anim_handle, TWEEN_STATE_IDLE )
		
		local district_tween_handle = vint_object_find( "district_group_anchor_twn_2" )
		vint_set_property( district_tween_handle, "end_event", "district_tween_end" )

		DISTRICT_OPEN = true
	else
		--TODO reset the time
		vint_set_property(District_name_anim_handle, "start_time", (vint_get_time_index() - 0.17) )
		--vint_set_child_tween_state( District_name_anim_handle, TWEEN_STATE_IDLE )
	end
	
	if (district_hash ~= 0) then
		vint_set_property( District_name_handle, "text_tag_crc", district_hash)
	else
		vint_set_property( District_name_handle, "text_tag", fallback_name)
	end

	--get the scale
	vint_set_property( District_name_handle, "text_scale",0.75,0.75 )
	local text_scale_x,text_scale_y = vint_get_property( District_name_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "mini_map_main" ), "scale" )

	local text_width,text_height = vint_get_property( District_name_handle, "screen_size" )
	local name_max_width = 164.0 * parent_scalex
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( District_name_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( District_name_handle, "text_scale",text_scale_x,text_scale_y )
	end

	--store the district name so we can compare it next time
	if (district_hash ~= nil) then
		Previous_district = district_hash
	else 
		Previous_district = 0
	end
end

-- ##############################################################

function district_tween_end()
	DISTRICT_OPEN = false
end

-- ##############################################################
function hud_set_new_action(data_item_handle, event_name)
	local icon,text1,text2,text3 = vint_dataitem_get(data_item_handle)
	
	vint_set_property( Action_group_handle,"visible",true)
	vint_set_property( Action_icon_handle,"image",icon)
	vint_set_property( Action_text1_handle,"text_tag",text1)
	vint_set_property( Action_text2_handle,"text_tag",text2)
	vint_set_property( Action_text3_handle,"text_tag",text3)

	--play the animation
	local action_anim_handle = vint_object_find("action_anim")
	vint_set_child_tween_state( action_anim_handle, TWEEN_STATE_RUNNING)
	vint_set_property( action_anim_handle, "start_time", vint_get_time_index() )

end


-- ##############################################################
function play_control_sound_change()
	rfg_play_audio("HUD_CONTROL_CHANGE")
end

-- ##############################################################
function end_control()
	Control_done = false
end

-- ##############################################################
function play_morale_sound_change()
	rfg_play_audio("HUD_MORALE_CHANGE")
end

-- ##############################################################
function end_morale()
	Morale_done = false
end

-- ##############################################################
function play_control_sound_lower()
	if ( Control_went_down ) then
		rfg_play_audio("HUD_CONTROL_LOWER")
	end
	Control_done = true
end

-- ##############################################################
function play_morale_sound_alter()
	if ( Morale_went_down ) then
		rfg_play_audio("HUD_MORALE_LOWER")
	else
		rfg_play_audio("HUD_MORALE_RAISE")
	end
	Morale_done = true
end

-- ##############################################################
function play_mission_unlocked_sound()
	rfg_play_audio("HUD_CONTROL_MISSION_UNLOCK")
end

-- ##############################################################
function play_mission_completed_sound()
	rfg_play_audio("HUD_CONTROL_MISSION_COMPLETE")
end

