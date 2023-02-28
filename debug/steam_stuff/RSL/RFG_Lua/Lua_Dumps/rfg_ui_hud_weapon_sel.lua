
-- handles for each OBJ
NUM_OBJ_HANDLES_WS	= 14
NUM_NAME_HANDLES_WS	= 17
WEAPON_HANDLES_START	= 9
WEAPON_SLOT_OFFSET	= 8
NAME_PAD		= 15

Obj_handles_ws			= {0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Weapon_hud_visible_ws		= false
Weapon_ammo_handles 		= {0,0,0,0}
Weapon_name_handles		= {0,0,0,0}
Weapon_shine_handle 		= 0
Fade_in_handle 			= 0
Weapons_main_handle 		= 0
Button_art_handle 		= 0
Shine_anim_handle 		= 0
Highlight_handle 		= 0
Name_group_handle		= 0
Name_group_anim			= 0
Name_text_handle		= 0
Name_bg_handle			= 0
Name_shadow_handle		= 0
Weapon_parent_scale_x		= 0
Weapon_parent_scale_y		= 0

Tween_is_done		= false
Current_slot		= 0
Previous_slot		= 0
Input_type		= 0
Slot	 = 0
P_slot = 0

-- ##############################################################
function init_ws_handles()

	--weapon bgs
	Obj_handles_ws[1]	= vint_object_find( "weapon_plate_01" )
	Obj_handles_ws[2]	= vint_object_find( "weapon_plate_02" )
	Obj_handles_ws[3]	= vint_object_find( "weapon_plate_03" )
	Obj_handles_ws[4]	= vint_object_find( "weapon_plate_04" )
	--weapon ammo
	Obj_handles_ws[5]	= vint_object_find( "weapon_ammo_text_01" )
	Obj_handles_ws[6]	= vint_object_find( "weapon_ammo_text_02" )
	Obj_handles_ws[7]	= vint_object_find( "weapon_ammo_text_03" )
	Obj_handles_ws[8]	= vint_object_find( "weapon_ammo_text_04" )
	--weapon icons
	Obj_handles_ws[9]	= vint_object_find( "weapon_icon_01" )
	Obj_handles_ws[10]	= vint_object_find( "weapon_icon_02" )
	Obj_handles_ws[11]	= vint_object_find( "weapon_icon_03" )
	Obj_handles_ws[12]	= vint_object_find( "weapon_icon_04" )
	
	--our fade in tween
	Obj_handles_ws[13] = vint_object_find( "weapon_button_alpha_tween_2" )

	--our rb hint for swapping
	Obj_handles_ws[14] = vint_object_find( "weapon_hint_main" )

	Weapon_ammo_handles[1] = vint_object_find( "weapon_ammo_group_1" )
	Weapon_ammo_handles[2] = vint_object_find( "weapon_ammo_group_2" )
	Weapon_ammo_handles[3] = vint_object_find( "weapon_ammo_group_3" )
	Weapon_ammo_handles[4] = vint_object_find( "weapon_ammo_group_4" )

	Weapon_shine_handle = vint_object_find( "weapon_shine" )
	Fade_in_handle	= vint_object_find( "fade_in" )
	Weapons_main_handle = vint_object_find( "weapons_main" )
	Button_art_handle = vint_object_find( "weapon_button_art_main" )
	Shine_anim_handle	= vint_object_find( "weapon_shine_anim" )
	Highlight_handle = vint_object_find( "weapon_plate_highlight" )

	Name_group_handle		= vint_object_find( "weapon_name_group" )
	Name_group_anim			= vint_object_find( "weapon_name_anim" )
	Name_text_handle		= vint_object_find( "weapon_name" )
	Name_bg_handle			= vint_object_find( "weapon_name_bg" )
	Name_shadow_handle		= vint_object_find( "weapon_name_shadow" )

	Weapon_parent_scale_x,Weapon_parent_scale_y = vint_get_property( Weapons_main_handle, "scale" )
	vint_set_property( Weapons_main_handle, "visible", false )

end

function ws_image_update(data_item_handle, event_name)

	local button_image_01,button_image_02,button_image_03,button_image_04 = vint_dataitem_get(data_item_handle)
	
	-- set the button images here!
	vint_set_property( vint_object_find("weapon_a_button"), "text_tag", button_image_01)
	vint_set_property( vint_object_find("weapon_x_button"), "text_tag", button_image_02)
	vint_set_property( vint_object_find("weapon_y_button"), "text_tag", button_image_03)
	vint_set_property( vint_object_find("weapon_b_button"), "text_tag", button_image_04)
end


-- ##############################################################
function rfg_ui_hud_weapon_sel_cleanup()
	remove_tween_end_callback(Obj_handles_ws[13])
end

-- ##############################################################
function rfg_ui_hud_weapon_sel_init()

	-- get the handles
	init_ws_handles()

	-- subscribe to the data item whose name is ButtonAStatus, and we listen for updates, so that
	-- it then calls our function button_a_status_change
	vint_dataitem_add_subscription( "WeaponSlotInfo", "update", "ws_weapon_info" )
	vint_dataitem_add_subscription( "WeaponShowInfo", "update", "ws_weapon_show" )
	
	--new RZ function to update button images
	vint_dataitem_add_subscription("WeaponButtonInfo", "update", "ws_image_update" )

	
	vint_set_property(Obj_handles_ws[13], "end_event", "ws_fade_in_end")
	vint_set_property( vint_object_find("fade_in"), "is_paused", false )
end

-- ##############################################################
function ws_weapon_info(data_item_handle, event_name)
	-- get all the data items at once (it puts the 4 values in tmp1-4)
	-- ac = ammo count
	

	local ac01, weapon_icon_name01, weapon_name01, ac02, weapon_icon_name02, weapon_name02, ac03, weapon_icon_name03, weapon_name03, ac04, weapon_icon_name04, weapon_name04 = vint_dataitem_get(data_item_handle)
	local text_rotation = 90 * DEG_TO_RAD
	
	for i = 9, 12 do
		vint_set_property( Obj_handles_ws[i], "visible", false )	
	end

		--look for the hammer or repair tool
	if(ac01 == -2)then
		ac01 = ""
	end
	if(ac02 == -2)then
		ac02 = ""
	end
	if(ac03 == -2)then
		ac03 = ""
	end
	if(ac04 == -2)then
		ac04 = ""
	end
	
	--deal with unlimited ammo
	if( ac01 ~= -1 )then
		vint_set_property( Obj_handles_ws[5], "text_tag", tostring(ac01) )
		vint_set_property( Obj_handles_ws[5], "rotation", 0 )
	else
		vint_set_property( Obj_handles_ws[5], "text_tag",  "8" )
		vint_set_property( Obj_handles_ws[5], "rotation", text_rotation )
	end

	if ( weapon_icon_name01 ~= nil ) then
		Weapon_name_handles[1] =  weapon_name01
		vint_set_property( Obj_handles_ws[9], "image",  weapon_icon_name01)
		vint_set_property( Obj_handles_ws[9], "visible", true )
		if(ac01 ~= "")then
			vint_set_property( Weapon_ammo_handles[1], "visible", true )
		else
			vint_set_property( Weapon_ammo_handles[1], "visible", false )
		end
	else
		vint_set_property( Weapon_ammo_handles[1], "visible", false )
	end

	--deal with unlimited ammo
	if( ac02 ~= -1 )then
		vint_set_property( Obj_handles_ws[6], "text_tag", tostring(ac02) )
		vint_set_property( Obj_handles_ws[6], "rotation", 0 )
	else
		vint_set_property( Obj_handles_ws[6], "text_tag", "8"  )
		vint_set_property( Obj_handles_ws[6], "rotation", text_rotation )
	end
	if ( weapon_icon_name02 ~= nil ) then
		Weapon_name_handles[2] =  weapon_name02
		vint_set_property( Obj_handles_ws[10], "image",  weapon_icon_name02)
		vint_set_property( Obj_handles_ws[10], "visible", true )
		if(ac02 ~= "")then
			vint_set_property( Weapon_ammo_handles[2], "visible", true )
		else
			vint_set_property( Weapon_ammo_handles[2], "visible", false )
		end
	else
		vint_set_property( Weapon_ammo_handles[2], "visible", false )
	end

	--deal with unlimited ammo
	if( ac03 ~= -1 )then
		vint_set_property( Obj_handles_ws[7], "text_tag", tostring(ac03) )
		vint_set_property( Obj_handles_ws[7], "rotation", 0 )
	else
		vint_set_property( Obj_handles_ws[7], "text_tag", "8" )
		vint_set_property( Obj_handles_ws[7], "rotation", text_rotation )
	end
	if ( weapon_icon_name03 ~= nil ) then
		Weapon_name_handles[3] =  weapon_name03
		vint_set_property( Obj_handles_ws[11], "image",  weapon_icon_name03)
		vint_set_property( Obj_handles_ws[11], "visible", true )
		if(ac03 ~= "")then
			vint_set_property( Weapon_ammo_handles[3], "visible", true )
		else
			vint_set_property( Weapon_ammo_handles[3], "visible", false )
		end
	else
		vint_set_property( Weapon_ammo_handles[3], "visible", false )
	end
	--deal with unlimited ammo
	if( ac04 ~= -1 )then
		vint_set_property( Obj_handles_ws[8], "text_tag", tostring(ac04) )
		vint_set_property( Obj_handles_ws[8], "rotation", 0 )
	else
		vint_set_property( Obj_handles_ws[8], "text_tag", "8" )
		vint_set_property( Obj_handles_ws[8], "rotation", text_rotation )
	end
	if ( weapon_icon_name04 ~= nil ) then
		Weapon_name_handles[4] =  weapon_name04
		vint_set_property( Obj_handles_ws[12], "image",  weapon_icon_name04)
		vint_set_property( Obj_handles_ws[12], "visible", true )
		if(ac04 ~= "")then
			vint_set_property( Weapon_ammo_handles[4], "visible", true )
		else
			vint_set_property( Weapon_ammo_handles[4], "visible", false )
		end
	else
		vint_set_property( Weapon_ammo_handles[4], "visible", false )
	end

	handle_icon_scale()
end

-- ##############################################################
function ws_fade_in_end(tween_h, event_name)
	--debug_print("vint", "fade_in_end_event\n")
	Tween_is_done = true
	actual_weapon_show(Weapon_hud_visible_ws, Current_slot, Previous_slot, Input_type)
end

-- ##############################################################
function ws_weapon_show(data_item_handle, event_name)
	--get all the data items at once (it puts the 2 values in tmp1-2)
	--debug_print("vint", "fade_in_end_event\n")
	local show_weapons, current_slot, prev_slot, input_type = vint_dataitem_get(data_item_handle)

	debug_print("vint",  "input_type: "..tostring(input_type).."\n")

	if ( ( show_weapons == true ) and ( Weapon_hud_visible_ws == false ) ) then
		
		-- we will be playing our tween, so our tween is not done yet
		Tween_is_done = false
		vint_set_time_index(0.4)
		vint_set_property( Weapon_shine_handle, "visible", false )
		vint_set_child_tween_state( Fade_in_handle, TWEEN_STATE_IDLE )
		-- play audio
		rfg_play_audio("SYS_WEP_SELECT_OPEN")
	elseif (( show_weapons == false ) and (Weapon_hud_visible_ws == true)) then
		-- play audio	
		rfg_play_audio("SYS_WEP_SELECT_CLOSE")
	end

	Current_slot = current_slot
	Previous_slot = prev_slot
	Input_type = input_type

	actual_weapon_show( show_weapons, current_slot, prev_slot, input_type )
end

-- ##############################################################
function actual_weapon_show(show_weapons, current_slot, prev_slot, input_type)
	
	--show/hide the weapons group
	if ( show_weapons == true ) then
		if( Weapon_hud_visible_ws ~= true )then
		--enable the fade in
		--disable the fade out
		--zero the document time
		--trigger the animation
		vint_set_property( Weapons_main_handle, "visible", true )
		end
	else
		if( Weapon_hud_visible_ws ~= false )then
		--disable the fade in
		--enable the fade out
		--zero the document time
		--trigger the animation
		vint_set_property( Weapons_main_handle, "visible", false )
		end
	end

	Weapon_hud_visible_ws = show_weapons

	if ( Tween_is_done == true ) then

		--default the plates
		for i = 1,4 do
			vint_set_property( Obj_handles_ws[i], "alpha", 1.0 )
			vint_set_property( Obj_handles_ws[i], "scale", 1.0, 1.0 )
			vint_set_property( Obj_handles_ws[i + WEAPON_SLOT_OFFSET], "alpha", 1.0 )
		
			vint_set_property( Obj_handles_ws[i], "tint", 0.5, 0.5, 0.5 )
			vint_set_property( Obj_handles_ws[i + WEAPON_SLOT_OFFSET], "tint", 0.5, 0.5, 0.5 )
		end

		--highlight the current weapon plate
		Slot = current_slot + 1
		if ( Slot > 0 ) then
			vint_set_property( Obj_handles_ws[Slot], "alpha", 1.0 )
			vint_set_property( Obj_handles_ws[Slot], "scale", 1.1, 1.1 )
			vint_set_property( Obj_handles_ws[Slot + WEAPON_SLOT_OFFSET], "alpha", 1.0 )

			vint_set_property( Obj_handles_ws[Slot], "tint", 1.0, 1.0, 1.0 )
			vint_set_property( Obj_handles_ws[Slot + WEAPON_SLOT_OFFSET], "tint", 1.0, 1.0, 1.0 )
		end
		
		P_slot = prev_slot + 1
		vint_set_property( Obj_handles_ws[P_slot + WEAPON_SLOT_OFFSET], "alpha", 1.0 )
		vint_set_property( Obj_handles_ws[P_slot], "tint", 1.0, 1.0, 1.0 )
		vint_set_property( Obj_handles_ws[P_slot + WEAPON_SLOT_OFFSET], "tint", 1.0, 1.0, 1.0 )

		handle_icon_scale()

		vint_set_property( Obj_handles_ws[14], "visible", false )

		handle_highlight()
		
		if ( show_weapons == true ) then
			if ( current_slot == 1 ) then
				rfg_play_audio("SYS_WEP_SELECT_A")
			elseif ( current_slot == 2 ) then
				rfg_play_audio("SYS_WEP_SELECT_B")
			elseif ( current_slot == 3 ) then
				rfg_play_audio("SYS_WEP_SELECT_X")
			else
				rfg_play_audio("SYS_WEP_SELECT_Y")
			end
		end
		
	end -- if ( Tween_is_done == true) then

	-- should we show the face buttons?
	if(input_type == true)then
		vint_set_property( Button_art_handle, "visible", true )
	else
		vint_set_property( Button_art_handle, "visible", false )
	end

end

-- ##############################################################
function handle_icon_scale()
	for i = 1,4 do
		vint_set_property( Obj_handles_ws[i + WEAPON_SLOT_OFFSET], "scale", 0.7, 0.7 )
	end

	if ( Slot > 0 ) then
		vint_set_property( Obj_handles_ws[Slot + WEAPON_SLOT_OFFSET], "scale", 0.9, 0.9 )
	end
	vint_set_property( Obj_handles_ws[P_slot + WEAPON_SLOT_OFFSET], "scale", 0.8, 0.8 )
end

-- ##############################################################
function handle_highlight()

	--get the current slot X and Y
	if ( Slot > 0 ) then
		local xtoset, ytoset = vint_get_property( Obj_handles_ws[Slot], "anchor" )
		
		local rotation = 0
		--rotate the highlight
		if( Slot == 1 )then
			rotation = 90 * DEG_TO_RAD
		elseif( Slot == 2 )then
			rotation = 180 * DEG_TO_RAD
		elseif( Slot == 3 )then
			rotation = 270 * DEG_TO_RAD
		elseif( Slot == 4 )then
			rotation = 0
		end
		--offeset to get the correct icon index icons 9-12
		local name_index = Slot + 8
		local name_text = tostring(Weapon_name_handles[Slot])
		
		if(Tween_is_done == true)then
			vint_set_property( Name_group_handle, "visible", true )
		else
			vint_set_property( Name_group_handle, "visible", false )
		end
		
		vint_set_property( Name_text_handle, "text_tag", name_text )

		local text_width,text_height = vint_get_property(  Name_text_handle, "screen_size" )
		local bg_width,bg_height = vint_get_property(  Name_bg_handle, "scale" )
		local max_width = (text_width/Weapon_parent_scale_x) + NAME_PAD
		--if( max_width <= 130 )then
		--	max_width = 130
		--end
		vint_set_property( Name_bg_handle, "scale", -1*(max_width), bg_height )

		local shadow_width,shadow_height = vint_get_property(Name_shadow_handle, "screen_size" )
		vint_set_property( Name_shadow_handle, "screen_size", text_width, shadow_height )

		local icon_x,icon_y = vint_get_property(   Obj_handles_ws[name_index], "anchor" )
		vint_set_property( Name_group_handle, "anchor", (icon_x - 50), icon_y )
		
		--start the name anim		
		vint_set_property( Name_group_anim, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Name_group_anim, TWEEN_STATE_RUNNING )
					
		
		vint_set_property( Shine_anim_handle, "start_time", vint_get_time_index() )

		-- Can't change the state for animations, change the child tween states instead
		vint_set_child_tween_state( Shine_anim_handle, TWEEN_STATE_RUNNING )

		--vint_set_property( Shine_anim_handle, "is_paused", false )

		--set the highlight X and Y and rotation to the current slot 
		vint_set_property( Highlight_handle, "anchor", xtoset, ytoset )
		vint_set_property( Highlight_handle, "rotation", rotation )
		vint_set_property( Highlight_handle, "visible", true )
		vint_set_property( Weapon_shine_handle, "visible", true )
		vint_set_property( Weapon_shine_handle, "anchor", xtoset, ytoset )
	else 
		vint_set_child_tween_state( Shine_anim_handle, TWEEN_STATE_PAUSED )
		--vint_set_property( Shine_anim_handle, "is_paused", true )
		
		vint_set_property( Weapon_shine_handle, "visible", false )
		vint_set_property( Highlight_handle, "visible", false )
	end

end
