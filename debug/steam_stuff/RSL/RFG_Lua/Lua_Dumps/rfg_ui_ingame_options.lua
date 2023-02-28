
-- handles for each menu item
MAX_ITEMS					= 17
MAX_HINT_ITEMS					= 4
TEXT_OFFSET					= 10
BUTTON_Y_FUDGE						= 5
IO_HIGHLIGHT_PADDING				= 23
IO_num_items					= 0
IO_tween_fadein_bounce_handles			= {0, 0, 0, 0}
IO_obj_handles					= {MAX_ITEMS = 0}
IO_obj_anim_fadein_handles			= {MAX_ITEMS = 0}
IO_obj_anim_fadeout_handles			= {MAX_ITEMS = 0}
IO_obj_visible					= {MAX_ITEMS = true}
IO_obj_enabled					= {MAX_ITEMS = true}
IO_hint_group					= {MAX_HINT_ITEMS = 0}
IO_choice					= 0
IO_choice_prev					= 0
IO_tween_fadein_event_handle			= 0
IO_fadein_anchor				= false
IO_model_handle					= 0
IO_highlight_button_handle			= 0
IO_highlight_button_x				= 0
IO_highlight_button_y				= 0
IO_highlight_button_size_x			= 0
IO_highlight_button_size_y			= 0
IO_text_group_x					= 0
IO_text_group_y					= 0
IO_tween_on_select_handle			= 0
IO_can_set_title				= true
IO_num_hints					= 0

FADE_IN_START_TIME = 0.67

--RZ
MM_scale_x = 1.0
MM_scale_y = 1.0

--my_array = { [0] = 1, [1] = 2, [2] = 3 }
-- subscribe to a data group instead
-- subscribe to an insert/add/remove

--function mm01_insert_data_item(data_item_h)
--	IO_obj_handles[IO_obj_handles.num_items] = data_item_h
--	IO_obj_handles.num_items = IO_obj_handles.num_items + 1
--end
-- IO_obj_handles[i] = vint_object_find(""..i)

-- ##############################################################
function ig_get_handles()
	--debug_print("vint", "function ig_get_handles()")

	-- text_group (text_clone, text_value_clone)
	-- hints_group (hint_text, hint_bmp)
	-- anim_selection (selection_tween)
	-- highlight_button_anim_slidein (highlight_button_slidein1-4)
	-- highlight_button_anim_slideout (highlight_button_slideout1)
	-- text_group_anim_slidein (text_group_slidein1-4)
	-- text_group_anim_slideout (text_group_slideout1)
	local h = vint_object_find( "text_group_anim_slidein_norm" )
	vint_set_property( h, "start_time", 0 )

	-- menu_highlight_button - get the button handle, and its information
	IO_highlight_button_handle			= vint_object_find( "menu_highlight_button" )
	IO_highlight_button_x, IO_highlight_button_y = vint_get_property(IO_highlight_button_handle, "anchor" )
	local sx, sy = vint_get_property(IO_highlight_button_handle, "screen_size")
	
	MM_scale_x, MM_scale_y = vint_get_property( vint_object_find( "screen_group" ), "scale" )
	

	-- get the handle for our text group and the text group slide in and slide out anims
	IO_obj_handles[1]						= vint_object_find("text_group")
	--debug_print("vint", "\tIO_obj_handles[1] = "..IO_obj_handles[1])
	IO_obj_anim_fadein_handles[1]	= vint_object_find( "text_group_anim_slidein_norm" )
	IO_obj_anim_fadeout_handles[1]	= vint_object_find( "text_group_anim_slideout" )
	IO_highlight_button_size_x, IO_highlight_button_size_y = vint_get_property(IO_obj_handles[1], "screen_size")
	
	IO_highlight_button_size_y = IO_highlight_button_size_y / MM_scale_y
	
	if (IO_highlight_button_size_y < ((sy * 0.8) / MM_scale_y)) and (IO_highlight_button_size_y < (40 / MM_scale_y) ) then
		--give a little padding to each text item
		if ( (40 / MM_scale_y) < (sy / MM_scale_y)) then
			IO_highlight_button_size_y = (40 / MM_scale_y)
		else
			IO_highlight_button_size_y = (sy * 0.8) / MM_scale_y
		end
		debug_print("always_on", "size set:"..IO_highlight_button_size_y )
	end
	
	--[[if (IO_highlight_button_size_y < 40) then
		IO_highlight_button_size_y = 40
	end
	]]--

	IO_hint_group[1] = vint_object_find("hints")
	vint_set_property(IO_hint_group[1], "visible", false)

	-- get start x, y for the text group
	IO_text_group_x, IO_text_group_y = vint_get_property( IO_obj_handles[1], "anchor" )
	IO_text_group_y = IO_text_group_y - 5

	-- get the model handle
	IO_model_handle = vint_object_find( "model" )

	-- disable the slide in and slide out tweens
	local i
	vint_set_property( vint_object_find("text_group_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("highlight_button_slideout1"), "state", TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find("text_group_slidein_norm1"), "state", TWEEN_STATE_DISABLED )
	local start_time = 0
	for i = 1, 4 do
		-- disable highlight button slideins
		local highlight_slide_h = vint_object_find("highlight_button_slidein"..i)
		local duration = vint_get_property( highlight_slide_h, "duration" )
		vint_set_property( highlight_slide_h, "start_time", start_time + FADE_IN_START_TIME)
		vint_set_property( highlight_slide_h, "state", TWEEN_STATE_DISABLED )

		-- also get the fadein bounce handles for the selected text object and disable them
		IO_tween_fadein_bounce_handles[i] = vint_object_find( "text_group_slidein"..i )
		vint_set_property(IO_tween_fadein_bounce_handles[i], "start_time", start_time + FADE_IN_START_TIME )
		vint_set_property(IO_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
		start_time = start_time + duration
	end
	vint_set_property( vint_object_find( "highlight_button_move" ), "state", TWEEN_STATE_DISABLED )

	-- hide the text group
	vint_set_property( IO_obj_handles[1], "visible", false )

	vint_set_property( vint_object_find( "hints_group" ), "visible", false )

	-- show the model
	vint_set_property( IO_model_handle, "visible", true )

	-- get on select handle
	IO_tween_on_select_handle = vint_object_find("highlight_button_slideout1")

	-- we make sure that when the pause group anim stops, it disables itself!
	vint_set_property( vint_object_find("pause_group_scale_twn_1"), "end_event", "ig_io_group_scale_done" )
end

-- ##############################################################
function rfg_ui_ingame_options_cleanup()
end

-- ##############################################################
function rfg_ui_ingame_options_init()

	-- get the handles
	ig_get_handles()

	vint_dataitem_add_subscription( "TweenOnSelect_ingame", "update", "ig_io_play_on_selection_tween" )
	vint_datagroup_add_subscription( "MenuGroup_ingame", "update", "ig_io_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup_ingame", "insert", "ig_io_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup_ingame", "remove", "ig_io_group_remove" )
	vint_datagroup_add_subscription( "HintsInfo_ingame", "update", "ig_io_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo_ingame", "insert", "ig_io_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo_ingame", "remove", "ig_io_hints_remove" )
	vint_dataitem_add_subscription( "MenuTitle_ingame", "update", "ig_io_update_title" )

	-- guarantee time index is at 0
	vint_set_time_index(0)
end

-- ##############################################################
function ig_io_group_add()

	-- k, looks like a data item has been added so we need to bump the number of items
	-- that we have11:29 AM 10/6/2008
	local prev_num_items = IO_num_items
	IO_num_items = prev_num_items + 1

	if (prev_num_items ~= 0) then
		-- this is not the first item, so we clone the other items
		--debug_print("vint", "vint_object_clone_rename(IO_obj_handles[1], text_group..IO_num_items)")
		--debug_print("vint", "\tIO_obj_handles[1] = "..IO_obj_handles[1])
		--debug_print("vint", "\tIO_num_items = "..IO_num_items)
		IO_obj_handles[IO_num_items] = vint_object_clone_rename(IO_obj_handles[1], "text_group"..IO_num_items )
		IO_obj_anim_fadein_handles[IO_num_items] = vint_object_clone_rename(IO_obj_anim_fadein_handles[1], "text_group_anim_slidein_norm"..IO_num_items )
		IO_obj_anim_fadeout_handles[IO_num_items] = vint_object_clone_rename(IO_obj_anim_fadeout_handles[1], "text_group_anim_slideout"..IO_num_items )
	end

	-- set visible
	vint_set_property( IO_obj_handles[IO_num_items], "visible", true )

	-- indicate visible and enabled
	IO_obj_visible[IO_num_items] = true
	IO_obj_enabled[IO_num_items] = true

end

-- ##############################################################
function ig_update_item_position(index)

	-- update the position of this item (really is just its y-value)
	local diff = ig_get_item_offset(index)
	local x, y = vint_get_property( IO_obj_handles[1], "anchor" )
	local new_y = IO_text_group_y + IO_highlight_button_size_y * diff
	vint_set_property( IO_obj_handles[index], "anchor", x, new_y )

	-- set new start time for the animation of fading in
	local new_start = 0.05 * diff + FADE_IN_START_TIME
	vint_set_property( IO_obj_anim_fadein_handles[index], "start_time", new_start )

	-- update the targets for the tweens, and their start/end values
	local handle, tmpx, tmpy

	-- get handle of the fadeout tween, then set its target handle and its state
	handle = vint_object_find( "text_group_slideout1", IO_obj_anim_fadeout_handles[index] )
	vint_set_property( handle, "target_handle", IO_obj_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadeout
	tmpx, tmpy = vint_get_property( handle, "start_value" )
	vint_set_property( handle, "start_value", tmpx, new_y )
	
	tmpx, tmpy = vint_get_property( handle, "end_value" )
	vint_set_property( handle, "end_value", tmpx, new_y )

	-- get handle of the fadein tween, then set its target handle and its state
	handle = vint_object_find( "text_group_slidein_norm1", IO_obj_anim_fadein_handles[index] )
	vint_set_property( handle, "target_handle", IO_obj_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- update the start and end values for fadein
	tmpx, tmpy = vint_get_property( handle, "start_value" )
	vint_set_property( handle, "start_value", tmpx, new_y )

	tmpx, tmpy = vint_get_property( handle, "end_value" )
	vint_set_property( handle, "end_value", tmpx, new_y )
end

-- ##############################################################
function ig_io_group_remove(data_item_handle, event_name)

	if (IO_num_items > 0) then
	
		-- k, here we remove an item
		local prev_num_items = IO_num_items
		IO_num_items = prev_num_items - 1

		if (prev_num_items > 1) then
			-- simply get rid of the objects
			vint_object_destroy( IO_obj_handles[prev_num_items] )
			vint_object_destroy( IO_obj_anim_fadein_handles[prev_num_items] )
			vint_object_destroy( IO_obj_anim_fadeout_handles[prev_num_items] )

			IO_obj_handles[prev_num_items] = 0
			IO_obj_anim_fadein_handles[prev_num_items] = 0
			IO_obj_anim_fadeout_handles[prev_num_items] = 0
		end

		-- indicate not visible nor enabled
		IO_obj_visible[prev_num_items] = false
		IO_obj_enabled[prev_num_items] = false
	end
	
end

-- ##############################################################
function resize_text(handle)

	vint_set_property(handle, "text_scale", 1, 1)
	local text_width, text_height = vint_get_property(handle, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"),"scale")
	local MAX_TEXT_WIDTH_1 = 570 * parent_scale_x
	local MAX_TEXT_WIDTH_2 = 600 * parent_scale_x

	if(text_width > MAX_TEXT_WIDTH_1) then

		vint_set_property(handle, "text_scale", 0.85, 1.0)

		if(text_width > MAX_TEXT_WIDTH_2) then
			vint_set_property(handle, "text_scale", 0.75, 1.0) 
		end

	end
	
end

-- ##############################################################
function ig_io_update_group_item(data_item_handle, event_name)

	-- k, get the index, its caption, value, and positions for caption and value
	local play_fadein, is_fadein_callback, is_selected, is_visible, is_enabled, index, is_slider, caption, value = vint_dataitem_get(data_item_handle)

	if (play_fadein) then
		-- reset the time index
		vint_set_time_index(0)
		IO_fadein_anchor = true

		-- MLG: Fixes this tween getting skiped on a long frame and never setting the end value
		vint_set_child_tween_state( vint_object_find("bottom_right_dirt"), TWEEN_STATE_IDLE )
	end

	-- is this an add?
	if ( event_name == "insert" ) then
		ig_io_group_add()
	end

	-- update this guy's position
	ig_update_item_position(index)

	if (index >= 1) and ( index <= IO_num_items ) then

		-- set its text tags
		local handle = vint_object_find( "text_clone", IO_obj_handles[index] )
		vint_set_property( handle, "text_tag", caption )
		local value_handle = vint_object_find( "text_value_clone", IO_obj_handles[index] )
		vint_set_property( value_handle, "text_tag", value )

		--resize text
		resize_text(handle)		

		--resize the highlight
		resize_highlight()
		
		if (is_selected) then
			vint_set_property(value_handle, "tint", 0, 0, 0)
		else
			local r, g, b = vint_get_property( handle, "tint" )
			vint_set_property(value_handle, "tint", r, g, b)
		end

		--check if value is present
		--if so, hide the "2nd" model, so it is not on top
		if ( index == 1 ) then
			if (value ~= nil) and (value ~= "") then
				vint_set_property( IO_model_handle, "visible", false )
			else
				vint_set_property( IO_model_handle, "visible", true )
			end
		end

		-- should we update the colors?
		local update = false
		if (IO_obj_visible[index] ~= is_visible) then
			update = true
		elseif (IO_obj_enabled[index] ~= is_enabled) then
			update = true
		end

		-- set its visibility, enabled status 
		IO_obj_visible[index] = is_visible
		IO_obj_enabled[index] = is_enabled

		if (play_fadein == true) then

			-- reset time index
			vint_set_time_index(0)

			

			-- trigger this guy's fadein tween
			ig_trigger_fadein_tween(index, is_fadein_callback, is_selected)

		elseif (IO_fadein_anchor == false) then

			-- flat out set its position
			local diff = ig_get_item_offset(index)
			local new_y = IO_text_group_y + IO_highlight_button_size_y*diff
			vint_set_property( IO_obj_handles[index], "anchor", IO_text_group_x, new_y )
		end

		if ( is_selected == true ) then
			
			-- set the index, but first set last choice
			ig_set_choice(index)

			-- make sure we update color
			update = true
		end

		-- set visibility
		vint_set_property( IO_obj_handles[index], "visible", IO_obj_visible[index] )

		-- set enabled state
		if ( is_enabled ~= true ) then
			vint_set_property( IO_obj_handles[index], "alpha", 0.33 )
			vint_set_property( IO_obj_handles[index], "tint", 1.0, 0.576471, 0.0313726 )
		elseif (is_selected) then
			vint_set_property( IO_obj_handles[index], "alpha", 1.0 )
			vint_set_property( IO_obj_handles[index], "tint", 1.0, 1.0, 1.0 )
		else
			vint_set_property( IO_obj_handles[index], "alpha", 0.7 )
			vint_set_property( IO_obj_handles[index], "tint", 1.0, 0.576471, 0.0313726 )
		end
	
	else 
		--debug_print("vint", "\nINGAME WTF!?!?!?!?" )
	end

end

-- ##############################################################
function ig_io_play_on_selection_tween(data_item_handle, event_name)

	-- the user has actually chosen something, so we do a special tween, and when it is done,
	-- we callback to the game, letting it know to continue with the gamestate change
	local selection = vint_dataitem_get(data_item_handle)
	
	if ( selection ~= 0 ) then

		-- get current time
		local time_index = vint_get_time_index()

		-- ok, time to play the fadeout anims!
		local i
		for i = 1, IO_num_items do

			-- get the tween handle
			local tween_handle = vint_object_find( "text_group_slideout1", IO_obj_anim_fadeout_handles[i] )
			vint_set_property( IO_obj_anim_fadeout_handles[i], "start_time", 0 )
			vint_set_property( tween_handle, "start_time", time_index )
			vint_set_property( tween_handle, "state", TWEEN_STATE_RUNNING )

			local j
			for j = 1, 4 do
				tween_handle = vint_object_find( "text_group_slidein"..j, IO_obj_anim_fadein_handles[i] )
				vint_set_property( tween_handle, "state", TWEEN_STATE_DISABLED )
			end
		end

		-- set the end event for the highlight button move out, and its position information
		local x, y = vint_get_property( IO_highlight_button_handle, "anchor" )
		IO_tween_on_select_handle = vint_object_find("highlight_button_slideout1")
		vint_set_property( vint_object_find("highlight_button_anim_slideout"), "start_time", 0 )
		vint_set_property( IO_tween_on_select_handle, "start_time", time_index )
		vint_set_property( IO_tween_on_select_handle, "state", TWEEN_STATE_RUNNING )
		vint_set_property( IO_tween_on_select_handle, "end_event", "ig_io_tween_on_select_end")
		vint_set_property( IO_tween_on_select_handle, "start_value", x, y )

		local endx, endy = vint_get_property( IO_tween_on_select_handle, "end_value" )
		vint_set_property( IO_tween_on_select_handle, "end_value", endx, y )
	else

		vint_set_property( IO_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )
	end

end

-- ##############################################################
function ig_io_tween_on_select_end(tween_h, event_name)

	-- callback into the game and let it know we are done
	menu_tween_on_select_end()

	-- remove this callback
	remove_tween_end_callback(IO_tween_on_select_handle)

	-- disable the fadeout tweens for each item
	local i
	for i = 1, IO_num_items do
		local tween_handle = vint_object_find( "text_group_slideout1", IO_obj_anim_fadeout_handles[i] )
		vint_set_property( tween_handle, "state", TWEEN_STATE_DISABLED )
	end

	-- disable our tween
	vint_set_property(IO_tween_on_select_handle, "state", TWEEN_STATE_DISABLED )
end

-- ##############################################################
function ig_io_fade_in_end(target_handle, event_name)

	-- no longer fading in
	IO_fadein_anchor = false

	-- remove this callback
	remove_tween_end_callback(IO_tween_fadein_event_handle)
	IO_tween_fadein_event_handle = 0
	
	-- disable this
	local io_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
	vint_set_property( io_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )

	-- disable the fadein tweens
	local i
	for i = 1, IO_num_items do
		vint_set_property( vint_object_find("text_group_slidein_norm1", IO_obj_anim_fadein_handles[i]), "state", TWEEN_STATE_DISABLED )
	end

	for i = 1, 4 do
		vint_set_property( vint_object_find( "highlight_button_slidein"..i ), "state", TWEEN_STATE_DISABLED )
		vint_set_property( IO_tween_fadein_bounce_handles[i], "state", TWEEN_STATE_DISABLED )
	end

	-- now callback into the game
	menu_tween_fade_in_end()

	debug_print("vint", "Fade in ended\n")
end

-- ##############################################################
function ig_io_hints_info(data_item_handle, event_name)
	
	local index, text, image_name = vint_dataitem_get(data_item_handle)
	local hints_group = vint_object_find( "hints_group" )
	
	if (event_name == "insert") then
		-- cloning time!
		IO_num_hints = IO_num_hints + 1
		
		if (IO_num_hints > 1) then
			IO_hint_group[IO_num_hints] = vint_object_clone_rename(IO_hint_group[1], "hints"..index )
			vint_set_property( IO_hint_group[IO_num_hints], "alpha", 0.45 )
			vint_set_property( IO_hint_group[IO_num_hints], "tint", 1.0, 0.5, 0.0 )
		else
			vint_set_property( hints_group, "visible", true )
			vint_set_property( IO_hint_group[1], "alpha", 0.45 )
			vint_set_property( IO_hint_group[1], "tint", 1.0, 0.5, 0.0 )
		end
	end

	local group_h = IO_hint_group[index]
	vint_set_property(group_h, "visible", true)
	
	local text_h = vint_object_find("hint_text", group_h)
	local image_h = vint_object_find("hint_bmp", group_h)
	local BUFFER = 7
	
	vint_set_property( text_h, "text_tag", text )
	vint_set_property( image_h, "image", image_name )
	
	local parent_scale_x, parent_scale_y = vint_get_property( vint_object_find("screen_group"), "scale" )

	-- update position
	for i = 2, index do
		local scale_x, scale_y = vint_get_property( IO_hint_group[i-1], "screen_size" )
		local anchor_x, anchor_y = vint_get_property( IO_hint_group[i-1], "anchor" )
		vint_set_property(IO_hint_group[i], "anchor", anchor_x + (scale_x / parent_scale_x) + BUFFER, anchor_y)
	end
end

-- ##############################################################
function ig_io_hints_remove(data_item_handle, event_name)

	if ( IO_num_hints > 0 ) then
		-- k, here we destroy the item (if num hints is greater than 1)
		local new_num_items = IO_num_hints - 1
		
		if (IO_num_hints > 1) then
			vint_object_destroy( IO_hint_group[IO_num_hints] )	
			IO_hint_group[IO_num_hints] = 0
		else
			vint_set_property( IO_hint_group[IO_num_hints], "visible", false )
			vint_set_property( vint_object_find( "hints_group" ), "visible", false )
		end

		IO_num_hints = new_num_items
	end
end

-- ##############################################################
function ig_trigger_fadein_tween(index, is_fadein_callback, is_selected)

	local handle

	-- get our new y value for the text!
	local diff = ig_get_item_offset(index)
	local new_y = IO_text_group_y + IO_highlight_button_size_y * diff

	-- we need to set our anchor to the fadein start value!
	local x, y = vint_get_property( vint_object_find("text_group_slidein1"), "start_value" )
	vint_set_property( IO_obj_handles[index], "anchor", x, new_y )

	-- get handle of the fadeout tween, and disable it!
	handle = vint_object_find( "text_group_slideout1", IO_obj_anim_fadeout_handles[index] )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- ok, if we are selected, then we "bounce" in - so we have to ...
	if ( is_selected == true ) then

		-- disable our "normal" slidein tween
		handle = vint_object_find( "text_group_slidein_norm1", IO_obj_anim_fadein_handles[index] )
		vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

		-- get where the new highlight y should be placed
		local new_highlight_y = IO_highlight_button_y + IO_highlight_button_size_y * diff

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
			handle = IO_tween_fadein_bounce_handles[i]
			x, y = vint_get_property(handle, "start_value")
			vint_set_property( handle, "start_value", x, new_y)
			x, y = vint_get_property(handle, "end_value")
			vint_set_property( handle, "end_value", x, new_y)

			-- set their targets to be us
			vint_set_property( handle, "target_handle", IO_obj_handles[index] )
		
			-- and set them to running
			vint_set_property( handle, "state", TWEEN_STATE_RUNNING )
		end

		-- are we the fadein callback?
		if ( is_fadein_callback == true ) then
			IO_tween_fadein_event_handle = vint_object_find( "highlight_button_slidein4" )
			vint_set_property( IO_tween_fadein_event_handle, "end_event", "ig_io_fade_in_end" )
		end

	else
		-- enable our normal slidein tween
		handle = vint_object_find( "text_group_slidein_norm1", IO_obj_anim_fadein_handles[index] )
		vint_set_property( handle, "state", TWEEN_STATE_RUNNING )

		-- and guarantee its y values are ok
		x, y = vint_get_property(handle, "start_value")
		vint_set_property( handle, "start_value", x, new_y)
		x, y = vint_get_property(handle, "end_value")
		vint_set_property( handle, "end_value", x, new_y)

		-- are we the fadein callback?
		if ( is_fadein_callback == true ) then
			vint_set_property( handle, "end_event", "ig_io_fade_in_end" )
		end
	end
end

-- ##############################################################
function ig_set_choice(index)

	IO_choice_prev = IO_choice
	IO_choice = index

	if (IO_fadein_anchor == false) then

		-- this occurs when the user has moved down or up on the menu
		local io_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		local oldx, oldy = vint_get_property( io_tween_highlight_button_handle, "end_value" )
		local diff1 = ig_get_item_offset(IO_choice_prev)
		local diff2 = ig_get_item_offset(IO_choice)
		local new_starty	= IO_highlight_button_y + IO_highlight_button_size_y * diff1 -- BUTTON_Y_FUDGE
		local new_endy		= IO_highlight_button_y + IO_highlight_button_size_y * diff2 -- BUTTON_Y_FUDGE

		vint_set_property( io_tween_highlight_button_handle, "duration", 0.125 )
		vint_set_property( io_tween_highlight_button_handle, "start_time", vint_get_time_index() )
		vint_set_property( io_tween_highlight_button_handle, "start_value", oldx, new_starty)
		vint_set_property( io_tween_highlight_button_handle, "end_value", oldx, new_endy)
		vint_set_property( io_tween_highlight_button_handle, "state", TWEEN_STATE_RUNNING )
	else
		local io_tween_highlight_button_handle	= vint_object_find( "highlight_button_move" )
		vint_set_property( io_tween_highlight_button_handle, "state", TWEEN_STATE_DISABLED )
	end

end

-- ##############################################################
function ig_get_item_offset(index)

	local i
	local num_visible_before = 0
	for i = 1, index-1 do
		
		if (IO_obj_visible[i] == true) then
			num_visible_before = num_visible_before + 1
		end
	end

	return num_visible_before
end

-- ##############################################################
function ig_io_update_title(data_item_handle, event_name)

	local multiplayer, menu_title, dead = vint_dataitem_get(data_item_handle)
	
	if (IO_can_set_title) then
		local pause_group_h = vint_object_find( "pause_group" )
		local pause_text_h = vint_object_find("paused_text")
		local pause_outline_h = vint_object_find("paused_box")

		if ( multiplayer == false ) then

			-- set visible
			vint_set_property( pause_group_h, "visible", true )
			vint_set_property( pause_text_h, "text_tag", menu_title )
			IO_can_set_title = false
		else
			vint_set_property( pause_group_h, "visible", false )
		end

		--handle text scaling for long strings

		vint_set_property(pause_text_h, "text_scale", 1.67, 1.67)
		
		local pause_width, pause_height = vint_get_property(pause_text_h, "screen_size")
		local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"), "scale")
		local MAX_WIDTH = 544 * parent_scale_x

		if(pause_text_h > MAX_WIDTH) then
			vint_set_property(pause_text_h, "text_scale", 1.2, 1.4)
		end

		--if( dead == true )then
		--	vint_set_property( pause_outline_h, "tint", 1,0,0 )
		--	vint_set_property( pause_text_h, "tint", 0.5,0,0 )
		--end
	end
end

-- ##############################################################
function ig_io_group_scale_done()

	-- DISABLE OUR TWEEN!
	local handle = vint_object_find("pause_group_scale_twn_1")
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- remove this callback
	remove_tween_end_callback(handle)

end

-- ##############################################################
function resize_highlight()

	local max_width = get_text_width()
	local head_handle = vint_object_find( "menu_highlight_frame" )
	local tail_handle = vint_object_find( "menu_highlight_frame_tail" )
	local bar_handle = vint_object_find( "bar_fill_group" )

	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )

	local head_x,head_y = vint_get_property( head_handle, "anchor" )
	local head_width,head_height = vint_get_property( head_handle, "screen_size" )

	local tail_x,tail_y = vint_get_property( tail_handle, "anchor" )
	local tail_width,tail_height = vint_get_property( tail_handle, "screen_size" )

	local bar_x,bar_y = vint_get_property( bar_handle, "anchor" )
	local bar_width,bar_height = vint_get_property( bar_handle, "screen_size" )

	local new_tail_x = head_x + max_width/parent_xscale - head_width/parent_xscale + IO_HIGHLIGHT_PADDING*2
	
	if( new_tail_x < 0 )then
		new_tail_x = 0
	end
	
	local new_bar_x = new_tail_x + tail_width/parent_xscale
	
	vint_set_property( tail_handle,"anchor",new_tail_x,tail_y )
	vint_set_property( bar_handle,"anchor",new_bar_x,bar_y )

end

-- ##############################################################
function get_text_width()
	local max_text_width = 0
	for i = 1,IO_num_items do
		local handle = vint_object_find( "text_clone", IO_obj_handles[i] )
		local text_width,text_height = vint_get_property( handle, "screen_size" )
		if(text_width > max_text_width)then
			max_text_width = text_width
		end
	end
	return max_text_width
end
