
ORANGE				= {R=0.83,G=0.54,B=0}
BROWN				= {R=0.5,G=0.25,B=0}
INVALID_RED			= {R=.9,G=0,B=0}
INVALID_DARK_RED		= {R=.3,G=0,B=0}
DARK_ORANGE			= {R=0.5,G=0.25,B=0}

MP_OPTIONS_HINT_PADDING			= 20

MAX_PAGES			= 5

MAX_ROWS			= 16
Row_handles			= { MAX_ROWS = 0 }
Num_rows			= 0

Row_base_pos_x = 0
Row_base_pos_y = 0

Highlight_bar_size_x = 0
Highlight_bar_size_y = 0

MP_options_parent_scale_x		= 0
MP_options_parent_scale_y		= 0

Scroll_bar_height = 0
Scroll_bar_top_y = 0
Scroll_bar_top_x = 0
Scroll_bar_bottom_y = 0

Page_base_x = 0
Page_base_y = 0
Controls_parent_scale_x		= 0
Controls_parent_scale_y		= 0

-- ##############################################################
function init_mp_options_handles()

	Row_handles[1] = vint_object_find( "row_group" )

	local handle = vint_object_find( "row_group" )
	Row_base_pos_x, Row_base_pos_y = vint_get_property( handle, "anchor" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "row_highlight_main" )
	Highlight_bar_size_x, Highlight_bar_size_y = vint_get_property( handle, "screen_size" )
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "screen_group" )
	MP_options_parent_scale_x, MP_options_parent_scale_y = vint_get_property( handle, "scale" )

	handle = vint_object_find( "scroll_bar_fill" )
	Scroll_bar_top_x, Scroll_bar_height = vint_get_property( handle, "screen_size" )
	Scroll_bar_top_x, Scroll_bar_top_y = vint_get_property( handle, "anchor" )

	--local crap_x
	--crap_x, Scroll_bar_height = vint_get_property( vint_object_find( "black_scrollfill" ), "screen_size" )

	handle = vint_object_find( "black_scrollfill" )
	local outline_posx, outline_posy = vint_get_property( handle, "anchor" ) 
	local ontline_sizex, outline_sizey = vint_get_property( handle, "screen_size" )

	handle = vint_object_find( "screen_group" )
	Controls_parent_scale_x, Controls_parent_scale_y = vint_get_property( handle, "scale" )
	--global for page text start x pos
	handle = vint_object_find( "page1" )
	Page_base_x, Page_base_y = vint_get_property( handle, "anchor" )

	local offset = Scroll_bar_top_y - outline_posy
	Scroll_bar_bottom_y = Scroll_bar_top_y + outline_sizey - Scroll_bar_height - 10

	--set the paper image manually
	vint_set_property( vint_object_find( "info_bg_image" ), "image", "ui_handbook_paper" )
	vint_set_property( vint_object_find( "info_bg_image" ), "scale", 0.92,1.16 )

	handle = vint_object_find( "map_group" )
	vint_set_property( handle, "visible", false )

	--debug_print("vint", "Bottom Y: "..Scroll_bar_bottom_y.."\n")

end

-- ##############################################################
function rfg_ui_mp_options_cleanup()
end

-- ##############################################################
function rfg_ui_mp_options_init()

	-- get the handles
	init_mp_options_handles()

	-- subscribe to the data item whose name is ??, and we listen for updates, so that
	-- it then calls our function ??
	vint_dataitem_add_subscription( "HeaderData", "update", "set_header" )
	vint_dataitem_add_subscription( "PageTabData", "update", "set_page_tab" )
	
	vint_datagroup_add_subscription( "RowData", "insert", "update_row" )
	vint_datagroup_add_subscription( "RowData", "update", "update_row" )
	vint_datagroup_add_subscription( "RowData", "remove", "remove_row" )
	
	vint_dataitem_add_subscription( "HintData", "update", "set_hints" )
	vint_dataitem_add_subscription( "InfoData", "update", "set_info" )
	vint_dataitem_add_subscription( "MapData", "update", "set_map" )


end

-- ##############################################################
function set_header(data_item_handle, event_name)
	local title, show_scroll, scroll_percent = vint_dataitem_get(data_item_handle)

	local title_handle			= vint_object_find( "title_text" )

	local scroll_bar_handle			= vint_object_find( "scroll_bar" )
	local scroll_bar_fill_handle		= vint_object_find( "scroll_bar_fill" )

	-- Set all of the text tags
	vint_set_property( title_handle, "text_tag", title )

	vint_set_property( scroll_bar_handle, "visible", show_scroll )
	if (show_scroll == true) then
		--set the scroll bar thumb position
		local new_y = Scroll_bar_top_y + (scroll_percent * (Scroll_bar_bottom_y - Scroll_bar_top_y))
		vint_set_property( scroll_bar_fill_handle, "anchor", Scroll_bar_top_x, new_y )
	end

end

-- ##############################################################
function set_map(data_item_handle, event_name)
	local is_visible, map_image, map_title, map_value, player_title, player_value = vint_dataitem_get(data_item_handle)
	
	local group_handle			= vint_object_find( "map_group" )
	local image_handle			= vint_object_find( "map_image" )
	local map_title_handle			= vint_object_find( "map_title" )
	local map_value_handle			= vint_object_find( "map_value" )
	local player_title_handle		= vint_object_find( "player_title" )
	local player_value_handle		= vint_object_find( "player_value" )
	
	vint_set_property( group_handle, "visible", is_visible )
	if(is_visible == true)then
		if (map_image ~= nil) then
			vint_set_property( image_handle, "visible", true )		
			vint_set_property( image_handle, "image", map_image )
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
			vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		else
			vint_set_property( image_handle, "visible", false )
		end

		-- Set all of the text tags
		vint_set_property( map_title_handle, "text_tag", map_title )
		vint_set_property( map_value_handle, "text_tag", map_value )
		vint_set_property( player_title_handle, "text_tag", player_title )
		vint_set_property( player_value_handle, "text_tag", player_value )
	end

end

-- #############################################################
function set_page_tab(data_item_handle, event_name)
	local page_new = { MAX_PAGES = false }
	local page1_name, selected_page, num_pages
	page1_name, selected_page, num_pages = vint_dataitem_get(data_item_handle)
	
	--set the page name text
	local page_name = vint_object_find( "page1" )
	vint_set_property( page_name,"text_tag",page1_name )
	--get the text properties
	vint_set_property( page_name, "text_scale", 0.5, 0.7 )
	local options_parent_scale_x, options_parent_scale_y = vint_get_property(vint_object_find("screen_group"),"scale")
	local text_scale_x,text_scale_y = vint_get_property(page_name, "text_scale" )
	local text_width,text_height = vint_get_property( page_name, "screen_size" )
	local name_max_width = 262.0 * options_parent_scale_x
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( page_name, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( page_name, "text_scale",text_scale_x,text_scale_y )
	end

	--handle the page tabs
	local page_tabs = { vint_object_find( "tab_1" ), vint_object_find( "tab_2" ), vint_object_find( "tab_3" ), vint_object_find( "tab_4" ), vint_object_find( "tab_5" ), vint_object_find( "tab_6" ), vint_object_find( "tab_7" ), vint_object_find( "tab_8" ) }
	--make everyone brown
	for i=1,MAX_PAGES do
		vint_set_property( page_tabs[i], "tint", BROWN.R,BROWN.G,BROWN.B )
		vint_set_property( page_tabs[i], "visible", false )
	end
	--show the correct tabs
	for i=1,num_pages do
		vint_set_property( page_tabs[i], "visible", true )
	end

	--handle the tab highlight
	--make the current tab orange
	vint_set_property( page_tabs[selected_page], "tint", ORANGE.R,ORANGE.G,ORANGE.B )
	--move the highlight box
	local tab_highlight = vint_object_find( "tab_highlight" )
	local tab_x,tab_y = vint_get_property( page_tabs[selected_page], "anchor" )
	vint_set_property( tab_highlight, "anchor", tab_x,tab_y )

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
end

-- #############################################################
function update_row_position(index)
	local new_y = Row_base_pos_y + ((Highlight_bar_size_y/MP_options_parent_scale_y) - 2) * (index - 1)
	vint_set_property( Row_handles[index], "anchor", Row_base_pos_x, new_y )
end

-- #############################################################
function update_row(data_item_handle, event_name)
	local index, caption, value, highlighted, selectable, has_dags, button_image, is_valid = vint_dataitem_get(data_item_handle)

	-- Do we need to add a new row?
	if (event_name == "insert") then
		add_row()
	end

	-- Update this guys position
	update_row_position(index)

	-- Set all of his data
	if ((index >= 1) and (index <= Num_rows)) then
		local handle
		local name_handle = vint_object_find( "row_name", Row_handles[index] )
		local value_handle = vint_object_find( "row_value", Row_handles[index] )
		vint_set_property( name_handle, "text_tag", caption )

		--if toggle text is nil then we need to hide it because we have a button
		if( value ~= nil )then
			vint_set_property( value_handle, "visible", true )
			vint_set_property( value_handle, "text_tag", value )
		else
			vint_set_property( value_handle, "visible", false )
		end


		--handle name text scaling for long strings
		vint_set_property(name_handle, "text_scale", 0.7, 0.8)
		
		local value_width, value_height = vint_get_property(name_handle, "screen_size")
		local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"), "scale")

		local MAX_WIDTH, MAX_HEIGHT = vint_get_property( vint_object_find( "row_highlight_bg" ), "screen_size" )
		local arrow_width, arrow_height = vint_get_property( vint_object_find( "row_left_arrow" ), "screen_size" )
		local MAX_WIDTH = MAX_WIDTH - (arrow_width * 4.0)

		if(value_width > MAX_WIDTH) then
			local new_scale_x = MAX_WIDTH/value_width * 0.7
			vint_set_property(name_handle, "text_scale", new_scale_x, 0.8)
		end


		--handle value text scaling for long strings
		vint_set_property(value_handle, "text_scale", 0.7, 0.8)
		
		value_width, value_height = vint_get_property(value_handle, "screen_size")
		MAX_WIDTH = 202 * parent_scale_x

		if(value_width > MAX_WIDTH) then
			vint_set_property(value_handle, "text_scale", 0.66, 0.8)
		end
				
		--if row value is invalid then we should tint it as such
		if( is_valid == false )then
			if( highlighted )then
				vint_set_property( value_handle, "tint", INVALID_DARK_RED.R,INVALID_DARK_RED.G,INVALID_DARK_RED.B )
				vint_set_property( name_handle, "tint", INVALID_RED.R,INVALID_RED.G,INVALID_RED.B )
			else
				vint_set_property( value_handle, "tint", INVALID_RED.R,INVALID_RED.G,INVALID_RED.B )
				vint_set_property( name_handle, "tint", INVALID_RED.R,INVALID_RED.G,INVALID_RED.B )
			end
		elseif( highlighted )then
			vint_set_property( value_handle, "tint", 0,0,0 )
			vint_set_property( name_handle, "tint", ORANGE.R,ORANGE.G,ORANGE.B )
		else
			vint_set_property( value_handle, "tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B )
			vint_set_property( name_handle, "tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B )
		end

			--hide the toggle arrows by default
		local left_arrow_handle = vint_object_find( "row_left_arrow", Row_handles[index] )
		local right_arrow_handle = vint_object_find( "row_right_arrow", Row_handles[index] )
		vint_set_property( left_arrow_handle, "visible", false )
		vint_set_property( right_arrow_handle, "visible", false )

		-- If we're highlighted then move the highlight bar to our position
		if (highlighted == true) then
			local pos_x, pos_y = vint_get_property( Row_handles[index], "anchor" )
			
			handle = vint_object_find( "row_highlight_main" )
			
			local highlight_x,highlight_y = vint_get_property( handle, "anchor" )
		
			vint_set_property( handle, "anchor", highlight_x, pos_y )
			vint_set_property( handle, "visible", true )

			if( button_image ~= nil )then
				vint_set_property( vint_object_find( "row_highlight_button" ), "visible", true )
				vint_set_property( vint_object_find( "row_highlight_button" ), "image", button_image )
			else
				vint_set_property( vint_object_find( "row_highlight_button" ), "visible", false )
			end
			
			--if we are highlighted and we have a toggle then show the arrows
			if( value ~= nil )then
				vint_set_property( left_arrow_handle, "visible", true )
				vint_set_property( right_arrow_handle, "visible", true )
			end

			handle = vint_object_find( "row_highlight_button" )
			vint_set_property( handle, "visible", selectable )

			-- Lastly, highlighted rows never have dags
			has_dags = false
		end

		-- Does this row have dags?
		handle = vint_object_find( "row_bg_main", Row_handles[index] )
		vint_set_property( handle, "visible", has_dags )
	end
end


-- ##############################################################
function set_hints(data_item_handle, event_name)
	local a_hint_image, lb_hint_image, rb_hint_image, b_hint_image, b_hint_text,a_hint_text = vint_dataitem_get(data_item_handle)

	local handle = vint_object_find( "hint_button_1" )
	vint_set_property( handle, "text_tag", a_hint_image )

	handle = vint_object_find( "hints_text_1" )
	vint_set_property( handle, "text_tag", a_hint_text )

	local page_left_handle = vint_object_find( "page_left" )
	local page_right_handle = vint_object_find( "page_right" )
	vint_set_property( page_left_handle, "text_tag", lb_hint_image )
	vint_set_property( page_right_handle, "text_tag", rb_hint_image )

	handle = vint_object_find( "hint_2_group" )
	vint_set_property( handle, "visible", true )

	handle = vint_object_find( "hint_button_2" )
	vint_set_property( handle, "text_tag", b_hint_image )

	handle = vint_object_find( "hints_text_2" )
	vint_set_property( handle, "text_tag", b_hint_text )

	local parentscalex,parentscaley = vint_get_property( vint_object_find( "screen_group" ),"scale" )
	local hint1x,hint1y = vint_get_property( vint_object_find( "hint_1_group" ),"anchor" )
	local hint1width,hint1height = vint_get_property( vint_object_find( "hint_1_group" ),"screen_size" )
	handle = vint_object_find( "hint_2_group" )
	local new_x = hint1x + (hint1width/parentscalex) + MP_OPTIONS_HINT_PADDING
	vint_set_property( handle, "anchor", new_x, hint1y )

end

-- ##############################################################
function set_info(data_item_handle, event_name)
	local visible, title, info = vint_dataitem_get(data_item_handle)

	local title_handle = vint_object_find( "info_title" )
	local text_handle = vint_object_find( "info_text" )

	vint_set_property(title_handle, "visible", true)
	vint_set_property( title_handle, "text_tag", title )

	vint_set_property(text_handle, "visible", visible)

	if (visible) then
		vint_set_property( text_handle, "text_tag", info )

		--max_width = 297 * 
		vint_set_property( title_handle, "text_scale", 0.9, 1.0 )
		local text_scale_x,text_scale_y = vint_get_property( title_handle, "text_scale" )
		local text_width,text_height = vint_get_property( title_handle, "screen_size" )
		local parent_scale_x,parent_scale_y = vint_get_property(vint_object_find( "screen_group" ), "scale" )
		local name_max_width = 297.0 * parent_scale_x
		local new_scale = name_max_width/text_width * text_scale_x
		--make the text fit
		if( text_width > name_max_width )then
			vint_set_property( title_handle, "text_scale", new_scale, text_scale_y )
		else
			vint_set_property( title_handle, "text_scale",text_scale_x,text_scale_y )
		end
	end
end