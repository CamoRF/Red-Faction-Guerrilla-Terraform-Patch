
ORANGE				= {R=0.83,G=0.54,B=0}
BROWN				= {R=0.5,G=0.25,B=0}

MAX_ROWS			= 9
Row_handles			= { MAX_ROWS = 0 }
Num_rows			= 0

--[[
Icon_image_name	= {	
		"ui_hud_backpack_icon_jetpack",		-- JETPACK
		"ui_hud_weapon_icon_charges",		-- REMOTE_CHARGES
		"ui_hud_weapon_icon_charges",		-- REMOTE_CHARGE_COUNT
		"",					-- APC (Vehicle)
		"ui_hud_weapon_icon_hammer",		-- SLEDGEHAMMER
		"ui_hud_weapon_icon_welder",		-- ARC_WELDER
		"ui_hud_weapon_icon_grinder",		-- GRINDER
		"ui_hud_weapon_icon_grinder",		-- GRINDER_FASTER
		"ui_hud_weapon_icon_mines",		-- PROXIMITY_MINES
		"ui_hud_weapon_icon_mines",		-- PROXIMITY_MINES_SMART
		"ui_hud_weapon_icon_rockets",		-- ROCKET
		"ui_hud_weapon_icon_rockets",		-- ROCKET_MULTI
		"ui_hud_weapon_icon_rockets",		-- ROCKET_HEAT_SEAK
		"ui_hud_weapon_icon_thermo",		-- THERMO_ROCKET
		"ui_hud_weapon_icon_nano",		-- NANO_RIFLE
		"",					-- PERSONEL_DETECTOR
		"",					-- RADIATION_SHEILDING
		"" }					-- GUNS_OF_THARSIS
--]]

Row_base_pos_x = 0
Row_base_pos_y = 0

Highlight_bar_size_x = 0
Highlight_bar_size_y = 0

Scroll_bar_height = 0
Scroll_bar_top_y = 0
Scroll_bar_top_x = 0
Scroll_bar_bottom_y = 0


-- ##############################################################
function init_load_screen_handles()
	Row_handles[1] = vint_object_find( "row_group" )

	local handle = vint_object_find( "row_group" )
	Row_base_pos_x, Row_base_pos_y = vint_get_property( handle, "anchor" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "row_highlight_main" )
	Highlight_bar_size_x, Highlight_bar_size_y = vint_get_property( handle, "screen_size" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "scroll_bar_fill" )
	Scroll_bar_top_x, Scroll_bar_height = vint_get_property( handle, "screen_size" )
	Scroll_bar_top_x, Scroll_bar_top_y = vint_get_property( handle, "anchor" )

	handle = vint_object_find( "black_scrollfill" )
	local outline_posx, outline_posy = vint_get_property( handle, "anchor" ) 
	local outline_sizex, outline_sizey = vint_get_property( handle, "screen_size" )

	-- For this to work properly with different resolutions, we need to unscale the outline and scroll
	--  bar heights, since screen_size is post-resolution-scale, but anchor is independent of scale.
	handle = vint_object_find( "screen_group" )
	local parent_scale_x, parent_scale_y = vint_get_property( handle, "scale" )

	outline_sizex = outline_sizex / parent_scale_x
	outline_sizey = outline_sizey / parent_scale_y
	Scroll_bar_height = Scroll_bar_height / parent_scale_y

	local offset = Scroll_bar_top_y - outline_posy
	Scroll_bar_bottom_y = outline_posy + outline_sizey - offset - Scroll_bar_height - 10

	handle = vint_object_find( "hint_3_group" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "hint_4_group" )
	vint_set_property( handle, "visible", false )
end

-- ##############################################################
function rfg_ui_load_game_cleanup()
end

-- ##############################################################
function rfg_ui_load_game_init()

	-- get the handles
	init_load_screen_handles()

	-- subscribe to the data item whose name is ??, and we listen for updates, so that
	-- it then calls our function ??
	vint_dataitem_add_subscription( "HeaderData", "update", "set_header" )
	
	vint_datagroup_add_subscription( "RowData", "insert", "update_row" )
	vint_datagroup_add_subscription( "RowData", "update", "update_row" )
	vint_datagroup_add_subscription( "RowData", "remove", "remove_row" )
	
	vint_dataitem_add_subscription( "HintData", "update", "set_hints" )

end

-- ##############################################################
function set_header(data_item_handle, event_name)
	local title, mission_header, activity_header, control_header, filename_header, date_header, time_header, district_crc, missions, activities, control, image_name, show_scroll, scroll_percent, control_visible = vint_dataitem_get(data_item_handle)

	local title_handle					= vint_object_find( "title_text" )
	local mission_header_handle 		= vint_object_find( "missions_completed" )
	local activity_header_handle 		= vint_object_find( "mini_completed" )
	local control_header_handle 		= vint_object_find( "edf_control" )
	local filename_header_handle		= vint_object_find( "header_text_1" )
	local date_header_handle		= vint_object_find( "header_text_2" )
	local time_header_handle		= vint_object_find( "header_text_3" )
	local district_handle 			= vint_object_find( "file_name" )
	local mission_handle 			= vint_object_find( "num_missions_completed" )
	local activity_handle	 		= vint_object_find( "num_mini_completed" )
	local control_handle 			= vint_object_find( "num_edf_control" )
	local image_thumb_handle 		= vint_object_find( "file_image" )
	local scroll_bar_handle			= vint_object_find( "scroll_bar" )
	local scroll_bar_fill_handle		= vint_object_find( "scroll_bar_fill" )

	-- Set all of the text tags
	vint_set_property( title_handle, "text_tag", title )
	vint_set_property( mission_header_handle, "text_tag", mission_header )
	vint_set_property( activity_header_handle, "text_tag", activity_header )
	vint_set_property( control_header_handle, "text_tag", control_header )
	vint_set_property( filename_header_handle, "text_tag", filename_header )
	vint_set_property( date_header_handle, "text_tag", date_header )
	vint_set_property( time_header_handle, "text_tag", time_header )
	vint_set_property( district_handle, "text_tag_crc", district_crc )
	vint_set_property( mission_handle, "text_tag", tostring(missions) )
	vint_set_property( activity_handle, "text_tag", tostring(activities) )
	vint_set_property( control_handle, "text_tag", tostring(control) )

	--DLC: Hiding last two filename headers
	if(control_visible == false) then
		--vint_set_property(activity_header_handle,"visible", false)
		--vint_set_property(activity_handle,"visible", false)
		vint_set_property(control_header_handle,"visible", false)
		vint_set_property(control_handle ,"visible", false)
	else
		vint_set_property(control_header_handle,"visible", true)
		vint_set_property(control_handle ,"visible", true)
	end

	-- Set the thumb image
	if ( image_name ~= " " ) then
		local size_x, size_y = vint_get_property( image_thumb_handle, "screen_size" )	-- Need to store the current scale so we can reset this after we set the new image

		vint_set_property( image_thumb_handle, "image", image_name )
			
		-- MW: Hack to fix interface scaling
		local img_size_x, img_size_y, img_scale_x, img_scale_y = rfg_get_bitmap_dimensions(image_thumb_handle)
		vint_set_property(image_thumb_handle, "image_size", img_size_x * img_scale_x, img_size_y * img_scale_y )
			
		vint_set_property( image_thumb_handle, "screen_size", size_x, size_y )
		vint_set_property( image_thumb_handle, "visible", true )
	else
		vint_set_property( image_thumb_handle, "visible", false )
	end

	vint_set_property( scroll_bar_handle, "visible", show_scroll )
	if (show_scroll == true) then
		--set the scroll bar thumb position
		local new_y = Scroll_bar_top_y + (scroll_percent * (Scroll_bar_bottom_y - Scroll_bar_top_y))
		vint_set_property( scroll_bar_fill_handle, "anchor", Scroll_bar_top_x, new_y )
	end

end

-- #############################################################
function add_row()
	if (Num_rows < 1) then
		vint_set_property( Row_handles[1], "visible", true )
	else
		Row_handles[Num_rows + 1] = vint_object_clone_rename( Row_handles[1], "row_group"..Num_rows )
	end

	Num_rows = Num_rows + 1
end

-- #############################################################
function remove_row()
	if (Num_rows <= 1) then
		vint_set_property( Row_handles[1], "visible", false )
	else 
		vint_object_destroy( Row_handles[Num_rows] )
	end

	Num_rows = Num_rows - 1

	if (Num_rows == 0) then
		vint_set_property( vint_object_find("row_highlight_main"), "visible", false )
	end
end

-- #############################################################
function update_row_position(index)

	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )	
	local new_y = Row_base_pos_y + (Highlight_bar_size_y/parent_yscale) * (index - 1)
	vint_set_property( Row_handles[index], "anchor", Row_base_pos_x, new_y )
end

-- #############################################################
function update_row(data_item_handle, event_name)
	local index, caption, date, time, highlighted, selectable, has_dags = vint_dataitem_get(data_item_handle)

	-- Do we need to add a new row?
	if (event_name == "insert") then
		add_row()
	end

	-- Update this guys position
	update_row_position(index)

	-- Set all of his data
	if ((index >= 1) and (index <= Num_rows)) then
		local handle = vint_object_find( "row_name", Row_handles[index] )
		vint_set_property( handle, "text_tag", caption )

		handle = vint_object_find( "row_value_1", Row_handles[index] )
		vint_set_property( handle, "text_tag", date )
		vint_set_property( handle, "tint", 0.85, 0.5, 0.01)

		handle = vint_object_find( "row_value_2", Row_handles[index] )
		vint_set_property( handle, "text_tag", time )
		vint_set_property( handle, "tint", 0.85, 0.5, 0.01)

		-- If we're highlighted then move the highlight bar to our position
		if (highlighted == true) then
			local pos_x, pos_y = vint_get_property( Row_handles[index], "anchor" )
			
			handle = vint_object_find( "row_name", Row_handles[index] )
			vint_set_property( handle, "tint", 1.0, 1.0, 1.0)
			
			handle = vint_object_find( "row_highlight_main" )
			vint_set_property( handle, "anchor", pos_x, pos_y )
			vint_set_property( handle, "visible", true )

			handle = vint_object_find( "row_highlight_button" )
			vint_set_property( handle, "visible", false )

			handle = vint_object_find( "row_value_1", Row_handles[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)

			handle = vint_object_find( "row_value_2", Row_handles[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)

			-- Lastly, highlighted rows never have dags
			has_dags = false
		else			
			handle = vint_object_find( "row_name", Row_handles[index] )
			vint_set_property( handle, "tint", 1, 0.501961, 0)		
		end

		-- Does this row have dags?
		handle = vint_object_find( "row_bg_main", Row_handles[index] )
		vint_set_property( handle, "visible", has_dags )
	end
end


-- ##############################################################
function set_hints(data_item_handle, event_name)
	local b_hint_image, b_hint_text, x_hint_image, x_hint_text, a_hint_image, a_hint_text, y_hint_image, y_hint_text = vint_dataitem_get(data_item_handle)

	local num_hints = 1
	local max_hints = 4
	
	local handle = vint_object_find( "hint_" .. tostring(num_hints) .. "_group" )
	vint_set_property( handle, "visible", true )
	
	handle = vint_object_find( "hint_button_" .. tostring(num_hints) )
	vint_set_property( handle, "text_tag", b_hint_image )

	handle = vint_object_find( "hints_text_" .. tostring(num_hints) )
	vint_set_property( handle, "text_tag", b_hint_text )
	
	num_hints = num_hints + 1
 
	if (x_hint_image ~= " ") then
		handle = vint_object_find( "hint_" .. tostring(num_hints) .. "_group" )
		vint_set_property( handle, "visible", true )
	
		handle = vint_object_find( "hint_button_" .. tostring(num_hints) )
		vint_set_property( handle, "text_tag", x_hint_image )

		handle = vint_object_find( "hints_text_" .. tostring(num_hints) )
		vint_set_property( handle, "text_tag", x_hint_text )
	
		num_hints = num_hints + 1
	end

	handle = vint_object_find( "hint_" .. tostring(num_hints) .. "_group" )
	vint_set_property( handle, "visible", true )

	handle = vint_object_find( "hint_button_" .. tostring(num_hints) )
	vint_set_property( handle, "text_tag", a_hint_image )

	handle = vint_object_find( "hints_text_" .. tostring(num_hints) )
	vint_set_property( handle, "text_tag", a_hint_text )
	
	num_hints = num_hints + 1
 
	if (y_hint_image ~= " ") then
		handle = vint_object_find( "hint_" .. tostring(num_hints) .. "_group" )
		vint_set_property( handle, "visible", true )
	
		handle = vint_object_find( "hint_button_" .. tostring(num_hints) )
		vint_set_property( handle, "text_tag", y_hint_image )

		handle = vint_object_find( "hints_text_" .. tostring(num_hints) )
		vint_set_property( handle, "text_tag", y_hint_text )
	
		num_hints = num_hints + 1
	end
	
	for i = num_hints,max_hints do
		handle = vint_object_find( "hint_" .. tostring(i) .. "_group" )
		vint_set_property( handle, "visible", false )
	end

	local blank_space = 45
	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )	
		
	handle = vint_object_find( "hint_1_group" )
	local pos1_x, pos1_y = vint_get_property( handle, "anchor" )
	local size1_x, size1_y = vint_get_property( handle, "screen_size" )

	handle = vint_object_find( "hint_2_group" )
	local pos2_x = pos1_x + (size1_x/parent_xscale) + blank_space
	local pos2_y = pos1_y
	vint_set_property( handle, "anchor", pos2_x, pos2_y )
	local size2_x, size2_y = vint_get_property( handle, "screen_size" )

	handle = vint_object_find( "hint_3_group" )
	local pos3_x = pos2_x + (size2_x/parent_xscale) + blank_space
	local pos3_y = pos1_y
	vint_set_property( handle, "anchor", pos3_x, pos3_y )
	local size3_x, size3_y = vint_get_property( handle, "screen_size" )

	handle = vint_object_find( "hint_4_group" )
	local pos4_x = pos3_x + (size3_x/parent_xscale) + blank_space
	local pos4_y = pos1_y
	vint_set_property( handle, "anchor", pos4_x, pos4_y )
end