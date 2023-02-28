
Show_me		= false

Use_image_names	={	"ui_hud_hand_icon",
			"ui_hud_hand_icon",--"ui_hud_hydrotank_icon",
			"ui_hud_hand_icon",--"ui_hud_ladder_icon",
			"ui_hud_convoy_car_icon",
			"ui_map_icon_mission_marauder",
			"ui_hud_icon_demo_man",--demo gurr
			"ui_hud_icon_demo_man",--demo edf
			"ui_hud_icon_bag",--bagman gurr
			"ui_hud_icon_bag",--bagman edf
			"ui_hud_icon_upgrade"}--for upgrades table
Use_info_was_visible = false

Ammo_group_handle	= {OBJECT_HANDLES_AMMO = 0}
Ammo_anim_handle	= {OBJECT_HANDLES_AMMO = 0}
Ammo_total_count	= 0
Ammo_running_count	= 0
Ammo_start_x		= 0
Ammo_start_y		= 0
Ammo_width		= 0
Ammo_gap_width		= -30

Salvage_anim_handle = 0
Salvage_anim2_handle = 0
			
-- ##############################################################
function rfg_ui_messages_cleanup()
	
end

-- ##############################################################
function rfg_ui_messages_init()

	-- get the handles
	init_msg_handles()
	
	-- subscribe to the data item whose name is BLANK, and we listen for updates
	vint_dataitem_add_subscription( "SwapData", "update", "swap_info" )
	vint_dataitem_add_subscription( "UseData", "update", "use_info" )
	--vint_dataitem_add_subscription( "AmmoData", "update", "ammo_info" )
	
	-- subscribe to the data group for ammo pickup messages
	vint_datagroup_add_subscription( "AmmoData", "insert", "ammo_info" )
	vint_datagroup_add_subscription( "AmmoData", "update", "ammo_info" )
	vint_datagroup_add_subscription( "AmmoData", "remove", "ammo_remove" )

end

-- ##############################################################
function init_msg_handles()

	local message_animate_in_handle	= vint_object_find( "message_animate_in" )
	local message_animate_out_handle = vint_object_find( "message_animate_out" )

	vint_set_property( message_animate_in_handle, "is_paused", true )
	
	-- Can't set states on animation, set the state on the child tweens instead
	--vint_set_property( message_animate_in_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( message_animate_in_handle, TWEEN_STATE_DISABLED )

	vint_set_property( message_animate_out_handle, "is_paused", true )

	-- Can't set states on animation, set the state on the child tweens instead
	--vint_set_property( message_animate_out_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( message_animate_out_handle, TWEEN_STATE_DISABLED )

	vint_set_child_tween_state( vint_object_find( "use_anim" ), TWEEN_STATE_DISABLED)
	vint_set_child_tween_state( vint_object_find( "use_anim_out" ), TWEEN_STATE_DISABLED)


	--hide the ammo pick up
	Ammo_group_handle[1] = vint_object_find( "message_ammo" )
	Ammo_anim_handle[1] = vint_object_find( "ammo_anim" )
	Ammo_start_x, Ammo_start_y = vint_get_property( Ammo_group_handle[1], "anchor" )

	Ammo_width = vint_get_property( Ammo_group_handle[1], "screen_size" )

	vint_set_property(  Ammo_group_handle[1], "visible", false )
	vint_set_child_tween_state( Ammo_anim_handle[1], TWEEN_STATE_DISABLED )

	vint_set_child_tween_state( vint_object_find( "usage_text_minor_anim" ), TWEEN_STATE_DISABLED )

	Salvage_anim_handle = vint_object_find("salvage_add_anim")
	Salvage_anim2_handle = vint_object_find("salvage_add_anim2")
	vint_set_child_tween_state( Salvage_anim_handle, TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Salvage_anim2_handle, TWEEN_STATE_DISABLED )
end

-- ##############################################################
function swap_info(data_item_handle, event_name)

	local is_visible, swap_type, next_icon, current_icon, button_name, current_ammo, next_ammo = vint_dataitem_get(data_item_handle)
	local start_time =  vint_get_time_index() - 0.17 --speed me up

	local message_swap_main_handle	= vint_object_find( "message_swap_main" )
	local message_button_handle	= vint_object_find( "message_button" )
	local message_icon1_handle	= vint_object_find( "message_icon1" )
	local message_icon2_handle	= vint_object_find( "message_icon2" )
	local message_animate_in_handle	= vint_object_find( "message_animate_in" )
	local message_animate_out_handle= vint_object_find( "message_animate_out" )

	if ( is_visible == true ) then
		--show the HUD
		vint_set_property( message_swap_main_handle, "alpha", 1 )

		if (current_icon ~= nil) then
			vint_set_property( message_icon1_handle, "visible", true )
			vint_set_property( message_icon1_handle, "image", current_icon )
		else
			vint_set_property( message_icon1_handle, "visible", false )
		end

		if (next_icon ~= nil) then
			vint_set_property( message_icon2_handle, "visible", true )
			vint_set_property( message_icon2_handle, "image", next_icon )
		else
			vint_set_property( message_icon2_handle, "visible", false )
		end

		if (button_name ~= nil) then
			vint_set_property( message_button_handle, "visible", true )
			vint_set_property( message_button_handle, "text_tag", button_name )
		else
			vint_set_property( message_button_handle, "visible", false )
		end

		if(current_ammo ~= nil)then
			vint_set_property( vint_object_find( "message_ammo_main" ), "visible", true )
			vint_set_property( vint_object_find( "message_weapon_ammo1" ), "text_tag", current_ammo )
		else
			vint_set_property( vint_object_find( "message_ammo_main" ), "visible", false )
		end

		if(next_ammo ~= nil)then
			vint_set_property( vint_object_find( "message_ammo_main" ), "visible", true )
			vint_set_property( vint_object_find( "message_weapon_ammo2" ), "text_tag", next_ammo )
		else
			vint_set_property( vint_object_find( "message_ammo_main" ), "visible", false )
		end

		vint_set_property( message_icon1_handle, "scale", 0.8, 0.8 )
		vint_set_property( message_icon2_handle, "scale", 0.8, 0.8 )
		
		--stop the fade out animation
		vint_set_property( message_animate_out_handle, "is_paused", true )
		vint_set_child_tween_state(message_animate_out_handle, TWEEN_STATE_DISABLED)
		--start the animation
		vint_set_property( message_animate_in_handle, "is_paused", false )
		vint_set_child_tween_state(message_animate_in_handle, TWEEN_STATE_RUNNING)
		
		vint_set_property( message_animate_in_handle, "start_time", start_time )
		vint_set_property( message_swap_main_handle, "visible", true )
		--vint_set_time_index(0.2)
		Show_me = true
	else
		--hide the HUD
		-- test me out
		--start the animation
		if( Show_me == true )then
			Show_me = false
			--stop fade in
			vint_set_property( message_animate_in_handle, "is_paused", true )
			vint_set_child_tween_state(message_animate_in_handle, TWEEN_STATE_DISABLED)
			--start fade out
			vint_set_property( message_animate_out_handle, "is_paused", false )
			vint_set_property( message_animate_out_handle, "start_time", start_time )
			vint_set_child_tween_state(message_animate_out_handle, TWEEN_STATE_RUNNING)
		else
			vint_set_property( message_swap_main_handle, "visible", false )
		end
	end
end



function ammo_info(data_item_handle, event_name)

	local which, total_num, is_full, ammo_icon, ammo_text, salvage_increase = vint_dataitem_get(data_item_handle)

	if ( event_name == "insert" ) then
		Ammo_total_count = Ammo_total_count + 1

		if ( Ammo_total_count > 1 ) then
			Ammo_group_handle[Ammo_total_count] = vint_object_clone_rename( Ammo_group_handle[1], "message_ammo"..Ammo_running_count )
			Ammo_anim_handle[Ammo_total_count] = vint_object_clone_rename( Ammo_anim_handle[1], "ammo_anim"..Ammo_running_count )

			local tween_handle = vint_object_find( "ammo_alpha_twn_3", Ammo_anim_handle[Ammo_total_count] )
			local target_handle = Ammo_group_handle[Ammo_total_count]
			vint_set_property( tween_handle, "target_handle", target_handle)

			tween_handle = vint_object_find( "ammo_icon_group_alpha", Ammo_anim_handle[Ammo_total_count] )
			target_handle = vint_object_find( "message_ammo_icon_group", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)


			tween_handle = vint_object_find( "ammo_icon_group_scale", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammo_icon_group", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)


			tween_handle = vint_object_find( "ammo_text_alpha_twn_1", Ammo_anim_handle[Ammo_total_count] )
			target_handle = vint_object_find( "message_ammo_text", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)


			tween_handle = vint_object_find( "ammo_text_alpha_twn_2", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammo_text", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)


			tween_handle = vint_object_find( "ammo_text_anchor_twn_1", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammo_text", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)

			tween_handle = vint_object_find( "ammobg3_alpha_twn_1", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammobg3", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)

			tween_handle = vint_object_find( "ammobg3_alpha_twn_2", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammobg3", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)


			tween_handle = vint_object_find( "ammobg3_anchor_twn_1", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammobg3", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)

			tween_handle = vint_object_find( "ammobg3_scale_twn_1", Ammo_anim_handle[Ammo_total_count] )
			--target_handle = vint_object_find( "message_ammobg3", Ammo_group_handle[Ammo_total_count] )
			vint_set_property( tween_handle, "target_handle", target_handle)
		end

		Ammo_running_count = Ammo_running_count + 1			
	end

	--if ( ammo_icon ~= "" ) then
		local start_time = vint_get_time_index()
		local ammo_main_handle = Ammo_group_handle[which]
		local ammo_anim_handle = Ammo_anim_handle[which]
		local ammo_icon_handle = vint_object_find( "message_ammo_icon", ammo_main_handle )
		local ammo_text_handle = vint_object_find( "message_ammo_text", ammo_main_handle )
		local ammo_bg_handle = vint_object_find( "message_ammobg3", ammo_main_handle )
		local salvage_increase_text = vint_object_find( "salvage_add_text" )
		local salvage_increase_text2 = vint_object_find( "salvage_add_text2" )
		local play_salvage_anim = false
		local play_salvage_anim2 = false

		--show the HUD
		vint_set_property( ammo_main_handle, "alpha", 1.0 )
		vint_set_property( ammo_main_handle, "visible", true )

		vint_set_property( ammo_icon_handle, "image", ammo_icon )
		vint_set_property( ammo_icon_handle, "scale", 0.8, 0.8 )

		if( ammo_icon == "ui_hud_icon_salvage" )then
			 vint_set_property( vint_object_find( "message_ammo_plate", ammo_main_handle),"visible",false )
			 vint_set_property( ammo_icon_handle,"tint", 1, 0.5, 0 )

			 if( salvage_increase >= 3 ) then
				 play_salvage_anim = true

				 if(vint_get_property( vint_object_find("salvage_add_bg_alpha_twn_2"), "state" ) == TWEEN_STATE_RUNNING) then
					play_salvage_anim2 = true
					vint_set_property( salvage_increase_text2, "text_tag", "+"..salvage_increase )		
				 else
					vint_set_property( salvage_increase_text, "text_tag", "+"..salvage_increase )
				 end
			 end
		else
			 vint_set_property( vint_object_find( "message_ammo_plate", ammo_main_handle),"visible",true )
			 vint_set_property( ammo_icon_handle, "tint", 1, 1, 1 )
		end
		
		--CHANGE THE FONT IF WE ARE USING TEXT INSTEAD OF NUMBERS
		if( is_full == true )then
			vint_set_property( ammo_text_handle, "font", "font_body" )
		else
			vint_set_property( ammo_text_handle, "font", "font_numbers" )
		end

		if( ammo_text ~= "" ) then
			vint_set_property( ammo_text_handle, "text_tag", ammo_text )
			vint_set_property( ammo_text_handle, "visible", true )
			vint_set_property( ammo_bg_handle, "visible", true )
		else
			vint_set_property( ammo_text_handle, "visible", false )
			vint_set_property( ammo_bg_handle, "visible", false )
		end
		
		--set the new anchor
		local total_width = (total_num * Ammo_width) + ((total_num - 1) * Ammo_gap_width)
		local base_x = ((Ammo_width * 0.5) + Ammo_start_x) - (total_width * 0.5)
		local actual_x = base_x + (which - 1) * (Ammo_width + Ammo_gap_width)

		vint_set_property( ammo_main_handle, "anchor", actual_x, Ammo_start_y )


		--start the animation
		vint_set_property( ammo_anim_handle, "start_time", start_time )
		vint_set_child_tween_state( ammo_anim_handle, TWEEN_STATE_RUNNING )

		if( play_salvage_anim == true ) then
			vint_set_property( Salvage_anim_handle, "start_time", start_time )
			vint_set_child_tween_state( Salvage_anim_handle, TWEEN_STATE_RUNNING )
			if(play_salvage_anim2 == true) then
				vint_set_property( Salvage_anim2_handle, "start_time", start_time )
				vint_set_child_tween_state( Salvage_anim2_handle, TWEEN_STATE_RUNNING )
			end
		end
	--end
end	


-- ##############################################################
function ammo_remove(data_item_handle, event_name)
	if ( Ammo_total_count > 1 ) then
		vint_object_destroy( Ammo_group_handle[Ammo_total_count] )
		vint_object_destroy( Ammo_anim_handle[Ammo_total_count] )
	else 
		vint_set_property( Ammo_group_handle[1], "visible", false )
		vint_set_child_tween_state( Ammo_anim_handle[1], TWEEN_STATE_DISABLED )
	end

	Ammo_total_count = Ammo_total_count - 1
end



-- ##############################################################
function use_info(data_item_handle, event_name)

	local is_visible, use_type, use_button = vint_dataitem_get(data_item_handle)
	--use_type
	--1 = interact, turret, rescue,computer,ammobox
	--2 = pick up hydrogen tank
	--3 = climb ladder
	--4 = get in a car
	--5 = start a mission

	local start_time = vint_get_time_index()

	local use_main_handle = vint_object_find( "message_use" )
	local use_icon_handle = vint_object_find( "message_use_icon" )
	local use_button_handle = vint_object_find( "message_use_button" )
	local use_button2_handle = vint_object_find( "message_use_button2" )
	local use_anim_handle = vint_object_find( "use_anim" )
	local use_anim_out_handle = vint_object_find( "use_anim_out" )

	if ( is_visible == true ) then
		--show the HUD
		vint_set_property( use_main_handle, "alpha", 1 )
		vint_set_property( use_main_handle, "visible", true )

		vint_set_property( use_icon_handle, "image", Use_image_names[use_type] )
		vint_set_property( use_button_handle, "text_tag", use_button )
		vint_set_property( use_button2_handle, "text_tag", use_button )

		if( Use_image_names[use_type] == "ui_hud_convoy_car_icon" )then
			vint_set_property( use_icon_handle, "tint", 1,1,1 )
		else
			if( Use_image_names[use_type] == "ui_hud_hand_icon" )then
				vint_set_property( use_icon_handle, "scale", 0.8,0.8 )
			end
			vint_set_property( use_icon_handle, "tint", 0.96,0.65,0.20 )
		end
		
		--start the entry animation (only if we were previously hidden)
		if ( Use_info_was_visible == false ) then
			vint_set_child_tween_state( use_anim_out_handle, TWEEN_STATE_PAUSED )

			vint_set_property( use_anim_handle, "start_time", start_time )
			vint_set_child_tween_state( use_anim_handle, TWEEN_STATE_RUNNING )
		end
		
	else
		vint_set_property( use_main_handle, "visible", false )

		--start the exit animation (only if we were previously visible) and make sure the entry animatino is paused
		if ( Use_info_was_visible == true ) then
			vint_set_child_tween_state( use_anim_handle, TWEEN_STATE_PAUSED )

			vint_set_property( use_anim_out_handle, "start_time", start_time )
			vint_set_child_tween_state( use_anim_out_handle, TWEEN_STATE_RUNNING )
		end
	end

	Use_info_was_visible = is_visible
end
