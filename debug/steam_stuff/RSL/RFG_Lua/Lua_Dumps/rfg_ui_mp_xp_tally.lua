
MAX_ROWS			= 16
Row_handles			= { MAX_ROWS = 0 }
Num_rows			= 0

Row_base_pos_x			= 0
Row_base_pos_y			= 0
Row_base_size_x			= 0
Row_base_size_y			= 0
XP_parent_scale_x		= 0
XP_parent_scale_y		= 0

ORANGE				= {R=0.83,G=0.54,B=0}
DARK_ORANGE			= {R=0.5,G=0.25,B=0}

STAMP_PAD			= 20

stack_depth = 0
function stack(function_name)
	for i=1,stack_depth do
		debug_print( "mp_vint", "\t" )
	end

	debug_print( "mp_vint", function_name.."\n" )
	stack_depth = stack_depth + 1
end

function unstack()
	stack_depth = stack_depth -1
end

-- ##############################################################
function init_handles_mp_xp_tally()
	
	Row_handles[1] = vint_object_find( "event_group" )

	local handle = vint_object_find( "event_group" )
	Row_base_pos_x, Row_base_pos_y = vint_get_property( handle, "anchor" )
	vint_set_property( handle, "visible", false )

	Row_base_size_x, Row_base_size_y = vint_get_property( handle, "screen_size" )

	handle = vint_object_find( "xp_tally_screen_group" )
	XP_parent_scale_x, XP_parent_scale_y = vint_get_property( handle, "scale" )

	handle = vint_object_find( "xp_screen_bg")
	vint_set_property( handle, "visible", false )

	vint_set_property(vint_object_find( "xp_tally_unlock_group"),"visible",false)
	vint_set_property(vint_object_find( "xp_tally_levelup_group"),"visible",false)
	vint_set_child_tween_state( vint_object_find( "xp_tally_stamp_anim" ), TWEEN_STATE_DISABLED )
end


-- ##############################################################
function rfg_ui_mp_xp_tally_cleanup()

end

-- ##############################################################
function rfg_ui_mp_xp_tally_init()
	-- get the handles
	init_handles_mp_xp_tally()

	vint_dataitem_add_subscription( "multiplayer_xp_tally_challenges", "update", "set_tally_challenges" )
	vint_dataitem_add_subscription( "multiplayer_xp_tally_labels", "update", "set_tally_labels" )
	vint_dataitem_add_subscription( "multiplayer_xp_tally_values", "update", "set_tally_values" )
	vint_dataitem_add_subscription( "multiplayer_xp_tally_unlocks", "update", "set_tally_unlock_data" )

	vint_datagroup_add_subscription( "multiplayer_xp_tally_event", "insert", "update_row" )
	vint_datagroup_add_subscription( "multiplayer_xp_tally_event", "update", "update_row" )
	vint_datagroup_add_subscription( "multiplayer_xp_tally_event", "remove", "remove_event_row" )
end

-- ##############################################################
function set_tally_labels(data_item_handle, event_name)
	stack("set_tally_labels(data_item_handle, event_name)")
	local player_badge,player_name,match_xp,match_bonus,total_xp,next_level,level,level_up,event_label,event_value = vint_dataitem_get(data_item_handle)

	local player_handle =  vint_object_find( "xp_tally_player" )
	local badge_handle =  vint_object_find( "xp_tally_badge" )
	local match_xp_handle = vint_object_find( "xp_tally_match_xp_label" )
	local match_bonus_label = vint_object_find( "xp_tally_match_bonus_label" )
	local total_xp_handle = vint_object_find( "xp_tally_total_xp_label" )
	local next_level_label = vint_object_find( "xp_tally_next_level_label" )
	local level_handle = vint_object_find( "xp_tally_next_level_label" )
	local level_up_handle = vint_object_find( "xp_tally_levelup_text" )
	local event_title_handle = vint_object_find( "xp_event_title" )

	vint_set_property( player_handle, "text_tag", player_name )
	vint_set_property( badge_handle, "image_badge", player_badge )

	if( match_xp ~= nil )then
		vint_set_property( match_xp_handle, "text_tag", match_xp )
		vint_set_property( match_xp_handle, "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_xp_icon" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_xp_value" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_xp_valuebg" ), "visible", true )
	else
		vint_set_property( match_xp_handle, "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_xp_icon" ), "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_xp_value" ), "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_xp_valuebg" ), "visible", false )
	end

	if( match_bonus ~= nil )then
		vint_set_property( match_bonus_label, "text_tag", match_bonus )

		--[[local match_bonus_x, match_bonus_y = vint_get_property(match_bonus_label, "screen_size")
		local parent_scale_x, parent_scale_y = vint_get_property(vint_object_find("xp_tally_screen_group"),"scale")
		local MAX_WIDTH = 285 * parent_scale_x

		debug_print("vint","\n\nMATCH BONUS SIZE =========== "..match_bonus_x)
		debug_print("vint","\n\nMAX_WIDTH =========== "..MAX_WIDTH)

		if(match_bonus_x >= MAX_WIDTH)then
			vint_set_property(match_bonus_label, "text_scale", 0.6,0.8)
		end]]--

		vint_set_property( match_bonus_label, "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_icon" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_value" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_valuebg" ), "visible", true )
	else
		vint_set_property( match_bonus_label, "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_icon" ), "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_value" ), "visible", false )
		vint_set_property( vint_object_find( "xp_tally_match_bonus_valuebg" ), "visible", false )
	end

	vint_set_property( total_xp_handle, "text_tag", total_xp )
	vint_set_property( next_level_label, "text_tag", next_level )
	vint_set_property( level_handle, "text_tag", level )
	vint_set_property( level_up_handle, "text_tag", level_up )
	vint_set_property( event_title_handle, "text_tag", event_label )

	local event_value_handle = vint_object_find( "xp_event_title_value" )
	vint_set_property( event_value_handle, "text_tag", event_value )
	
	local max_width = 250.0
	
	--stack("set_text_width( player_handle, max_width, 1.1)")
		--set_text_width( player_handle, max_width, 1.1)
	--unstack()
	stack("set_text_width( match_xp_handle, max_width, 1.0 )")
		set_text_width( match_xp_handle, max_width, 1.0 )
	unstack()
	stack("set_text_width( match_bonus_label, max_width, 1.0 )")
		set_text_width( match_bonus_label, max_width, 1.0 )
	unstack()
	stack("set_text_width( total_xp_handle, max_width, 1.0 )")
		set_text_width( total_xp_handle, max_width, 1.0 )
	unstack()
	stack("set_text_width( next_level_label, max_width, 1.0 )")
		set_text_width( next_level_label, max_width, 1.0 )
	unstack()
	stack("set_text_width( level_handle, max_width, 1.0 )")
		set_text_width( level_handle, max_width, 1.0 )
	unstack()
	unstack()

	local outline_handle =  vint_object_find( "xp_tally_stamp")
	local outline2_handle =  vint_object_find( "xp_tally_stamp2")
	local parent_scalex,parent_scaley = vint_get_property(vint_object_find( "xp_tally_screen_group" ), "scale")
	local text_width,text_height = vint_get_property( level_up_handle, "screen_size")
	local text_x,text_y = vint_get_property( level_up_handle, "anchor")
	local x_to_set = text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD
	local stamp_max_width = 275.0 --* parent_scalex
	local stamp_min_width = 150.0 --* parent_scalex
	if(x_to_set <= stamp_min_width)then
		x_to_set = stamp_min_width
	elseif(x_to_set >= stamp_max_width)then
		x_to_set = stamp_max_width
	end
	vint_set_property(outline2_handle, "anchor", x_to_set,4)
	
	x_to_set = -1*(text_x+(text_width/parent_scalex)*0.5 + STAMP_PAD)
	if(x_to_set >= (-1 * stamp_min_width))then
		x_to_set = (-1 * stamp_min_width)
	elseif(x_to_set <= (-1 * stamp_max_width))then
		x_to_set = (-1 * stamp_max_width)
	end
	vint_set_property( outline_handle, "anchor", x_to_set,4)
end

-- ##############################################################
function set_tally_values(data_item_handle, event_name)
	local match_xp,match_bonus,total_xp,next_level,level,leveled_up,meter_pct = vint_dataitem_get(data_item_handle)

	local match_xp_handle = vint_object_find( "xp_tally_match_xp_value" )
	local match_bonus_label = vint_object_find( "xp_tally_match_bonus_value" )
	local total_xp_handle = vint_object_find( "xp_tally_total_xp_value" )
	local next_level_label = vint_object_find( "xp_tally_next_level_value" )
	local level_handle = vint_object_find( "xp_tally_level_value" )

	vint_set_property( match_xp_handle, "text_tag", match_xp )
	vint_set_property( match_bonus_label, "text_tag", match_bonus )
	vint_set_property( total_xp_handle, "text_tag", total_xp )
	vint_set_property( next_level_label, "text_tag", next_level )
	vint_set_property( level_handle, "text_tag", level )
	
	
	if( leveled_up == true )then
		--play the stamp anim
		vint_set_property(vint_object_find( "xp_tally_levelup_group"),"visible",true)
		vint_set_property(vint_object_find( "xp_tally_stamp_anim" ), "start_time", vint_get_time_index() )
		vint_set_child_tween_state( vint_object_find( "xp_tally_stamp_anim" ), TWEEN_STATE_RUNNING )
	end

	if(meter_pct ~= nil)then
		local meter_handle = vint_object_find( "meter_fill" )
		local meter_max = 343
		local new_width = meter_pct * meter_max
		local adjusted_width = meter_max - new_width
		local meter_width,meter_height = vint_get_property(meter_handle,"scale")
		vint_set_property(meter_handle,"scale",adjusted_width,meter_height)
	end
	
end

-- ##############################################################
function set_tally_unlock_data(data_item_handle, event_name)
	stack("set_tally_unlock_data(data_item_handle, event_name)")
	local unlock_label,unlock_value,unlock_title,unlock_text, left_hint, right_hint = vint_dataitem_get(data_item_handle)

	local label_handle = vint_object_find( "unlock_header_title" )
	local value_handle = vint_object_find( "unlock_count" )
	local title_handle = vint_object_find( "unlock_header_label" )
	local text_handle = vint_object_find( "unlock_description" )

	vint_set_property( label_handle, "text_tag", unlock_label )
	vint_set_property( value_handle, "text_tag", unlock_value )

	if (unlock_title ~= nil and unlock_text ~= nil) then
		vint_set_property( title_handle, "visible", true )
		vint_set_property( text_handle, "visible", true )
		vint_set_property( title_handle, "text_tag", unlock_title )
		vint_set_property( text_handle, "text_tag", unlock_text )
		vint_set_property(vint_object_find( "xp_tally_unlock_group"),"visible",true)
	else
		vint_set_property( title_handle, "visible", false )
		vint_set_property( text_handle, "visible", false )
		vint_set_property(vint_object_find( "xp_tally_unlock_group"),"visible",false)
	end
	
	--set the hints
	if(left_hint ~= nil)then
		vint_set_property( vint_object_find( "xp_tally_unlock_left_hint" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_unlock_left_hint" ), "text_tag", left_hint )
	else
		vint_set_property( vint_object_find( "xp_tally_unlock_left_hint" ), "visible", false )
	end

	if(right_hint ~= nil)then
		vint_set_property( vint_object_find( "xp_tally_unlock_right_hint" ), "visible", true )
		vint_set_property( vint_object_find( "xp_tally_unlock_right_hint" ), "text_tag", right_hint )
	else
		vint_set_property( vint_object_find( "xp_tally_unlock_right_hint" ), "visible", false )
	end
	
	--adjust widths
	stack("set_text_width( title_handle, 370, 0.7)")
		set_text_width( title_handle, 370, 0.7)
	unstack()
	stack("set_text_width( label_handle, 288, 0.9)")
		set_text_width( label_handle, 288, 0.9)
	unstack()
	unstack()
end

-- ##############################################################
function set_tally_challenges(data_item_handle, event_name)
	local image = {}
	image[1],image[2],image[3],image[4],image[5],image[6],image[7],image[8],image[9],
		image[10],image[11],image[12],image[13],image[14],image[15],image[16] = vint_dataitem_get(data_item_handle)

	for i=1,16 do
		vint_set_property( vint_object_find( "xp_challenge_"..i ), "image", image[i] )
		if(image[i] == "ui_fend_icon_lock")then
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "alpha", 0.33 )
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "scale", 0.5,0.5 )
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "tint", DARK_ORANGE.R,DARK_ORANGE.G,DARK_ORANGE.B )
		else
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "alpha", 1 )
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "scale", 1,1 )
			vint_set_property( vint_object_find( "xp_challenge_"..i ), "tint", 1,1,1 )
		end
	end
	
end

-- #############################################################
function update_row_position(index)
	local new_y = Row_base_pos_y + (Row_base_size_y/XP_parent_scale_y) * (index - 1)
	vint_set_property( Row_handles[index], "anchor", Row_base_pos_x, new_y )
end

-- #############################################################
function update_row(data_item_handle, event_name)
	local index, label, value, has_dags, scroll_pct = vint_dataitem_get(data_item_handle)

	-- Do we need to add a new row?
	if (event_name == "insert") then
		add_event_row()
	end

	-- Update this guys position
	update_row_position(index)

	-- Set all of his data
	if ((index >= 1) and (index <= Num_rows)) then
		local handle = vint_object_find( "event_label", Row_handles[index] )
		vint_set_property( handle, "text_tag", label )

		handle = vint_object_find( "event_value", Row_handles[index] )
		vint_set_property( handle, "text_tag", value )
		set_text_width( handle, 180, 1.0 )
		
		
		--vint_set_property( name_handle, "tint", BROWN.R,BROWN.G,BROWN.B )
		--vint_set_property( new_handle, "tint", BROWN.R,BROWN.G,BROWN.B )

		-- Does this row have dags?
		handle = vint_object_find( "event_dags_main", Row_handles[index] )
		vint_set_property( handle, "visible", has_dags )
	end

	if(scroll_pct ~= nil)then
		local tab_handle =  vint_object_find( "tab" )
		local tab_x,tab_y = vint_get_property( tab_handle, "anchor" )
		local scroll_max = 425
		local new_tab_y = scroll_pct * scroll_max
		vint_set_property( tab_handle, "anchor", tab_x, new_tab_y )
	end
end

-- #############################################################
function add_event_row()
	if (Num_rows < 1) then
		vint_set_property( Row_handles[1], "visible", true )
	else
		Row_handles[Num_rows + 1] = vint_object_clone_rename( Row_handles[1], "event_group"..Num_rows )
	end

	Num_rows = Num_rows + 1
end

-- #############################################################
function remove_event_row()
	if (Num_rows <= 1) then
		vint_set_property( Row_handles[1], "visible", false )
	else 
		vint_object_destroy( Row_handles[Num_rows] )
	end

	Num_rows = Num_rows - 1
end

-- ##############################################################
function set_text_width( text_handle, max_width, text_scale )
	--resize the text if it is too big
	--get the scale
	--vint_set_property(text_handle,"text_scale",0.7, 0.8)
	
	local text_scale_x,text_scale_y = vint_get_property( text_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "xp_tally_screen_group" ), "scale" )

	local text_width,text_height = vint_get_property( text_handle, "screen_size" )
	local text_max_width = max_width * parent_scalex
	local new_scale = text_max_width/text_width * text_scale
	--make the text fit
	if( text_width > text_max_width )then
		vint_set_property( text_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( text_handle, "text_scale",text_scale,text_scale_y )
	end
end