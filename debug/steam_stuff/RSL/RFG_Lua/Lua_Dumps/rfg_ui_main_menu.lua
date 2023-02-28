
-- handles for each menu item
MAX_ITEMS					= 17
MAX_HINT_ITEMS					= 4
TEXT_OFFSET					= 10
MM_HIGHLIGHT_PADDING				= 23
MM_num_items					= 0
MM_tween_fadein_bounce_handles			= {0, 0, 0, 0}
MM_obj_handles					= {MAX_ITEMS = 0}
MM_obj_anim_fadein_handles			= {MAX_ITEMS = 0}
MM_obj_anim_fadeout_handles			= {MAX_ITEMS = 0}
MM_obj_visible					= {MAX_ITEMS = true}
MM_obj_enabled					= {MAX_ITEMS = true}
MM_hint_group					= {MAX_HINT_ITEMS = 0}
MM_choice					= 0
MM_choice_prev					= 0
MM_tween_fadein_event_handle = 0
MM_fadein_anchor				= false
MM_model_handle					= 0
MM_highlight_button_handle			= 0
MM_highlight_button_x				= 0
MM_highlight_button_y				= 0
MM_highlight_button_size_x			= 0
MM_highlight_button_size_y			= 0
MM_text_group_x					= 0
MM_text_group_y					= 0
MM_tween_on_select_handle			= 0
MM_num_hints					= 0
MM_max_text_width				= 0
MM_showing = false

--RZ
MM_scale_x = 1.0
MM_scale_y = 1.0

--my_array = { [0] = 1, [1] = 2, [2] = 3 }
-- subscribe to a data group instead
-- subscribe to an insert/add/remove

--function mm01_insert_data_item(data_item_h)
--	MM_obj_handles[MM_obj_handles.num_items] = data_item_h
--	MM_obj_handles.num_items = MM_obj_handles.num_items + 1
--end
	-- MM_obj_handles[i] = vint_object_find(""..i)

-- ##############################################################
function get_handles()

	-- text_group (text_clone, text_value_clone)
	-- hints_group (back_bmp, back_text, select_bmp, select_text)
	-- anim_selection (selection_tween)
	-- highlight_button_anim_slidein (highlight_button_slidein1-4)
	-- highlight_button_anim_slideout (highlight_button_slideout1)
	-- text_group_anim_slidein (text_group_slidein1-4)
	-- text_group_anim_slideout (text_group_slideout1)
	local h = vint_object_find( "text_group_anim_slidein_norm" )
	vint_set_property( h, "start_time", 0 )

	-- menu_highlight_button - get the button handle, and its information
	MM_highlight_button_handle			= vint_object_find( "menu_highlight_button" )
	MM_highlight_button_x, MM_highlight_button_y = vint_get_property(MM_highlight_button_handle, "anchor" )
	local sx, sy = vint_get_property(MM_highlight_button_handle, "screen_size")

	-- get the handle for our text group and the text group slide in and slide out anims
	MM_obj_handles[1]						= vint_object_find("text_group")
	MM_obj_anim_fadein_handles[1]		= vint_object_find( "text_group_anim_slidein_norm" )
	MM_obj_anim_fadeout_handles[1]	= vint_object_find( "text_group_anim_slideout" )
	MM_highlight_button_size_x, MM_highlight_button_size_y = vint_get_property(MM_obj_handles[1], "screen_size")
	
	--RZ: get the scale for the main screen
	MM_scale_x, MM_scale_y = vint_get_property( vint_object_find( "scale_group" ), "scale" )
	
	debug_print("always_on", "scale: "..MM_scale_y.."\n" )
	debug_print("always_on", "size: "..MM_highlight_button_size_y.."\n" )
	
	MM_highlight_button_size_y = MM_highlight_button_size_y / MM_scale_y
	debug_print("always_on", "size2: "..MM_highlight_button_size_y.."\n" )
	debug_print("always_on", "sy: "..sy.."\n" )
	

	if (MM_highlight_button_size_y < ((sy * 0.8) / MM_scale_y)) and (MM_highlight_button_size_y < (40 / MM_scale_y) ) then
		--give a little padding to each text item
		if ( (40 / MM_scale_y) < (sy / MM_scale_y)) then
			MM_highlight_button_size_y = (40 / MM_scale_y)
		else
			MM_highlight_button_size_y = (sy * 0.8) / MM_scale_y
		end
		debug_print("always_on", "size set:"..MM_highlight_button_size_y.."\n" )
	end
	
	--[[ taken out for pc build
	if (MM_highlight_button_size_y < 40) then
		debug_print("always_on", "size set".."\n")
		MM_highlight_button_size_y = 40
	end

	]]--
	
	-- MW: Hack to move menu selections closer together
	MM_highlight_button_size_y = MM_highlight_button_size_y - 5

	MM_hint_group[1] = vint_object_find("hints")
	vint_set_property(MM_hint_group[1], "visible", false)
	
	-- get start x, y for the text group
	MM_text_group_x, MM_text_group_y = vint_get_property( MM_obj_handles[1], "anchor" )

	-- get the model handle

	-- MLG: The model is not on the menu with the PC
	--MM_model_handle = vint_object_find( "model" )

	-- disable the slide in and slide out tweens
	local i
	vint_set_property( vint_object_find("text_group_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("highlight_button_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("text_group_slidein_norm1"), "state", TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find("controller_select_fade_in") , TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find("controller_select_fade_out") , TWEEN_STATE_DISABLED )
	local start_time = 0
	for i = 1, 4 do
		-- disable highlight button slideins
		local highlight_slide_h = vint_object_find("highlight_button_slidein"..i)
		vint_set_property( highlight_slide_h, "state", TWEEN_STATE_DISABLED )
		local duration = vint_get_property( highlight_slide_h, "duration" )
		vint_set_property( highlight_slide_h, "start_time", start_time)

		-- also get the fadein bounce handles for the selected text object and disable them
		MM_tween_fadein_bounce_handles[i] = vint_object_find( "text_group_slidein"..i )
		vint_set_property(MM_tween_fadein_bounce_handles[i], "start_time", start_time )
		vint_set_property(MM_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
		start_time = start_time + duration
	end
	vint_set_property( vint_object_find( "highlight_button_move" ), "state", TWEEN_STATE_DISABLED )

	-- hide the text group
	vint_set_property( MM_obj_handles[1], "visible", false )

	vint_set_property( vint_object_find( "hints_group" ), "visible", false )

	-- MLG: The model is not on the menu with the PC
	-- show the model
	--vint_set_property( MM_model_handle, "visible", true )

	-- get on select handle
	MM_tween_on_select_handle = vint_object_find("highlight_button_slideout1")

	vint_set_property(vint_object_find("rfg_mobile_group"), "visible", false )

end

-- ##############################################################
function rfg_ui_main_menu_cleanup()
end

-- ##############################################################
function rfg_ui_main_menu_init()

	-- get the handles
	get_handles()
	
	-- MM_tween_started = {}

	vint_dataitem_add_subscription( "TweenOnSelect", "update", "mm_play_on_selection_tween" )
	vint_datagroup_add_subscription( "MenuGroup", "update", "mm_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup", "insert", "mm_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup", "remove", "mm_group_remove" )
	vint_datagroup_add_subscription( "HintsInfo", "update", "mm_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo", "insert", "mm_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo", "remove", "mm_hints_remove" )
	vint_dataitem_add_subscription( "MenuTitle", "update", "mm_update_title" )
	vint_dataitem_add_subscription( "MenuRFGMobile", "update", "mm_rfg_mobile" )
	vint_dataitem_add_subscription( "MainMenuControllerSelect", "update", "mm_controller_select" )
	
	MM_showing = false

	-- guarantee time index is at 0
	vint_set_time_index(0)
end

-- ##############################################################
function mm_group_add()

	-- k, looks like a data item has been added so we need to bump the number of items
	-- that we have
	local prev_num_items = MM_num_items
	MM_num_items = prev_num_items + 1

	if (prev_num_items ~= 0) then
		-- this is not the first item, so we clone the other items
		MM_obj_handles[MM_num_items]					= vint_object_clone_rename(MM_obj_handles[1], "text_group"..MM_num_items )
		MM_obj_anim_fadein_handles[MM_num_items]		= vint_object_clone_rename(MM_obj_anim_fadein_handles[1], "text_group_anim_slidein"..MM_num_items )
		MM_obj_anim_fadeout_handles[MM_num_items]		= vint_object_clone_rename(MM_obj_anim_fadeout_handles[1], "text_group_anim_slideout"..MM_num_items )
	end

	-- set visible
	vint_set_property( MM_obj_handles[MM_num_items], "visible", true )

	-- indicate visible and enabled
	MM_obj_visible[MM_num_items] = true
	MM_obj_enabled[MM_num_items] = true

end

-- ##############################################################
function update_item_position(index)

	-- update the position of this item (really is just its y-value)
	local diff = get_item_offset(index)
	local x, y = vint_get_property( MM_obj_handles[1], "anchor" )
	local new_y = MM_text_group_y + MM_highlight_button_size_y * diff
	vint_set_property( MM_obj_handles[index], "anchor", x, new_y )

	-- set new start time for the animation of fading in
	local new_start = 0.05 * diff
	vint_set_property( MM_obj_anim_fadein_handles[index], "start_time", new_start )

	-- update the targets for the tweens, and their start/end values
	local handle, tmpx, tmpy

	-- get handle of the fadeout tween, then set its target handle and its state
	handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[index] )
	vint_set_property( handle, "target_handle", MM_obj_handles[index] )

	-- MLG: I don't see any reason we need this and it was causing the menus to sometimes not finish sliding.
	-- If this caused problems we can uncomment it
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadeout
	tmpx, tmpy = vint_get_property( handle, "start_value" )
	vint_set_property( handle, "start_value", tmpx, new_y )
	
	tmpx, tmpy = vint_get_property( handle, "end_value" )
	vint_set_property( handle, "end_value", tmpx, new_y )

	-- get handle of the fadein tween, then set its target handle and its state
	handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
	vint_set_property( handle, "target_handle", MM_obj_handles[index] )

	-- MLG: I don't see any reason we need this and it was causing the menus to sometimes not finish sliding.
	-- If this caused problems we can uncomment it
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadein
	tmpx, tmpy = vint_get_property( handle, "start_value" )
	vint_set_property( handle, "start_value", tmpx, new_y )

	tmpx, tmpy = vint_get_property( handle, "end_value" )
	vint_set_property( handle, "end_value", tmpx, new_y )
end

-- ##############################################################
function mm_group_remove(data_item_handle, event_name)

	if (MM_num_items > 0) then
	
		-- k, here we remove an item
		local prev_num_items = MM_num_items
		MM_num_items = prev_num_items - 1

		if (prev_num_items > 1) then
			-- simply get rid of the objects
			vint_object_destroy( MM_obj_handles[prev_num_items] )
			vint_object_destroy( MM_obj_anim_fadein_handles[prev_num_items] )
			vint_object_destroy( MM_obj_anim_fadeout_handles[prev_num_items] )

			MM_obj_handles[prev_num_items] = 0
			MM_obj_anim_fadein_handles[prev_num_items] = 0
			MM_obj_anim_fadeout_handles[prev_num_items] = 0
		end

		-- indicate not visible nor enabled
		MM_obj_visible[prev_num_items] = false
		MM_obj_enabled[prev_num_items] = false
	end
end

-- ##############################################################
function mm_update_group_item(data_item_handle, event_name)

	-- k, get the index, its caption, value, and positions for caption and value
	local play_fadein, is_fadein_callback, is_selected, is_visible, is_enabled, index, is_slider, caption, value = vint_dataitem_get(data_item_handle)
 
	if (play_fadein) then
		-- MW: Hacky bullshit: because of the vint_set_time_index(0) below, this animation can get fucked
		-- completely and end up in some broken, messy freeze state. To avoid this, we need to adjust the
		-- start_time once more...
		local start_time = vint_get_property(vint_object_find("controller_select_fade_out"), "start_time")
		local time_index = vint_get_time_index()
		vint_set_property( vint_object_find("controller_select_fade_out"), "start_time", start_time - time_index )
		
		-- reset the time index
		vint_set_time_index(0)
		MM_fadein_anchor = true
	end

	-- is this an add?
	if ( event_name == "insert" ) then
		mm_group_add()
	end

	-- update this guy's position
	update_item_position(index)

	if (index >= 1) and ( index <= MM_num_items ) then

		-- set its text tags
		local handle = vint_object_find( "text_clone", MM_obj_handles[index] )
		vint_set_property( handle, "text_tag", caption )

		--resize text if needed
		mm_resize_text(handle)
		
		--resize the highlight
		mm_resize_highlight()
		
		--check if value is present
		--if so, hide the "2nd" model, so it is not on top
		if ( index == 1 ) then
			if (value ~= nil) and (value ~= "") then
				-- MLG: The model is not on the menu with the PC
				--vint_set_property( MM_model_handle, "visible", false )
			else
				-- MLG: The model is not on the menu with the PC
				--vint_set_property( MM_model_handle, "visible", true )
			end
		end

		-- set its visibility, enabled status 
		MM_obj_visible[index] = is_visible
		MM_obj_enabled[index] = is_enabled

		if (play_fadein == true) then

			-- reset time index
			--vint_set_time_index(0)

			--[[if ( is_fadein_callback == true ) then
				MM_tween_fadein_event_handle = vint_object_find( "text_group_slidein4" )
				vint_set_property( MM_tween_fadein_event_handle, "end_event", "mm_fade_in_end" )
			end--]]

			-- trigger this guy's fadein tween
			trigger_fadein_tween(index, is_fadein_callback, is_selected)

		elseif (MM_fadein_anchor == false) then

			-- flat out set its position
			local diff = get_item_offset(index)
			local new_y = MM_text_group_y + MM_highlight_button_size_y*diff
			vint_set_property( MM_obj_handles[index], "anchor", MM_text_group_x, new_y )
		end

		if ( is_selected == true ) then
			
			-- set the index, but first set last choice
			set_choice(index)
		end


		-- set visibility
		vint_set_property( MM_obj_handles[index], "visible", MM_obj_visible[index] )

		-- set enabled state
		if ( is_enabled ~= true ) then
			vint_set_property( MM_obj_handles[index], "alpha", 0.10 )
			vint_set_property( MM_obj_handles[index], "tint", 1.0, 0.576471, 0.0313726 )
		elseif (is_selected) then
			vint_set_property( MM_obj_handles[index], "alpha", 1.0 )
			vint_set_property( MM_obj_handles[index], "tint", 1.0, 1.0, 1.0 )
		else
			vint_set_property( MM_obj_handles[index], "alpha", 0.33 )
			vint_set_property( MM_obj_handles[index], "tint", 1.0, 0.576471, 0.0313726 )
		end
	
	else 
		debug_print("vint", "\nMAINMENU WTH HAPPENED!?!?!?!?".."\n" )
	end

end

-- ##############################################################
function mm_play_on_selection_tween(data_item_handle, event_name)

	-- the user has actually chosen something, so we do a special tween, and when it is done,
	-- we callback to the game, letting it know to continue with the gamestate change
	local selection = vint_dataitem_get(data_item_handle)
	
	if ( selection ~= 0 ) then

		-- get current time
		local time_index = vint_get_time_index()

		-- ok, time to play the fadeout anims!
		local i
		for i = 1, MM_num_items do

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
		local x, y = vint_get_property( MM_highlight_button_handle, "anchor" )
		MM_tween_on_select_handle = vint_object_find("highlight_button_slideout1")
		vint_set_property( vint_object_find("highlight_button_anim_slideout"), "start_time", 0 )
		vint_set_property( MM_tween_on_select_handle, "start_time", time_index )
		vint_set_property( MM_tween_on_select_handle, "state", TWEEN_STATE_RUNNING )
		vint_set_property( MM_tween_on_select_handle, "end_event", "mm_tween_on_select_end")
		vint_set_property( MM_tween_on_select_handle, "start_value", x, y )

		local endx, endy = vint_get_property( MM_tween_on_select_handle, "end_value" )
		vint_set_property( MM_tween_on_select_handle, "end_value", endx, y )
	else

		vint_set_property( MM_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )
	end

end

-- ##############################################################
function mm_tween_on_select_end(tween_h, event_name)

	-- remove this callback
	remove_tween_end_callback(MM_tween_on_select_handle)

	-- disable the fadeout tweens for each item
	local i
	for i = 1, MM_num_items do
		local tween_handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[i] )
		vint_set_property( tween_handle, "state", TWEEN_STATE_DISABLED )
	end

	-- disable our tween
	vint_set_property(MM_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )

	-- callback into the game and let it know we are done
	menu_tween_on_select_end()
end

-- ##############################################################
function mm_fade_in_end(target_handle, event_name)

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
end

-- ##############################################################
function mm_hints_info(data_item_handle, event_name)
	
	local index, text, image_name = vint_dataitem_get(data_item_handle)
	local hints_group = vint_object_find( "hints_group" )
	
	if (event_name == "insert") then
		-- cloning time!
		MM_num_hints = MM_num_hints + 1
		
		if (MM_num_hints > 1) then
			MM_hint_group[MM_num_hints] = vint_object_clone_rename(MM_hint_group[1], "hints"..index )
			vint_set_property( MM_hint_group[MM_num_hints], "alpha", 0.45 )
			vint_set_property( MM_hint_group[MM_num_hints], "tint", 1.0, 0.5, 0.0 )
		else
			vint_set_property( hints_group, "visible", true )
			vint_set_property( MM_hint_group[1], "alpha", 0.45 )
			vint_set_property( MM_hint_group[1], "tint", 1.0, 0.5, 0.0 )
		end
	end

	local group_h = MM_hint_group[index]
	vint_set_property(group_h, "visible", true)
	
	local text_h = vint_object_find("hint_text", group_h)
	local image_h = vint_object_find("hint_bmp", group_h)
	
	vint_set_property( text_h, "text_tag", text )
	vint_set_property( image_h, "image", image_name )
	
	-- update position
	local parent_scale_x, parent_scale_y = vint_get_property( vint_object_find("item_group"), "scale" )

	for i = 2, index do
		local screen_size_x, screen_size_y = vint_get_property( MM_hint_group[i-1], "screen_size" )
		local anchor_x, anchor_y = vint_get_property( MM_hint_group[i-1], "anchor" )

		vint_set_property(MM_hint_group[i], "anchor", anchor_x + (screen_size_x / parent_scale_x) + 7, anchor_y)
	end
end

-- ##############################################################
function	mm_hints_remove(data_item_handle, event_name)

	if (MM_num_hints > 0) then
		-- k, here we destroy the item (if num hints is greater than 1)
		local new_num_items = MM_num_hints - 1

		if (MM_num_hints > 1) then
			vint_object_destroy( MM_hint_group[MM_num_hints] )	
			MM_hint_group[MM_num_hints] = 0
		else
			vint_set_property( MM_hint_group[MM_num_hints], "visible", false )
			vint_set_property( vint_object_find( "hints_group" ), "visible", false )
		end

		MM_num_hints = new_num_items
	end
end

-- ##############################################################
function trigger_fadein_tween(index, is_fadein_callback, is_selected)

	local handle

	-- get our new y value for the text!
	local diff = get_item_offset(index)
	local new_y = MM_text_group_y + MM_highlight_button_size_y * diff

	-- we need to set our anchor to the fadein start value!
	local x, y = vint_get_property( vint_object_find("text_group_slidein1"), "start_value" )
	vint_set_property( MM_obj_handles[index], "anchor", x, new_y )

	-- get handle of the fadeout tween, and disable it!
	handle = vint_object_find( "text_group_slideout1", MM_obj_anim_fadeout_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- enable our normal slidein tween
	handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_RUNNING )

	-- and guarantee its y values are ok
	x, y = vint_get_property(handle, "start_value")
	vint_set_property( handle, "start_value", x, new_y)
	x, y = vint_get_property(handle, "end_value")
	vint_set_property( handle, "end_value", x, new_y)

	-- ok, if we are selected, then we "bounce" in - so we have to ...
	if ( is_selected == true ) then
		-- get where the new highlight y should be placed
		local new_highlight_y = MM_highlight_button_y + MM_highlight_button_size_y * diff

		handle = vint_object_find( "text_group_slidein_norm1", MM_obj_anim_fadein_handles[index] )
		x, y = vint_get_property( handle, "start_value" )
		vint_set_property ( vint_object_find( "menu_highlight_button" ), "anchor", x, new_highlight_y )

		-- now we re-target the slidein bounce tweens to target us, and reposition the slidein highlight tween
		local start_time = vint_get_property( MM_obj_anim_fadein_handles[index], "start_time" )		

		local i
		for i = 1, 4 do

			-- retarget the highlight button to slide in with our y value!
			handle = vint_object_find( "highlight_button_slidein"..i )
			x, y = vint_get_property( handle, "start_value" )
			vint_set_property( handle, "start_value", x, new_highlight_y )
			x, y = vint_get_property( handle, "end_value" )
			vint_set_property( handle, "end_value", x, new_highlight_y )

			local duration = vint_get_property( handle, "duration" )
			vint_set_property( handle, "start_time", start_time )

			-- and set them to running
			vint_set_property( handle, "state", TWEEN_STATE_IDLE )
			
			debug_print("vint", "start_time:"..start_time.."\n" )
			start_time = start_time + duration
		end
	end

	if (is_fadein_callback == true) then
		vint_set_property( handle, "end_event", "mm_fade_in_end" )
	end
end

-- #############################################################d#
function set_choice(index)

	MM_choice_prev = MM_choice
	MM_choice = index

	if (MM_fadein_anchor == false) then

		-- this occurs when the user has moved down or up on the menu
		local mm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		local oldx, oldy = vint_get_property( mm_tween_highlight_button_handle, "end_value" )
		local diff1 = get_item_offset(MM_choice_prev)
		local diff2 = get_item_offset(MM_choice)
		local new_starty	= MM_highlight_button_y + MM_highlight_button_size_y * diff1
		local new_endy		= MM_highlight_button_y + MM_highlight_button_size_y * diff2

		vint_set_property( mm_tween_highlight_button_handle, "duration", 0.125 )
		vint_set_property( mm_tween_highlight_button_handle, "start_time", vint_get_time_index() )
		vint_set_property( mm_tween_highlight_button_handle, "start_value", oldx, new_starty)
		vint_set_property( mm_tween_highlight_button_handle, "end_value", oldx, new_endy)
		vint_set_property( mm_tween_highlight_button_handle, "state", TWEEN_STATE_RUNNING )
	else
		local mm_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		vint_set_property( mm_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )
	end

end

-- ##############################################################
function get_item_offset(index)

	local i
	local num_visible_before = 0
	for i = 1, index-1 do
		
		if (MM_obj_visible[i] == true) then
			num_visible_before = num_visible_before + 1
		end
	end

	return num_visible_before
end

-- ##############################################################
function mm_update_title(data_item_handle, event_name)

	-- k, get the title text and multiplayer flag!
	local multiplayer, title_text = vint_dataitem_get(data_item_handle)

end

-- ##############################################################
function mm_resize_highlight()

	local max_width = get_text_width()
	local head_handle = vint_object_find( "menu_frame" )
	local tail_handle = vint_object_find( "menu_frame2" )
	local bar_handle = vint_object_find( "bar_fill_group" )
	local parent_handle = vint_object_find( "scale_group" )
	
	local parent_xscale,parent_yscale = vint_get_property( parent_handle,"scale" )

	local head_x,head_y = vint_get_property( head_handle, "anchor" )
	local head_width,head_height = vint_get_property( head_handle, "screen_size" )

	local tail_x,tail_y = vint_get_property( tail_handle, "anchor" )
	local tail_width,tail_height = vint_get_property( tail_handle, "screen_size" )

	local bar_x,bar_y = vint_get_property( bar_handle, "anchor" )
	local bar_width,bar_height = vint_get_property( bar_handle, "screen_size" )

	local new_tail_x = head_x + max_width/parent_xscale - head_width/parent_xscale + MM_HIGHLIGHT_PADDING*2
	
	if( new_tail_x < 0 )then
		new_tail_x = 0
	end
	
	local new_bar_x = new_tail_x + tail_width/parent_xscale
	
	vint_set_property( tail_handle,"anchor",new_tail_x,tail_y )
	vint_set_property( bar_handle,"anchor",new_bar_x,bar_y )

end

-- ##############################################################
function mm_resize_text(handle)

	vint_set_property(handle, "text_scale", 1, 1)
	local text_width, text_height = vint_get_property(handle, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("item_group"),"scale")
	local MAX_TEXT_WIDTH_1 = 550 * parent_scale_x
	local MAX_TEXT_WIDTH_2 = 600 * parent_scale_x

	if(text_width > MAX_TEXT_WIDTH_1) then

		vint_set_property(handle, "text_scale", 0.85, 1.0)

		if(text_width > MAX_TEXT_WIDTH_2) then
			vint_set_property(handle, "text_scale", 0.75, 1.0) -- CHANGE THE FIRST SCALE NUMBER HERE IF THERE'S TEXT THAT'S TOO WIDE IN OTHER LANGUAGES - JHG
		end

	end
	
end

-- ##############################################################
function mm_rfg_mobile(data_item_handle, event_name)
	local is_visible,image = vint_dataitem_get(data_item_handle)
	
	if(is_visible == true)then
		vint_set_property(vint_object_find("rfg_mobile_group"), "visible", true )
		vint_set_property(vint_object_find("player_model"), "visible", false )
		vint_set_property(vint_object_find("title_group"), "visible", false )
		vint_set_property(vint_object_find("text_group"), "visible", false )
		vint_set_property(vint_object_find("menu_highlight_button"), "visible", false )
		vint_set_property(vint_object_find("rfg_mobile"), "image", image )
	else
		vint_set_property(vint_object_find("player_model"), "visible", true )
		vint_set_property(vint_object_find("title_group"), "visible", true )
		vint_set_property(vint_object_find("text_group"), "visible", true )
		vint_set_property(vint_object_find("menu_highlight_button"), "visible", true )
		vint_set_property(vint_object_find("rfg_mobile_group"), "visible", false )
	end
end

-- ##############################################################
function mm_controller_select(data_item_handle, event_name)
	local show, text = vint_dataitem_get(data_item_handle)
	
	if MM_showing == false and show == true then
		vint_set_property( vint_object_find("controller_select_group"), "visible", true )
		vint_set_property( vint_object_find( "cs_title_alpha_tween_out" ), "end_event", nil )
		
		vint_set_property( vint_object_find("controller_select_fade_in"), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find("controller_select_fade_in") , TWEEN_STATE_RUNNING )
		vint_set_child_tween_state( vint_object_find("controller_select_fade_out") , TWEEN_STATE_DISABLED )
	elseif MM_showing == true and show == false then		
		vint_set_property( vint_object_find( "cs_title_alpha_tween_out" ), "end_event", "mm_cs_fade_out_done" )
		
		vint_set_child_tween_state( vint_object_find("controller_select_fade_in") , TWEEN_STATE_DISABLED )
		vint_set_property( vint_object_find("controller_select_fade_out"), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find("controller_select_fade_out") , TWEEN_STATE_RUNNING )
	end
	
	vint_set_property( vint_object_find("select_controller_text"), "text_tag", text )
	
	MM_showing = show
end

function mm_cs_fade_out_done()
	vint_set_property( vint_object_find( "cs_title_alpha_tween_out" ), "end_event", nil )
	
	vint_set_child_tween_state( vint_object_find("controller_select_fade_out") , TWEEN_STATE_DISABLED )
	vint_set_property(vint_object_find("controller_select_group"), "visible", false )
end

-- ##############################################################
function get_text_width()
	local max_text_width = 0
	for i = 1,MM_num_items do
		local handle = vint_object_find( "text_clone", MM_obj_handles[i] )
		local text_width,text_height = vint_get_property( handle, "screen_size" )
		if(text_width > max_text_width)then
			max_text_width = text_width
		end
	end
	return max_text_width
end
