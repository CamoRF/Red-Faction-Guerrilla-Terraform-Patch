ORANGE				= {R=0.83,G=0.54,B=0}
DARK_ORANGE			= {R=0.69,G=0.35,B=0}
BROWN				= {R=0.5,G=0.25,B=0}

-- handles for each menu item
MAX_ITEMS			= 17
MAX_HINT_ITEMS			= 4
TEXT_OFFSET			= 10
CM_num_items			= 0
CM_tween_fadein_bounce_handles 	= {0, 0, 0, 0}
CM_obj_handles			= {MAX_ITEMS = 0}

CM_obj_visible			= {MAX_ITEMS = true}
CM_obj_enabled			= {MAX_ITEMS = true}
CM_hint_group			= {MAX_HINT_ITEMS = 0}
CM_choice			= 0
CM_choice_prev			= 0
--CM_tween_fadein_event_handle 	= 0
--CM_fadein_anchor		= false
--CM_model_handle		= 0
CM_highlight_button_handle	= 0
CM_highlight_button_x		= 0
CM_highlight_button_y		= 0
CM_highlight_button_size_x	= 0
CM_highlight_button_size_y	= 0
CM_text_group_x			= 0
CM_text_group_y			= 0
--CM_tween_on_select_handle	= 0
CM_num_hints			= 0

Controls_parent_scale_x		= 0 
Controls_parent_scale_y		= 0

Page_base_x = 0
Page_base_y = 0

LT_LABEL_BASEY = 0

MAX_ROWS			= 9
Row_handles			= { MAX_ROWS = 0 }
Num_rows			= 0

Row_base_pos_x = 0
Row_base_pos_y = 0

Highlight_bar_size_x = 0
Highlight_bar_size_y = 0

Scroll_bar_height = 0
Scroll_bar_top_y = 0
Scroll_bar_top_x = 0
Scroll_bar_bottom_y = 0


-- ##############################################################
function get_handles_controls()

	-- menu_highlight_button - get the button handle, and its information
	CM_highlight_button_handle = vint_object_find( "highlight_main" )
	CM_highlight_button_x, CM_highlight_button_y = vint_get_property( CM_highlight_button_handle, "anchor" )
	local sx, sy = vint_get_property(CM_highlight_button_handle, "screen_size")

	-- get the handle for our text group and the text group slide in and slide out anims
	CM_obj_handles[1] = vint_object_find("controls_row_main")
	--CM_obj_anim_fadein_handles[1]		= vint_object_find( "text_group_anim_slidein_norm" )
	--CM_obj_anim_fadeout_handles[1]	= vint_object_find( "text_group_anim_slideout" )
	CM_highlight_button_size_x, CM_highlight_button_size_y = vint_get_property(CM_obj_handles[1], "screen_size")
	
		local scale_x, scale_y = vint_get_property(vint_object_find("screen_group"), "scale")
	
	--[[
	CM_highlight_button_size_y = CM_highlight_button_size_y / scale_y
	if (CM_highlight_button_size_y < (sy / scale_y)) and (CM_highlight_button_size_y < (32 / scale_y) ) then
		--give a little padding to each text item
		if ( (32 / scale_y) < (sy)) then
			CM_highlight_button_size_y = (32 / scale_y)
		else
			CM_highlight_button_size_y = (sy /scale_y)
		end
	end
	]]--
	
	local highlight_y = sy / scale_y
	if (CM_highlight_button_size_y < (highlight_y * 0.9)) then
		CM_highlight_button_size_y = highlight_y * 0.9
		debug_print("always_on", "size set:"..CM_highlight_button_size_y )
	end
	
	--[[  RZ taken out on pc version
	if (CM_highlight_button_size_y < 32) then
		CM_highlight_button_size_y = 32
	end
	]]--

	CM_hint_group[1] = vint_object_find("hints")
	vint_set_property(CM_hint_group[1], "visible", false)
	
	-- get start x, y for the text group
	CM_text_group_x, CM_text_group_y = vint_get_property( CM_obj_handles[1], "anchor" )

	local handle = vint_object_find( "screen_group" )
	Controls_parent_scale_x, Controls_parent_scale_y = vint_get_property( handle, "scale" )

	--global for page text start x pos
	handle = vint_object_find( "page1" )
	Page_base_x, Page_base_y = vint_get_property( handle, "anchor" )


	-- disable the slide in and slide out tweens
	--[[local i
	vint_set_property( vint_object_find("text_group_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("highlight_button_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("text_group_slidein_norm1"), "state", TWEEN_STATE_DISABLED )
	local start_time = 0
	for i = 1, 4 do
		-- disable highlight button slideins
		local highlight_slide_h = vint_object_find("highlight_button_slidein"..i)
		vint_set_property( highlight_slide_h, "state", TWEEN_STATE_DISABLED )
		local duration = vint_get_property( highlight_slide_h, "duration" )
		vint_set_property( highlight_slide_h, "start_time", start_time)

		-- also get the fadein bounce handles for the selected text object and disable them
		CM_tween_fadein_bounce_handles[i] = vint_object_find( "text_group_slidein"..i )
		vint_set_property(CM_tween_fadein_bounce_handles[i], "start_time", start_time )
		vint_set_property(CM_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
		start_time = start_time + duration
	end
	vint_set_property( vint_object_find( "highlight_button_move" ), "state", TWEEN_STATE_DISABLED )--]]



	-- hide the text group
	vint_set_property( vint_object_find( "controls_bg" ), "visible", true )


	debug_print( "vint", "stuff" )
	
	Row_handles[1] = vint_object_find( "row_group" )
	
	local handle = vint_object_find( "row_group" )
	Row_base_pos_x, Row_base_pos_y = vint_get_property( handle, "anchor" )
	vint_set_property( handle, "visible", false )

	--RZ: we no longer have the highlight as the basis for everything, so we should size based on it!
	--handle = vint_object_find( "row_highlight_main" )
	Highlight_bar_size_x, Highlight_bar_size_y = vint_get_property( handle, "screen_size" )
	
	vint_set_property( handle, "visible", false )

	handle = vint_object_find( "scroll_bar_fill" )
	Scroll_bar_top_x, Scroll_bar_height = vint_get_property( handle, "screen_size" )
	Scroll_bar_top_x, Scroll_bar_top_y = vint_get_property( handle, "anchor" )

	handle = vint_object_find( "black_scrollfill" )
	local outline_posx, outline_posy = vint_get_property( handle, "anchor" ) 
	local ontline_sizex, outline_sizey = vint_get_property( handle, "screen_size" )

	local offset = Scroll_bar_top_y - outline_posy
	Scroll_bar_bottom_y = Scroll_bar_top_y + outline_sizey - Scroll_bar_height - 10
	

	-- get on select handle
	--CM_tween_on_select_handle = vint_object_find("highlight_button_slideout1")

end

-- ##############################################################
function rfg_ui_controls_pc_cleanup()
end

-- ##############################################################
function rfg_ui_controls_pc_init()
	-- get the handles
	get_handles_controls()
	
	debug_print("always_on", "Header_update" )

	-- Register for our data subscription to the button text data
	vint_dataitem_add_subscription( "Controls", "update", "controls_set_labels" )
	vint_dataitem_add_subscription( "ButtonImages", "update", "controls_set_images" )

	-- Register for our menu data updates
	vint_dataitem_add_subscription( "TweenOnSelectCM", "update", "cm_play_on_selection_tween" )
	vint_datagroup_add_subscription( "MenuGroupCM", "update", "cm_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroupCM", "insert", "cm_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroupCM", "remove", "cm_group_remove" )
	vint_datagroup_add_subscription( "HintsInfoCM", "update", "cm_hints_info" )
	vint_datagroup_add_subscription( "HintsInfoCM", "insert", "cm_hints_info" )
	vint_datagroup_add_subscription( "HintsInfoCM", "remove", "cm_hints_remove" )
	vint_dataitem_add_subscription( "MenuTitleCM", "update", "cm_update_title" )

	vint_dataitem_add_subscription( "PageTabData", "update", "set_page_tab" )

	vint_datagroup_add_subscription( "RowData", "insert", "update_row" )
	vint_datagroup_add_subscription( "RowData", "update", "update_row" )
	vint_datagroup_add_subscription( "RowData", "remove", "remove_row" )
	
	--RZ : scroll bar for this now
	vint_dataitem_add_subscription( "HeaderData", "update", "set_header" )
	
	-- guarantee time index is at 0
	vint_set_time_index(0)

	-- store LT's base position
	local bogusx
	bogusx, LT_LABEL_BASEY = vint_get_property(vint_object_find("lt"), "anchor")

end

-- ##############################################################
function set_header(data_item_handle, event_name)
	local show_scroll, scroll_percent = vint_dataitem_get(data_item_handle)
	local scroll_bar_handle			= vint_object_find( "scroll_bar" )
	local scroll_bar_fill_handle		= vint_object_find( "scroll_bar_fill" )
	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )

	vint_set_property( scroll_bar_handle, "visible", show_scroll )
	if (show_scroll == true) then
		--set the scroll bar thumb position
		local new_y = Scroll_bar_top_y + (scroll_percent * ((Scroll_bar_bottom_y - Scroll_bar_top_y) / parent_yscale))
		vint_set_property( scroll_bar_fill_handle, "anchor", Scroll_bar_top_x, new_y )
	end
	
	debug_print("always_on", "Header_update" )

end


-- #############################################################
function set_page_tab(data_item_handle, event_name)
	local page1_name, page2_name, page3_name, selected_page, scroll_left, scroll_right,left_button,right_button, title = vint_dataitem_get(data_item_handle)

	local page = { vint_object_find( "page1" ), vint_object_find( "page2" ), vint_object_find( "page3" ) }

	local page_bg_handle = vint_object_find( "page_text_bg" )
	
	local page_left_handle = vint_object_find( "page_left" )
	local page_right_handle = vint_object_find( "page_right" )
	local left_arrow_handle = vint_object_find( "page_left_arrow_main" )
	local right_arrow_handle = vint_object_find( "page_right_arrow_main" )

	vint_set_property( page_left_handle, "text_tag", left_button )
	vint_set_property( page_right_handle, "text_tag", right_button )

	local page_divide_handle = vint_object_find( "page_divide" )

	vint_set_property(  page[1],"text_tag",page1_name )
	vint_set_property(  page[1],"tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B )
	vint_set_property(  page[2],"text_tag",page2_name )
	vint_set_property(  page[2],"tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B )
	vint_set_property(  page[3],"text_tag",page3_name )
	vint_set_property(  page[3],"tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B ) 

	local cur_pos_x = Page_base_x
	local page_x,page_y = vint_get_property( page[1],"anchor" )
	local width, height
	local pos_x, pos_y
	local gap = 15

	for i=1,3 do
		-- is this guy selected
		if (selected_page == i) then
			local highlight_width = 0
			local highlight_x = cur_pos_x - (gap / 2) 

			-- If we can scroll to the left, then setup the left arrow and image
			if (scroll_left == true) then
				width, height = vint_get_property(left_arrow_handle, "screen_size")
				pos_x, pos_y = vint_get_property( left_arrow_handle, "anchor")	
				vint_set_property(left_arrow_handle, "anchor", cur_pos_x, pos_y)
				cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
				highlight_x = cur_pos_x - (gap / 2)
	
				width, height = vint_get_property(page_left_handle, "screen_size")
				pos_x, pos_y = vint_get_property( page_left_handle, "anchor")	
				vint_set_property(page_left_handle, "anchor", cur_pos_x, pos_y)
				cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
				highlight_width = highlight_width + ((width + gap))-- / Controls_parent_scale_x)
			end

			width, height = vint_get_property(page[i], "screen_size")
			pos_x, pos_y = vint_get_property( page[i], "anchor")	
			vint_set_property(page[i], "anchor", cur_pos_x, pos_y)

			cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
			highlight_width = highlight_width + ((width + gap))-- / Controls_parent_scale_x)

			-- If we can scroll to the right, then setup the right arrow and image
			if (scroll_right == true) then
				width, height = vint_get_property(page_right_handle, "screen_size")
				pos_x, pos_y = vint_get_property(page_right_handle, "anchor")	
				vint_set_property(page_right_handle, "anchor", cur_pos_x, pos_y)
				cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
				highlight_width = highlight_width + ((width + gap))-- / Controls_parent_scale_x)
				
				width, height = vint_get_property(right_arrow_handle, "screen_size")
				pos_x, pos_y = vint_get_property(right_arrow_handle , "anchor")	
				vint_set_property(right_arrow_handle, "anchor", cur_pos_x, pos_y)
				cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
			end

			-- Now it's time to setup the highlight bar
			width, height = vint_get_property( page_bg_handle, "screen_size")
			pos_x, pos_y = vint_get_property( page_bg_handle, "anchor")	
			vint_set_property(page_bg_handle, "anchor", highlight_x, pos_y)
			vint_set_property(page_bg_handle, "screen_size", highlight_width, height)
		else
			width, height = vint_get_property(page[i], "screen_size")
			pos_x, pos_y = vint_get_property( page[i], "anchor")	
			vint_set_property(page[i], "anchor", cur_pos_x, pos_y)
			cur_pos_x = cur_pos_x + ((width + gap) / Controls_parent_scale_x)
		end
	end

	if (scroll_left == true) then
		vint_set_property(left_arrow_handle, "visible", true)
		vint_set_property(page_left_handle, "visible", true)
	else
		vint_set_property(left_arrow_handle, "visible", false)
		vint_set_property(page_left_handle, "visible", false)
	end

	if (scroll_right == true) then
		vint_set_property(right_arrow_handle, "visible", true)
		vint_set_property(page_right_handle, "visible", true)
	else
		vint_set_property(right_arrow_handle, "visible", false)
		vint_set_property(page_right_handle, "visible", false)
	end

	vint_set_property( page[selected_page], "tint", ORANGE.R, ORANGE.G, ORANGE.B )
	--RZ: title is appended here, since we dont call the update images like in console versions
	local title_handle = vint_object_find( "controls_title1" )
	vint_set_property( title_handle,"text_tag",(title) )	
	
end



-- ##############################################################
function cm_group_add()

	-- k, looks like a data item has been added so we need to bump the number of items
	-- that we have
	local prev_num_items = CM_num_items
	CM_num_items = prev_num_items + 1

	if (prev_num_items ~= 0) then
		-- this is not the first item, so we clone the other items

		CM_obj_handles[CM_num_items] = vint_object_clone_rename(CM_obj_handles[1], "controls_row_main"..CM_num_items )
		--CM_obj_anim_fadein_handles[IO_num_items] = vint_object_clone_rename(CM_obj_anim_fadein_handles[1], "text_group_anim_slidein"..IO_num_items )
		--CM_obj_anim_fadeout_handles[IO_num_items] = vint_object_clone_rename(CM_obj_anim_fadeout_handles[1], "text_group_anim_slideout"..IO_num_items )
	end

	-- set visible
	vint_set_property( CM_obj_handles[CM_num_items], "visible", true )

	-- indicate visible and enabled
	CM_obj_visible[CM_num_items] = true
	CM_obj_enabled[CM_num_items] = true

end

-- ##############################################################
function update_item_position_controls(index)

	-- update the position of this item (really is just its y-value)
	local diff = cm_get_item_offset(index)
	local x, y = vint_get_property( CM_obj_handles[1], "anchor" )
	local new_y = CM_text_group_y + CM_highlight_button_size_y * diff
	vint_set_property( CM_obj_handles[index], "anchor", x, new_y )

	-- set new start time for the animation of fading in
	--local new_start = 0.05 * diff
	--vint_set_property( MM_obj_anim_fadein_handles[index], "start_time", new_start )

	-- update the targets for the tweens, and their start/end values
	--local handle, tmpx, tmpy

	-- get handle of the fadeout tween, then set its target handle and its state
	--handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[index] )
	--vint_set_property( handle, "target_handle", MM_obj_handles[index] )
	--vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadeout
	--tmpx, tmpy = vint_get_property( handle, "start_value" )
	--vint_set_property( handle, "start_value", tmpx, new_y )
	
	--tmpx, tmpy = vint_get_property( handle, "end_value" )
	--vint_set_property( handle, "end_value", tmpx, new_y )

	-- get handle of the fadein tween, then set its target handle and its state
	--handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
	--vint_set_property( handle, "target_handle", MM_obj_handles[index] )
	--vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadein
	--tmpx, tmpy = vint_get_property( handle, "start_value" )
	--vint_set_property( handle, "start_value", tmpx, new_y )

	--tmpx, tmpy = vint_get_property( handle, "end_value" )
	--vint_set_property( handle, "end_value", tmpx, new_y )
end


-- ##############################################################
function cm_group_remove(data_item_handle, event_name)

	if (CM_num_items > 0) then
	
		-- k, here we remove an item
		local prev_num_items = CM_num_items
		CM_num_items = prev_num_items - 1

		if (prev_num_items > 1) then
			-- simply get rid of the objects
			vint_object_destroy( CM_obj_handles[prev_num_items] )
			--vint_object_destroy( CM_obj_anim_fadein_handles[prev_num_items] )
			--vint_object_destroy( CM_obj_anim_fadeout_handles[prev_num_items] )

			CM_obj_handles[prev_num_items] = 0
			--CM_obj_anim_fadein_handles[prev_num_items] = 0
			--CMM_obj_anim_fadeout_handles[prev_num_items] = 0
		end

		-- indicate not visible nor enabled
		CM_obj_visible[prev_num_items] = false
		CM_obj_enabled[prev_num_items] = false
	end
	
end

-- ##############################################################
function cm_update_group_item(data_item_handle, event_name)

	-- k, get the index, its caption, value, and positions for caption and value
	local play_fadein, is_fadein_callback, is_selected, is_visible, is_enabled, index, is_slider, caption, value = vint_dataitem_get(data_item_handle)

	--[[if (play_fadein) then
		-- reset the time index
		vint_set_time_index(0)
		CM_fadein_anchor = true
	end--]]

	-- is this an add?
	if ( event_name == "insert" ) then
		cm_group_add()
	end

	-- update this guy's position
	update_item_position_controls(index)

	if (index >= 1) and ( index <= CM_num_items ) then

		-- set its text tags
		local handle = vint_object_find( "row_label", CM_obj_handles[index] )
		vint_set_property( handle, "text_tag", caption )
		handle = vint_object_find( "row_text", CM_obj_handles[index] )
		vint_set_property( handle, "text_tag", value )

		-- should we update the colors?
		local update = false
		if (CM_obj_visible[index] ~= is_visible) then
			update = true
		elseif (CM_obj_enabled[index] ~= is_enabled) then
			update = true
		end

		-- set its visibility, enabled status 
		CM_obj_visible[index] = is_visible
		CM_obj_enabled[index] = is_enabled

		if (play_fadein == true) then

			menu_tween_fade_in_end()
			--[[
			-- reset time index
			vint_set_time_index(0)

			-- are we the fadein callback?
			if ( is_fadein_callback == true ) then
				MM_tween_fadein_event_handle = vint_object_find( "text_group_slidein4" )
				vint_set_property( MM_tween_fadein_event_handle, "end_event", "mm_fade_in_end" )
			end

			-- trigger this guy's fadein tween
			cm_trigger_fadein_tween(index, is_fadein_callback, is_selected)
			--]]

		--elseif (CM_fadein_anchor == false) then

			-- flat out set its position
		--	local diff = cm_get_item_offset(index)
		--	local new_y = CM_text_group_y + CM_highlight_button_size_y*diff
		--	vint_set_property( CM_obj_handles[index], "anchor", CM_text_group_x, new_y )
		end

		if ( is_selected == true ) then
			
			-- set the index, but first set last choice
			cm_set_choice(index)

			-- make sure we update color
			update = true

			vint_set_property(handle, "tint", 0.0, 0.0 , 0.0)

		else

			vint_set_property(handle, "tint", 1.0, 0.57 , 0.03)

		end

		-- set visibility
		vint_set_property( CM_obj_handles[index], "visible", CM_obj_visible[index] )

		-- should it have diags?

		if ( (vint_mod(index,  2) == 1) and (is_selected == false) ) then
			vint_set_property( vint_object_find( "row_bg", CM_obj_handles[index] ), "visible", true ) 
		else 
			vint_set_property( vint_object_find( "row_bg", CM_obj_handles[index] ), "visible", false )
		end

		-- set enabled state
		if ( is_enabled ~= true ) then
			vint_set_property( CM_obj_handles[index], "alpha", 0.33 )
		elseif (is_selected) then
			vint_set_property( CM_obj_handles[index], "alpha", 1.0 )
		else
			vint_set_property( CM_obj_handles[index], "alpha", 0.67 )
		end
	
	else 
		debug_print("vint", "\nCONTROLLER MENU WTH HAPPENED!?!?!?!?" )
	end

end


-- ##############################################################
function cm_play_on_selection_tween(data_item_handle, event_name)

	-- the user has actually chosen something, so we do a special tween, and when it is done,
	-- we callback to the game, letting it know to continue with the gamestate change
	local selection = vint_dataitem_get(data_item_handle)
	
	if ( selection ~= 0 ) then
		--[[
		-- get current time
		local time_index = vint_get_time_index()

		-- ok, time to play the fadeout anims!
		local i
		for i = 1, CM_num_items do

			-- get the tween handle
			local tween_handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[i] )
			vint_set_property( MM_obj_anim_fadeout_handles[i], "start_time", 0 )
			vint_set_property( tween_handle, "start_time", time_index )
			vint_set_property( tween_handle, "state", TWEEN_STATE_RUNNING )

			local j
			for j = 1, 4 do
				tween_handle = vint_object_find( "text_group_slidein"..j, MM_obj_anim_fadein_handles[i] )
				vint_set_property( tween_handle, "state", TWEEN_STATE_DISABLED )
			end
		end

		-- set the end event for the highlight button move out, and its position information
		--local x, y = vint_get_property( MM_highlight_button_handle, "anchor" )
		MM_tween_on_select_handle = vint_object_find("highlight_button_slideout1")
		vint_set_property( vint_object_find("highlight_button_anim_slideout"), "start_time", 0 )
		vint_set_property( MM_tween_on_select_handle, "start_time", time_index )
		vint_set_property( MM_tween_on_select_handle, "state", TWEEN_STATE_RUNNING )
		vint_set_property( MM_tween_on_select_handle, "end_event", "mm_tween_on_select_end")
		vint_set_property( MM_tween_on_select_handle, "start_value", x, y )

		local endx, endy = vint_get_property( MM_tween_on_select_handle, "end_value" )
		vint_set_property( MM_tween_on_select_handle, "end_value", endx, y )
		--]]
		
		cm_tween_on_select_end()
	else
		
		--vint_set_property( MM_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )
	end


	
end

-- ##############################################################
function cm_tween_on_select_end(tween_h, event_name)

	-- callback into the game and let it know we are done
	menu_tween_on_select_end()

	-- remove this callback
	--[[remove_tween_end_callback(MM_tween_on_select_handle)

	-- disable the fadeout tweens for each item
	local i
	for i = 1, MM_num_items do
		local tween_handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[i] )
		vint_set_property( tween_handle, "state", TWEEN_STATE_DISABLED )
	end--]]

	-- disable our tween
end

-- ##############################################################
function cm_fade_in_end(target_handle, event_name)
--[[
	-- no longer fading in
	MM_fadein_anchor = false

	-- remove this callback
	remove_tween_end_callback(MM_tween_fadein_event_handle)
	MM_tween_fadein_event_handle = 0
	
	-- disable this
	local mm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
	vint_set_property( mm_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )

	-- disable the fadein tweens
	local i
	for i = 1, MM_num_items do
		local tween_h = vint_object_find("text_group_slidein_norm1", MM_obj_anim_fadein_handles[i])
		vint_set_property( tween_h, "state", TWEEN_STATE_DISABLED )
	end

	for i = 1, 4 do
		vint_set_property( vint_object_find( "highlight_button_slidein"..i ), "state", TWEEN_STATE_DISABLED )
		vint_set_property( MM_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
	end

	-- now callback into the game
	menu_tween_fade_in_end()
--]]
end
	

-- ##############################################################
function cm_hints_info(data_item_handle, event_name)
	
	local index, text, image_name = vint_dataitem_get(data_item_handle)
	
	if (event_name == "insert") then
		-- cloning time!
		CM_num_hints = CM_num_hints + 1
		
		if (CM_num_hints > 1) then
			CM_hint_group[CM_num_hints] = vint_object_clone_rename(CM_hint_group[1], "hints"..index )
		end
	end


	local group_h = CM_hint_group[index]
	vint_set_property(group_h, "visible", true)
	
	local text_h = vint_object_find("hint_text", group_h)
	local image_h = vint_object_find("hint_button", group_h)
	
	vint_set_property( text_h, "text_tag", text )
	vint_set_property( image_h, "image", image_name )
	
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find("screen_group"), "scale" )
	local OPTIONS_HINT_PADDING = 7
	
	-- update position
	for i = 2, index do
		local width, height = vint_get_property( CM_hint_group[i-1], "screen_size" )
		local anchor_x, anchor_y = vint_get_property( CM_hint_group[i-1], "anchor" )
		local new_x = anchor_x + (width/parent_scalex) + OPTIONS_HINT_PADDING
		vint_set_property(CM_hint_group[i], "anchor", new_x, anchor_y)
	end
end

-- ##############################################################
function cm_hints_remove(data_item_handle, event_name)

	if (CM_num_hints > 0) then
		-- k, here we destroy the item (if num hints is greater than 1)
		local new_num_items = CM_num_hints - 1

		if (CM_num_hints > 1) then
			vint_object_destroy( CM_hint_group[CM_num_hints] )	
			CM_hint_group[CM_num_hints] = 0
		else
			vint_set_property( CM_hint_group[CM_num_hints], "visible", false )
		end

		CM_num_hints = new_num_items
	end
end


-- ##############################################################
function cm_trigger_fadein_tween(index, is_fadein_callback, is_selected)
--[[
	local handle

	-- get our new y value for the text!
	local diff = cm_get_item_offset(index)
	--local new_y = MM_text_group_y + MM_highlight_button_size_y * diff

	-- we need to set our anchor to the fadein start value!
	local x, y = vint_get_property( vint_object_find("text_group_slidein1"), "start_value" )
	vint_set_property( MM_obj_handles[index], "anchor", x, new_y )

	-- get handle of the fadeout tween, and disable it!
	handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- ok, if we are selected, then we "bounce" in - so we have to ...
	if ( is_selected == true ) then

		-- disable our "normal" slidein tween
		handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
		vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

		-- get where the new highlight y should be placed
		--local new_highlight_y = CM_highlight_button_y + MM_highlight_button_size_y * diff

		-- now we re-target the slidein bounce tweens to target us, and reposition the slidein highlight tween
		local i
		for i = 1, 4 do

			-- retarget the highlight button to slide in with our y value!
			handle = vint_object_find( "highlight_button_slidein"..i )
			x, y = vint_get_property( handle, "start_value" )
			vint_set_property( handle, "start_value", x, new_highlight_y )
			x, y = vint_get_property( handle, "end_value" )
			vint_set_property( handle, "end_value", x, new_highlight_y )
			-- and set them to running
			vint_set_property( handle, "state", TWEEN_STATE_RUNNING )

			-- update the fadein bounce tweens to use our y value
			handle = MM_tween_fadein_bounce_handles[i]
			x, y = vint_get_property(handle, "start_value")
			vint_set_property( handle, "start_value", x, new_y)
			x, y = vint_get_property(handle, "end_value")
			vint_set_property( handle, "end_value", x, new_y)

			-- set their targets to be us
			vint_set_property( handle, "target_handle", MM_obj_handles[index] )
		
			-- and set them to running
			vint_set_property( handle, "state", TWEEN_STATE_RUNNING )
		end

	else
		-- enable our normal slidein tween
		handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
		vint_set_property( handle, "state", TWEEN_STATE_RUNNING )

		-- and guarantee its y values are ok
		x, y = vint_get_property(handle, "start_value")
		vint_set_property( handle, "start_value", x, new_y)
		x, y = vint_get_property(handle, "end_value")
		vint_set_property( handle, "end_value", x, new_y)
	end
--]]
end


-- #############################################################d#
function cm_set_choice(index)

	CM_choice_prev = CM_choice
	CM_choice = index


	--if (CM_fadein_anchor == false) then

		-- this occurs when the user has moved down or up on the menu
		local cm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		local oldx, oldy = vint_get_property( cm_tween_highlight_button_handle, "end_value" )
		local diff1 = cm_get_item_offset(CM_choice_prev)
		local diff2 = cm_get_item_offset(CM_choice)
		local new_starty	= CM_highlight_button_y + CM_highlight_button_size_y * diff1
		local new_endy		= CM_highlight_button_y + CM_highlight_button_size_y * diff2

		vint_set_property( cm_tween_highlight_button_handle, "duration", 0.125 )
		vint_set_property( cm_tween_highlight_button_handle, "start_time", vint_get_time_index() )
		vint_set_property( cm_tween_highlight_button_handle, "start_value", oldx, new_starty)
		vint_set_property( cm_tween_highlight_button_handle, "end_value", oldx, new_endy)
		vint_set_property( cm_tween_highlight_button_handle, "state", TWEEN_STATE_RUNNING )

	--else
	--	local mm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
	--	vint_set_property( mm_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )
	--end
--]]

end


-- ##############################################################
function cm_get_item_offset(index)

	local i
	local num_visible_before = 0
	for i = 1, index-1 do
		
		if (CM_obj_visible[i] == true) then
			num_visible_before = num_visible_before + 1
		end
	end

	return num_visible_before
end

-- ##############################################################
function cm_update_title(data_item_handle, event_name)

	-- k, get the title text and multiplayer flag!
	local multiplayer, title_text = vint_dataitem_get(data_item_handle)

end



-- ##############################################################
function controls_set_labels(data_item_handle, event_name)	

local title, controler_visible, image_name, label_a, label_b, label_x, label_y, label_lb, label_lt, label_rb, label_rt, label_ls, label_rs, label_start, label_back, unused_string = vint_dataitem_get(data_item_handle)

	local title_handle = vint_object_find( "controls_title1" )
	local lb = vint_object_find("lb")
	local lt = vint_object_find("lt")
	local rb = vint_object_find("rb")
	local rt = vint_object_find("rt")
	local unused_tint_r = 0.396
	local unused_tint_g = 0.2
	local unused_tint_b = 0.0
	local used_tint_r   = 1.0
	local used_tint_g   = 0.502
	local used_tint_b   = 0.0

	vint_set_property( title_handle,"text_tag",(title) )	

	vint_set_property( vint_object_find( "controls_bg" ), "image", "ui_fend_large_debris" )

	if ( controler_visible == true ) then
		vint_set_property( vint_object_find("controls_controller"), "visible", true )
		--controller animate in
		vint_set_property(vint_object_find("animate_controller_in"), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find("animate_controller_in"), TWEEN_STATE_RUNNING )

		vint_set_property( vint_object_find("controller"), "image", image_name )

		local handle = vint_object_find( "a" )
		if (label_a == " ") then
			label_a = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_a )


		handle = vint_object_find( "b" )
		if (label_b == " ") then
			label_b = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_b )


		handle = vint_object_find( "x" )
		if (label_x == " ") then
			label_x = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_x )

		handle = vint_object_find( "y" )
		if (label_y == " ") then
			label_y = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_y )


		if (label_lb == " ") then
			label_lb = unused_string
			vint_set_property( lb, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( lb, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( lb, "text_tag", label_lb )


		if (label_lt == " ") then
			label_lt = unused_string
			vint_set_property( lt, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( lt, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( lt, "text_tag", label_lt )


		if (label_rb == " ") then
			label_rb = unused_string
			vint_set_property( rb, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( rb, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( rb, "text_tag", label_rb )

		if (label_rt == " ") then
			label_rt = unused_string
			vint_set_property( rt, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( rt, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( rt, "text_tag", label_rt )


		handle = vint_object_find( "ls" )
		if (label_ls == " ") then
			label_ls = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property(handle, "text_tag", label_ls )

		handle = vint_object_find( "rs" )
		if (label_rs == " ") then
			label_rs = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_rs )

		handle = vint_object_find( "back" )
		if (label_back == " ") then
			label_back = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_back )

		handle = vint_object_find( "start" )
		if (label_start == " ") then
			label_start = unused_string
			vint_set_property( handle, "tint", unused_tint_r, unused_tint_g, unused_tint_b )
		else
			vint_set_property( handle, "tint", used_tint_r, used_tint_g, used_tint_b )
		end
		vint_set_property( handle, "text_tag", label_start )

	else
		vint_set_property( vint_object_find("controls_controller"), "visible", false )
	end

	local lt_textx, lt_texty = vint_get_property(lt, "screen_size")
	local rt_textx, rt_texty = vint_get_property(rt, "screen_size")
	local lt_x, lt_y = vint_get_property(lt, "anchor")
	local rt_x, rt_y = vint_get_property(rt, "anchor")

	vint_set_property(lt, "anchor", lt_x, LT_LABEL_BASEY)
	vint_set_property(rt, "anchor", rt_x, LT_LABEL_BASEY)	
	
	if (lt_texty > 30) then

   	vint_set_property(lt, "anchor", lt_x, LT_LABEL_BASEY - 24)

	elseif (rt_texty > 30) then

		vint_set_property(rt, "anchor", rt_x, LT_LABEL_BASEY - 24)

	end 

end


-- ##############################################################
function controls_set_images(data_item_handle, event_name)
	local a_img, b_img, x_img, y_img, lb_img, lt_img, rb_img, rt_img, ls_img, rs_img, start_img, back_img = vint_dataitem_get(data_item_handle)

	vint_set_property( vint_object_find("a_image"), "image", a_img )
	vint_set_property( vint_object_find("b_image"), "image", b_img )
	vint_set_property( vint_object_find("x_image"), "image", x_img )
	vint_set_property( vint_object_find("y_image"), "image", y_img )
	vint_set_property( vint_object_find("lb_image"), "image", lb_img )
	vint_set_property( vint_object_find("lt_image"), "image", lt_img )
	vint_set_property( vint_object_find("rb_image"), "image", rb_img )
	vint_set_property( vint_object_find("rt_image"), "image", rt_img )
	vint_set_property( vint_object_find("ls_image"), "image", ls_img )
	vint_set_property( vint_object_find("rs_image"), "image", rs_img )
	vint_set_property( vint_object_find("back_image"), "image", back_img )
	vint_set_property( vint_object_find("start_image"), "image", start_img )
end


-- ##############################################################
function controls_set_hints(data_item_handle, event_name)
	
	local hint_text1,hint_image1 = vint_dataitem_get(data_item_handle)

	local hint_text1_handle = vint_object_find( "hint_text_1" )
	local hint_button1_handle = vint_object_find( "hint_button_1" )
	
	if (hint_text1 ~= nil) then
		vint_set_property( hint_text1_handle,"text_tag", (hint_text1) )
		vint_set_property( hint_button1_handle,"image", hint_image1 )
		vint_set_property( hint_text1_handle,"visible", true )
		vint_set_property( hint_button1_handle,"visible", true )
	else
		vint_set_property( hint_text1_handle,"visible", false )
		vint_set_property( hint_button1_handle,"visible", false )
	end

end

-- ##############################################################
function controls_set_titles(data_item_handle, event_name)
	
	local title1 = vint_dataitem_get(data_item_handle)

	local title1_handle = vint_object_find( "controls_title1" )
	vint_set_property( title1_handle,"text_tag",(title1) )

end

-- #############################################################
function add_row()
	if (Num_rows < 1) then
		vint_set_property( Row_handles[1], "visible", true )
	else
		Row_handles[Num_rows + 1] = vint_object_clone_rename( Row_handles[1], "row_group"..Num_rows + 1 )
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
	local new_y = Row_base_pos_y + ( Highlight_bar_size_y / parent_yscale) * (index - 1)
	
	--RZ replaced: vint_set_property( Row_handles[index], "anchor", Row_base_pos_x, new_y )
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

		--[[ RZ
		-- If we're highlighted then move the highlight bar to our position
		if (highlighted == true) then
			local pos_x, pos_y = vint_get_property( Row_handles[index], "anchor" )
			
			--handle = vint_object_find( "row_highlight_main" )
			vint_set_property( handle, "anchor", pos_x, pos_y )
			vint_set_property( handle, "visible", true )
			--

			--RZ removed since no button any more
			--handle = vint_object_find( "row_highlight_button" )
			--vint_set_property( handle, "visible", selectable )

			handle = vint_object_find( "row_value_1", Row_handles[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)

			handle = vint_object_find( "row_value_2", Row_handles[index]  )
			vint_set_property( handle, "tint", 0.0,0.0,0.0)

			-- Lastly, highlighted rows never have dags
			has_dags = false
		end
		--]]

		-- Does this row have dags?
		handle = vint_object_find( "row_bg_main", Row_handles[index] )
		vint_set_property( handle, "visible", has_dags )
	end
end


