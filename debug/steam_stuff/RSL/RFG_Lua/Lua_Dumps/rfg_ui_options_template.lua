-- handles for each menu item
MAX_ITEMS			= 17
MAX_HINT_ITEMS			= 4
TEXT_OFFSET			= 10
OPTIONS_HINT_PADDING		= 20
OM_num_items			= 0
OM_tween_fadein_bounce_handles 	= {0, 0, 0, 0}
OM_obj_handles			= {MAX_ITEMS = 0}

OM_obj_visible			= {MAX_ITEMS = true}
OM_obj_enabled			= {MAX_ITEMS = true}
OM_hint_group			= {MAX_HINT_ITEMS = 0}
OM_choice			= 0
OM_choice_prev			= 0
--OM_tween_fadein_event_handle 	= 0
--OM_fadein_anchor		= false
--OM_model_handle		= 0
OM_highlight_button_handle	= 0
OM_highlight_button_x		= 0
OM_highlight_button_y		= 0
OM_highlight_button_size_x	= 0
OM_highlight_button_size_y	= 0
OM_text_group_x			= 0
OM_text_group_y			= 0
--OM_tween_on_select_handle	= 0
OM_num_hints_groups		= 0
OM_custom_data_pos_x		= 0
OM_custom_data_pos_y		= 0

-- ##############################################################
function get_handles_controls()

	-- menu_highlight_button - get the button handle, and its information
	OM_highlight_button_handle = vint_object_find( "row_highlight_main" )
	OM_highlight_button_x, OM_highlight_button_y = vint_get_property( OM_highlight_button_handle, "anchor" )
	local sx, sy = vint_get_property(OM_highlight_button_handle, "screen_size")

	-- get the handle for our text group and the text group slide in and slide out anims
	OM_obj_handles[1] = vint_object_find("row_group")
	--OM_obj_anim_fadein_handles[1]		= vint_object_find( "text_group_anim_slidein_norm" )
	--OM_obj_anim_fadeout_handles[1]	= vint_object_find( "text_group_anim_slideout" )
	OM_highlight_button_size_x, OM_highlight_button_size_y = vint_get_property(OM_obj_handles[1], "screen_size")
	
	local scale_x, scale_y = vint_get_property(vint_object_find("options_screen_group"), "scale")
	
	debug_print("always_on", "scale: "..scale_y )
	debug_print("always_on", "size: "..OM_highlight_button_size_y )
		
	--OM_highlight_button_size_y = OM_highlight_button_size_y / scale_y
	
	debug_print("always_on", "size2: "..OM_highlight_button_size_y )
	debug_print("always_on", "sy: "..sy )
	
	--[[if (OM_highlight_button_size_y < (sy / scale_y)) and (OM_highlight_button_size_y < (32 / scale_y) ) then
		--give a little padding to each text item
		if ( (32 / scale_y) < (sy)) then
			OM_highlight_button_size_y = (32 / scale_y)
		else
			OM_highlight_button_size_y = (sy / scale_y)
		end
		debug_print("always_on", "size set:"..OM_highlight_button_size_y )
	end
	]]--
	
	local highlight_y = sy / scale_y
	if (OM_highlight_button_size_y < (highlight_y * 0.9)) then
		OM_highlight_button_size_y = highlight_y * 0.9
		debug_print("always_on", "size set:"..OM_highlight_button_size_y )
	end
	
	--[[
	if ( (OM_highlight_button_size_y < (s scale_y) < 32) then
		OM_highlight_button_size_y = 32
	end
	--]]

	OM_hint_group[1] = vint_object_find("hint_1_group")
	vint_set_property(OM_hint_group[1], "visible", false)
	
	-- get start x, y for the text group
	OM_text_group_x, OM_text_group_y = vint_get_property( OM_obj_handles[1], "anchor" )

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
		OM_tween_fadein_bounce_handles[i] = vint_object_find( "text_group_slidein"..i )
		vint_set_property(OM_tween_fadein_bounce_handles[i], "start_time", start_time )
		vint_set_property(OM_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
		start_time = start_time + duration
	end
	--]]

	vint_set_property( vint_object_find( "highlight_button_move" ), "state", TWEEN_STATE_DISABLED )

	-- get on select handle
	--OM_tween_on_select_handle = vint_object_find("highlight_button_slideout1")

	OM_custom_data_pos_x, OM_custom_data_pos_y = vint_get_property( vint_object_find( "custom_data" ), "anchor" )
	vint_set_property( vint_object_find( "custom_data" ), "visible", false )
end

-- ##############################################################
function rfg_ui_options_template_cleanup()
end

-- ##############################################################
function rfg_ui_options_template_init()
	-- get the handles
	get_handles_controls()

	-- Register for our menu data updates
	vint_dataitem_add_subscription( "TweenOnSelectOM", "update", "OM_play_on_selection_tween" )
	vint_datagroup_add_subscription( "MenuGroupOM", "update", "OM_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroupOM", "insert", "OM_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroupOM", "remove", "OM_group_remove" )
	vint_datagroup_add_subscription( "HintsInfoOM", "update", "OM_hints_group_info" )
	vint_datagroup_add_subscription( "HintsInfoOM", "insert", "OM_hints_group_info" )
	vint_datagroup_add_subscription( "HintsInfoOM", "remove", "OM_hints_group_remove" )
	vint_dataitem_add_subscription( "MenuTitleOM", "update", "OM_update_title" )
	vint_dataitem_add_subscription( "CustomInfo", "update", "CM_update_custom_info" )

	-- guarantee time index is at 0
	vint_set_time_index(0)

end


-- ##############################################################
function OM_group_add()

	-- k, looks like a data item has been added so we need to bump the number of items
	-- that we have
	local prev_num_items = OM_num_items
	OM_num_items = prev_num_items + 1

	if (prev_num_items ~= 0) then
		-- this is not the first item, so we clone the other items

		OM_obj_handles[OM_num_items] = vint_object_clone_rename(OM_obj_handles[1], "row_group"..OM_num_items )
		--OM_obj_anim_fadein_handles[IO_num_items] = vint_object_clone_rename(OM_obj_anim_fadein_handles[1], "text_group_anim_slidein"..IO_num_items )
		--OM_obj_anim_fadeout_handles[IO_num_items] = vint_object_clone_rename(OM_obj_anim_fadeout_handles[1], "text_group_anim_slideout"..IO_num_items )
	end

	-- set visible
	vint_set_property( OM_obj_handles[OM_num_items], "visible", true )

	-- indicate visible and enabled
	OM_obj_visible[OM_num_items] = true
	OM_obj_enabled[OM_num_items] = true

	CM_set_custom_data_pos()
end

-- ##############################################################
function update_item_position_controls(index)

	-- update the position of this item (really is just its y-value)
	local diff = OM_get_item_offset(index)
	local x, y = vint_get_property( OM_obj_handles[1], "anchor" )
	local new_y = OM_text_group_y + OM_highlight_button_size_y * diff
	vint_set_property( OM_obj_handles[index], "anchor", x, new_y )

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
function OM_group_remove(data_item_handle, event_name)

	if (OM_num_items > 0) then
	
		-- k, here we remove an item
		local prev_num_items = OM_num_items
		OM_num_items = prev_num_items - 1

		if (prev_num_items > 1) then
			-- simply get rid of the objects
			vint_object_destroy( OM_obj_handles[prev_num_items] )
			--vint_object_destroy( OM_obj_anim_fadein_handles[prev_num_items] )
			--vint_object_destroy( OM_obj_anim_fadeout_handles[prev_num_items] )

			OM_obj_handles[prev_num_items] = 0
			--OM_obj_anim_fadein_handles[prev_num_items] = 0
			--OMM_obj_anim_fadeout_handles[prev_num_items] = 0
		end

		-- indicate not visible nor enabled
		OM_obj_visible[prev_num_items] = false
		OM_obj_enabled[prev_num_items] = false
	end

	CM_set_custom_data_pos()
	
end

-- ##############################################################
function OM_get_visible_index(actual_index)
	local new_index = 0

	for i = 1, min(OM_num_items, actual_index) do
		if (OM_obj_visible[i] == true) then
			new_index = new_index + 1
		end
	end


	return new_index
end

-- ##############################################################
function OM_update_group_item(data_item_handle, event_name)

	-- k, get the index, its caption, value, and positions for caption and value
	local play_fadein, is_fadein_callback, is_selected, is_visible, is_enabled, index, is_slider, caption, value = vint_dataitem_get(data_item_handle)

	--[[if (play_fadein) then
		-- reset the time index
		vint_set_time_index(0)
		OM_fadein_anchor = true
	end--]]

	-- is this an add?
	if ( event_name == "insert" ) then
		OM_group_add()
	end

	-- update this guy's position
	update_item_position_controls(index)

	if (index >= 1) and ( index <= OM_num_items ) then

		-- set its text tags
		local handle = vint_object_find( "row_name", OM_obj_handles[index] )
		vint_set_property( handle, "text_tag", caption )
		handle = vint_object_find( "row_value_1", OM_obj_handles[index] )
		vint_set_property( handle, "text_tag", value )

		-- should we update the colors?
		local update = false
		if (OM_obj_visible[index] ~= is_visible) then
			update = true
		elseif (OM_obj_enabled[index] ~= is_enabled) then
			update = true
		end

		-- set its visibility, enabled status 
		OM_obj_visible[index] = is_visible
		OM_obj_enabled[index] = is_enabled

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
			OM_trigger_fadein_tween(index, is_fadein_callback, is_selected)
			--]]

		--elseif (OM_fadein_anchor == false) then

			-- flat out set its position
		--	local diff = OM_get_item_offset(index)
		--	local new_y = OM_text_group_y + OM_highlight_button_size_y*diff
		--	vint_set_property( OM_obj_handles[index], "anchor", OM_text_group_x, new_y )
		end

		if ( is_selected == true ) then
			
			-- set the index, but first set last choice
			OM_set_choice(index)

			-- make sure we update color
			update = true

			vint_set_property(handle, "tint", 0.0, 0.0 , 0.0)

		else

			vint_set_property(handle, "tint", 1.0, 0.57 , 0.03)

		end

		-- set visibility
		vint_set_property( OM_obj_handles[index], "visible", OM_obj_visible[index] )

		-- should it have diags?

		if ( (vint_mod(OM_get_visible_index(index),  2) == 1) and (is_selected == false) ) then
			vint_set_property( vint_object_find( "row_bg_main", OM_obj_handles[index] ), "visible", true ) 
		else 
			vint_set_property( vint_object_find( "row_bg_main", OM_obj_handles[index] ), "visible", false )
		end

		-- set enabled state
		if ( is_enabled ~= true ) then
			vint_set_property( OM_obj_handles[index], "alpha", 0.33 )
		elseif (is_selected) then
			vint_set_property( OM_obj_handles[index], "alpha", 1.0 )
		else
			vint_set_property( OM_obj_handles[index], "alpha", 0.67 )
		end
	
	else 
		debug_print("vint", "\nOPTION MENU WTH HAPPENED!?!?!?!?" )
	end

end


-- ##############################################################
function OM_play_on_selection_tween(data_item_handle, event_name)

	-- the user has actually chosen something, so we do a special tween, and when it is done,
	-- we callback to the game, letting it know to continue with the gamestate change
	local selection = vint_dataitem_get(data_item_handle)
	
	if ( selection ~= 0 ) then
		--[[
		-- get current time
		local time_index = vint_get_time_index()

		-- ok, time to play the fadeout anims!
		local i
		for i = 1, OM_num_items do

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
		
		OM_tween_on_select_end()
	else
		
		--vint_set_property( MM_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )
	end


	
end

-- ##############################################################
function OM_tween_on_select_end(tween_h, event_name)

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
function OM_fade_in_end(target_handle, event_name)
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
function OM_hints_group_info(data_item_handle, event_name)
	
	local index, text, image_name = vint_dataitem_get(data_item_handle)
	
	if (event_name == "insert") then
		-- cloning time!
		OM_num_hints_groups = OM_num_hints_groups + 1
		
		if (OM_num_hints_groups > 1) then
			OM_hint_group[OM_num_hints_groups] = vint_object_clone_rename(OM_hint_group[1], "hint_1_group"..index )
		end
	end


	local group_h = OM_hint_group[index]
	vint_set_property(group_h, "visible", true)
	
	local text_h = vint_object_find("hints_text_1", group_h)
	local image_h = vint_object_find("hint_button_1", group_h)

	local parent_scalex,parent_scaley = vint_get_property( vint_object_find("options_screen_group"), "scale" )
	
	vint_set_property( text_h, "text_tag", text )
	vint_set_property( image_h, "image", image_name )
	
	-- update position
	for i = 2, index do
		local width, height = vint_get_property( OM_hint_group[i-1], "screen_size" )
		local anchor_x, anchor_y = vint_get_property( OM_hint_group[i-1], "anchor" )
		local new_x = anchor_x + (width/parent_scalex) + OPTIONS_HINT_PADDING
		vint_set_property(OM_hint_group[i], "anchor", new_x, anchor_y)
	end
end

-- ##############################################################
function OM_hints_group_remove(data_item_handle, event_name)

	if (OM_num_hints_groups > 0) then
		-- k, here we destroy the item (if num hint_1_group is greater than 1)
		local new_num_items = OM_num_hints_groups - 1

		if (OM_num_hints_groups > 1) then
			vint_object_destroy( OM_hint_group[OM_num_hints_groups] )	
			OM_hint_group[OM_num_hints_groups] = 0
		else
			vint_set_property( OM_hint_group[OM_num_hints_groups], "visible", false )
		end

		OM_num_hints_groups = new_num_items
	end
end


-- ##############################################################
function OM_trigger_fadein_tween(index, is_fadein_callback, is_selected)
--[[
	local handle

	-- get our new y value for the text!
	local diff = OM_get_item_offset(index)
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
		--local new_highlight_y = OM_highlight_button_y + MM_highlight_button_size_y * diff

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
function OM_set_choice(index)

	OM_choice_prev = OM_choice
	OM_choice = index


	--if (OM_fadein_anchor == false) then

		-- this occurs when the user has moved down or up on the menu
		local OM_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		local oldx, oldy = vint_get_property( OM_tween_highlight_button_handle, "end_value" )
		local diff1 = OM_get_item_offset(OM_choice_prev)
		local diff2 = OM_get_item_offset(OM_choice)
		local new_starty	= OM_highlight_button_y + OM_highlight_button_size_y * diff1
		local new_endy		= OM_highlight_button_y + OM_highlight_button_size_y * diff2

		vint_set_property( OM_tween_highlight_button_handle, "duration", 0.125 )
		vint_set_property( OM_tween_highlight_button_handle, "start_time", vint_get_time_index() )
		vint_set_property( OM_tween_highlight_button_handle, "start_value", oldx, new_starty)
		vint_set_property( OM_tween_highlight_button_handle, "end_value", oldx, new_endy)
		vint_set_property( OM_tween_highlight_button_handle, "state", TWEEN_STATE_RUNNING )

	--else
	--	local mm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
	--	vint_set_property( mm_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )
	--end

	--debug_print( "vint", "Set Choice\n" )
end


-- ##############################################################
function OM_get_item_offset(index)

	local i
	local num_visible_before = 0
	for i = 1, index-1 do
		
		if (OM_obj_visible[i] == true) then
			num_visible_before = num_visible_before + 1
		end
	end

	return num_visible_before
end

-- ##############################################################
function OM_update_title(data_item_handle, event_name)

	-- k, get the title text and multiplayer flag!
	local multiplayer, title_text = vint_dataitem_get(data_item_handle)

	vint_set_property( vint_object_find( "title_text" ), "text_tag", title_text )

end

-- ##############################################################
function OM_set_hints_group(data_item_handle, event_name)
	
	local hint_text1,hint_image1 = vint_dataitem_get(data_item_handle)

	local hint_text1_handle = vint_object_find( "hints_text_1" )
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

	local title1_handle = vint_object_find( "title_text" )
	vint_set_property( title1_handle,"text_tag",(title1) )

end

-- ##############################################################
function CM_update_custom_info(data_item_handle, event_name)
	local visible, image_name, display_text = vint_dataitem_get(data_item_handle)

	local custom_group_handle = vint_object_find( "custom_data" )
	local custom_image_handle = vint_object_find( "custom_bitmap_1" )
	local custom_text_handle  = vint_object_find( "custom_text_1" )

	vint_set_property( custom_group_handle, "visible", true )
	if (visible == true) then
		-- handle the image
		if (image_name ~= "") then
			vint_set_property( custom_image_handle, "visible", true )
			vint_set_property( custom_image_handle, "image", image_name )
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(custom_image_handle)
			vint_set_property(custom_image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		else
			vint_set_property( custom_image_handle, "visible", false )
		end

		-- now set the text
		vint_set_property( custom_text_handle, "text_tag", display_text )

		-- K, now everything is set, so go ahead and position it correctly below the last menu item
		CM_set_custom_data_pos()
	end
end

function CM_set_custom_data_pos()
		local custom_group_handle = vint_object_find( "custom_data" )

		local parent_scale_x, parent_scale_y = vint_get_property( vint_object_find( "options_screen_group" ), "scale" )

		-- next, we need to get the anchor of the last menu item
		local diff = OM_get_item_offset(OM_num_items)
		local x, y = vint_get_property( OM_obj_handles[1], "anchor" )
		local new_anchor_y = OM_text_group_y + OM_highlight_button_size_y * (diff + 1)

		-- now add in the height of the image
		local sizex, sizey = vint_get_property( vint_object_find("custom_bitmap_1"), "screen_size" )		
		local new_anchor_y = new_anchor_y + (sizey / parent_scale_y )
		vint_set_property( custom_group_handle, "anchor", OM_custom_data_pos_x, new_anchor_y )
end
		
		





