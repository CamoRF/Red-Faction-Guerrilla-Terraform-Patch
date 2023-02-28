
--[[
MAX_INPUT_ITEMS = 5
Input_handles = {MAX_INPUT_ITEMS = 0}
local safe_frame_handle = vint_object_find("safe_frame")
Input_handles[1] = vint_subscribe_to_input_event(safe_frame_handle, "nav_up", "choice_change_up")
Input_handles[2] = vint_subscribe_to_input_event(safe_frame_handle, "joy_up", "choice_change_up")
Input_handles[3] = vint_subscribe_to_input_event(safe_frame_handle, "nav_down", "choice_change_down")
Input_handles[4] = vint_subscribe_to_input_event(safe_frame_handle, "joy_down", "choice_change_down")
Input_handles[5] = vint_subscribe_to_input_event(safe_frame_handle, "select", "choice_change_select")
vint_unsubscribe_to_input_event(Input_handles[i])
Input_handles[i] = 0
--]]

MBOX_OFFSET = 5
MAX_MBOX_ITEMS = 16
MAX_MBOX_HINT_ITEMS = 4
MBOX_num_items = 0
MBOX_num_hints = 0
MBOX_item_group_handles = {MAX_MBOX_ITEMS = 0}
MBOX_hint_group = {MAX_MBOX_HINT_ITEMS = 0}

MBOX_background_base_size_x = 60
MBOX_background_base_size_y = 0
MBOX_background_base_posn_x = 0
MBOX_background_base_posn_y = 0

MBOX_item_group_size_x = 0
MBOX_item_group_size_y = 34
MBOX_item_group_posn_x = 0
MBOX_item_group_posn_y = 0

MBOX_hint_group_posn_x = 0
MBOX_hint_group_posn_y = 0
MBOX_hint_group_size_x = 0
MBOX_hint_group_size_y = 0

MBOX_caption_base_size_x = 0
MBOX_caption_base_size_y = 0

MBOX_loading_screen = false

Small_saving_handle = 0
Saving_Anim = 0
Saving_fadeout = 0
Autosave_icon_visible = false

Text_chat_anim = 0
Text_chat_hints_visible = 0

MBOX_fading_in = false

MBOX_default_loading_scale_x = 1.0
MBOX_default_loading_scale_y = 1.0

-- ##############################################################
function rfg_ui_utility_cleanup()
end

-- ##############################################################
function rfg_ui_utility_init_handles()

	-- body_bkgrnd - what we scale
	-- item_group - what we clone (item_text, item_value)
	-- title_group - bkgrnd_title, title
	-- hint_group (button_image, button_text)

	-- setup our data for the menu item group
	local handle = vint_object_find( "item_group" )
	MBOX_item_group_handles[1] = handle
	MBOX_item_group_size_x, MBOX_item_group_size_y = vint_get_property(handle, "screen_size")
	MBOX_item_group_posn_x, MBOX_item_group_posn_y = vint_get_property(handle, "anchor")
	vint_set_property(handle, "visible", false)

	-- setup our data for the hints
	handle = vint_object_find( "hints_scale_group" )
	MBOX_hint_group[1] = handle
	MBOX_hint_group_posn_x, MBOX_hint_group_posn_y = vint_get_property(handle, "anchor")
	MBOX_hint_group_size_x, MBOX_hint_group_size_y = vint_get_property(handle, "screen_size")
	vint_set_property( handle, "visible", false )

	-- get the backgroun base position and size
	handle = vint_object_find( "popup_middle" )
	MBOX_background_base_posn_x, MBOX_background_base_posn_y = vint_get_property(handle, "anchor")
	MBOX_background_base_size_x, MBOX_background_base_size_y = vint_get_property(handle, "screen_size")

	-- just disable the fadeout tween for now
	handle = vint_object_find( "scale_out_tween" )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED)

	-- update our fade in to not play right now
	--msgbox_trigger_fadein(false)
	handle = vint_object_find( "scale_in_tween" )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	handle = vint_object_find( "description_text" )
	MBOX_caption_base_size_x, MBOX_caption_base_size_y = vint_get_property( handle, "screen_size" )

	-- Turn off the loading animation
	vint_set_property(vint_object_find("loading_group"), "visible", false)
	vint_set_child_tween_state( vint_object_find("loading_anim"), TWEEN_STATE_PAUSED )

	--hide highlight bar
	vint_set_property(vint_object_find("highlight_group"),"visible", false)

	-- setup our on select tween
	handle = vint_object_find( "highlight_group_selected_twn" )
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	vint_set_child_tween_state( vint_object_find("loading_anim"), TWEEN_STATE_DISABLED )
	vint_set_property( vint_object_find( "subtitle_group" ),"visible",false)
	vint_set_property( vint_object_find( "subtitle_group" ),"alpha",0.0)

	Small_saving_handle = vint_object_find("small_saving")
	vint_set_property(Small_saving_handle, "visible", false)
	
	Saving_Anim = vint_object_find("saving_diag_anim")
	vint_set_child_tween_state( Saving_Anim , TWEEN_STATE_DISABLED )
	
	Saving_fadeout = vint_object_find("saving_diag_fade_out")
	vint_set_child_tween_state( Saving_fadeout , TWEEN_STATE_DISABLED )
	
	Text_chat_anim = vint_object_find("text_chat_hints_anim")
	vint_set_child_tween_state( Text_chat_anim , TWEEN_STATE_DISABLED )
	
	vint_set_property(vint_object_find("rfg_bkgrnd_group"), "visible", false )

	MBOX_default_loading_scale_x, MBOX_default_loading_scale_y = vint_get_property( vint_object_find("LOADING"), "text_scale" )
end

-- ##############################################################
function rfg_ui_utility_init()

	-- k, we are essentially a menu, and we have a title, hint information, and we get data
	-- items from a group added/removed from us
	vint_dataitem_add_subscription( "TweenOnSelect_MB", "update", "msgbox_play_on_selection_tween" )
	vint_datagroup_add_subscription( "MenuGroup_MB", "update", "msgbox_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup_MB", "insert", "msgbox_update_group_item" )
	vint_datagroup_add_subscription( "MenuGroup_MB", "remove", "msgbox_group_remove" )
	vint_datagroup_add_subscription( "HintsInfo_MB", "update", "msgbox_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo_MB", "insert", "msgbox_hints_info" )
	vint_datagroup_add_subscription( "HintsInfo_MB", "remove", "msgbox_hints_remove" )	
	vint_dataitem_add_subscription( "MenuTitle_MB", "update", "msgbox_update_title" )
	vint_dataitem_add_subscription( "MsgBoxInfo", "update", "msgbox_update_msgbox" )
	--subtitle stuff
	vint_dataitem_add_subscription( "SubtitleTextUpdate", "update", "util_set_subtitle" )
	--PC version has an image here
	vint_dataitem_add_subscription( "ResChangeImage", "update", "util_res_change" )
	-- autosave icon
	vint_dataitem_add_subscription( "AutoSaveUpdate", "update", "util_update_autosave" )
	-- voice chat
	vint_dataitem_add_subscription( "VoiceChatUpdate", "update", "util_update_voicechat" )

	
	-- Hold on the reveal animation
	local reveal_anim = vint_object_find("popup_reveal_anim")
	vint_set_child_tween_state( reveal_anim, TWEEN_STATE_DISABLED )

	rfg_ui_utility_init_handles()
	
	vint_set_property(vint_object_find("highlight_group_anim"), "is_paused", true)

end

-- ##############################################################
function msgbox_play_on_selection_tween(data_item_handle, event_name)
	
	local selection = vint_dataitem_get(data_item_handle)

	-- setup the on select tween
	if ( selection ~= 0 ) then

		local handle = vint_object_find( "highlight_group_selected_twn" )
		vint_set_property( handle, "end_event", "msgbox_on_select_done" )
		vint_set_property( handle, "start_time", vint_get_time_index() )
		vint_set_property( handle, "state", TWEEN_STATE_RUNNING )
	end

end

-- ##############################################################
function msgbox_on_select_done()
			
	local handle = vint_object_find( "highlight_group_selected_twn" )

	vint_set_property( handle, "end_event", "")
	vint_set_property( handle, "state", TWEEN_STATE_DISABLED )

	-- callback into the game and let it know we are done
	menu_tween_on_select_end()
end


-- ##############################################################
function msgbox_update_group_item(data_item_handle, event_name)

	local play_fadein, is_fadein_callback, is_selected, is_visible, is_enabled, index, is_slider, caption, value = vint_dataitem_get(data_item_handle)
	
	if (event_name == "insert") then
		msgbox_add_item()
	end

	
	if (MBOX_item_group_handles[index] ~= 0) then
	
		-- get the group handle for this item
		local handle = MBOX_item_group_handles[index]

		-- set its information
		local text_h	= vint_object_find( "item_text", handle )
		local value_h	= vint_object_find( "item_value", handle )
		vint_set_property( text_h, "text_tag", caption )
		vint_set_property( value_h, "text_tag", value )
		
		--if (index == 1) then
		--	vint_set_property( handle, "tint", 0.62, 0.31, 0.04 )
		if (is_selected) then
					
			local index_x, index_y = vint_get_property( handle, "anchor")
			

			vint_set_property( handle, "tint", 1.0, 0.5, 0.0 )
			vint_set_property( vint_object_find("highlight_group"), "anchor", index_x, index_y  )
		else
			vint_set_property( handle, "tint", 0.62, 0.31, 0.04 )
		end
		
		-- set visibility status here
		vint_set_property(handle, "visible", is_visible)

		-- set enabled status
		if (is_enabled or (index == 1)) then
			vint_set_property(handle, "alpha", 1.0)
		else
			vint_set_property(handle, "alpha", 0.25)
		end
	end

end

-- ##############################################################
function msgbox_hints_info(data_item_handle, event_name)
	
	local index, text, image_name = vint_dataitem_get(data_item_handle)
	
	if (event_name == "insert") then
		-- cloning time!
		MBOX_num_hints = MBOX_num_hints + 1
		
		if (MBOX_num_hints > 1) then
			MBOX_hint_group[MBOX_num_hints] = vint_object_clone_rename(MBOX_hint_group[1], "hint_group"..index )
		end
	end

	local group_h = MBOX_hint_group[index]
	vint_set_property(group_h, "visible", true)
	
	local text_h = vint_object_find("button_text", group_h)
	local image_h = vint_object_find("button_image", group_h)

	vint_set_property( text_h, "text_tag", text )
	vint_set_property( image_h, "text_tag", image_name )

	local group_scale_x, group_scale_y = vint_get_property(vint_object_find("hints_scale_group"), "scale")
	local FUDGE = 25
	-- update position
	for i = 2, index do
		local anchor_x, anchor_y = vint_get_property( MBOX_hint_group[i-1], "anchor" )
		local hint_size_x, hint_size_y = vint_get_property( MBOX_hint_group[i-1], "screen_size" )
		vint_set_property(MBOX_hint_group[i], "anchor", anchor_x + hint_size_x * group_scale_x + FUDGE, anchor_y)
	end

	--center hints
	local HINTS_CENTER = 640
	local handle = vint_object_find("hints_scale_group")
	local handle_x, handle_y = vint_get_property(handle, "anchor")
	local handle_width, handle_height = vint_get_property(handle, "screen_size")
	
	if(MBOX_num_hints > 1) then
		
		vint_set_property(handle, "anchor", HINTS_CENTER - (handle_width * 0.5), handle_y)

	else

		vint_set_property(handle, "anchor", HINTS_CENTER, handle_y)
	
	end

end

-- ##############################################################
function msgbox_hints_remove(data_item_handle, event_name)
	local o = vint_object_find("popup_game_pause_fade_in")
	vint_set_property(o, "paused", true)

	o = vint_object_find("popup_paused_grp")
	vint_set_property(o, "alpha", 0)

	if (MBOX_num_hints > 0) then
		-- k, here we destroy the item (if num hints is greater than 1)
		local new_num_items = MBOX_num_hints - 1
		
		if (MBOX_num_hints > 1) then
			vint_object_destroy( MBOX_hint_group[MBOX_num_hints] )	
			MBOX_hint_group[MBOX_num_hints] = 0
		else
			vint_set_property( MBOX_hint_group[1], "visible", false )
		end

		MBOX_num_hints = new_num_items
	end
end

-- ##############################################################
function msgbox_update_title(data_item_handle, event_name)

	-- k, get the title text and multiplayer flag!
	local multiplayer, title_text = vint_dataitem_get(data_item_handle)

	local handle = vint_object_find("title")
	
	if (title_text ~= nil) then
		vint_set_property(handle, "text_tag", title_text)
		vint_set_property(handle, "visible", true)
	else
		vint_set_property(handle, "visible", false)
	end

	local title_size_x, title_size_y = vint_get_property(handle, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("popup_frame"), "scale")
	local MAX_WIDTH = 750 * parent_scale_x

	if(title_size_x >= MAX_WIDTH) then
		vint_set_property(handle, "text_scale", 0.8, 1.0)
	else
		vint_set_property(handle, "text_scale", 1.0, 1.0)
	end

end

-- ##############################################################
function msgbox_hide_popup()
	-- Hides all the hexagonal bits that are used to the the regular popup transition in
	
	
	
end


-- ##############################################################
function msgbox_reveal_popup()
	-- Shows the hexagonal bits that are used to animation the transition into a popup
	
	
end

-- ##############################################################
function msgbox_update_msgbox(data_item_handle, event_name)
		local visible, loading, description, img_text, highlight_button, skipFadeIn = vint_dataitem_get(data_item_handle)

	-- Set up the border and window
	--local reveal_anim = vint_object_find("popup_reveal_anim")
	--vint_set_property( reveal_anim, "is_paused", true)
	
	-- Turn everything on or off
	if (visible == true) then
		msgbox_update_scaling()

		vint_set_property( vint_object_find("main_group"), "visible", true )
		vint_set_property( vint_object_find("popup_frame"), "visible", true )
		vint_set_property( vint_object_find("screen_scrim"), "visible", true )
		vint_set_property( vint_object_find("highlight_hint"), "text_tag", highlight_button )
		
		-- Animate in the border and window
		if (skipFadeIn == false) then
			msgbox_trigger_fadein(true)
		else
			msgbox_trigger_fadein(false)
		end

		--vint_set_property( reveal_anim, "is_paused", false)
		--vint_set_property( reveal_anim, "start_time", vint_get_time_index())
	else
		vint_set_property( vint_object_find("main_group"), "visible", false )
		vint_set_property( vint_object_find("popup_frame"), "visible", false )
		vint_set_property( vint_object_find("screen_scrim"), "visible", false )
		
		--  Stop the border and window animations if they're still playing
		msgbox_trigger_fadein(false)
	end

	-- Set appropriate settings for whether or not this is a Loading message box type
	MBOX_loading_screen = loading
	if (loading == true) then
		vint_set_property( vint_object_find("description_text"), "visible", false )
		vint_set_property( vint_object_find("description_text"), "text_tag", "" )

		play_loading_anim()
		vint_set_property( vint_object_find("LOADING"), "text_tag", img_text) 
		util_set_text_width( vint_object_find("LOADING"), 242 )
	else
		vint_set_property( vint_object_find("description_text"), "visible", true )
		vint_set_property( vint_object_find("description_text"), "text_tag", description )
		stop_loading_anim()
	end
	

	-- Resize the message box
	msgbox_update_scaling()
end

-- ##############################################################
function msgbox_add_item()

	-- k, we need to remove an item - if our count gets below
	local prev_num = MBOX_num_items
	MBOX_num_items = prev_num + 1

	if (MBOX_num_items > 1) then

		-- k, gotta create an item
		local handle = vint_object_clone_rename(MBOX_item_group_handles[1], "item_group"..MBOX_num_items)
		MBOX_item_group_handles[MBOX_num_items] = handle
	end
	
	vint_set_property( MBOX_item_group_handles[MBOX_num_items], "visible", true )
	
	local highlight_handle = vint_object_find("highlight_group")

	vint_set_property(highlight_handle,"visible", true)

	-- update our scaling information
	msgbox_update_scaling()

end

-- ##############################################################
function msgbox_group_remove(data_item_handle, event_name)

	if (MBOX_num_items > 0) then
		-- k, we need to remove an item - if our count gets below
		local prev_num = MBOX_num_items
		MBOX_num_items = prev_num - 1

		-- make sure invisible
		vint_set_property(MBOX_item_group_handles[prev_num], "visible", false)
		
		if (prev_num > 1) then

			-- k, gotta destroy the last item's info
			vint_object_destroy(MBOX_item_group_handles[prev_num])
			MBOX_item_group_handles[prev_num] = 0
		else
			vint_set_property(vint_object_find("highlight_group"),"visible", false)
		end

		-- update our scaling information
		msgbox_update_scaling()
	end
	
end

-- ##############################################################
function msgbox_update_scaling()
	
--[[
	~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~
	THIS LUA SCRIPT IS SPECIAL BECAUSE IT IS LOADED BEFORE SCREEN SIZE IS SET.
	I WOULD RECOMMEND TALKING TO ME BRIEFLY BEFORE YOU MAKE ANY CHANGES ~MATT GAWALEK
	~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~
--]]


	-- k, our job is, based upon how many items we have, update any scaling that is necessary for our msg box	

	local added_height, handle
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "popup_frame" ), "scale" )

	if ( MBOX_loading_screen == true ) then
		added_height = 0
	else
		-- Calculate the new position and scale for the middle background section
		added_height = 15
		added_height = added_height + (MBOX_num_items - 1) * MBOX_item_group_size_y
		
		--[[
		if ( added_height < 0 ) then
			added_height = 0
		end
		--]]

		-- now in any added height used by the description text field	
		handle = vint_object_find( "description_text" )
		local description_size_x, description_size_y = vint_get_property( handle, "screen_size" )
		local description_delta_height = description_size_y - MBOX_caption_base_size_y
		added_height = added_height + description_delta_height

		-- if there are no hints, then we need to remove the height of the hints from the message box height
		local hint_delta_height
		-- MW: Apparently, this check shouldn't be here and makes some message boxes look weird...
		--if ( vint_get_property( MBOX_hint_group[1], "visible") == false ) then
			added_height = added_height - MBOX_hint_group_size_y
		--end

		-- Lastly, we need to reposition all of the menu items (everything else is auto positioned based on the middle, top, or bottom )
		handle = vint_object_find( "item_group" )
		local item_y = MBOX_item_group_posn_y + description_delta_height / parent_scaley
		for i = 1, MBOX_num_items do
			vint_set_property( MBOX_item_group_handles[i], "anchor", MBOX_item_group_posn_x, item_y)
			item_y = item_y + MBOX_item_group_size_y / parent_scaley
		end
	end

	-- Start by resizing and repositioning the middle piece
	local new_middle_height = MBOX_background_base_size_y + added_height
	local new_middle_pos_y = MBOX_background_base_posn_y - (added_height / 2)
	handle = vint_object_find("popup_middle")
	vint_set_property( handle, "anchor", MBOX_background_base_posn_x, new_middle_pos_y )
	vint_set_property( handle, "screen_size", MBOX_background_base_size_x, new_middle_height )
	
debug_print("vint", "MBOX_background_base_posn_x = "..MBOX_background_base_posn_x.."\n")

	-- Ok now do the top and bottom background pieces based on the middle background piece
	handle = vint_object_find( "popup_top" )
	vint_set_property( handle, "anchor", MBOX_background_base_posn_x, new_middle_pos_y )	-- Set to the same anchor as the middle because the top is SW justified
	handle = vint_object_find( "popup_bottom" )
	vint_set_property( handle, "anchor", MBOX_background_base_posn_x, (new_middle_pos_y + new_middle_height / parent_scaley) )


end

-- ##############################################################
function msgbox_trigger_fadein(play)

	local fadein_anim = vint_object_find("popup_reveal_anim")
	local last_tween = vint_object_find("r6c_alpha")

	if (play) then

		if (MBOX_fading_in == false) then
			MBOX_fading_in = true
			
			vint_set_property( fadein_anim, "start_time", vint_get_time_index() )
			vint_set_child_tween_state( fadein_anim, TWEEN_STATE_IDLE )
			vint_set_property( last_tween, "end_event", "msgbox_fadein_callback" )

			-- Reset the alpha on each one of the animating bits
			vint_set_property(vint_object_find("mask_l1a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l1b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l1c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l2a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l2b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l2c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l3a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l3b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l3c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4d"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4e"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_l4f"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r1a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r1b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r1c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r2a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r2b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r2c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r2d"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r3a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r3b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r3c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r4a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r4b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r4c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r5a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r5b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r5c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r5d"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r6a"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r6b"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r6c"), "alpha", 0.0)
			vint_set_property(vint_object_find("mask_r6d"), "alpha", 0.0)
		end

	else
		if (MBOX_fading_in == true) then
			MBOX_fading_in = false
			menu_tween_fade_in_end()
		end
		
		vint_set_child_tween_state( fadein_anim, TWEEN_STATE_DISABLED )

	end
end

-- ##############################################################
function msgbox_fadein_callback(target_handle, event_name)
	remove_tween_end_callback(target_handle)

	msgbox_trigger_fadein(false)
end


-- ##############################################################
function play_loading_anim()

	-- set all the tickmarks to 0 alpha
	local i
	for i = 1, 5 do
		vint_set_property( vint_object_find( "tick_fill_"..i ), "alpha", 0.0 )
	end

	-- get the handle to the last tick that fades out
	local last_fadeout_tween = vint_object_find( "tick_5_fadeout" )

	-- subscribe to when this tween finishes
	vint_set_property( last_fadeout_tween, "end_event", "tween_end" )
	
	vint_set_property(vint_object_find("loading_group"), "visible", true)
	vint_set_property(vint_object_find("message_boxes"), "visible", false)

	local loading_anim_handle = vint_object_find("loading_anim")
		
	vint_set_child_tween_state( loading_anim_handle, TWEEN_STATE_RUNNING )
	vint_set_property( loading_anim_handle, "start_time", vint_get_time_index() )

end

-- ##############################################################
function stop_loading_anim()

	vint_set_property(vint_object_find("loading_group"), "visible", false)
	vint_set_property(vint_object_find("message_boxes"), "visible", true)
	
	vint_set_child_tween_state( vint_object_find("loading_anim"), TWEEN_STATE_DISABLED )
end


-- ##############################################################
function tween_end()

	local loading_anim_handle = vint_object_find("loading_anim")
		
	vint_set_child_tween_state( loading_anim_handle, TWEEN_STATE_RUNNING )
	vint_set_property( loading_anim_handle, "start_time", vint_get_time_index() )

end


-- ##############################################################
function play_saving_anim()	
	vint_set_property(Small_saving_handle, "visible", true)
		
	vint_set_child_tween_state( Saving_Anim, TWEEN_STATE_RUNNING )
	vint_set_child_tween_state( Saving_fadeout, TWEEN_STATE_DISABLED )
	vint_set_property( Saving_Anim, "start_time", vint_get_time_index() )

end

-- ##############################################################
function stop_saving_anim()	
	vint_set_child_tween_state( Saving_Anim, TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Saving_fadeout, TWEEN_STATE_RUNNING )
	vint_set_property( Saving_fadeout, "start_time", vint_get_time_index() )
	
	vint_set_property( vint_object_find( "small_saving_alpha_twn_1_out" ), "end_event", "saving_fadeout_done" )
end

function saving_fadeout_done()
	vint_set_child_tween_state( Saving_fadeout, TWEEN_STATE_DISABLED )
	vint_set_property(Small_saving_handle, "visible", false)
end


-- ##############################################################
function util_set_text_width( text_handle, max_width )
	-- MW: reset size so that calculations below work as expected
	-- (and so that text that is small enough) fills the box ideally
	vint_set_property( text_handle, "text_scale",MBOX_default_loading_scale_x, MBOX_default_loading_scale_y )
		
	--resize the text if it is too big
	--get the scale
	local text_scale_x,text_scale_y = vint_get_property( text_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "main_group" ), "scale" )

	local text_width,text_height = vint_get_property( text_handle, "screen_size" )
	local text_max_width = max_width * parent_scalex
	local new_scale = text_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > text_max_width ) then
		vint_set_property( text_handle, "text_scale", new_scale, text_scale_y )
	end
end

-- ##############################################################
function util_res_change(data_item_handle, event_name)
	local is_visible,image = vint_dataitem_get(data_item_handle)
	
	if(is_visible == true)then
		vint_set_property(vint_object_find("rfg_bkgrnd_group"), "visible", true )
		vint_set_property(vint_object_find("rfg_bkgrnd_img"), "image", image )
	else
		vint_set_property(vint_object_find("rfg_bkgrnd_group"), "visible", false )
	end
end

-- ##############################################################
function util_set_subtitle(data_item_handle, event_name)
	local update, visible, text, time = vint_dataitem_get(data_item_handle)

	if (update == true) then 
		if( visible ) then
			--set the text
			vint_set_property( vint_object_find( "subtitle_text" ),"text_tag",text)
			vint_set_property( vint_object_find( "subtitle_text_shadow" ),"text_tag",text)
			--show the text
			vint_set_property( vint_object_find( "subtitle_group" ),"visible",true)
			vint_set_property( vint_object_find( "subtitle_group" ),"alpha",1.0)

			--start the anim
			local duration = 0.333
			local fade_out_time = time - duration
			vint_set_property( vint_object_find( "subtitle_group_alpha_twn_1" ),"start_time",fade_out_time)
			vint_set_property( vint_object_find( "subtitle_group_alpha_twn_1" ),"duration",duration)
		
			vint_set_child_tween_state( vint_object_find("subtitle_group_anim_1"), TWEEN_STATE_RUNNING )
			vint_set_property( vint_object_find( "subtitle_group_anim_1" ), "start_time", vint_get_time_index() )
		else
			vint_set_property( vint_object_find( "subtitle_group" ),"visible",false)
		end
	end

end

-- ##############################################################
function util_update_autosave(data_item_handle, event_name)
	local visible, text = vint_dataitem_get(data_item_handle)
	
	if (visible == true and Autosave_icon_visible == false) then
		play_saving_anim()
	elseif (visible == false and Autosave_icon_visible == true) then
		stop_saving_anim()
	end
	
	Autosave_icon_visible = visible
	
	if (Autosave_icon_visible == true) then
		local handle = vint_object_find( "saving_text" )
		local saving_text = vint_get_property(handle, "text_tag")
		if (saving_text ~= text) then
			vint_set_property(handle, "text_tag", text)
			vint_set_property(vint_object_find( "saving_text_shadow" ), "text_tag", text)
		end
	end
end


-- ##############################################################
function play_text_chat_anim()	
	vint_set_property(vint_object_find( "text_chat_group" ), "visible", true)
		
	vint_set_child_tween_state( Text_chat_anim, TWEEN_STATE_RUNNING )
	vint_set_property( Text_chat_anim, "start_time", vint_get_time_index() )
	
	vint_set_property( vint_object_find( "text_chat_hints_alpha_twn_3" ), "end_event", "text_chat_fadeout_done" )
end

-- ##############################################################
function stop_text_chat_anim()	
	vint_set_child_tween_state( Text_chat_anim, TWEEN_STATE_DISABLED )
	vint_set_property( Saving_fadeout, "start_time", vint_get_time_index() )
	
	vint_set_property( vint_object_find( "small_saving_alpha_twn_1_out" ), "end_event", "saving_fadeout_done" )
end

function text_chat_fadeout_done()
	vint_set_child_tween_state( Saving_fadeout, TWEEN_STATE_DISABLED )
	vint_set_property(vint_object_find( "text_chat_group" ), "visible", false)
end

-- ##############################################################
function util_update_voicechat(data_item_handle, event_name)
	local visible, main_text, shadow_text, text_chat_visible, text_chat_hint_text, text_chat_mode_changed = vint_dataitem_get(data_item_handle)
	
	vint_set_property(vint_object_find( "voice_chat_group" ), "visible", visible)
		
	if (visible) then
		vint_set_property(vint_object_find( "voice_chat_users" ), "text_tag", main_text)
		vint_set_property(vint_object_find( "voice_chat_users_shadow" ), "text_tag", shadow_text)
	end
	
	if (text_chat_visible == true and Text_chat_hints_visible == false) then
		play_text_chat_anim()
		text_chat_mode_changed = true
	elseif (text_chat_visible == false and Text_chat_hints_visible == true) then
		text_chat_fadeout_done()
	end
	
	Text_chat_hints_visible = text_chat_visible
	
	if (Text_chat_hints_visible and text_chat_mode_changed) then
		vint_set_property(vint_object_find( "text_chat_hints" ), "text_tag", text_chat_hint_text)
		play_text_chat_anim()
	else
	end
end
		