
ORANGE			= {R=0.83,G=0.54,B=0}
BROWN				= {R=0.5,G=0.25,B=0}

MAX_ROWS_DLC			= 9
Row_handles_dlc			= { MAX_ROWS_DLC = 0 }
Num_rows_dlc			= 0

Row_base_pos_x_dlc = 0
Row_base_pos_y_dlc = 0

Highlight_bar_size_x_dlc = 0
Highlight_bar_size_y_dlc = 0

Scroll_bar_height_dlc = 0
Scroll_bar_top_y_dlc = 0
Scroll_bar_top_x_dlc = 0
Scroll_bar_bottom_y_dlc = 0



-- ##############################################################
function init_ps3_dlc_screen_handles()
	Row_handles_dlc[1] = vint_object_find( "row_group" )

	local handle = vint_object_find( "row_group" )
	Row_base_pos_x_dlc, Row_base_pos_y_dlc = vint_get_property( handle, "anchor" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "row_highlight_main" )
	Highlight_bar_size_x_dlc, Highlight_bar_size_y_dlc = vint_get_property( handle, "screen_size" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "scroll_bar_fill" )
	Scroll_bar_top_x_dlc, Scroll_bar_height_dlc = vint_get_property( handle, "screen_size" )
	Scroll_bar_top_x_dlc, Scroll_bar_top_y_dlc = vint_get_property( handle, "anchor" )

	handle = vint_object_find( "black_scrollfill" )
	local outline_posx, outline_posy = vint_get_property( handle, "anchor" ) 
	local ontline_sizex, outline_sizey = vint_get_property( handle, "screen_size" )

	local offset = Scroll_bar_top_y_dlc - outline_posy
	Scroll_bar_bottom_y_dlc = Scroll_bar_top_y_dlc + outline_sizey - Scroll_bar_height_dlc - 10


	--debug_print("vint", "Bottom Y: "..Scroll_bar_bottom_y_dlc.."\n")

end

-- ##############################################################
function rfg_ui_ps3_dlc_cleanup()
end

-- ##############################################################
function rfg_ui_ps3_dlc_init()

	-- get the handles
	init_ps3_dlc_screen_handles()

	-- subscribe to the data item whose name is ??, and we listen for updates, so that
	-- it then calls our function ??
	vint_dataitem_add_subscription( "DlcHeaderData", "update", "set_header_dlc" )
	
	vint_datagroup_add_subscription( "DlcRowData", "insert", "update_row_dlc" )
	vint_datagroup_add_subscription( "DlcRowData", "update", "update_row_dlc" )
	vint_datagroup_add_subscription( "DlcRowData", "remove", "remove_row_dlc" )
	
	vint_dataitem_add_subscription( "DlcHintData", "update", "set_hints_dlc" )

end

-- ##############################################################
function set_header_dlc(data_item_handle, event_name)
	local page_title, title, description_caption, description, size_caption, size_value, image_handle, show_scroll, scroll_percent, file_name_caption, date_caption, cost_caption, view, image_name = vint_dataitem_get(data_item_handle)

	local page_title_handle				= vint_object_find( "title_text")
	local title_handle					= vint_object_find( "file_name" )
	local description_caption_handle 	= vint_object_find( "description_title" )
	local description_handle	 		= vint_object_find( "description_value" )
	local size_caption_handle	 		= vint_object_find( "size_title" )
	local size_value_handle				= vint_object_find( "file_size_value" )
	local image_frame_handle			= vint_object_find( "file_image" )
	local scroll_bar_handle				= vint_object_find( "scroll_bar" )
	local scroll_bar_fill_handle		= vint_object_find( "scroll_bar_fill" )
	local file_name_caption_handle		= vint_object_find( "header_text_1" )
	local date_caption_handle			= vint_object_find( "header_text_2" )
	local cost_caption_handle			= vint_object_find( "header_text_3" )


	-- Set all of the text tags
	vint_set_property( page_title_handle, "text_tag", page_title )
	vint_set_property( title_handle, "text_tag", title )
	vint_set_property( description_caption_handle, "text_tag", description_caption )
	vint_set_property( description_handle, "text_tag", description )
	vint_set_property( size_caption_handle, "text_tag", size_caption )
	vint_set_property( size_value_handle, "text_tag", size_value )
	vint_set_property( file_name_caption_handle, "text_tag", file_name_caption)
	

	-- Set the thumb image
	local size_x, size_y = vint_get_property( image_frame_handle, "screen_size" )	-- Need to store the current scale so we can reset this after we set the new image

	if (view == false) then
		vint_set_property( image_frame_handle, "image_raw", image_handle )
			
		-- MW: Hack to fix interface scaling
		-- MW: Apparently won't work on "image_raw"...
		-- local img_size_x, img_size_y, img_scale_x, img_scale_y = rfg_get_bitmap_dimensions(image_frame_handle)
		-- vint_set_property(image_frame_handle, "image_size", img_size_x * img_scale_x, img_size_y * img_scale_y )
			
		vint_set_property( date_caption_handle, "text_tag", date_caption )
		vint_set_property( cost_caption_handle, "text_tag", cost_caption )
		vint_set_property( date_caption_handle, "visible", true)
		vint_set_property( cost_caption_handle, "visible", true)
		vint_set_property( size_caption_handle, "visible", true)
		vint_set_property( size_value_handle, "visible", true )
	else
		vint_set_property( image_frame_handle, "image", image_name)
			
		if image_name ~= nil then
			-- MW: Hack to fix interface scaling
			local img_size_x, img_size_y, img_scale_x, img_scale_y = rfg_get_bitmap_dimensions(image_frame_handle)
			vint_set_property(image_frame_handle, "image_size", img_size_x * img_scale_x, img_size_y * img_scale_y )
		end
		
		vint_set_property( date_caption_handle, "visible", false)
		vint_set_property( cost_caption_handle, "visible", false)
		vint_set_property( size_caption_handle, "visible", false)
		vint_set_property( size_value_handle, "visible", false )
	end
	vint_set_property( image_frame_handle, "screen_size", size_x, size_y )
	vint_set_property( image_frame_handle, "visible", true )


	vint_set_property( scroll_bar_handle, "visible", show_scroll )
	if (show_scroll == true) then
		--set the scroll bar thumb position
		local new_y = Scroll_bar_top_y_dlc + (scroll_percent * (Scroll_bar_bottom_y_dlc - Scroll_bar_top_y_dlc))
		vint_set_property( scroll_bar_fill_handle, "anchor", Scroll_bar_top_x_dlc, new_y )
	end

end

-- #############################################################
function add_row_dlc()
	if (Num_rows_dlc < 1) then
		vint_set_property( Row_handles_dlc[1], "visible", true )
	else
		Row_handles_dlc[Num_rows_dlc + 1] = vint_object_clone_rename( Row_handles_dlc[1], "row_group"..Num_rows_dlc )
	end

	Num_rows_dlc = Num_rows_dlc + 1
end

-- #############################################################
function remove_row_dlc()
	if (Num_rows_dlc <= 1) then
		vint_set_property( Row_handles_dlc[1], "visible", false )
	else 
		vint_object_destroy( Row_handles_dlc[Num_rows_dlc] )
	end

	Num_rows_dlc = Num_rows_dlc - 1

	if (Num_rows_dlc == 0) then
		vint_set_property( vint_object_find("row_highlight_main"), "visible", false )
	end
end

-- #############################################################
function update_row_position_dlc(index)
	local new_y = Row_base_pos_y_dlc + Highlight_bar_size_y_dlc * (index - 1)
	vint_set_property( Row_handles_dlc[index], "anchor", Row_base_pos_x_dlc, new_y )
end

-- #############################################################
function update_row_dlc(data_item_handle, event_name)
	local index, caption, price, highlighted, has_dags, highlight_button, view = vint_dataitem_get(data_item_handle)

	-- Do we need to add a new row?
	if (event_name == "insert") then
		add_row_dlc()
	end

	-- Update this guys position
	update_row_position_dlc(index)

	-- Set all of his data
	if ((index >= 1) and (index <= Num_rows_dlc)) then
		local handle = vint_object_find( "row_name", Row_handles_dlc[index] )
		vint_set_property( handle, "text_tag", caption )

		handle = vint_object_find( "row_value_1", Row_handles_dlc[index] )
		vint_set_property( handle, "text_tag", price )
		vint_set_property( handle, "tint", 0.85, 0.5, 0.01)
		--DLC: Hiding because I don't think this is used
		--vint_set_property( handle, "visible", view)

		-- If we're highlighted then move the highlight bar to our position
		if (highlighted == true) then
			local pos_x, pos_y = vint_get_property( Row_handles_dlc[index], "anchor" )
			
			handle = vint_object_find( "row_highlight_main" )
			vint_set_property( handle, "anchor", pos_x, pos_y )
			vint_set_property( handle, "visible", true )

			handle = vint_object_find( "row_value_1", Row_handles_dlc[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)

			handle = vint_object_find( "row_value_2", Row_handles_dlc[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)
			
			handle = vint_object_find( "row_highlight_button")
			vint_set_property( handle, "text_tag", highlight_button )
			vint_set_property( handle, "visible", true )

			-- Lastly, highlighted rows never have dags
			has_dags = false
		end

		-- Does this row have dags?
		handle = vint_object_find( "row_bg_main", Row_handles_dlc[index] )
		vint_set_property( handle, "visible", has_dags )
	end
end


-- ##############################################################
function set_hints_dlc(data_item_handle, event_name)
	local a_hint_image, a_hint_text, b_hint_image, b_hint_text, view, y_hint_image, y_hint_text  = vint_dataitem_get(data_item_handle)

	local handle = vint_object_find( "hint_button_1" )
	vint_set_property( handle, "text_tag", a_hint_image )

	handle = vint_object_find( "hints_text_1" )
	vint_set_property( handle, "text_tag", a_hint_text )
	
	handle = vint_object_find( "hint_button_2" )
	vint_set_property( handle, "text_tag", b_hint_image )

	handle = vint_object_find( "hints_text_2" )
	vint_set_property( handle, "text_tag", b_hint_text )

	--DLC: fix hint spacing

	local hint_1 = vint_object_find("hint_1_group")
	local hint_2 = vint_object_find("hint_2_group")
	local hint_1_x, hint_1_y =  vint_get_property(hint_1, "anchor")
	local hint_2_x, hint_2_y = vint_get_property(hint_2, "anchor")
	local hint_1_width, hint_1_height = vint_get_property(hint_1, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"),"scale")

	vint_set_property(hint_2, "anchor", hint_1_x + hint_1_width / parent_scale_x + 7, hint_2_y)
	
		
	-- need to add a button for going to the purchasing menu
	-- handle = vint_object_find( "hints_text_3" )
	-- local handle2 = vint_object_find( "hints_button_3" )
	-- if (view == true) then
	--		vint_set_property( handle2, "image", y_hint_image )
	--		vint_set_property( handle, "text_tag", y_hint_text )
	-- else
	--		vint_set_property( handle2, "visible", false)
	--		vint_set_property( handle, "visible", false)
	-- end
end
