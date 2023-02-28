RUMPS_TYPE_BASIC_MENU		= 0
RUMPS_TYPE_LOBBY		= 1
RUMPS_TYPE_OPTIONS		= 2
RUMPS_TYPE_MATCHMAKING		= 3
RUMPS_TYPE_WRECKING_CREW	= 4

RUMPS_ROW_Y_FUDGE			= 0
RUMPS_HINT_PADDING			= 20
RUMPS_HEADER_FUDGE			= 5
RUMPS_VETO_FUDGE			= 5
RUMPS_UNSELECTED_DEPTH		= 11
RUMPS_SELECTED_DEPTH		= 0

RUMPS_SELECTION_INDEX		= 0

RUMPS_MAX_ROW_HEIGHT		= 28

RUMPS_ORANGE				= {R=0.83,G=0.54,B=0}
RUMPS_DARK_ORANGE			= {R=0.30,G=0.10,B=0}
RUMPS_IMAGE_GRAY			= {R=0.50,G=0.50,B=0.50}
INVALID_RED			= {R=.9,G=0,B=0}
INVALID_DARK_RED		= {R=.3,G=0,B=0}

RUMPS_IMAGE_1_PREVIOUS			= 0

rumps_row_data_item_handles		= {OBJECT_HANDLES_ROWS = 0}
rumps_row_group_handles		= {OBJECT_HANDLES_ROWS = 0}
rumps_ready_anim_handles	= {OBJECT_HANDLES_ROWS = 0}
rumps_row_group_size			= {0, 0}
rumps_row_total				= 0
rumps_hightlight_base_x			= 0
rumps_hightlight_base_y			= 0
rumps_screen_type			= RUMPS_TYPE_BASIC_MENU

rumps_debug_stack_depth			= 0

rumps_selected_row			= 1

rumps_screen_group_scale_x		= 0
rumps_screen_group_scale_y		= 0

rumps_max_name_width			= 0	

rumps_row_locks				= {}
rumps_row_valid				= {}
rumps_prev_wait				= false

view_gamercard_image = "[button:view_gamercard]"
accept_image = "[button:menu_accept]"


-- ##############################################################
function init_mp_shell_handles()
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rfg_ui_mp_shell_init()\n" )

	local game_module_handle = vint_object_find("mp_shell_game_main")
	local highlight_arrows_handle = vint_object_find("row_highlight_arrows")
	local info_text_handle = vint_object_find("mp_shell_info_text")
	
	--hide the info text till we need it
	vint_set_property(info_text_handle,"visible",false)

	--hide the game module till we need it
	vint_set_property(game_module_handle,"visible",false)

	--hide the toggle arrows till we need them
	vint_set_property(highlight_arrows_handle,"visible",false)

	--hide the tips
	vint_set_property(vint_object_find( "mp_shell_tips_main" ),"visible", false)

	--store the screen group scale
	rumps_screen_group_scale_x,rumps_screen_group_scale_y = vint_get_property(vint_object_find("screen_group"), "scale")

	--get and store the screen size of the row group so we can use the height later when we need 
	--to clone the group and dynamically position it in the list
	local row_parent_handle = vint_object_find("mp_shell_row_main")
	rumps_row_group_size[1], rumps_row_group_size[2] = vint_get_property(row_parent_handle, "screen_size")

	-- Adjust the row size by the screen scale
	rumps_row_group_size[1] = rumps_row_group_size[1] / rumps_screen_group_scale_x
	rumps_row_group_size[2] = rumps_row_group_size[2] / rumps_screen_group_scale_y

	-- Make sure we don't exceed our max height
	if ((rumps_row_group_size[2]) > RUMPS_MAX_ROW_HEIGHT) then
		rumps_row_group_size[2] = RUMPS_MAX_ROW_HEIGHT
	end

	-- hide main guy we clone
	vint_set_property(row_parent_handle, "visible", false)

	-- hide party info by default
	vint_set_property(vint_object_find("mp_shell_preview_main"), "visible", false)
	
	--hide the playlist info by default
	vint_set_property(vint_object_find("mp_shell_playlist_main"), "visible", false)

	--hide veto group by default
	vint_set_property(vint_object_find("mp_shell_veto_main"), "visible", false)

	--stop ready up anim
	vint_set_child_tween_state(vint_object_find("ready_up_anim"), TWEEN_STATE_DISABLED)

	--stop the button anim
	vint_set_child_tween_state(vint_object_find("highlight_flash_anim"), TWEEN_STATE_DISABLED) 

	--hide press start group
	vint_set_property(vint_object_find("mp_shell_start_main"),"visible",false)

	--hide the timer
	vint_set_property(vint_object_find("mp_shell_timer_main"),"visible",false)

	--hide the character select
	vint_set_property(vint_object_find("mp_shell_char_main"),"visible",false)

	--hide the video
	vint_set_property(vint_object_find("mp_shell_video_main"),"visible",false)

	--hide the wrecking crew stuff
	vint_set_property(vint_object_find("mp_shell_wc_main"),"visible",false)

	vint_set_child_tween_state(vint_object_find("image1_anim"), TWEEN_STATE_DISABLED)

end

-- ##############################################################
function rfg_ui_mp_shell_cleanup()
	rumps_debug_print(0, "rfg_ui_mp_shell.lua::rfg_ui_mp_shell_init()\n" )
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rfg_ui_mp_shell_init()
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rfg_ui_mp_shell_init()\n" )

	-- get the handles
	init_mp_shell_handles()

	-- subscribe to the data item whose name is ??, and we listen for updates, so that
	-- it then calls our function ??
	vint_dataitem_add_subscription( "MpShellHintInfo", "update", "rumps_set_hints" )
	vint_dataitem_add_subscription( "MpShellTitles", "update", "rumps_set_titles" )
	vint_dataitem_add_subscription( "MpShellInfoText", "update", "rumps_set_info_text" )
	vint_dataitem_add_subscription( "MpShellHighlightInfo", "update", "rumps_set_highlight" )
	vint_dataitem_add_subscription( "MpShellTypeEnum", "update", "rumps_set_menu_type" )
	vint_dataitem_add_subscription( "MpShellMatchmingHint", "update", "rumps_set_secondary_hint" )
	vint_dataitem_add_subscription( "MpShellGameInfo", "update", "rumps_set_game_module" )
	
	vint_datagroup_add_subscription( "MpShellPlayerInfo", "insert", "rumps_set_player_row_data" )
	vint_datagroup_add_subscription( "MpShellPlayerInfo", "update", "rumps_set_player_row_data" )
	vint_datagroup_add_subscription( "MpShellPlayerInfo", "remove", "rumps_remove_player_row" )
	
	vint_datagroup_add_subscription( "MpShellMenuInfo", "insert", "rumps_set_menu_row_data" )
	vint_datagroup_add_subscription( "MpShellMenuInfo", "update", "rumps_set_menu_row_data" )
	vint_datagroup_add_subscription( "MpShellMenuInfo", "remove", "rumps_remove_player_row" )
	vint_dataitem_add_subscription( "MpShellPartyInfo", "update", "rumps_set_party_info" )

	vint_dataitem_add_subscription( "MpSelectionTween", "update", "rumps_playlist_change" )
	vint_dataitem_add_subscription( "MpShellVetoInfo", "update", "rumps_set_veto_data" )

	vint_dataitem_add_subscription( "MpShellPlaylistInfo", "update", "rumps_set_playlist_data" )

	vint_dataitem_add_subscription( "MpShellPressStart", "update", "rumps_set_press_start" )

	vint_dataitem_add_subscription( "MpShellUpdateTimer", "update", "rumps_set_timer")

	vint_dataitem_add_subscription( "MpShellUpdateTips", "update", "rumps_set_tip_info" )

	vint_dataitem_add_subscription( "MpShellUpdateCharacter", "update", "rumps_set_char_sel" )

	vint_dataitem_add_subscription( "MpShellSetVideo", "update", "rumps_set_video" )

	vint_dataitem_add_subscription( "MpShellWCCharacter", "update", "rumps_set_wc_info" )
	
	-- get the base position of the highlight bar
	local highlight_handle = vint_object_find( "mp_shell_highlight_main" )
	rumps_hightlight_base_x,rumps_hightlight_base_y = vint_get_property( highlight_handle, "anchor" )
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_party_info(data_item_handle, event_name)
	local is_visible,label = vint_dataitem_get(data_item_handle)

	--set the visibility
	vint_set_property( vint_object_find( "party_label" ),"visible", is_visible )
	--set the text

	if (is_visible == true) then
		vint_set_property( vint_object_find( "party_label" ),"text_tag", label )
	end
end

-- ##############################################################
function rumps_set_hints(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_hints("..data_item_handle..", "..event_name..")\n" )
	local hint_text1,hint_text2,hint_text3,hint_text4, hint_text5, sel_img, view_img = vint_dataitem_get(data_item_handle)
	
	accept_image = sel_img
	view_gamercard_image = view_img
	
	vint_set_property(vint_object_find("mp_shell_hint_main" ),"visible",true)

	local hint_text1_handle = vint_object_find("hint_text_1")
	local hint_text2_handle = vint_object_find("hint_text_2")
	local hint_text3_handle = vint_object_find("hint_text_3")
	local hint_text4_handle = vint_object_find("hint_text_4")

	local hint_group_all = vint_object_find("hint_group_all")

	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )
	
	local hint1_width,hint1_height = 0
	local hint1_x,hint1_y = 0

	local hint2_width,hint2_height = 0
	local hint2_x = 0

	local hint3_width,hint3_height = 0
	local hint3_x = 0
	
	vint_set_property(hint_text1_handle,"text_scale", 0.8, 0.8)
	vint_set_property(hint_text2_handle,"text_scale", 0.8, 0.8)
	vint_set_property(hint_text3_handle,"text_scale", 0.8, 0.8)
	vint_set_property(hint_text4_handle,"text_scale", 0.8, 0.8)

	if (hint_text1 ~= nil) then

		vint_set_property( hint_text1_handle,"text_tag", hint_text1 )
		vint_set_property( hint_text1_handle,"visible", true )
		hint1_width,hint1_height = vint_get_property( vint_object_find( "hint_group_1" ),"screen_size" )
		hint1_x,hint1_y = vint_get_property( vint_object_find( "hint_group_1" ),"anchor" )
	else
		vint_set_property( hint_text1_handle,"visible", false )
	end

	if (hint_text2 ~= nil) then

		vint_set_property( hint_text2_handle,"text_tag", hint_text2 )
		vint_set_property( hint_text2_handle,"visible", true )
		hint2_width,hint2_height = vint_get_property( vint_object_find( "hint_group_2" ),"screen_size" )

		hint2_x = hint1_x + (hint1_width/parent_xscale) + RUMPS_HINT_PADDING
		vint_set_property( vint_object_find( "hint_group_2" ),"anchor", hint2_x, hint1_y)
	else
		vint_set_property( hint_text2_handle,"visible", false )
	end

	if (hint_text3 ~= nil) then

		vint_set_property( hint_text3_handle,"text_tag", hint_text3 )
		vint_set_property( hint_text3_handle,"visible", true )
		hint3_width,hint3_height = vint_get_property( vint_object_find( "hint_group_3" ),"screen_size" )

		hint3_x = hint2_x + (hint2_width/parent_xscale) + RUMPS_HINT_PADDING
		vint_set_property( vint_object_find( "hint_group_3" ),"anchor", hint3_x, hint1_y)
	else
		vint_set_property( hint_text3_handle,"visible", false )
	end

	if (hint_text4 ~= nil) then

		vint_set_property( hint_text4_handle,"text_tag", hint_text4 )
		vint_set_property( hint_text4_handle,"visible", true )
		local hintx = hint3_x + (hint3_width/parent_xscale) + RUMPS_HINT_PADDING
		vint_set_property( vint_object_find( "hint_group_4" ),"anchor", hintx, hint1_y)
	else
		vint_set_property( hint_text4_handle,"visible", false )
	end
	
	--determine if all hints together are too big for the screen and scale text accordingly
	local hint_group_x, hint_group_y = vint_get_property(hint_group_all, "screen_size")
	local MAX_WIDTH = 820 * parent_xscale

	if(hint_group_x > MAX_WIDTH) then
		vint_set_property(hint_text1_handle,"text_scale", 0.68, 0.8)

		hint1_width,hint1_height = vint_get_property( vint_object_find( "hint_group_1" ),"screen_size" )
		hint2_x = hint1_x + (hint1_width/parent_xscale) + RUMPS_HINT_PADDING - 2
		vint_set_property( vint_object_find( "hint_group_2" ),"anchor", hint2_x, hint1_y)

		vint_set_property(hint_text2_handle,"text_scale", 0.68, 0.8)

		hint2_width,hint1_height = vint_get_property( vint_object_find( "hint_group_2" ),"screen_size" )
		hint3_x = hint2_x + (hint2_width/parent_xscale) + RUMPS_HINT_PADDING - 2
		vint_set_property( vint_object_find( "hint_group_3" ),"anchor", hint3_x, hint1_y)

		vint_set_property(hint_text3_handle,"text_scale", 0.68, 0.8)

		hint3_width,hint1_height = vint_get_property( vint_object_find( "hint_group_3" ),"screen_size" )
		local hint4_x = hint3_x + (hint3_width/parent_xscale) + RUMPS_HINT_PADDING - 2
		vint_set_property( vint_object_find( "hint_group_4" ),"anchor", hint4_x, hint1_y)

		vint_set_property(hint_text4_handle,"text_scale", 0.68, 0.8)
	end	

	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_menu_type(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_menu_type("..data_item_handle..", "..event_name..")\n" )
	rumps_screen_type = vint_dataitem_get(data_item_handle)
	rumps_debug_print(0, "vint_dataitem_get(data_item_handle="..data_item_handle..") returned rumps_screen_type="..rumps_screen_type.."\n" )

	local header_handle = vint_object_find("mp_shell_header_main")
	local game_group_handle = vint_object_find("mp_shell_game_main")
	local select_arrows_handle = vint_object_find("row_highlight_arrows")
	local select_button_handle = vint_object_find("row_highlight_button")
	
	-- set visibility for global elements
	if(rumps_screen_type == RUMPS_TYPE_BASIC_MENU) then
		rumps_debug_print(0, "rumps_screen_type = RUMPS_TYPE_BASIC_MENU\n");
		vint_set_property(header_handle,"visible",false)
		vint_set_property(game_group_handle,"visible",false)
		
		vint_set_property(select_arrows_handle,"visible",false)
		vint_set_property(vint_object_find("row_highlight_button"), "text_tag", accept_image)
		
	elseif(rumps_screen_type == RUMPS_TYPE_LOBBY) then
		rumps_debug_print(0, "rumps_screen_type = RUMPS_TYPE_LOBBY\n");
		vint_set_property(header_handle,"visible",true)
		vint_set_property(vint_object_find("row_highlight_button"), "text_tag", view_gamercard_image)


	elseif(rumps_screen_type == RUMPS_TYPE_OPTIONS) then
		rumps_debug_print(0, "rumps_screen_type = RUMPS_TYPE_OPTIONS\n");
		vint_set_property(header_handle,"visible",false)
		vint_set_property(game_group_handle,"visible",false)
		vint_set_property(select_arrows_handle,"visible",true)	
		vint_set_property(vint_object_find("row_highlight_button"), "text_tag", accept_image)

	
	elseif(rumps_screen_type == RUMPS_TYPE_MATCHMAKING) then
		rumps_debug_print(0, "rumps_screen_type = RUMPS_TYPE_MATCHMAKING\n");
		vint_set_property(header_handle,"visible",true)
		vint_set_property(game_group_handle,"visible",false)
		vint_set_property(select_button_handle,"visible",true)
		vint_set_property(vint_object_find("row_highlight_button"), "text_tag", view_gamercard_image)
		
	elseif(rumps_screen_type == RUMPS_TYPE_WRECKING_CREW) then
		-- For wrecking crew mainly... its just like options, but needs the map, so we can't hide game_group_handle
		rumps_screen_type = RUMPS_TYPE_LOBBY
		vint_set_property(header_handle,"visible",false)
				
		vint_set_property(select_arrows_handle,"visible",true)	
	end
	
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_titles(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_titles("..data_item_handle..", "..event_name..")\n" )
	local title1,title2 = vint_dataitem_get(data_item_handle)
	
	local title1_handle = vint_object_find( "mp_shell_title1" )
	local title2_handle = vint_object_find( "mp_shell_title2" )
	vint_set_property( title1_handle,"text_tag",title1 )
	vint_set_property( title2_handle,"text_tag",title2 )

	--resize the title if it is too big
	--get the scale
	vint_set_property( title2_handle, "text_scale",0.7,0.8 )
	local text_scale_x,text_scale_y = vint_get_property( title2_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )

	local text_width,text_height = vint_get_property( title2_handle, "screen_size" )
	local name_max_width = 325.0 * parent_scalex
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( title2_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( title2_handle, "text_scale",text_scale_x,text_scale_y )
	end
	
	text_scale_x,text_scale_y = vint_get_property( title1_handle, "text_scale" )
	text_width,text_height = vint_get_property( title1_handle, "screen_size" )
	name_max_width = 380.0 * parent_scalex
	new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( title1_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( title1_handle, "text_scale",text_scale_x,text_scale_y )
	end

	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_info_text(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_info_text("..data_item_handle..", "..event_name..")\n" )
	local show,info_text,img_name,waiting,waiting_label = vint_dataitem_get(data_item_handle)

	local info_text_handle = vint_object_find( "mp_shell_info_text" )
	local game_module_handle = vint_object_find( "mp_shell_game_main" )
	local playlist_handle = vint_object_find( "mp_shell_playlist_main" )
	local map_image_handle = vint_object_find( "game_map_image" )
	local map_caption_handle = vint_object_find( "game_mod_title" )

	vint_set_property( info_text_handle, "visible", false )
	vint_set_property( map_image_handle, "visible", false )
	vint_set_property( map_caption_handle, "visible", false )

	if (show == true) then
		vint_set_property(vint_object_find( "mp_shell_playlist_main" ), "visible", false)
	end

	if ( show == true ) then
		if (img_name ~= nil and img_name ~= "") then
			vint_set_property( map_image_handle, "visible", true )

			local orig_size_x, orig_size_y = vint_get_property( map_image_handle, "screen_size" )
			
			vint_set_property( map_image_handle, "image", img_name )
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(map_image_handle)
			vint_set_property(map_image_handle, "image_size", size_x * scale_x, size_y * scale_y )
			
			vint_set_property( map_image_handle, "screen_size", orig_size_x, orig_size_y )
		else
			vint_set_property( info_text_handle,"visible", true )
			vint_set_property( info_text_handle,"text_tag",info_text )
			vint_set_property(vint_object_find("mp_shell_veto_main"),"visible", false)
		end
	end
	
	if(waiting ~= nil)then
		vint_set_property( vint_object_find( "mp_shell_wait_main"),"visible",waiting)
		
		if(waiting_label ~= nil)then
			vint_set_property( vint_object_find( "wait_text"),"visible",true)
			vint_set_property( vint_object_find( "wait_text"),"text_tag",waiting_label)
		else
			vint_set_property( vint_object_find( "wait_text"),"visible",false)
		end

		if(waiting == true )then
			if( rumps_prev_wait == false )then
				rumps_prev_wait = true
				vint_set_property(vint_object_find( "wait_anim" ), "start_time", vint_get_time_index() )
				vint_set_child_tween_state( vint_object_find( "wait_anim" ), TWEEN_STATE_RUNNING )
			end
		else
			rumps_prev_wait = false
			vint_set_property( vint_object_find( "mp_shell_wait_main"),"visible",false)
			vint_set_child_tween_state( vint_object_find( "wait_anim" ), TWEEN_STATE_DISABLED )
		end
	else
		rumps_prev_wait = false
		vint_set_property( vint_object_find( "mp_shell_wait_main"),"visible",false)
		vint_set_child_tween_state( vint_object_find( "wait_anim" ), TWEEN_STATE_DISABLED )
	end
	
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function set_lobby_preview(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::set_lobby_preview("..data_item_handle..", "..event_name..")\n" )
	local show,title1,value1,title2,value2 = vint_dataitem_get(data_item_handle)
	
	local preview_handle = vint_object_find( "mp_shell_preview_main" )
	local title1_handle = vint_object_find( "preview_party_title" )
	local value1_handle = vint_object_find( "preview_party_value" )
	local title2_handle = vint_object_find( "preview_leader_title" )
	local value2_handle = vint_object_find( "preview_leader_value" )
	vint_set_property( title1_handle,"text_tag",title1 )
	vint_set_property( title2_handle,"text_tag",title2 )
	rumps_debug_print(-1, "end\n" )
end

--###############################################################
function rumps_set_secondary_hint(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_secondary_hint("..data_item_handle..", "..event_name..")\n" )
	local show,title1,value1,hint_button,hint_value = vint_dataitem_get(data_item_handle)
	
	local secondary_hint_handle = vint_object_find( "mp_shell_secondary_main" )
	local title_handle = vint_object_find( "secondary_title" )
	local value_handle = vint_object_find( "secondary_value" )
	local hint_button_handle = vint_object_find( "secondary_button" )
	local hint_value_handle = vint_object_find( "secondary_hint" )
	
	vint_set_property( secondary_hint_handle,"visible",show )

	if (show) then
		vint_set_property(vint_object_find("mp_shell_veto_main"),"visible", false)

		vint_set_property( title_handle,"text_tag",title1 )

		vint_set_property( value_handle,"text_tag",value1 )
		
		if (hint_button == nil or hint_value == nil or hint_button == " " or hint_value == " ") then
			vint_set_property( hint_value_handle,"visible",false )
			vint_set_property( hint_button_handle,"visible",false )
		else
			vint_set_property( hint_value_handle,"visible",true )
			vint_set_property( hint_button_handle,"visible",true )


			vint_set_property( hint_value_handle,"text_tag",hint_value )
			--set the button image
			vint_set_property( hint_button_handle,"text_tag",hint_button )
		end
	end
	rumps_debug_print(-1, "end\n" )
end

--###############################################################
function rumps_set_playlist_data(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_playlist_data("..data_item_handle..", "..event_name..")\n" )
	local show,title1,value1,title2,value2,title3,value3,title4,value4,info = vint_dataitem_get(data_item_handle)
	
	local playlist_handle = vint_object_find( "mp_shell_playlist_main" )
	local game_module_handle = vint_object_find( "mp_shell_game_main" )
	local title_handle = vint_object_find( "playlist_header_title" )
	local value_handle = vint_object_find( "playlist_header_value" )
	local title2_handle = vint_object_find( "playlist_players_title" )
	local value2_handle = vint_object_find( "playlist_players_value" )
	local title3_handle = vint_object_find( "playlist_map_title" )
	local value3_handle = vint_object_find( "playlist_map_value" )
	local title4_handle = vint_object_find( "playlist_max_title" )
	local value4_handle = vint_object_find( "playlist_max_value" )
	
	vint_set_property( playlist_handle,"visible",show )

	-- If we're showing playlist info, hide game info
	if (show == true) then
		vint_set_property( vint_object_find( "mp_shell_info_text" ),"visible",false )
		vint_set_property( game_module_handle, "visible", false )
		
	end

	if (show == true) then
		vint_set_property( title_handle,"text_tag",title1 )
		vint_set_property( value_handle,"text_tag",value1 )
		vint_set_property( title2_handle,"text_tag",title2 )
		vint_set_property( value2_handle,"text_tag",value2 )
		vint_set_property( title3_handle,"text_tag",title3 )
		vint_set_property( value3_handle,"text_tag",value3 )
		vint_set_property( title4_handle,"text_tag",title4 )
		vint_set_property( value4_handle,"text_tag",value4 )
	end
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_menu_row_data(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_menu_row_data("..data_item_handle..", "..event_name..")\n" )

	local row_id,row_name,row_text,row_locked,is_valid = vint_dataitem_get(data_item_handle)
	rumps_debug_print(0, "vint_dataitem_get(data_item_handle = "..data_item_handle..") returned row_id="..row_id..",row_name="..row_name..",row_text="..row_text.."\n" )

	if ( event_name == "insert" ) then
		rumps_add_player_row(data_item_handle)
	end
	
	--store a handle to the group
	local row_parent_handle = rumps_row_group_handles[row_id]
	rumps_debug_print(0, "row_parent_handle = rumps_row_group_handles[row_id] = "..rumps_row_group_handles[row_id].."\n" )

	--store a handle to all the row objects
	local row_image_handle = vint_object_find( "row_image", row_parent_handle )
	local row_name_handle = vint_object_find( "row_name", row_parent_handle )
	local row_team_handle = vint_object_find( "row_team", row_parent_handle )
	--local row_level_handle = vint_object_find( "row_level", row_parent_handle )
	local row_mute_handle = vint_object_find( "row_mute", row_parent_handle )
	local row_leader_handle = vint_object_find( "row_leader", row_parent_handle )
	local row_text_handle = vint_object_find( "row_text", row_parent_handle )
	
	vint_set_property( row_image_handle,"visible",false )
	vint_set_property( row_name_handle,"visible",true )
	vint_set_property( row_team_handle,"visible",false )
	vint_set_property( row_mute_handle,"visible",false )
	vint_set_property( row_leader_handle,"visible",false )
	vint_set_property( row_text_handle,"visible",true )
	

	vint_set_property( row_name_handle,"text_tag",row_name )
	vint_set_property( row_text_handle,"text_tag",row_text )

	--get the scale
	local text_scale_x = 0.75
	local text_scale_y = 0.80
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )

	vint_set_property( row_text_handle, "text_scale", text_scale_x, text_scale_y )
	local text_width,text_height = vint_get_property( row_text_handle, "screen_size" )
	local name_max_width = 206.0 * parent_scalex
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( row_text_handle, "text_scale", new_scale, text_scale_y )
	end

	vint_set_property( row_name_handle, "text_scale", text_scale_x, text_scale_y )
	local text_width,text_height = vint_get_property( row_name_handle, "screen_size" )
	local name_max_width = 168 * parent_scalex
	local new_scale = name_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > name_max_width )then
		vint_set_property( row_name_handle, "text_scale", new_scale, text_scale_y )
	end
	
	-- - 1 adjust for incorrect index
	rumps_set_text_highlight(rumps_selected_row - 1)

	--offset highlight bg, black box
	local xtoset,bogus_y = vint_get_property( row_image_handle,"anchor")
	local bg_x,ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
	bg_x = 115
	vint_set_property( vint_object_find("row_highlight_bg"),"anchor", bg_x, ytoset )
	
	--set the position of the name text field based on the highlight bg x pos
	local name_old_x,name_ytoset = vint_get_property( row_name_handle,"anchor")
	local new_bg_x,bg_ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
	local name_new_x = new_bg_x - 116--116 is the amount difference in offset

	local bg_scale_x,bg_scale_y = vint_get_property( vint_object_find("row_highlight_bg"),"scale")
	vint_set_property( vint_object_find("row_highlight_bg"),"scale", 200, bg_scale_y )

	-- need to move the name over even more in Arabic
	if (rfg_get_language_right_to_left() == true) then
		name_new_x = name_new_x + 165
	end
	vint_set_property( row_name_handle,"anchor", name_new_x, name_ytoset )


	--4:3 correction
	local x_size,bogus_ysize = vint_get_property( vint_object_find("row_highlight_bg"),"screen_size")
	
	local highlight_arrow_handle = vint_object_find( "row_highlight_arrows" )
	local arrow_size_x,arrow_size_y = vint_get_property( highlight_arrow_handle,"screen_size")
	local arrow_x,arrow_y = vint_get_property( highlight_arrow_handle,"anchor")
	
	if (rfg_get_language_right_to_left() == false) then
		arrow_x = bg_x + (x_size/rumps_screen_group_scale_x) - (arrow_size_x/rumps_screen_group_scale_x)
	else
		arrow_x = bg_x + 10
	end
	
	vint_set_property( highlight_arrow_handle,"anchor", arrow_x, arrow_y )

	--debug_print("vint","RUMPS_TYPE_OPTIONS\n")

		-- HACK: If this row is locked, replace the leader icon with the lock icon
	if (row_locked == true) then
		vint_set_property(row_leader_handle, "visible", true)
		vint_set_property(row_leader_handle, "image", "ui_hud_icon_lock")
	end
	
	--store the row lock and validification for use in the text highlight function
	rumps_row_valid[row_id] = is_valid
	rumps_row_locks[row_id] = row_locked

	rumps_debug_print(-1, "end\n" )
end


-- ##############################################################
function rumps_set_player_row_data(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_player_row_data("..data_item_handle..", "..event_name..")\n" )

	local row_id,row_image_tex_handle,row_name,row_team,row_level,row_mute,row_leader,row_party,row_locked,ready_visible,row_ready, hide_row = vint_dataitem_get(data_item_handle)
	rumps_debug_print(0, "vint_dataitem_get(data_item_handle = "..data_item_handle..") returned row_id="..row_id..",row_image_tex_handle="..row_image_tex_handle..",row_name="..row_name..",row_team="..row_team..",row_level="..row_level..",row_mute=BOOL,row_leader=BOOL\n" )

	if ( event_name == "insert" ) then
		rumps_add_player_row(data_item_handle)
	end
	
	--store a handle to the group
	local row_parent_handle = rumps_row_group_handles[row_id]
	rumps_debug_print(0, "row_parent_handle = rumps_row_group_handles[row_id] = "..rumps_row_group_handles[row_id].."\n" )
	
	if (hide_row ~= nil) then		
		vint_set_property( row_parent_handle, "visible", not hide_row)
	end

	--store a handle to all the row objects
	local row_image_handle = vint_object_find( "row_image", row_parent_handle )
	local row_name_handle = vint_object_find( "row_name", row_parent_handle )
	local row_team_handle = vint_object_find( "row_team", row_parent_handle )
	--local row_level_handle = vint_object_find( "row_level", row_parent_handle )
	local row_mute_handle = vint_object_find( "row_mute", row_parent_handle )
	local row_leader_handle = vint_object_find( "row_leader", row_parent_handle )
	local row_text_handle = vint_object_find( "row_text", row_parent_handle )
	local row_ready_handle =  vint_object_find( "row_ready", row_parent_handle )
	local row_ready2_handle =  vint_object_find( "row_ready2", row_parent_handle )
	local ready_up_anim = rumps_ready_anim_handles[row_id]
	
	--set the gamertag pic
	vint_set_property( row_image_handle,"image_badge",row_image_tex_handle )
	
	--set the gamertag name
	rumps_debug_print(0, "vint_set_property( row_name_handle="..row_name_handle..",\"text_tag\",row_name=\""..row_name.."\")\n" )
	vint_set_property( row_name_handle,"text_tag",row_name )

	
	--set the team icon
	vint_set_property( row_team_handle,"visible",false)

	if(row_team == 0)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_guerrilla" )
	elseif(row_team == 1)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_edf" )
	elseif(row_team == 3)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_spec" )
	end

	--set the mute icon
	vint_set_property( row_mute_handle, "visible", false )

	if(row_mute == 0)then
		--player is muted
		vint_set_property( row_mute_handle, "visible", true )
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute3" )
	elseif(row_mute == 1)then
		--player is not muted
		vint_set_property( row_mute_handle, "visible", true )
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute2" )
	elseif(row_mute == 2)then
		--player is not muted and talking
		vint_set_property( row_mute_handle, "visible", true )
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute" )
	end
	
	vint_set_property( row_leader_handle,"visible",false )

	--set the leader icon
	if(row_leader == true)then
		--player is leader show the icon
		vint_set_property( row_leader_handle,"visible",true )
		vint_set_property( row_leader_handle,"image","ui_fend_icon_leader" )
	elseif(row_party == true) then
		vint_set_property( row_leader_handle,"visible",true )
		vint_set_property( row_leader_handle,"image","ui_fend_icon_party" )
	end

	-- HACK: If this row is locked, replace the leader icon with the lock icon
	if (row_locked == true) then
		vint_set_property(row_leader_handle, "visible", true)
		vint_set_property(row_leader_handle, "image", "ui_hud_icon_lock")
	end

	vint_set_property(row_ready2_handle,"visible",false)

	if( row_ready ~= nil )then
		vint_set_property(row_ready_handle,"visible",ready_visible)
		if(row_ready == true)then
			vint_set_property(row_ready_handle,"image","ui_fend_check_box")
			vint_set_property(row_ready2_handle,"image","ui_fend_check_box")
			vint_set_property(row_ready2_handle,"visible",true)
			vint_set_property(ready_up_anim, "start_time", vint_get_time_index())
			vint_set_child_tween_state(ready_up_anim, TWEEN_STATE_IDLE)
		else
			vint_set_property(row_ready_handle,"image","ui_fend_uncheck_box")
		end
	else
		vint_set_property(row_ready_handle,"visible",false)
	end
	
	--store the row lock for use in the text highlight function
	rumps_row_locks[row_id] = row_locked

	debug_print("vint","row_id = "..row_id..", row_locked = "..tostring(row_locked).."\n")

	vint_set_property( row_text_handle, "visible", false)
	
	--set visibility
	if(rumps_screen_type == RUMPS_TYPE_BASIC_MENU) then
		--set the button text
		vint_set_property( row_name_handle,"text_tag",row_name )

		--fit the name text
		local text_scale_x = 0.70
		local text_scale_y = 0.8
		local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )

		local text_width,text_height = vint_get_property( row_name_handle, "screen_size" )
		local name_max_width = 300.0 * parent_scalex
		local new_scale = name_max_width/text_width * text_scale_x
		--make the text fit
		if( text_width > name_max_width )then
			vint_set_property( row_name_handle, "text_scale", new_scale, text_scale_y )
		else
			vint_set_property( row_name_handle, "text_scale",text_scale_x,text_scale_y )
		end

		vint_set_property( row_image_handle,"visible",false )
		vint_set_property( row_name_handle,"visible",true )
		vint_set_property( row_team_handle,"visible",false )
		vint_set_property( row_mute_handle,"visible",false )

		--offset highlight bg, black box
		local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )
		local image_x,bogus_y = vint_get_property( row_image_handle,"anchor")
		local xtoset,ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
		xtoset = 115

		vint_set_property( vint_object_find("row_highlight_bg"),"anchor", xtoset, ytoset )

		local bg_scale_x,bg_scale_y = vint_get_property( vint_object_find("row_highlight_bg"),"scale")

		--resize the highlight black box to fit the longest string
		--PRETTY WAY DOES NOT WORK
		--[[local name_width,name_height = vint_get_property( row_name_handle,"screen_size")
		local bg_width,bg_height = vint_get_property( vint_object_find("row_highlight_bg"),"screen_size")
		local new_name_width = name_width + 20
		if( new_name_width > rumps_max_name_width )then
			vint_set_property( vint_object_find("row_highlight_bg"),"screen_size", new_name_width, bg_height )
			rumps_max_name_width = new_name_width
		end]]
		--HACK VERSION OF PRETTY WAY
		local bg_width,bg_height = vint_get_property( vint_object_find("row_highlight_bg"),"screen_size")
		vint_set_property( vint_object_find("row_highlight_bg"),"screen_size", (345*parent_scalex), bg_height )
		
		--debug_print("vint","RUMPS_TYPE_BASIC_MENU\n")	

	elseif(rumps_screen_type == RUMPS_TYPE_LOBBY or rumps_screen_type == RUMPS_TYPE_MATCHMAKING) then
		vint_set_property( row_image_handle,"visible",true )
		vint_set_property( row_name_handle,"visible",true )

		local bg_x,ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
		bg_x = 170
		vint_set_property( vint_object_find("row_highlight_bg"),"anchor", bg_x, ytoset )
		
		local bg_scale_x,bg_scale_y = vint_get_property( vint_object_find("row_highlight_bg"),"scale")
		vint_set_property( vint_object_find("row_highlight_bg"),"scale", 260, bg_scale_y )

		--get the scale
		local text_scale_x,text_scale_y = vint_get_property( row_name_handle, "text_scale" )
		local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )

		local text_width,text_height = vint_get_property( row_name_handle, "screen_size" )
		local name_max_width = 220.0 * parent_scalex
		local new_scale = name_max_width/text_width * text_scale_x
		--make the text fit
		if( text_width > name_max_width )then
			vint_set_property( row_name_handle, "text_scale", new_scale, text_scale_y )
		else
			vint_set_property( row_name_handle, "text_scale",text_scale_x,text_scale_y )
		end

		--debug_print("vint","RUMPS_TYPE_LOBBY\n")
	end
	
	--set the position of the name text field based on the highlight bg x pos
	local name_old_x,name_ytoset = vint_get_property( row_name_handle,"anchor")
	local new_bg_x,bg_ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
	local name_new_x = new_bg_x - 116--116 is the amount difference in offset
	
	-- need to move the name over even more in Arabic
	if (rfg_get_language_right_to_left() == true) then
		local highlight_bg_size_x, highlight_bg_size_y = vint_get_property(vint_object_find("row_highlight_bg"),"scale")
		name_new_x = name_new_x + highlight_bg_size_x - 10
	end

	vint_set_property( row_name_handle,"anchor", name_new_x, name_ytoset )

	local bg_x,ytoset = vint_get_property( vint_object_find("row_highlight_bg"),"anchor")
	local highlight_arrow_handle = vint_object_find( "row_highlight_arrows" )
	local arrow_size_x,arrow_size_y = vint_get_property( highlight_arrow_handle,"screen_size")
	local x_size,bogus_ysize = vint_get_property( vint_object_find("row_highlight_bg"),"screen_size")
	local arrow_x,arrow_y = vint_get_property( highlight_arrow_handle,"anchor")

	if (rfg_get_language_right_to_left() == false) then
		arrow_x = bg_x + (x_size/rumps_screen_group_scale_x) - (arrow_size_x/rumps_screen_group_scale_x)
	else
		arrow_x = bg_x + 10
	end
	vint_set_property( highlight_arrow_handle,"anchor", arrow_x, arrow_y )
	
	-- - 1 adjust for incorrect index
	rumps_set_text_highlight(rumps_selected_row - 1)
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_set_press_start(data_item_handle, event_name)
	local is_visible,button_name,ready_text,start_text = vint_dataitem_get(data_item_handle)
	--TODO WE NEED TO SET ALL THE TEXT HERE AND BUTTON ICONS
	local start_group_handle = vint_object_find( "mp_shell_start_main" )
	local dags_handle = vint_object_find( "game_start_dags" )
	local start_button_handle = vint_object_find( "game_start_button" )
	local start_title_handle = vint_object_find( "game_start_title" )
	local ready_title_handle = vint_object_find( "game_ready_title" )
	local waiting_text_handle = vint_object_find( "game_waiting_text" )
	--show the ready start, only for custom match admin
	vint_set_property( vint_object_find( "mp_shell_start_main" ),"visible",is_visible )

	if (is_visible == true) then
		--set the text for non leader
		if(start_text ~= nil)then
			vint_set_property( start_title_handle, "text_tag", start_text )
		end

		if (ready_text ~= nil) then
			vint_set_property(ready_title_handle, "text_tag", ready_text)
		end
		--hide the button if we don't need it
		if(button_name ~= nil)then
			vint_set_property( start_button_handle,"visible", true )
			vint_set_property( waiting_text_handle, "visible", false )
			vint_set_property( start_title_handle, "visible", true )
			vint_set_property( start_button_handle,"text_tag", button_name )
			local parent_scalex,parent_scaley = vint_get_property(vint_object_find( "screen_group" ),"scale")
			local button_x,button_y = vint_get_property(start_button_handle,"anchor")
			local text_x,text_y = vint_get_property(start_title_handle,"anchor")
			local text_width,text_height = vint_get_property(start_title_handle,"screen_size")
			local adjusted_width = text_x + ( text_width / parent_scalex ) + 10
			vint_set_property( start_button_handle, "anchor", adjusted_width, button_y )
		else
			vint_set_property( waiting_text_handle,"text_tag", start_text )
			vint_set_property( waiting_text_handle,"visible", true )
			vint_set_property( start_button_handle,"visible", false )
			vint_set_property( start_title_handle, "visible", false )
		end
	end	
end

-- ##############################################################
function rumps_set_game_module(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_game_module("..data_item_handle..", "..event_name..")\n" )

	local show,settings_title,mode_title,mode_value,map_title,map_value,score_title,score_value,time_title,time_value,equip_title,equip_value,other_title,other_value,show_dags = vint_dataitem_get(data_item_handle)

	rumps_debug_print(0, "show = " .. tostring(show) .. "\n")
	
	local game_module_handle = vint_object_find( "mp_shell_game_main" )
	local playlist_handle = vint_object_find( "mp_shell_playlist_main" )
	local settings_title_handle = vint_object_find( "game_settings_title" )
	local mode_title_handle = vint_object_find( "game_mode_title" )
	local mode_value_handle = vint_object_find( "game_mode_value" )
	local map_title_handle = vint_object_find( "game_map_title" )
	local map_value_handle = vint_object_find( "game_map_value" )
	local score_title_handle = vint_object_find( "game_score_title" )
	local score_value_handle = vint_object_find( "game_score_value" )
	local time_title_handle = vint_object_find( "game_time_title" )
	local time_value_handle = vint_object_find( "game_time_value" )
	local equip_title_handle = vint_object_find( "game_equip_title" )
	local equip_value_handle = vint_object_find( "game_equip_value" )
	local other_title_handle = vint_object_find( "game_other_title" )
	local other_value_handle = vint_object_find( "game_other_value" )
	local map_image_handle = vint_object_find( "game_map_image" )

	--show the game module?
	vint_set_property( game_module_handle,"visible",show )

	-- If we're showing game info, hide playlist info
	if (show == true) then
		vint_set_property( vint_object_find( "mp_shell_info_text" ),"visible",false )
		vint_set_property( playlist_handle, "visible", false )
	end 

	--set all the data for the game settings module
	if (show == true) then
		vint_set_property(mode_value_handle, "text_scale", 0.64, 0.7)
		vint_set_property( settings_title_handle,"text_tag",settings_title )
		vint_set_property( mode_title_handle,"text_tag",mode_title )
		vint_set_property( mode_value_handle,"text_tag",mode_value )
		vint_set_property( map_title_handle,"text_tag",map_title )
		vint_set_property( map_value_handle,"text_tag",map_value )
		vint_set_property( score_title_handle,"text_tag",score_title )
		vint_set_property( score_value_handle,"text_tag",score_value )
		vint_set_property( time_title_handle,"text_tag",time_title )
		vint_set_property( time_value_handle,"text_tag",time_value )
		vint_set_property( equip_title_handle,"text_tag",equip_title )
		vint_set_property( equip_value_handle,"text_tag",equip_value )
		vint_set_property( other_title_handle,"text_tag",other_title )
		vint_set_property( other_value_handle,"text_tag",other_value )

		--resize time text
		resize_text(time_title_handle)

		--move the other field down if the equipment field wrapped
		local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ),"scale" )
		local equip_width,equip_height = vint_get_property( equip_value_handle,"screen_size" )
		local equip_x,equip_y = vint_get_property( equip_value_handle,"anchor" )
		local other_x,other_y = vint_get_property( vint_object_find( "game_other_group" ),"anchor" )
		local new_y = equip_y + (equip_height / parent_scaley) + RUMPS_HEADER_FUDGE

		vint_set_property( vint_object_find( "game_other_group" ),"anchor", other_x, new_y )

		--resize mode value text if too long
		local mode_value_x, mode_value_y = vint_get_property(mode_value_handle, "screen_size")
		local MAX_WIDTH = 170 * parent_scalex

		if(mode_value_x > MAX_WIDTH) then
			vint_set_property(mode_value_handle, "text_scale", 0.58, 0.7)
		end
	end

	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function resize_text(handle)

	vint_set_property(handle, "text_scale", 0.6, 0.7)
	local text_width, text_height = vint_get_property(handle, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"),"scale")
	local MAX_TEXT_WIDTH_1 = 190 * parent_scale_x

	if(text_width > MAX_TEXT_WIDTH_1) then

		vint_set_property(handle, "text_scale", 0.45, 0.6)

	end
	
end

-- ##############################################################
function rumps_set_text_highlight(index)
	--is the index valid
	--set the depths
	vint_set_property(rumps_row_group_handles[rumps_selected_row], "depth", RUMPS_UNSELECTED_DEPTH )
	
	rumps_selected_row = index + 1

	vint_set_property(rumps_row_group_handles[rumps_selected_row], "depth", RUMPS_SELECTED_DEPTH )

	--loop through all the rows and set the highlight/unhighlight state
	for i=1,rumps_row_total do
		--store a handle to the parent group
		local row_parent_handle = rumps_row_group_handles[i]
		--set the default color to unhighlight
		local r = 0.5
		local g = 0.25
		local b = 0
		local dag_vis = vint_get_property( vint_object_find( "row_bg", row_parent_handle ),"visible")
		
		--set the dag visibility
		if( vint_mod( i, 2 ) == 1 )then
			vint_set_property( vint_object_find( "row_bg", row_parent_handle ), "visible", true )
		else
			vint_set_property( vint_object_find( "row_bg", row_parent_handle ), "visible", false )
		end
		
		if(rumps_row_locks[i] == true)then
			r = 0.30
			g = 0.18
			b = 0
		end
		
		if(rumps_row_valid[i] == false) then
			r = INVALID_RED.R
			g = INVALID_RED.G
			b = INVALID_RED.B
		end
		vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", r,g,b )

		--if row highlighted change color and alpha
		if( i == (index + 1) ) then
			if rumps_row_valid[i] == false then
				-- if the row isn't valid, make things red and darker red
				vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", r,g,b )
				vint_set_property( vint_object_find( "row_text", row_parent_handle ),"tint", INVALID_DARK_RED.R,INVALID_DARK_RED.G,INVALID_DARK_RED.B )
			else
				--everything should be black except the name, so make it bright orange
				r = 0
				g = 0
				b = 0
				
				vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", 1,0.5,0 )
				-- and set the text color black
				vint_set_property( vint_object_find( "row_text", row_parent_handle ),"tint", r,g,b )
			end
			vint_set_property( vint_object_find( "row_bg", row_parent_handle ), "visible", false )
		else
			--set the text color if we aren't highlighted
			vint_set_property( vint_object_find( "row_text", row_parent_handle ),"tint", r,g,b )
		end
		
		--set the team icon color
		vint_set_property( vint_object_find( "row_team", row_parent_handle ),"tint", r,g,b)
		
		--set the player level color
		--vint_set_property(  vint_object_find( "row_level", row_parent_handle ),"tint", r,g,b )

		--set the mute icon color
		vint_set_property( vint_object_find( "row_mute", row_parent_handle ),"tint", r,g,b )

		--set the leader icon color
		vint_set_property(  vint_object_find( "row_leader", row_parent_handle ),"tint", r,g,b )

	end
end

-- ##############################################################
function rumps_set_highlight(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_set_highlight("..data_item_handle..", "..event_name..")\n" )

	if(event_name ~= "update") then
		rumps_debug_print(0, "rfg_ui_mp_shell.lua::rumps_set_highlight() called for non-update event. Badness!\n")
	end
	--will get a zero based index of the items
	local selection, button_image, arrows_visible = vint_dataitem_get(data_item_handle)
	RUMPS_SELECTION_INDEX = selection

	rumps_debug_print(0, "selection = " .. tostring(selection) .. "\tbutton_image = " .. tostring(button_image) .. "\tarrows_visible = " .. tostring(arrows_visible) .. "\n")
	
	--debug_print("vint","BUTTON = "..button_image.."\n")
	if(button_image ~= nil)then
		vint_set_property(vint_object_find("row_highlight_button"), "visible", true )	
		vint_set_property(vint_object_find("row_highlight_button"), "text_tag", button_image )
	else
		vint_set_property(vint_object_find("row_highlight_button"), "visible", false )
		
	end
	
	local row_handle = vint_object_find( "mp_shell_row_main" )
	local screen_sizex, screen_sizey = vint_get_property( row_handle, "screen_size" )
	
	local new_anchory = rumps_hightlight_base_y + selection*(rumps_row_group_size[2] + RUMPS_ROW_Y_FUDGE)

	local highlight_handle = vint_object_find( "mp_shell_highlight_main" )

	--is selection valid
	if(selection >= 0) then
		--show the highlight
		vint_set_property(highlight_handle, "visible", true )
		vint_set_property(vint_object_find("mp_shell_shadow_main"), "visible", true )
		--set the highlight x and y to the highlighted row
		vint_set_property(highlight_handle, "anchor", rumps_hightlight_base_x, new_anchory )
		vint_set_property(vint_object_find("mp_shell_shadow_main"),"anchor", rumps_hightlight_base_x, new_anchory)
		rumps_debug_print(0, "Changed highlight anchor to "..rumps_hightlight_base_x..","..new_anchory.." (index "..selection..")\n" )
	else
		vint_set_property(highlight_handle, "visible", false )
		vint_set_property(vint_object_find("mp_shell_shadow_main"), "visible", false )
		rumps_debug_print(0, "Changed highlight hidden\n" )
	end
	
	--set the row specific color and alpha highlight values
	rumps_set_text_highlight(selection)

	local highlight_arrow_handle = vint_object_find( "row_highlight_arrows" )
	
	vint_set_property(highlight_arrow_handle, "visible", arrows_visible )

	rumps_debug_print(-1, "end\n" )
end


-- ##############################################################
function rumps_add_player_row(data_item_handle)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_add_player_row("..data_item_handle..")\n" )

	local prev = rumps_row_total
	local new_cnt = rumps_row_total + 1
	
	-- k, clone the row group
	local row_parent_handle = vint_object_find( "mp_shell_row_main" )
	rumps_debug_print(0, "vint_object_find( \"mp_shell_row_main\" ) returned "..row_parent_handle.."\n" )
	rumps_row_group_handles[new_cnt] = vint_object_clone_rename(row_parent_handle, "mp_shell_row_main"..new_cnt )
	rumps_ready_anim_handles[new_cnt] = vint_anim_clone_and_retarget(vint_object_find("ready_up_anim"),rumps_row_group_handles[new_cnt])
	rumps_debug_print(0, "vint_object_clone_rename(row_parent_handle = "..row_parent_handle..", \"mp_shell_row_main\"..new_cnt = \"mp_shell_row_main"..new_cnt.."\" ) returned "..rumps_row_group_handles[new_cnt].."\n" )

			
	-- make visible
	vint_set_property( rumps_row_group_handles[new_cnt], "visible", true )
	rumps_debug_print(0, "vint_set_property( rumps_row_group_handles[new_cnt="..new_cnt.."] = "..rumps_row_group_handles[new_cnt]..", \"visible\", true )\n" )
	
	-- k, setup the positions - get the previous item's position
	local anchor_x, anchor_y
	local new_y
	if ( prev == 0 ) then
		anchor_x, anchor_y = vint_get_property( row_parent_handle, "anchor" )
		rumps_debug_print(0, "vint_get_property( row_parent_handle = "..row_parent_handle..", \"anchor\" ) returned "..anchor_x..","..anchor_y.."\n" )
	else
		anchor_x, anchor_y = vint_get_property( rumps_row_group_handles[prev], "anchor" )

		new_y = anchor_y + rumps_row_group_size[2]
		vint_set_property( rumps_row_group_handles[new_cnt], "anchor", anchor_x, new_y )

		--anchor_x, anchor_y = vint_get_property( rumps_row_group_handles[prev], "anchor" )
		rumps_debug_print(0, "vint_get_property( rumps_row_group_handles[prev="..prev.."] = "..rumps_row_group_handles[prev]..", \"anchor\" ) returned "..anchor_x..","..anchor_y.."\n" )
		
		--local new_y = anchor_y + rumps_row_group_size[2] + RUMPS_ROW_Y_FUDGE
		--vint_set_property( rumps_row_group_handles[new_cnt], "anchor", anchor_x, new_y )
		rumps_debug_print(0, "vint_set_property( rumps_row_group_handles[new_cnt="..new_cnt.."] = "..rumps_row_group_handles[new_cnt]..", \"anchor\","..anchor_x..", "..new_y.." )\n" )
	end

	--set the depth
	vint_set_property( rumps_row_group_handles[new_cnt], "depth", RUMPS_UNSELECTED_DEPTH )

	--set the dag visibility
	if( vint_mod( new_cnt, 2 ) == 1 )then
		vint_set_property( vint_object_find( "row_bg", rumps_row_group_handles[new_cnt] ), "visible", true )
	else
		vint_set_property( vint_object_find( "row_bg", rumps_row_group_handles[new_cnt] ), "visible", false )
	end
	
	-- keep track of the data item handle
	rumps_row_data_item_handles[new_cnt] = data_item_handle
	rumps_debug_print(0, "rumps_row_data_item_handles[new_cnt="..new_cnt.."] = data_item_handle = "..data_item_handle.."\n" )

	-- bump cnt
	rumps_row_total = new_cnt
	rumps_debug_print(0, "rumps_row_total = new_cnt = "..new_cnt.."\n" )
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_remove_player_row(data_item_handle, event_name)
	rumps_debug_print(1, "rfg_ui_mp_shell.lua::rumps_remove_player_row("..data_item_handle..", "..event_name..")\n" )
	
	-- k, simply delete the last one	
	rumps_row_data_item_handles[rumps_row_total] = 0
	
	-- now delete this item!
	vint_object_destroy(rumps_row_group_handles[rumps_row_total])
	rumps_row_group_handles[rumps_row_total] = 0
	vint_object_destroy(rumps_ready_anim_handles[rumps_row_total])
	rumps_ready_anim_handles[rumps_row_total] = 0

	local new_cnt = rumps_row_total - 1
	rumps_row_total = new_cnt
	rumps_debug_print(-1, "end\n" )
end

-- ##############################################################
function rumps_debug_print(stack_change, text_to_print)
	local stack_tabs = rumps_debug_stack_depth
	while(stack_tabs > 0) do
		debug_print( "mp_vint", "\t" )
		stack_tabs = stack_tabs - 1
	end
	debug_print( "mp_vint", text_to_print )
	rumps_debug_stack_depth = rumps_debug_stack_depth + stack_change
end

-- ##############################################################
function rumps_playlist_change(data_item_handle, event_name)
	--get the data
	local is_playing = vint_dataitem_get(data_item_handle)
	--if insert event then start the animation
	if ( is_playing == true ) then
		rumps_debug_print(0, "TWEEN START\n")
		--start the button anim
		vint_set_child_tween_state( vint_object_find( "highlight_flash_anim" ), TWEEN_STATE_RUNNING )	
	else
		rumps_debug_print(0, "TWEEN STOP\n")
		vint_set_child_tween_state( vint_object_find( "highlight_flash_anim" ), TWEEN_STATE_DISABLED )
		--restore the alpha incase we were previosly playing the animation
		vint_set_property( vint_object_find( "row_highlight" ),"alpha", 1.0 )
	end
end

-- ##############################################################
function rumps_set_timer(data_item_handle, event_name)
	--get the data
	local is_visible, timer_label, timer_value = vint_dataitem_get(data_item_handle)
	
	if (timer_label == nil or timer_value == nil) then
		is_visible = false
	end
	vint_set_property(vint_object_find("mp_shell_timer_main"),"visible", is_visible)
	--set the timer
	vint_set_property(vint_object_find("mp_shell_title"),"text_tag", timer_label)
	vint_set_property(vint_object_find("mp_shell_timer"),"text_tag", timer_value)

	local parent_xscale,parent_yscale = vint_get_property(vint_object_find("screen_group"),"scale")
	--layout the timer text
	local title_x,title_y = vint_get_property(vint_object_find("mp_shell_title"),"anchor")
	local title_width,title_height = vint_get_property(vint_object_find("mp_shell_title"),"screen_size")
	local new_x = title_x + title_width/parent_xscale
	vint_set_property( vint_object_find( "mp_shell_timer_group" ),"anchor", new_x, title_y )
end

-- ##############################################################
function rumps_set_veto_data(data_item_handle, event_name)
	--get the data
	local is_visible, can_veto, hint_text, hint_button, vote_total,
		votes_required,next_map = vint_dataitem_get(data_item_handle)

	vint_set_property(vint_object_find("mp_shell_veto_main"),"visible", is_visible)
	if( is_visible == true )then
		--set the hint
		vint_set_property(vint_object_find("veto_button"),"visible", can_veto)
		if (can_veto == true) then
			if( hint_button ~= nil )then
				vint_set_property(vint_object_find("veto_button"),"text_tag", hint_button)
			end
		end
		if (hint_text ~= nil) then
			vint_set_property(vint_object_find("veto_hint"),"text_tag", hint_text)
		end
		local parent_xscale,parent_yscale = vint_get_property(vint_object_find("screen_group"),"scale")
		vint_set_property(vint_object_find("veto_map"), "text_tag", next_map )

		--set the votes
		local vv_handle = vint_object_find("veto_votes")
		vint_set_property(vv_handle,"scale",1.0,1.0)
		vint_set_property(vv_handle,"text_tag", vote_total)
		local vv_size_x, vv_size_y = vint_get_property(vv_handle, "screen_size")
		if (vv_size_x > 350*parent_xscale) then
			local new_scale = 350/vv_size_x*parent_xscale
			vint_set_property(vv_handle,"scale",new_scale,1.0)
		end

		--layout hint text for whether or not you voted
		if( can_veto == false )then
			local hint_x,hint_y = vint_get_property(vint_object_find("veto_hint"),"anchor")
			local votes_x,votes_y = vint_get_property(vv_handle,"anchor")
			vint_set_property(vint_object_find("veto_hint"),"anchor", votes_x, hint_y)
		else
			local hint_x,hint_y = vint_get_property(vint_object_find("veto_hint"),"anchor")
			local button_x,button_y = vint_get_property(vint_object_find("veto_button"),"anchor")
			local button_width,button_height = vint_get_property(vint_object_find("veto_button"),"screen_size")
			local new_hint_x = button_x + (button_width*0.5)/parent_xscale + RUMPS_VETO_FUDGE
			vint_set_property(vint_object_find("veto_hint"),"anchor", new_hint_x, hint_y)
		end
	end	
end

-- ##############################################################
function rumps_set_tip_info(data_item_handle, event_name)
	local is_visible,button1,button2,title,text = vint_dataitem_get(data_item_handle)
	--set the visibility
	vint_set_property(vint_object_find("mp_shell_tips_main"),"visible",is_visible)
	--set the text
	if (is_visible == true) then
		vint_set_property(vint_object_find("tips_button_1"),"text_tag",button1)
		vint_set_property(vint_object_find("tips_button_2"),"text_tag",button2)
		vint_set_property(vint_object_find("tips_title"),"text_tag",title)
		vint_set_property(vint_object_find("tips_info"),"text_tag",text)
	end
end

-- ##############################################################
function rumps_set_char_sel(data_item_handle, event_name)
	local is_visible,character1_image,character1_name,character1_is_new,character2_image,character2_name,character2_is_new,character3_image,character3_name,character3_is_new,badge,badge_locked,gamertag,hammer,hammer_name,hammer_locked = vint_dataitem_get(data_item_handle)
	--set the visibility
	vint_set_property(vint_object_find("mp_shell_char_main"),"visible",is_visible)
	--set the text
	if (is_visible == true) then
		vint_set_property(vint_object_find("char_sel_gamertag"),"text_tag",gamertag)

		local hilite_handle = vint_object_find("char_sel_image_hilite")
		local image1_handel = vint_object_find("char_sel_image1")
		local image2_handel = vint_object_find("char_sel_image2")
		local image3_handel = vint_object_find("char_sel_image3")
		local name1_handle = vint_object_find("char_name_1")
		local name2_handle = vint_object_find("char_name_2")
		local name3_handle = vint_object_find("char_name_3")

		vint_set_property(name1_handle,"text_tag",character1_name)
		vint_set_property(name2_handle,"text_tag",character2_name)
		vint_set_property(name3_handle,"text_tag",character3_name)
		vint_set_property(image1_handel,"scale",1,1)
		vint_set_property(image2_handel,"scale",1,1)
		vint_set_property(image3_handel,"scale",1,1)
		
		if(badge_locked == true)then
			vint_set_property(vint_object_find("char_lock_group_5"),"visible",true)
		else
			vint_set_property(vint_object_find("char_lock_group_5"),"visible",false)
		end
		vint_set_property(vint_object_find("char_sel_badge"),"image_badge",badge)
		vint_set_property(vint_object_find("char_sel_badge"),"scale",1.2,1.2)


		vint_set_property(image1_handel,"image",character1_image)
		
		if(hammer ~= "")then
			vint_set_property(vint_object_find("char_sel_hammer"),"visible",true)
			vint_set_property(vint_object_find("char_sel_hammer"),"image",hammer)
			local parent_scalex,parent_scaley = vint_get_property(vint_object_find( "screen_group"),"scale")
			local hammer_sizex = 256 * parent_scalex
			local hammer_sizey = 100 * parent_scaley
			vint_set_property(vint_object_find("char_sel_hammer"),"screen_size",hammer_sizex,hammer_sizey)
		else
			vint_set_property(vint_object_find("char_sel_hammer"),"visible",false )
		end
		
		if(character1_image ~= "")then
			vint_set_property(image1_handel,"visible",true)
			vint_set_property(image1_handel,"image", character1_image)
			vint_set_property(image1_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B)
		else
			vint_set_property(image1_handel,"visible",false)
		end
		if(character2_image ~= "")then
			vint_set_property(image2_handel,"visible",true)
			vint_set_property(image2_handel,"image",character2_image)
			vint_set_property(image2_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B)
		else
			vint_set_property(image2_handel,"visible",false)
		end
		if(character3_image ~= "")then
			vint_set_property(image3_handel,"visible",true)
			vint_set_property(image3_handel,"image",character3_image)
			vint_set_property(image3_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B)
		else
			vint_set_property(image3_handel,"visible",false)
		end
			
		-- MW: Hack to fix interface scaling
		local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image1_handel)
		vint_set_property(image1_handel, "image_size", size_x * scale_x, size_y * scale_y )
		
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image2_handel)
		vint_set_property(image2_handel, "image_size", size_x * scale_x, size_y * scale_y )
		
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image3_handel)
		vint_set_property(image3_handel, "image_size", size_x * scale_x, size_y * scale_y )		
		
		if(character1_is_new == nil)then
			vint_set_property(vint_object_find("char_lock_group_1"),"visible",false)
		else
			vint_set_property(vint_object_find("char_lock_group_1"),"visible",true)
		end
		if(character2_is_new == nil)then
			vint_set_property(vint_object_find("char_lock_group_2"),"visible",false)
		else
			vint_set_property(vint_object_find("char_lock_group_2"),"visible",true)
		end
		if(character3_is_new == nil)then
			vint_set_property(vint_object_find("char_lock_group_3"),"visible", false)
		else
			vint_set_property(vint_object_find("char_lock_group_3"),"visible", true)
		end

		if(hammer_locked == nil)then
			vint_set_property( vint_object_find( "char_lock_group_4" ),"visible", false)
		else
			vint_set_property( vint_object_find( "char_lock_group_4" ),"visible", true)
		end

		vint_set_property( hilite_handle ,"visible", false )
		vint_set_property(  vint_object_find( "char_other_group" ),"visible",true )
		if(RUMPS_SELECTION_INDEX == 0 or RUMPS_SELECTION_INDEX == 1 or RUMPS_SELECTION_INDEX == 2)then
			--highlight the badge
			vint_set_property(  vint_object_find( "char_other_group" ),"visible",false )
			vint_set_property(  vint_object_find( "char_sel_badge_bg" ),"visible",true )
			vint_set_property(  vint_object_find( "char_sel_badge_bg2" ),"visible",true )
			vint_set_property(  vint_object_find( "char_sel_gamertag" ),"tint", 0,0,0 )
		else
			vint_set_property(  vint_object_find( "char_sel_badge_bg" ),"visible",false )
			vint_set_property(  vint_object_find( "char_sel_badge_bg2" ),"visible",false )
			vint_set_property(  vint_object_find( "char_sel_gamertag" ),"tint",RUMPS_ORANGE.R,RUMPS_ORANGE.G,RUMPS_ORANGE.B )
		end
		local hilite_x,hilite_y = vint_get_property( hilite_handle,"anchor" )
		local hilite_scale = 1.3
		if(RUMPS_SELECTION_INDEX == 3)then
			vint_set_property( vint_object_find( "char_other_value" ),"text_tag", character1_name )
			--highlight the first image
			if (character1_is_new == nil) then
				vint_set_property( image1_handel,"tint", 1,1,1 )
				vint_set_property( image2_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
				vint_set_property( image3_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )

				local image_x,image_y = vint_get_property( image1_handel,"anchor" )
				vint_set_property( hilite_handle,"anchor", image_x,hilite_y )
			end
			vint_set_property( name1_handle,"tint", RUMPS_ORANGE.R,RUMPS_ORANGE.G,RUMPS_ORANGE.B )
			vint_set_property( name2_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name3_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
		elseif(RUMPS_SELECTION_INDEX == 4)then
			vint_set_property( vint_object_find( "char_other_value" ),"text_tag", character2_name )
			--highlight the second image
			if (character2_is_new == nil) then
				vint_set_property( image1_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
				vint_set_property( image2_handel,"tint", 1,1,1 )
				vint_set_property( image3_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
				
				local image_x,image_y = vint_get_property( image2_handel,"anchor" )
				vint_set_property( hilite_handle,"anchor", image_x,hilite_y )	
			end
			vint_set_property( name1_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name2_handle,"tint", RUMPS_ORANGE.R,RUMPS_ORANGE.G,RUMPS_ORANGE.B )
			vint_set_property( name3_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
		elseif(RUMPS_SELECTION_INDEX == 5)then
			vint_set_property( vint_object_find( "char_other_value" ),"text_tag", character3_name )
			--highlight the third image
			if (character3_is_new == nil) then
				vint_set_property( image1_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
				vint_set_property( image2_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
				vint_set_property( image3_handel,"tint", 1,1,1 )
				
				local image_x,image_y = vint_get_property( image3_handel,"anchor" )
				vint_set_property( hilite_handle,"anchor", image_x,hilite_y )
			end
			vint_set_property( name1_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name2_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name3_handle,"tint", RUMPS_ORANGE.R,RUMPS_ORANGE.G,RUMPS_ORANGE.B )
		else
			vint_set_property( hilite_handle ,"visible", false )
			vint_set_property(  vint_object_find( "char_other_group" ),"visible",false )
			vint_set_property( image1_handel,"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
			vint_set_property( image2_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B)
			vint_set_property( image3_handel,"tint", RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B )
			vint_set_property( name1_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name2_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
			vint_set_property( name3_handle,"tint", RUMPS_DARK_ORANGE.R,RUMPS_DARK_ORANGE.G,RUMPS_DARK_ORANGE.B )
		end
		if(RUMPS_SELECTION_INDEX == 6 and hammer_locked == nil)then
			vint_set_property( vint_object_find( "char_sel_hammer" ),"tint", 1,1,1 )
		else
			vint_set_property( vint_object_find( "char_sel_hammer" ),"tint",RUMPS_IMAGE_GRAY.R,RUMPS_IMAGE_GRAY.G,RUMPS_IMAGE_GRAY.B)
		end
	end
end

-- ##############################################################
function rumps_set_video(data_item_handle, event_name)
	local is_visible,title,info = vint_dataitem_get(data_item_handle)
	
	--set the visibility
	vint_set_property( vint_object_find( "mp_shell_video_main" ),"visible", is_visible )
	--set the text
	if (is_visible == true) then
		vint_set_property( vint_object_find( "mp_shell_title2" ),"text_tag",title )
		vint_set_property( vint_object_find( "video_text" ),"text_tag_crc", info )
	end
end

-- ##############################################################
function rumps_set_wc_info(data_item_handle, event_name)
	local is_visible,player1,player2,player3,player4 = vint_dataitem_get(data_item_handle)

	--set the visibility
	vint_set_property( vint_object_find( "mp_shell_wc_main" ),"visible", is_visible )
	--set the text

	if (is_visible == true) then
		if(player1 ~= "") then
			vint_set_property( vint_object_find( "mp_shell_wc_player1" ),"visible", true )
			vint_set_property( vint_object_find( "mp_shell_wc_player1" ),"image", player1 )
		else
			vint_set_property( vint_object_find( "mp_shell_wc_player1" ),"visible", false )
		end
		if(player2 ~= "") then
			vint_set_property( vint_object_find( "mp_shell_wc_player2" ),"visible", true )
			vint_set_property( vint_object_find( "mp_shell_wc_player2" ),"image", player2 )
		else
			vint_set_property( vint_object_find( "mp_shell_wc_player2" ),"visible", false )
		end
		if(player3 ~= "") then
			vint_set_property( vint_object_find( "mp_shell_wc_player3" ),"visible", true )
			vint_set_property( vint_object_find( "mp_shell_wc_player3" ),"image", player3 )
		else
			vint_set_property( vint_object_find( "mp_shell_wc_player3" ),"visible", false )
		end
		if(player4 ~= "") then
			vint_set_property( vint_object_find( "mp_shell_wc_player4" ),"visible", true )
			vint_set_property( vint_object_find( "mp_shell_wc_player4" ),"image", player4 )
		else
			vint_set_property( vint_object_find( "mp_shell_wc_player4" ),"visible", false )
		end		
			
		-- MW: Hack to fix interface scaling
		local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_shell_wc_player1" ))
		vint_set_property(vint_object_find( "mp_shell_wc_player1" ), "image_size", size_x * scale_x, size_y * scale_y )
		
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_shell_wc_player2" ))
		vint_set_property(vint_object_find( "mp_shell_wc_player2" ), "image_size", size_x * scale_x, size_y * scale_y )
		
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_shell_wc_player3" ))
		vint_set_property(vint_object_find( "mp_shell_wc_player3" ), "image_size", size_x * scale_x, size_y * scale_y )
		
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(vint_object_find( "mp_shell_wc_player4" ))
		vint_set_property(vint_object_find( "mp_shell_wc_player4" ), "image_size", size_x * scale_x, size_y * scale_y )
		
	end
end
