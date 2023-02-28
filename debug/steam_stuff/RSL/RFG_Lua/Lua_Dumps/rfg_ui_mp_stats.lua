STATS_PADDING				= 5
STATS_HINT_PADDINNG			= 20
STATS_UNSELECTED_DEPTH			= 9
STATS_SELECTED_DEPTH			= 0

row_group_handle			= {OBJECT_HANDLES_ROWS = 0}
row_group_handle_indices		= {OBJECT_HANDLES_ROWS = 0}		-- Access this via data_item_handle to get the index required for row_group_handles
Row_anim_handle = {OBJECT_HANDLES_ROWS = 0}
Row_total				= 0
row_group_size				= {0, 0}

Hightlight_base_x			= 0
Hightlight_base_y			= 0

Shell_widescreen			= false

STATS_TEAM1_COLOR			= { R = 0,   G = 0,   B = 0   }
STATS_TEAM2_COLOR			= { R = 0,   G = 0,   B = 0   }
STATS_GRAY				= { R = 0.5, G = 0.5, B = 0.5 }

STATS_MAX_ROW_HEIGHT			= 30.5


-- ##############################################################
function rfg_ui_mp_stats_cleanup()
end

-- ##############################################################
function rfg_ui_mp_stats_init()

	-- get the handles
	init_mp_stats_handles()

	-- subscribe to the data item whose name is , and we listen for updates, so that
	-- it then calls our function show_mps

	--target subscriptions
	vint_datagroup_add_subscription( "StatsSetData", "insert", "set_row_data" )
	vint_datagroup_add_subscription( "StatsSetData", "update", "set_row_data" )
	vint_datagroup_add_subscription( "StatsSetData", "remove", "remove_row_item" )

	vint_dataitem_add_subscription( "StatsHintInfo", "update", "set_hints" )

	vint_dataitem_add_subscription( "StatsTitles", "update", "set_title" )

	vint_dataitem_add_subscription( "StatsHeaderInfo", "update", "set_header" )

	vint_dataitem_add_subscription( "StatsModeInfo", "update", "set_mode_info" )

	vint_dataitem_add_subscription( "StatsScoreInfo", "update", "set_score_info" )
	
	vint_dataitem_add_subscription( "StatsSelectionProps", "update", "set_selection_bar_properties" )

end

-- ##############################################################
function init_mp_stats_handles()

	--store the height of the row group
	local parent_scale_x, parent_scale_y = vint_get_property( vint_object_find("screen_group"), "scale" )

	-- Get the size of the base row
	local row_parent_handle = vint_object_find( "row_group" )
	row_group_size[1], row_group_size[2] = vint_get_property( row_parent_handle, "screen_size" )

	-- Adjust the row size by the screen scale
	row_group_size[1] = row_group_size[1] / parent_scale_x
	row_group_size[2] = row_group_size[2] / parent_scale_y

	-- Make sure we don't exceed our max height
	if ( (row_group_size[2]) > STATS_MAX_ROW_HEIGHT ) then
		row_group_size[2] = STATS_MAX_ROW_HEIGHT
	end

	--hide the row group clone target
	vint_set_property( row_parent_handle, "visible", false )

	-- get the base position of the highlight bar
	local highlight_handle = vint_object_find( "row_highlight_main" )
	Hightlight_base_x,Hightlight_base_y = vint_get_property( highlight_handle, "anchor" )

	--hide the scoreboard for now
	vint_set_property( vint_object_find( "score_header" ), "visible", false )

	--get the team colors
	local team1_red, team1_green, team1_blue = rfg_get_mp_team_color(HUMAN_TEAM_GUERILLA)
	local team2_red, team2_green, team2_blue = rfg_get_mp_team_color(HUMAN_TEAM_EDF)
	--store the team colors
	STATS_TEAM1_COLOR = { R = team1_red, G = team1_green, B = team1_blue }
	STATS_TEAM2_COLOR = { R = team2_red, G = team2_green, B = team2_blue }

	--hide mode map info by default
	vint_set_property( vint_object_find( "title_mode_title" ),"visible", false )
	vint_set_property( vint_object_find( "title_mode_value" ),"visible", false )

	vint_set_property( vint_object_find( "title_map_title" ),"visible", false )
	vint_set_property( vint_object_find( "title_map_value" ),"visible", false )

	vint_set_property( vint_object_find( "title_main" ),"visible",false)
	vint_set_property( vint_object_find( "hints_main" ),"visible", false )

	vint_set_child_tween_state( vint_object_find( "row_leader_anim"), TWEEN_STATE_DISABLED)

	local x,y = rfg_get_screen_dim()
	if( x >= 1280 )then
		Shell_widescreen = true
	else
		Shell_widescreen = false
	end

end

-- ##############################################################
function set_title(data_item_handle, event_name)
	local title1,show_screen,value = vint_dataitem_get(data_item_handle)
	local title1_handle = vint_object_find( "title_text" )
	local value_handle = vint_object_find( "title_value" )
	vint_set_property( title1_handle,"text_tag", title1 )
	
	if( value ~= nil )then
		vint_set_property( value_handle,"visible", true )
		vint_set_property( value_handle,"text_tag", value )
	else
		vint_set_property( value_handle,"visible", false )
	end
	
	if( show_screen ~= nil )then
		vint_set_property( vint_object_find( "main_group" ),"visible", show_screen )
	end

	vint_set_property( vint_object_find( "title_main" ),"visible",true)
	vint_set_property( title1_handle,"visible",true)
end

-- ##############################################################
function set_header(data_item_handle, event_name)
	local header1,header2,header3,header4,header5 = vint_dataitem_get(data_item_handle)
	--set the headers
	vint_set_property( vint_object_find( "header_text_1" ), "text_tag", header1 )
	vint_set_property( vint_object_find( "header_text_2" ), "text_tag", header2 )
	vint_set_property( vint_object_find( "header_text_3" ), "text_tag", header3 )
	vint_set_property( vint_object_find( "header_text_4" ), "text_tag", header4 )
	vint_set_property( vint_object_find( "header_text_5" ), "text_tag", header5 )
	vint_set_property( vint_object_find( "header_text_2" ), "visible", true )
	vint_set_property( vint_object_find( "header_text_3" ), "visible", true )
	vint_set_property( vint_object_find( "header_text_4" ), "visible", true )
	vint_set_property( vint_object_find( "header_text_5" ), "visible", true )
end

-- ##############################################################
function set_mode_info(data_item_handle, event_name)
	local is_visible, mode_label, mode_value, map_label, map_value = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "title_mode_title" ),"visible", is_visible )
	vint_set_property( vint_object_find( "title_mode_value" ),"visible", is_visible )

	vint_set_property( vint_object_find( "title_map_title" ),"visible", is_visible )
	vint_set_property( vint_object_find( "title_map_value" ),"visible", is_visible )

	if( is_visible == true )then
		vint_set_property( vint_object_find( "title_mode_title" ),"text_tag", mode_label )
		vint_set_property( vint_object_find( "title_mode_value" ),"text_tag", mode_value )

		vint_set_property( vint_object_find( "title_map_title" ),"text_tag", map_label )
		vint_set_property( vint_object_find( "title_map_value" ),"text_tag", map_value )
		
		local parent_scale_x,parent_scale_y = vint_get_property( vint_object_find( "screen_group" ),"scale" )
		
		local mode_title_x,mode_title_y = vint_get_property( vint_object_find( "title_mode_title" ),"anchor" )
		local mode_title_width,mode_title_height = vint_get_property( vint_object_find( "title_mode_title" ),"screen_size" )
		local new_mode_x = mode_title_x + (mode_title_width/parent_scale_x) + STATS_PADDING
		
		--vint_set_property( vint_object_find( "title_mode_value" ),"anchor", new_mode_x,mode_title_y )

		local mode_value_x,mode_value_y = vint_get_property( vint_object_find( "title_mode_value" ),"anchor" )
		local mode_value_width,mode_value_height = vint_get_property( vint_object_find( "title_mode_value" ),"screen_size" )
		local new_mode_value_x = mode_value_x + (mode_value_width/parent_scale_x) + (STATS_PADDING*2)
		
		--vint_set_property( vint_object_find( "title_map_title" ),"anchor", new_mode_value_x,mode_value_y )

		local mode_map_x,mode_map_y = vint_get_property( vint_object_find( "title_map_title" ),"anchor" )
		local mode_map_width,mode_map_height = vint_get_property( vint_object_find( "title_map_title" ),"screen_size" )
		local new_map_title_x = mode_map_x + (mode_map_width/parent_scale_x) + (STATS_PADDING)
		
		--vint_set_property( vint_object_find( "title_map_value" ),"anchor", new_map_title_x,mode_map_y )
	end
end

-- ##############################################################
function set_score_info(data_item_handle, event_name)
	local is_visible,team1_score,team2_score = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "score_header" ),"visible", is_visible )

	if( is_visible == true )then
		vint_set_property( vint_object_find( "guerrilla_score" ),"text_tag", team1_score )
		vint_set_property( vint_object_find( "edf_score" ),"text_tag", team2_score )

		--set the team colors
		vint_set_property( vint_object_find( "guerrilla_score" ),"tint", STATS_TEAM1_COLOR.R, STATS_TEAM1_COLOR.G, STATS_TEAM1_COLOR.B )
		vint_set_property( vint_object_find( "guerrilla_logo" ),"tint", STATS_TEAM1_COLOR.R, STATS_TEAM1_COLOR.G, STATS_TEAM1_COLOR.B )
		
		vint_set_property( vint_object_find( "edf_score" ),"tint", STATS_TEAM2_COLOR.R, STATS_TEAM2_COLOR.G, STATS_TEAM2_COLOR.B )
		vint_set_property( vint_object_find( "edf_logo" ),"tint", STATS_TEAM2_COLOR.R, STATS_TEAM2_COLOR.G, STATS_TEAM2_COLOR.B )
		
	end
end

-- ##############################################################
function set_hints(data_item_handle, event_name)
	local hint_text1, hint_text2, hint_text3, hint_text4, hint_text5, row_hint = vint_dataitem_get(data_item_handle)
	
	vint_set_property( vint_object_find( "hints_main" ),"visible", true )
	local hint_text1_handle = vint_object_find( "hints_text_1" )
	local hint_text2_handle = vint_object_find( "hints_text_2" )
	local hint_text3_handle = vint_object_find( "hints_text_3" )
	local hint_text4_handle = vint_object_find( "hints_text_4" )
	local hint_text5_handle = vint_object_find( "hints_text_5" )

	local hint_1_padding = STATS_HINT_PADDINNG
	local hint_2_padding = STATS_HINT_PADDINNG
	local hint_3_padding = STATS_HINT_PADDINNG
	local hint_4_padding = STATS_HINT_PADDINNG
	local hint_5_padding = STATS_HINT_PADDINNG
	
	if(row_hint ~= nil)then
		local row_button_handle = vint_object_find( "row_highlight_button" )
		vint_set_property( row_button_handle,"text_tag", row_hint )
	end

	vint_set_property( hint_text1_handle,"text_tag", hint_text1 )
	
	if(hint_text1 == "")then
		hint_1_padding = STATS_PADDING
	end
	if(hint_text2 == "")then
		hint_2_padding = STATS_PADDING
	end
	if(hint_text3 == "")then
		hint_3_padding = STATS_PADDING
	end
	if(hint_text4 == "")then
		hint_4_padding = STATS_PADDING
	end
	if(hint_text5 == "")then
		hint_5_padding = STATS_PADDING
	end

	if(hint_text2 == nil) then
		vint_set_property( hint_text2_handle,"visible", false )
	else
		vint_set_property( hint_text2_handle,"visible", true )
		vint_set_property( hint_text2_handle,"text_tag", hint_text2 )
	end

	if(hint_text3 == nil) then
		vint_set_property( hint_text3_handle, "visible", false )
	else
		vint_set_property( hint_text3_handle, "visible", true )
		vint_set_property( hint_text3_handle, "text_tag", hint_text3 )
	end

	if(hint_text4 == nil) then
		vint_set_property( hint_text4_handle, "visible", false )
	else
		vint_set_property( hint_text4_handle, "visible", true )
		vint_set_property( hint_text4_handle, "text_tag", hint_text4 )
	end

	if(hint_text5 == nil) then
		vint_set_property( hint_text5_handle, "visible", false )
	else
		vint_set_property( hint_text5_handle, "visible", true )
		vint_set_property( hint_text5_handle, "text_tag", hint_text5 )
	end

	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "screen_group" ),"scale" )

	--space out the hints based on text widths
	--get all the groups x,y positions and size
	local hint1_x,hint1_y = vint_get_property(vint_object_find("hint_1_group"),"anchor")
	local hint1_width,hint1_height = vint_get_property(vint_object_find("hint_1_group"),"screen_size")

	local hint2_x,hint2_y = vint_get_property(vint_object_find("hint_2_group"),"anchor")
	local hint2_width,hint2_height = vint_get_property(vint_object_find("hint_2_group"),"screen_size")

	local hint3_x,hint3_y = vint_get_property(vint_object_find("hint_3_group"),"anchor")
	local hint3_width,hint3_height = vint_get_property(vint_object_find("hint_3_group"),"screen_size")

	local hint4_x,hint4_y = vint_get_property(vint_object_find("hint_4_group"),"anchor")
	local hint4_width,hint4_height = vint_get_property(vint_object_find("hint_4_group"),"screen_size")

	local hint5_x,hint5_y = vint_get_property(vint_object_find("hint_5_group"),"anchor")
	local hint5_width,hint5_height = vint_get_property(vint_object_find("hint_5_group"),"screen_size")
	
	local xtoset = hint1_x + (hint1_width/parent_xscale) + hint_1_padding
	vint_set_property(vint_object_find("hint_2_group"),"anchor",xtoset,hint2_y)

	--get the second hints new x position since we just changed it
	hint2_x,hint2_y = vint_get_property(vint_object_find("hint_2_group"),"anchor")
	xtoset = hint2_x + (hint2_width/parent_xscale) + hint_2_padding
	vint_set_property(vint_object_find("hint_3_group"),"anchor",xtoset,hint3_y)

	--get the third hints new x position since we just changed it
	hint3_x,hint3_y = vint_get_property(vint_object_find("hint_3_group"),"anchor")
	xtoset = hint3_x + (hint3_width/parent_xscale) + hint_3_padding
	vint_set_property(vint_object_find("hint_4_group"),"anchor",xtoset,hint4_y)

	--get the fourth hints new x position since we just changed it
	hint4_x,hint4_y = vint_get_property(vint_object_find("hint_4_group"),"anchor")
	xtoset = hint4_x + (hint4_width/parent_xscale) + hint_4_padding
	vint_set_property(vint_object_find("hint_5_group"),"anchor",xtoset,hint5_y)

end

-- ##############################################################
function add_row_item(data_item_handle)
	local prev = Row_total
	local new_cnt = Row_total + 1
	
	local row_parent_handle = vint_object_find( "row_group" )
	local row_leader_anim_handle = vint_object_find("row_leader_anim")
	
	if(prev == 0)then
		row_group_handle[new_cnt] = row_parent_handle
		Row_anim_handle[new_cnt] = row_leader_anim_handle
	else
		-- k, clone the row group
		row_group_handle[new_cnt] = vint_object_clone_rename(row_parent_handle, "row_group"..new_cnt )
		Row_anim_handle[new_cnt] = vint_anim_clone_and_retarget(row_leader_anim_handle, row_group_handle[new_cnt] )
		
		-- k, setup the positions - get the previous item's position
		local anchor_x, anchor_y
		local new_y
		if ( prev ~= 0 ) then
			anchor_x, anchor_y = vint_get_property( row_group_handle[prev], "anchor" )

			new_y = anchor_y + row_group_size[2]
			vint_set_property( row_group_handle[new_cnt], "anchor", anchor_x, new_y )
		end
	end
	--set the depth
	vint_set_property( row_group_handle[new_cnt], "depth", STATS_UNSELECTED_DEPTH )

	-- make visible
	vint_set_property( row_group_handle[new_cnt], "visible", true )

	--set the dag visibility
	if( vint_mod( new_cnt, 2 ) == 1 )then
		vint_set_property( vint_object_find( "row_bg_main", row_group_handle[new_cnt] ), "visible", true )
	else
		vint_set_property( vint_object_find( "row_bg_main", row_group_handle[new_cnt] ), "visible", false )
	end
	--debug_print("vint","ADD ROW just set dag vis \n")
		
	-- bump cnt
	Row_total = new_cnt

	return new_cnt
end

-- ##############################################################
function remove_row_item(data_item_handle, event_name)

	local index = row_group_handle_indices[data_item_handle]
	
	Row_total = Row_total - 1
	if(index ~= 1)then
		-- now delete this item!
		vint_object_destroy(row_group_handle[index])
		vint_object_destroy(Row_anim_handle[index])
	else
		vint_set_property(row_group_handle[index], "visible", false)
	end
	row_group_handle[index] = 0
	Row_anim_handle[index] = 0

	row_group_handle_indices[data_item_handle] = nil
end


-- ##############################################################
function set_row_data(data_item_handle, event_name)
	
	local name,image,level,team,mute,is_leader,in_party,offered_party_up,in_lobby,selected,flash_party_icon,can_party,value1,value2,value3,value4 = vint_dataitem_get(data_item_handle)

	if ( event_name == "insert" ) then		
		local index = add_row_item( data_item_handle )
		row_group_handle_indices[data_item_handle] = index
	end

	set_row_data_actual( data_item_handle,name,image,level,team,mute,is_leader,in_party, offered_party_up, in_lobby,selected, flash_party_icon, can_party, value1,value2,value3,value4 )

end

-- ##############################################################
function set_row_data_actual(data_item_handle,name,image,level,row_team,
				row_mute,row_leader,row_party, offered_party_up, in_lobby, selected, flash_party_icon, can_party, value1,value2,value3,value4)

	--store a handle to the group
	local index = row_group_handle_indices[data_item_handle]
	if (index == nil) then
		return
	end

	local row_parent_handle = row_group_handle[index]
	if (row_parent_handle == nil) then
		return
	end
	
	--store a handle to all the row objects
	local row_name_handle = vint_object_find( "row_name", row_parent_handle )
	local row_image_handle = vint_object_find( "row_image", row_parent_handle )
	--local row_level_handle = vint_object_find( "row_level", row_parent_handle )
	local row_team_handle = vint_object_find( "row_team", row_parent_handle )
	local row_mute_handle = vint_object_find( "row_mute", row_parent_handle )
	local row_leader_handle = vint_object_find( "row_leader", row_parent_handle )
	local row_leader2_handle = vint_object_find( "row_leader2", row_parent_handle )
	local row_value1_handle = vint_object_find( "row_value_1", row_parent_handle )
	local row_value2_handle = vint_object_find( "row_value_2", row_parent_handle )
	local row_value3_handle = vint_object_find( "row_value_3", row_parent_handle )
	local row_value4_handle = vint_object_find( "row_value_4", row_parent_handle )

	vint_set_property( row_name_handle, "text_tag", name )
	
	--make the name fit
	vint_set_property( row_name_handle, "text_scale", 0.7, 0.8  )
	local text_width,text_height = vint_get_property( row_name_handle, "screen_size" )
	--get the scale
	local text_scale_x,text_scale_y = vint_get_property( row_name_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "screen_group" ), "scale" )
	
	local name_max_width = 218.0 * parent_scalex
	
	if( text_width > name_max_width )then
		local new_scale = name_max_width/text_width * text_scale_x
		vint_set_property( row_name_handle, "text_scale", new_scale, text_scale_y  )
	else
		vint_set_property( row_name_handle, "text_scale",text_scale_x,text_scale_y )
	end
	
	--set the team icon
	if(row_team == HUMAN_TEAM_GUERILLA)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_guerrilla" )
	elseif(row_team == HUMAN_TEAM_EDF)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_edf" )
	elseif(row_team == HUMAN_TEAM_MP_SPECTATOR)then
		vint_set_property( row_team_handle,"visible",true)
		vint_set_property( row_team_handle,"image","ui_fend_icon_spec" )
	else
		vint_set_property( row_team_handle,"visible",false)
	end

	--set the mute icon
	--show the mic
	vint_set_property( row_mute_handle,"visible", true )
	if(row_mute == 0)then
		--player is muted
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute3" )
	elseif(row_mute == 1)then
		--player is not muted
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute2" )
	elseif(row_mute == 2)then
		--player is not muted and talking
		vint_set_property( row_mute_handle,"image","ui_fend_icon_mute" )
	else
		--don't show the mic
		vint_set_property( row_mute_handle,"visible", false )
	end

	-- Hide the party status icon by default
	vint_set_property( row_leader_handle,"visible",false )
	vint_set_property( row_leader2_handle,"visible",false )
	
	--set the leader icon
	if( offered_party_up == true ) then
		if( row_leader == false and row_party == false)then
			-- player is alone and wants to party
			vint_set_property( row_leader_handle,"visible",true )
			vint_set_property( row_leader2_handle,"visible",true )
			vint_set_property( row_leader_handle,"image","ui_fend_icon_party03" )
			vint_set_property( row_leader2_handle,"image","ui_fend_icon_party03" )
		elseif( row_leader == true )then
			--player is in party and is the leader and wants to party
			vint_set_property( row_leader_handle,"visible",true )
			vint_set_property( row_leader2_handle,"visible",true )
			vint_set_property( row_leader_handle,"image","ui_fend_icon_party02" )
			vint_set_property( row_leader2_handle,"image","ui_fend_icon_party02" )
		elseif( row_leader == false and row_party == true )then
			--player is in party
			vint_set_property( row_leader_handle,"visible",true )
			vint_set_property( row_leader2_handle,"visible",true )
			vint_set_property( row_leader_handle,"image","ui_fend_icon_party06" )
			vint_set_property( row_leader2_handle,"image","ui_fend_icon_party06" )
		end
	else
		if( row_leader == false and row_party == false)then
			-- player is alone and does not want to party
			if (can_party == true) then
				vint_set_property( row_leader_handle,"visible",true )
				vint_set_property( row_leader2_handle,"visible",true )
				vint_set_property( row_leader_handle,"image","ui_fend_icon_party04" )
				vint_set_property( row_leader2_handle,"image","ui_fend_icon_party04" )
			end
		elseif( row_leader == true )then
			--player is in party and is the leader and does not want to party
			vint_set_property( row_leader_handle,"visible",true )
			vint_set_property( row_leader2_handle,"visible",true )
			if (can_party == true) then
				vint_set_property( row_leader_handle,"image","ui_fend_icon_party01" )
				vint_set_property( row_leader2_handle,"image","ui_fend_icon_party01" )
			else
				vint_set_property( row_leader_handle,"image","ui_fend_icon_leader" )
				vint_set_property( row_leader2_handle,"image","ui_fend_icon_leader" )
			end
		elseif( row_leader == false and row_party == true )then
			--player is in party and does not want to party
			vint_set_property( row_leader_handle,"visible",true )
			vint_set_property( row_leader2_handle,"visible",true )
			if (can_party == true) then
				vint_set_property( row_leader_handle,"image","ui_fend_icon_party05" )
				vint_set_property( row_leader2_handle,"image","ui_fend_icon_party05" )
			else
				vint_set_property( row_leader_handle,"image","ui_fend_icon_party" )
				vint_set_property( row_leader2_handle,"image","ui_fend_icon_party" )
			end
		end
	end

	if( flash_party_icon == true ) then
		vint_set_property(Row_anim_handle[index],"start_time",vint_get_time_index())
		vint_set_child_tween_state( Row_anim_handle[index], TWEEN_STATE_IDLE)
	else
		vint_set_child_tween_state( Row_anim_handle[index], TWEEN_STATE_DISABLED)
		vint_set_property( row_leader2_handle, "scale", 1.0, 1.0)
		vint_set_property( row_leader2_handle, "alpha", 0)
	end

	--set row value text back to original size
	vint_set_property(row_value1_handle, "text_scale", 0.8, 0.8)	
	vint_set_property(row_value2_handle, "text_scale", 0.8, 0.8)	
	vint_set_property(row_value3_handle, "text_scale", 0.8, 0.8)	
	vint_set_property(row_value4_handle, "text_scale", 0.8, 0.8)	
	
	vint_set_property( row_value1_handle, "text_tag", value1 )
	vint_set_property( row_value2_handle, "text_tag", value2 )
	vint_set_property( row_value3_handle, "text_tag", value3 )
	vint_set_property( row_value4_handle, "text_tag", value4 )

	--resize row value text if string is too long
	local row_value_x1, row_value_y = vint_get_property(row_value1_handle, "screen_size")
	local row_value_x2, row_value_y = vint_get_property(row_value2_handle, "screen_size")
	local row_value_x3, row_value_y = vint_get_property(row_value3_handle, "screen_size")
	local row_value_x4, row_value_y = vint_get_property(row_value4_handle, "screen_size")
	local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("screen_group"),"scale")
	local MAX_WIDTH = 235 * parent_scale_x

	if(row_value_x1 > MAX_WIDTH) then
	
		vint_set_property(row_value1_handle, "text_scale", 0.7, 0.8)

	elseif(row_value_x2 > MAX_WIDTH) then

		vint_set_property(row_value2_handle, "text_scale", 0.7, 0.8)

	elseif(row_value_x3 > MAX_WIDTH) then

		vint_set_property(row_value3_handle, "text_scale", 0.7, 0.8)

	elseif(row_value_x4 > MAX_WIDTH) then

		vint_set_property(row_value4_handle, "text_scale", 0.7, 0.8)

	end

	--vint_set_property( row_level_handle, "text_tag", level )
	vint_set_property( vint_object_find( "row_rank", row_parent_handle ), "text_tag", level )
	--vint_set_property( row_level_handle, "visible", true )

	--set the dag visibility
	if( vint_mod( index, 2 ) == 1 )then
		vint_set_property( vint_object_find( "row_bg_main", row_parent_handle ), "visible", true )
	else
		vint_set_property( vint_object_find( "row_bg_main", row_parent_handle ), "visible", false )
	end

	if(image ~= nil)then
		vint_set_property( row_image_handle, "visible", true )
		vint_set_property( vint_object_find( "row_rank", row_parent_handle ),"visible",false)
		vint_set_property( row_image_handle, "image_badge", image )
		vint_set_property( row_image_handle,"scale",0.8125,0.8125 )
	else
		vint_set_property( row_image_handle, "visible", false )
		--vint_set_property( row_level_handle, "visible", false )
		vint_set_property( vint_object_find( "row_rank", row_parent_handle ),"visible",true)
	end

	--set the depth
	vint_set_property( row_group_handle[index], "depth", STATS_UNSELECTED_DEPTH )

	if (selected) then
		set_highlight(index)
		
	elseif (in_lobby) then
		local r = 0.5
		local g = 0.25
		local b = 0
				
		vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", r,g,b )

		vint_set_property( vint_object_find( "row_team", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_mute", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_leader", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_leader2", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_level", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_rank", row_parent_handle ),"tint", r,g,b )

		vint_set_property( vint_object_find( "row_value_1", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_2", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_3", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_4", row_parent_handle ),"tint", r,g,b )	

	else
		local r = 0.28125
		local g = 0.25
		local b = 0.21484375
		vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", r,g,b )

		vint_set_property( vint_object_find( "row_team", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_mute", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_leader", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_leader2", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_level", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_rank", row_parent_handle ),"tint", r,g,b )

		vint_set_property( vint_object_find( "row_value_1", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_2", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_3", row_parent_handle ),"tint", r,g,b )
		vint_set_property( vint_object_find( "row_value_4", row_parent_handle ),"tint", r,g,b )	
	end
end


-- ##############################################################
function set_text_highlight(index)	
	--store a handle to the parent group
	local row_parent_handle = row_group_handle[index]

	--set the depth	
	vint_set_property( row_parent_handle, "depth", STATS_SELECTED_DEPTH )

	--set the default color to unhighlight
	local r = 0.5
	local g = 0.25
	local b = 0

	r = 0
	g = 0
	b = 0
	--everything should be black except the name, so make it bright orange
	vint_set_property( vint_object_find( "row_name", row_parent_handle ),"tint", 1,0.5,0 )
	vint_set_property( vint_object_find( "row_bg_main", row_parent_handle ), "visible", false )

	--debug_print("vint","****setting text black\n")
	--set the text color
	vint_set_property( vint_object_find( "row_team", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_mute", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_leader", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_leader2", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_level", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_rank", row_parent_handle ),"tint", r,g,b )

	vint_set_property( vint_object_find( "row_value_1", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_value_2", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_value_3", row_parent_handle ),"tint", r,g,b )
	vint_set_property( vint_object_find( "row_value_4", row_parent_handle ),"tint", r,g,b )	
end

-- ##############################################################
function set_highlight(selection)
	local new_anchory = Hightlight_base_y + (selection-1)*(row_group_size[2])

	local highlight_handle = vint_object_find( "row_highlight_main" )

	--is selection valid
	if(selection >= 0) then
		--show the highlight
		vint_set_property(highlight_handle, "visible", true )
		--set the highlight x and y to the highlighted row
		vint_set_property(highlight_handle, "anchor", Hightlight_base_x, new_anchory )
	else
		vint_set_property(highlight_handle, "visible", false )
	end
	
	--set the row specific color and alpha highlight values
	set_text_highlight(selection)
end

-- ##############################################################
function set_selection_bar_properties(data_item_handle)
	local button_visible = vint_dataitem_get(data_item_handle)
	
	local button_handle = vint_object_find( "row_highlight_button" )
	
	vint_set_property(button_handle, "visible", button_visible)
end
