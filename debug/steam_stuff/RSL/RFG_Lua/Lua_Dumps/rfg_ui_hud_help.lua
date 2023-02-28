
NUM_SCREEN_COORDS = 5

Screen_coords = {"help_anchor_ne","help_anchor_nw","help_anchor_se","help_anchor_sw","help_anchor_center"}
Screen_coords_handles = { NUM_SCREEN_COORDS }

Help_message_main_handle = 0
Help_title_handle = 0
Help_text_handle = 0
Help_icon_handle = 0
Help_icon2_handle = 0
Help_arrow_handle = 0
Help_hint_handle = 0
Help_bg_main = 0
Help_bg_body = 0
Help_bg_bottom = 0


Help_arrows_anim_handle = 0
Help_main_anim_handle = 0
Help_main_alpha_twn_handle = 0
Help_main_scale_twn_handle = 0


-- ##############################################################
function init_handles_help()
	Help_message_main_handle = vint_object_find( "help_message_main" )
	Help_title_handle = vint_object_find( "help_title" )
	Help_text_handle = vint_object_find( "help_text" )
	Help_icon_handle = vint_object_find( "help_icon" )
	Help_icon2_handle = vint_object_find( "help_icon2" )
	Help_arrow_handle = vint_object_find( "help_arrows_main" )
	Help_hint_handle = vint_object_find( "help_hint_main" )
	Help_bg_main = vint_object_find( "help_bg_main" )
	Help_bg_body = vint_object_find( "help_bg1" )
	Help_bg_bottom = vint_object_find( "help_bg_bottom" )

	Help_arrows_anim_handle = vint_object_find( "help_arrows_anim" )
	Help_main_anim_handle = vint_object_find( "help_main_anim" )
	Help_main_alpha_twn_handle = vint_object_find( "help_message_main_alpha_twn_2" )
	Help_main_scale_twn_handle = vint_object_find( "help_message_main_scale_twn_2" )

	for i=1,NUM_SCREEN_COORDS do
		Screen_coords_handles[i] = vint_object_find( Screen_coords[i] )
	end

end

-- ##############################################################
function rfg_ui_hud_help_cleanup()	
end


-- ##############################################################
function rfg_ui_hud_help_init()

	-- get the handles
	init_handles_help()

	-- subscribe to the data item whose name is HelpUpdate, and we listen for updates, so that
	-- it then calls our function set_help_data
	vint_dataitem_add_subscription( "HelpUpdate", "update", "set_help_data" )

	vint_set_property( Help_message_main_handle,"visible", false )

	--stop the anims	
	vint_set_child_tween_state( Help_arrows_anim_handle, TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Help_main_anim_handle, TWEEN_STATE_DISABLED )
end

-- ##############################################################
function set_help_data( data_item_handle, event_name )
	local is_visible, title, text, icon, animation, anchor, arrow, duration, hint, is_paused = vint_dataitem_get(data_item_handle)

	if( is_visible == true )then 
		vint_set_property( Help_message_main_handle,"visible", true )

		--make the title fit
		vint_set_property( Help_title_handle,"text_tag_crc", title )
		vint_set_property( Help_title_handle, "text_scale",0.7,0.7 )
		local text_width,text_height = vint_get_property( Help_title_handle, "screen_size" )
		
		--get the parent scale
		local parent_x,parent_y = vint_get_property( Help_message_main_handle, "scale" )
		--set the max width based on parent scale so it works in all screen dimensions
		local max_width = 350.0*parent_x
		--see if we are too wide
		if( text_width > max_width )then
			--scale the text
			local new_scale = max_width/text_width * 0.7
			vint_set_property( Help_title_handle, "text_scale", new_scale, 0.7 )
		end
		
		vint_set_property( Help_text_handle,"text_tag_crc", text )
		vint_set_property( Help_icon_handle,"image", icon )
		vint_set_property( Help_icon2_handle,"image", icon )
		

		local time_index = vint_get_time_index()
		if (hint == "") then
			--start the animations
	
			--start the main animation
			vint_set_property( Help_main_anim_handle, "start_time", time_index )
			vint_set_child_tween_state( Help_main_anim_handle, TWEEN_STATE_IDLE )	

			if (duration ~= -1) then
				local tween_start_time = time_index + duration - 0.2
				vint_set_property( Help_main_alpha_twn_handle, "start_time", tween_start_time )
				vint_set_property( Help_main_scale_twn_handle, "start_time", tween_start_time )
			else
				vint_set_property( Help_main_alpha_twn_handle, "state", TWEEN_STATE_PAUSED )
				vint_set_property( Help_main_scale_twn_handle, "state", TWEEN_STATE_PAUSED )	
			end

			-- start any custom animations
			if ( animation ~= "" ) then
				local animation_handle = vint_object_find( animation )
				vint_set_property( animation_handle, "start_time", time_index )
				vint_set_child_tween_state( animation_handle, TWEEN_STATE_IDLE )
			end 	

			vint_set_property( Help_hint_handle, "visible", false )
			
		else
			vint_set_property( Help_hint_handle, "visible", true )
			vint_set_property( vint_object_find( "help_hint" ), "text_tag", hint )
		end	
		
		--flashing arrows
		vint_set_property( Help_arrows_anim_handle, "start_time", time_index )
		vint_set_child_tween_state( Help_arrows_anim_handle, TWEEN_STATE_IDLE )

		--set the x position of the hint
		local x_to_set,y_to_set = vint_get_property( Screen_coords_handles[anchor],"anchor" )
		vint_set_property( Help_message_main_handle,"anchor", x_to_set, y_to_set )

		if (arrow >= 6) then
			vint_set_property( Help_arrow_handle, "visible", false )
		else
			vint_set_property( Help_arrow_handle, "visible", true )
		end

		-- Now we get to resize the tool tip to make sure everything fits
		local start_x, start_y = vint_get_property( Help_text_handle, "anchor" )
		local size_x, size_y = vint_get_property( Help_text_handle, "screen_size" )

		-- Move the hint text down
		local temp_x, temp_y = vint_get_property( Help_hint_handle, "anchor" )
		local new_y = start_y + (size_y / parent_y)
		local height = size_y
		vint_set_property( Help_hint_handle, "anchor", temp_x, new_y )
		
		if(is_paused == true)then
			temp_x, temp_y = vint_get_property( Help_hint_handle, "screen_size" )
			new_y = new_y + (temp_y--[[ + 10]]) * parent_y
			height = height + temp_y
		end
		
		temp_x, temp_y = vint_get_property( Help_title_handle, "screen_size" )
		height = height + temp_y + 10
		size_x, size_y = vint_get_property( Help_bg_body, "screen_size" )
		vint_set_property( Help_bg_body, "screen_size", size_x, height )

		start_x, start_y = vint_get_property( Help_bg_body, "anchor" )
		temp_x, temp_y = vint_get_property( Help_bg_body, "scale" )
		new_y = start_y + (temp_y)
		vint_set_property( Help_bg_bottom, "anchor", start_x, new_y )	
		
	else
		vint_set_property( Help_message_main_handle,"visible", false )
	end
end
