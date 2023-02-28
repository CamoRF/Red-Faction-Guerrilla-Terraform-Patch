
MAX_EVENTS		= 8
EVENT_PADDING		= 5
Event_handle		= {OBJECT_HANDLES_EVENTS = 0}
Event_anim_handle	= {OBJECT_HANDLES_EVENTS = 0}
Event_total		= 0
Event_group_size	= {0, 0}
Event_group_scale	= {0, 0}
Running_Count		= 1

-- ##############################################################
function init_handles_mp_hud_xp()
	
	--store the height of the event group
	local event_parent_handle = vint_object_find( "xp_event" )
	Event_group_size[1], Event_group_size[2] = vint_get_property( event_parent_handle, "screen_size" )

	--store the scale of the event group
	Event_group_scale[1], Event_group_scale[2] = vint_get_property( event_parent_handle, "scale" )

	vint_set_property( vint_object_find( "xp_event" ),"visible",false)
	vint_set_child_tween_state( vint_object_find( "xp_event_anim"), TWEEN_STATE_DISABLED )

	show_totals()
end


-- ##############################################################
function rfg_ui_mp_hud_xp_cleanup()

end

-- ##############################################################
function rfg_ui_mp_hud_xp_init()
	-- get the handles
	init_handles_mp_hud_xp()

	vint_dataitem_add_subscription( "multiplayer_hud_xp", "update", "set_xp_data" )
end

-- ##############################################################
function set_xp_data(data_item_handle, event_name)
	local xp_event_name, xp_amount, is_bonus_event, xp_total, xp_bonus, leveled_up = vint_dataitem_get(data_item_handle)
	
	-- get all of our handles
	local xp_bonus_total_label 	= vint_object_find( "xp_bonus_total_label" )
	local xp_bonus_total_value 	= vint_object_find( "xp_bonus_total_value" )
	local xp_bonus_icon 		= vint_object_find( "xp_bonus_icon" )
	local xp_bonus_background	= vint_object_find( "xp_bonus_bg")

	local xp_total_label		= vint_object_find( "xp_total_label" )	
	local xp_total_value		= vint_object_find( "xp_total_value" )
	local xp_total_icon		= vint_object_find( "xp_total_icon" )
	local xp_total_background	= vint_object_find( "xp_total_bg")
	
	local xp_bonus_new = ": "..xp_bonus
	vint_set_property( xp_bonus_total_value, "text_tag", xp_bonus_new )
	
	local parent_xscale,parent_yscale = vint_get_property( vint_object_find( "xp_group" ),"scale" )

	--layout the text based on widths
	local bonus_x,bonus_y = vint_get_property( xp_bonus_total_label, "anchor" )
	local bonus_width,bonus_height = vint_get_property( xp_bonus_total_label, "screen_size" )
	local new_x = bonus_x + bonus_width / parent_xscale + EVENT_PADDING
	vint_set_property( xp_bonus_total_value, "anchor",new_x,bonus_y )

	--size the background 
	local bonus_bg_width,bonus_bg_height = vint_get_property( xp_bonus_background, "screen_size" )
	vint_set_property( xp_bonus_background, "screen_size", 0, bonus_bg_height )
	vint_set_property( vint_object_find( "xp_bonus_end_cap" ), "anchor", 0,0)
	local new_bonus_bg_width = vint_get_property( vint_object_find( "xp_bonus_group" ), "screen_size" )
	
	vint_set_property( xp_bonus_background, "screen_size",new_bonus_bg_width,bonus_bg_height)
	
	--place the end cap
	local bonus_bg_x,bonus_bg_y = vint_get_property( xp_bonus_background, "anchor" )
	local bonus_end_cap_x = bonus_bg_x + new_bonus_bg_width / parent_xscale
	vint_set_property( vint_object_find( "xp_bonus_end_cap" ), "anchor", bonus_end_cap_x,bonus_bg_y)
	
	-- set the text for the total label and value
	local xp_total_new = ": "..xp_total
	vint_set_property( xp_total_value, "text_tag", xp_total_new )

	--layout the text based on widths
	local total_x,total_y = vint_get_property(xp_total_label, "anchor" )
	local total_width,total_height = vint_get_property( xp_total_label, "screen_size" )
	local new_x = total_x + total_width / parent_xscale + EVENT_PADDING
	vint_set_property( xp_total_value, "anchor",new_x,total_y )

	--size the background 
	local total_bg_width,total_bg_height = vint_get_property( xp_total_background, "screen_size" )
	vint_set_property( xp_total_background, "screen_size", 0, total_bg_height )
	vint_set_property( vint_object_find( "xp_total_end_cap" ), "anchor", 0,0)
	local new_total_bg_width = vint_get_property( vint_object_find( "xp_total_group" ), "screen_size" )
	vint_set_property( xp_total_background, "screen_size",new_total_bg_width,total_bg_height)
	
	--place the end cap
	local total_bg_x,total_bg_y = vint_get_property( xp_total_background, "anchor" )
	local total_end_cap_x = total_bg_x + new_total_bg_width / parent_xscale
	vint_set_property( vint_object_find( "xp_total_end_cap" ), "anchor", total_end_cap_x, total_bg_y )
	
	--valid event?
	if(xp_event_name ~= nil)then

		local prev = Event_total
		Event_total = Event_total + 1

		show_totals()

		-- if we've reached our limit, destroy whoever is ontop.
		if( Event_total > MAX_EVENTS )then
			Event_total = MAX_EVENTS
			print_out_array()
			--debug_print("vint", "BOUND DESTROY: "..Event_handle[MAX_EVENTS].."\n" )

			vint_object_destroy( Event_handle[MAX_EVENTS] )	
			vint_object_destroy( Event_anim_handle[MAX_EVENTS] )

		end
		
		local xp_parent_handle = vint_object_find( "xp_event" )
		local event_anim_parent_handle = vint_object_find( "xp_event_anim" )

		--debug_print( "vint", "EVENT_TOTAL:  "..Event_total.."\n" )
		--start the tween
		local anim_handle = vint_object_find( "xp_total_anim" )
		local bonus_group_handle = vint_object_find( "xp_bonus_group" )
		local total_group_handle = vint_object_find( "xp_total_group" )
		if( Event_total > 1 )then
			--bump data up
			for i = Event_total,2,-1 do
				--move all the existing objects and tween up
				Event_handle[i]	= Event_handle[i-1]
				Event_anim_handle[i] = Event_anim_handle[i-1]
			end
			--move all the rows up
			for i = 2, Event_total do
				-- k, setup the positions - get the previous item's position
				local new_y = get_event_y(i)

				local anchor_x, anchor_y = vint_get_property( Event_handle[i], "anchor" )
				vint_set_property( Event_handle[i], "anchor", anchor_x, new_y  )

				-- now do the anchor tween				
				local tween_handle = vint_object_find( "event_alpha_1", Event_anim_handle[i] )
				local end_x, end_y = vint_get_property( tween_handle, "end_value" )
				vint_set_property( tween_handle, "start_value", -500, new_y )
				vint_set_property( tween_handle, "end_value", end_x, new_y )
			end	
			vint_set_property( total_group_handle, "visible", true )
			vint_set_property( total_group_handle, "alpha", 1.0 )
			vint_set_property( bonus_group_handle, "visible", true )
			vint_set_property( bonus_group_handle, "alpha", 1.0 )
			vint_set_property(anim_handle, "start_time", (vint_get_time_index() - 0.33) )
		else		
			local anchor_x, anchor_y = vint_get_property( bonus_group_handle, "anchor" )
			vint_set_property( bonus_group_handle, "visible", true )
			vint_set_property( bonus_group_handle, "alpha", 1.0 )

			local anchor_x, anchor_y = vint_get_property( total_group_handle, "anchor" )
			vint_set_property( total_group_handle, "visible", true )
			vint_set_property( total_group_handle, "alpha", 1.0 )
			
			vint_set_property(anim_handle, "start_time", (vint_get_time_index() - 0.33) )
		end
		
		vint_set_child_tween_state( anim_handle, TWEEN_STATE_IDLE )
		
		--clone the event group and animation
		Event_handle[1] = vint_object_clone_rename(xp_parent_handle, "xp_event"..Running_Count )
		Event_anim_handle[1] = vint_object_clone_rename(event_anim_parent_handle, "xp_event_anim"..Running_Count )
		
		-- setup the new tween to point to the new xp group
		local twn_h = vint_object_find( "event_alpha_1", Event_anim_handle[1] )
		vint_set_property( twn_h, "target_handle", Event_handle[1] )
		twn_h = vint_object_find( "event_alpha_2", Event_anim_handle[1] )
		vint_set_property( twn_h, "target_handle", Event_handle[1] )
		vint_set_property( twn_h, "end_event", "remove_xp_event" )

		-- get the handles for all the objects in our new xp event
		local new_xp_num = vint_object_find( "xp_num",Event_handle[1] )
		local new_xp_text = vint_object_find( "xp_text", Event_handle[1] )
		local new_xp_icon = vint_object_find( "xp_icon", Event_handle[1] )
		local new_xp_background = vint_object_find( "xp_bg",Event_handle[1] )

		-- figure out the name of our icon
		local icon_name
		if(is_bonus_event == true )then
			icon_name =  "ui_map_icon_mp_bonus_xp"
		else
			icon_name =   "ui_map_icon_mp_xp"
		end		

		-- set the properties for our new xp event		 
		vint_set_property( new_xp_text, "text_tag", tostring(xp_event_name) )
		vint_set_property( new_xp_num, "text_tag", tostring(" +"..xp_amount) )
		vint_set_property( new_xp_icon, "image", icon_name )
		vint_set_property( new_xp_icon, "scale", 0.8,0.8 )
	
		local number_x,number_y = vint_get_property( new_xp_num, "anchor" )
		local number_width,number_height = vint_get_property( new_xp_num, "screen_size" )
		local new_x = number_x + number_width / parent_xscale + EVENT_PADDING
		vint_set_property( new_xp_text, "anchor",new_x,number_y )

		--size the background based on icon position, width and overall text width
		local bg_width,bg_height = vint_get_property( new_xp_background, "screen_size" )
		vint_set_property( new_xp_background, "screen_size", 0, bg_height )
		vint_set_property( vint_object_find( "xp_end_cap", Event_handle[1] ), "anchor", 0, 0 )
		local new_bg_width = vint_get_property( Event_handle[1], "screen_size" )
		if(new_bg_width~=nil)then
			vint_set_property( new_xp_background, "screen_size",new_bg_width,bg_height)
			--place the end cap
			local bg_x,bg_y = vint_get_property( new_xp_background, "anchor" )
			local end_cap_x = bg_x + new_bg_width / parent_xscale
			vint_set_property( vint_object_find( "xp_end_cap", Event_handle[1] ), "anchor", end_cap_x, bg_y )

			local anchor_x, anchor_y = vint_get_property( Event_handle[1], "anchor" )
			vint_set_property( Event_handle[1], "anchor", -500.0, anchor_y  )
			vint_set_property( Event_handle[1],"visible",true)
			vint_set_property( Event_handle[1], "alpha", 1.0 )
			
			--start the tween
			vint_set_property(Event_anim_handle[1], "start_time", vint_get_time_index() )
			vint_set_child_tween_state( Event_anim_handle[1], TWEEN_STATE_IDLE )
		end
		
		--handle totals
		

		-- update our running count so we get unique names for all of our objects we clone
		Running_Count = Running_Count + 1
		if (Running_Count > 8) then
			Running_Count = 1
		end

		
	else
		vint_set_property( vint_object_find( "xp_event" ), "visible", false )
		--debug_print( "vint", "NIL DUDE!!!\n" )
	end
	
end

function print_out_array()
	--debug_print( "vint", "EVENT TOTAL: "..Event_total.."\n" )

	for i = 1, Event_total do
		--debug_print( "vint", "INDEX:"..i.."   "..Event_handle[i].."\n" )
	end
end
	

function remove_xp_event(target_handle, event_name)
	print_out_array()
	--debug_print( "vint", "TWEEN DESTROY: "..Event_handle[Event_total].."\n" )

	-- delete the dude on top
	vint_object_destroy( Event_handle[Event_total] )	
	vint_object_destroy( Event_anim_handle[Event_total] ) 

	-- decriment our count
	Event_total = Event_total - 1

	--show_totals()
end

function get_event_y(index)
	local anchor_x, anchor_y = vint_get_property( vint_object_find( "xp_event" ), "anchor" )
	local adjusted_height = Event_group_size[2]
	local y_to_set = (anchor_y - adjusted_height * (index-1)) * Event_group_scale[2]

	return y_to_set
end

function show_totals()
	--debug_print("vint","Event_total = "..Event_total.."\n")
	if(Event_total > 0)then
		vint_set_property( vint_object_find( "xp_bonus_group" ), "visible", true)
		vint_set_property( vint_object_find( "xp_total_group" ), "visible", true )
	else
		vint_set_property( vint_object_find( "xp_bonus_group" ), "visible", false)
		vint_set_property( vint_object_find( "xp_total_group" ), "visible", false )
	end
end