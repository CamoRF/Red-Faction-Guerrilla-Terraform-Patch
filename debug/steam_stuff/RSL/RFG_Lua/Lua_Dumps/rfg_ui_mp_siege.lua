--include "rfg_ui_mp_siege_shared.lua"

siege_group_handle			= {OBJECT_HANDLES_ROWS = 0}
Siege_total				= 0
siege_group_size			= {0, 0}
siege_group_scale			= {0, 0}

siege_goal_data_item_handle		= {OBJECT_HANDLES_ROWS = 0}
siege_goal_group_handle			= {OBJECT_HANDLES_ROWS = 0}
siege_goal_total			= 0
siege_goal_group_size			= {0, 0}
siege_goal_group_scale			= {0, 0}

siege_group_anim_handle			= {OBJECT_HANDLES_ANIMS = 0}
siege_rebuild_anim_handle		= {OBJECT_HANDLES_ANIMS = 0}

prev_health				= {OBJECT_HANDLES_HEALTH = 0}

prev_names				= {OBJECT_HANDLES_NAMES = 0}

Siege_target_names			= {OBJECT_HANDLES_NAMES = 0}

Mode_name				= ""

ORANGE					= {R=0.83,G=0.54,B=0}
DARK_ORANGE				= {R=0.5,G=0.25,B=0}
RED					= {R=1.0,G=0.5,B=0.0}
BLUE					= {R=0.25,G=0.5,B=0.5}
GRAY					= {R=0.3,G=0.3,B=0.3}
GREEN					= {R=0.42,G=0.61,B=0.08}

SIEGE_TEAM1_COLOR			= { R = 0, G = 0, B = 0 }
SIEGE_TEAM2_COLOR			= { R = 0, G = 0, B = 0 }



-- ##############################################################
function rfg_ui_mp_siege_cleanup()
end

-- ##############################################################
function rfg_ui_mp_siege_init()
	
	Mode_name = rfg_get_multiplayer_mode_name()
	-- get the handles
	init_mp_siege_handles()
	--init_mp_siege_shared_handles(Mode_name) we removed unlock list don't need this

	-- subscribe to the data item whose name is , and we listen for updates, so that
	-- it then calls our function show_mps

	--target subscriptions
	vint_datagroup_add_subscription( "current_siege_targets", "insert", "set_siege_data" )
	vint_datagroup_add_subscription( "current_siege_targets", "update", "set_siege_data" )
	vint_datagroup_add_subscription( "current_siege_targets", "remove", "remove_siege_item" )
	
	vint_datagroup_add_subscription( "damage_control_targets", "insert", "set_siege_data" )
	vint_datagroup_add_subscription( "damage_control_targets", "update", "set_siege_data" )
	vint_datagroup_add_subscription( "damage_control_targets", "remove", "remove_siege_item" )

end

-- ##############################################################
function init_mp_siege_handles()

	--store the height of the siege group
	local siege_parent_handle = vint_object_find( "siege_group" )
	siege_group_size[1], siege_group_size[2] = vint_get_property( siege_parent_handle, "screen_size" )

	--store the scale of the siege group
	siege_group_scale[1], siege_group_scale[2] = vint_get_property( siege_parent_handle, "scale" )

	--hide the siege group clone target
	vint_set_property( siege_parent_handle, "visible", false )
	
	if( Mode_name == "king_of_the_hill" )then
		vint_set_property( vint_object_find( "siege_goal_bg" ), "visible", false )
	else
		vint_set_property( vint_object_find( "siege_goal_bg" ), "visible", true )
	end

	--get the team colors
	local team1_red, team1_green, team1_blue = rfg_get_mp_team_color(HUMAN_TEAM_GUERILLA)
	local team2_red, team2_green, team2_blue = rfg_get_mp_team_color(HUMAN_TEAM_EDF)
	--store the team colors
	SIEGE_TEAM1_COLOR = { R = team1_red, G = team1_green, B = team1_blue }
	SIEGE_TEAM2_COLOR = { R = team2_red, G = team2_green, B = team2_blue }
	--stop the animations
	--vint_set_child_tween_state( vint_object_find( "siege_group_anim" ), TWEEN_STATE_DISABLED ) 
	--vint_set_child_tween_state( vint_object_find( "siege_rebuild_anim" ), TWEEN_STATE_DISABLED )
	--vint_reset_child_tween_object( vint_object_find( "siege_group_anim" ) ) 
	local siege_group_anchor = {0,0}
	siege_group_anchor[1], siege_group_anchor[2] = vint_get_property( siege_parent_handle, "anchor" )
	--debug_print("vint","****** siege_group_anchor[1] = "..tostring(siege_group_anchor[1]).."\n\n")
end


-- ##############################################################
function set_siege_data(data_item_handle, event_name)
	
	local target_priority,target_name,target_health,target_distance,target_rotation,target_team,target_locked,target_index = nil
	target_priority,target_name,target_health,target_distance,target_rotation,target_team,target_locked,target_index = vint_dataitem_get(data_item_handle)

	if ( event_name == "insert" ) then		
	
		add_siege_item( target_locked )
		if( prev_health[target_index] == nil )then
			prev_health[target_index] = target_health
		end
	end

	set_siege_data_actual( data_item_handle, target_priority, target_name, target_health, target_distance, target_rotation, target_team, target_locked, target_index )

end

-- ##############################################################
function add_siege_item( target_locked )
	local prev = Siege_total
	local new_cnt = Siege_total + 1

	--debug_print("vint","ADD ITEM: prev = "..prev.." ,new_cnt = "..new_cnt.."\n")
	
	local siege_parent_handle = vint_object_find( "siege_group" )
	local siege_anim_parent_handle = vint_object_find( "siege_group_anim" )
	local siege_rebuild_parent_handle = vint_object_find( "siege_rebuild_anim" )

	if(prev == 0)then
		siege_group_handle[new_cnt] = siege_parent_handle
		siege_group_anim_handle[new_cnt] = siege_anim_parent_handle
		siege_rebuild_anim_handle[new_cnt] = siege_rebuild_parent_handle

		--if( Mode_name == "king_of_the_hill" or Mode_name == "siege" )then
			--offset the first widget for damage control
		local x,y = rfg_get_screen_dim()
		local siege_parent_handle = vint_object_find( "siege_group" )
		local anchor_x, anchor_y = vint_get_property( siege_parent_handle, "anchor" )
		local new_y
		--local adjusted_height = siege_group_size[2] * 720.0/y - ( 45 * y/720.0 )
		local adjusted_height = (siege_group_size[2] ) - ( 5.0 )
		new_y = anchor_y + adjusted_height * siege_group_scale[2]
		local startx,starty = vint_get_property( vint_object_find( "siege_group_anchor_twn_1"), "start_value" )
		vint_set_property( siege_parent_handle, "anchor", startx, new_y )
		local twn_h
		--set the tween y
		for i = 1,4 do
			twn_h = vint_object_find( "siege_group_anchor_twn_"..i ,  vint_object_find("siege_group_anim") )
			vint_set_property( twn_h, "target_handle", siege_parent_handle )
			local old_x,old_y = vint_get_property(twn_h,"start_value")
			vint_set_property( twn_h, "start_value", old_x,new_y )
			old_x,old_y = vint_get_property(twn_h,"end_value")
			vint_set_property( twn_h, "end_value", old_x,new_y )
		end
		--end
	else
		-- k, clone the row group
		siege_group_handle[new_cnt] = vint_object_clone_rename(siege_parent_handle, "siege_group"..new_cnt )
		--clone the anim
		siege_group_anim_handle[new_cnt] = vint_object_clone_rename(siege_anim_parent_handle, "siege_group_anim"..new_cnt )
		siege_rebuild_anim_handle[new_cnt] = vint_object_clone_rename(siege_rebuild_parent_handle, "siege_rebuild_anim"..new_cnt )
		
		-- k, setup the positions - get the previous item's position
		local anchor_x, anchor_y
		local new_y
		
		anchor_x, anchor_y = vint_get_property( siege_group_handle[prev], "anchor" )
		--local adjusted_height = siege_group_size[2] * 720.0/y - ( 25 * y/720.0 )
		local adjusted_height = (siege_group_size[2] ) - ( 5.0 )
		if( target_locked == true )then
			new_y = anchor_y + (adjusted_height) * siege_group_scale[2]
		else
			new_y = anchor_y + adjusted_height * siege_group_scale[2]
		end
		local startx,starty = vint_get_property( vint_object_find( "siege_group_anchor_twn_1"), "start_value" )
		--vint_set_property( siege_group_handle[new_cnt], "anchor", startx, new_y )
		vint_set_property( siege_group_handle[new_cnt], "anchor", startx, new_y )
		
		--retarget the tweens
		local twn_h
		for i = 1,4 do
			twn_h = vint_object_find( "siege_group_anchor_twn_"..i , siege_group_anim_handle[new_cnt] )
			vint_set_property( twn_h, "target_handle", siege_group_handle[new_cnt] )
			local old_x,old_y = vint_get_property(twn_h,"start_value")
			vint_set_property( twn_h, "start_value", old_x,new_y )
			old_x,old_y = vint_get_property(twn_h,"end_value")
			vint_set_property( twn_h, "end_value", old_x,new_y )
		end

		twn_h = vint_object_find( "siege_health_alpha_twn_1" , siege_group_anim_handle[new_cnt] )
		local twn_h2 =  vint_object_find( "siege_health", siege_group_handle[new_cnt] )
		vint_set_property( twn_h, "target_handle", twn_h2 )

		twn_h = vint_object_find( "siege_health2_scale_twn_1" , siege_rebuild_anim_handle[new_cnt] )
		twn_h2 =  vint_object_find( "siege_health2", siege_group_handle[new_cnt] )
		vint_set_property( twn_h, "target_handle", twn_h2 )

		twn_h = vint_object_find( "siege_health2_alpha_twn_1" , siege_rebuild_anim_handle[new_cnt] )
		twn_h2 =  vint_object_find( "siege_health2", siege_group_handle[new_cnt] )
		vint_set_property( twn_h, "target_handle", twn_h2 )
	end
	--stop the tweens
	--vint_set_child_tween_state( vint_object_find( "siege_group_anim" ), TWEEN_STATE_DISABLED ) 
	--vint_set_child_tween_state( vint_object_find( "siege_rebuild_anim" ), TWEEN_STATE_DISABLED ) 
	--vint_reset_child_tween_object( vint_object_find( "siege_group_anim" ) ) 

	--vint_set_child_tween_state( siege_group_anim_handle[new_cnt], TWEEN_STATE_DISABLED ) 
	--vint_set_child_tween_state( siege_rebuild_anim_handle[new_cnt], TWEEN_STATE_DISABLED ) 
	--vint_reset_child_tween_object( siege_group_anim_handle[new_cnt] ) 
	
	-- make visible
	vint_set_property( siege_group_handle[new_cnt], "visible", true )
		
	-- bump cnt
	Siege_total = new_cnt
	return new_cnt
end

-- ##############################################################
function remove_siege_item(data_item_handle, event_name)

	if(Siege_total ~= 1)then
		-- now delete this item!
		vint_object_destroy(siege_group_handle[Siege_total])
	else
		vint_set_property(siege_group_handle[Siege_total], "visible", false)
	end
	
	siege_group_handle[Siege_total] = 0

	Siege_total = Siege_total - 1
	
	-- DJH: This isn't *entirely* right, but whatever. It'll work as long as we remove all items before adding new ones
	
end

-- ##############################################################
function set_siege_data_actual( data_item_handle, target_priority,target_name,target_health,target_distance,target_rotation,target_team,target_locked,target_index )
	
	--local siege_parent_handle = siege_group_handle[index]
	local siege_parent_handle = siege_group_handle[target_index]
	if (siege_parent_handle == nil) then
		return
	end

	--debug_print("vint","SET DATA: target_index = "..target_index.." ,target_health = "..target_health.."\n")

	-- Truncate health and distance
	target_health = ceil(100 - target_health)
	target_distance = floor(target_distance)

	--store a handle to all the row objects
	local target_name_handle = vint_object_find( "siege_title", siege_parent_handle )
	local target_health_handle = vint_object_find( "siege_health", siege_parent_handle )
	local target_distance_handle = vint_object_find( "siege_distance", siege_parent_handle )
	local target_direction_handle = vint_object_find( "siege_direction", siege_parent_handle )
	local target_direction_handle2 = vint_object_find( "siege_direction2", siege_parent_handle )
	local target_team_handle = vint_object_find( "siege_team", siege_parent_handle )
	local target_logo_handle = vint_object_find( "siege_logo", siege_parent_handle )
	local target_name_shadow_handle = vint_object_find( "siege_title_shadow", siege_parent_handle )
	local target_changed

	if(target_name ~= prev_names[target_index])then
		target_changed = true
	else
		target_changed = false
	end
	
	--set the target name
	vint_set_property( target_name_handle, "text_tag", target_name )
	vint_set_property( target_name_handle, "text_scale",0.7,0.8 )

	vint_set_property( target_name_shadow_handle, "text_tag", target_name )
	vint_set_property( target_name_shadow_handle, "text_scale",0.7,0.8 )

	--make the target name fit
	local text_width,text_height = vint_get_property( target_name_handle, "screen_size" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "siege_group" ), "scale" )
	local name_max_width = 175.0 * parent_scalex
	if( text_width > name_max_width )then
		local new_scale = name_max_width/text_width * 0.7
		vint_set_property( target_name_handle, "text_scale", new_scale, 0.8 )
		vint_set_property( target_name_shadow_handle, "text_scale", new_scale, 0.8 )
	else
		vint_set_property( target_name_handle, "text_scale",0.7,0.8 )
		vint_set_property( target_name_shadow_handle, "text_scale",0.7,0.8 )
	end
	
	
	Siege_target_names[target_index] = target_name
	
	--make the health number we get a string
	local health_string = tostring(target_health)
	--add the percent symbol
	local health_toset = health_string.."%%"
	--set the target health
	vint_set_property( target_health_handle,"text_tag", health_toset )
	vint_set_property( vint_object_find( "siege_health2", siege_parent_handle ),"text_tag", health_toset )
	
	-- it seems that sometimes prev_health can be nil if the session is ending unexpectedly
	if( prev_health[target_index] ~= nil ) then
		--did health change negatively
		if( prev_health[target_index] > target_health and target_changed == false )then
			--animate the target
			vint_set_property(siege_group_anim_handle[target_index], "start_time", vint_get_time_index() )
			vint_set_child_tween_state( siege_group_anim_handle[target_index], TWEEN_STATE_IDLE ) 
		end

		--did health change positively
		if( prev_health[target_index] > 0 and prev_health[target_index] < target_health and target_changed == false)then
			--animate the target
			vint_set_property(siege_rebuild_anim_handle[target_index], "start_time", vint_get_time_index() )
			vint_set_child_tween_state( siege_rebuild_anim_handle[target_index], TWEEN_STATE_IDLE ) 
		end
	end
	
	if(target_changed == true)then
		vint_set_child_tween_state( siege_group_anim_handle[target_index], TWEEN_STATE_DISABLED ) 
		vint_set_child_tween_state( siege_rebuild_anim_handle[target_index], TWEEN_STATE_DISABLED ) 
		
		--set health2 back to 0 alpha
		vint_set_property(vint_object_find("siege_health2",siege_parent_handle),"alpha",0)

		local startx,starty = vint_get_property( vint_object_find( "siege_group_anchor_twn_1"), "start_value" )
		local targetx,targety = vint_get_property( siege_parent_handle, "anchor" )
		vint_set_property( siege_parent_handle, "anchor", startx, targety )
	end

	--set the color of the text based on health
	local r = 1
	local g = 0.24
	local b = 0.24

	if (target_health > 0) then
		if( target_health >= 75 )then
			--green
			r = 0.42
			g = 0.61
			b = 0.08
		elseif( target_health < 75 and target_health >= 50)then
			--yellow
			r = 0.97
			g = 0.78
			b = 0.02
		elseif( target_health < 50 and target_health >= 25)then
			--orange
			r = 1
			g = 0.5
			b = 0

		elseif( target_health < 25 )then
			--red
			r = 1
			g = 0.24
			b = 0.24
		else
			--red
			r = 1
			g = 0.24
			b = 0.24
		end
	else
		--red
		r = 1
		g = 0.24
		b = 0.24
	end
	vint_set_property( target_health_handle,"tint", r,g,b )
	vint_set_property( vint_object_find( "siege_health2", siege_parent_handle ),"tint", r,g,b )

	--set the target distance
	vint_set_property( target_distance_handle,"text_tag", target_distance )

	--set the target direction
	vint_set_property( target_direction_handle,"rotation", target_rotation )
	vint_set_property( target_direction_handle2,"rotation", target_rotation )

	--scale and tint direction arrow
	if( target_distance < 20 )then
		vint_set_property( target_direction_handle,"tint", GREEN.R, GREEN.G, GREEN.B )
		vint_set_property( target_direction_handle2,"tint", GREEN.R, GREEN.G, GREEN.B )
		vint_set_property( target_direction_handle2,"visible",true )
		vint_set_property( target_direction_handle2,"alpha",0.50 )
	else
		vint_set_property( target_direction_handle,"tint", ORANGE.R, ORANGE.G, ORANGE.B )
		vint_set_property( target_direction_handle2,"visible",false )
	end

	if( target_team ~= nil )then-- and Mode_name == "king_of_the_hill" )then
		--check the team
		if( target_team == 0 )then
			--target is guerrilla
			vint_set_property( target_team_handle, "visible", true )
			vint_set_property( target_logo_handle, "image", "ui_hud_guerilla_logo_white" )
			vint_set_property( target_logo_handle, "scale", 0.8,0.8 )
			vint_set_property( target_logo_handle, "tint", SIEGE_TEAM1_COLOR.R, SIEGE_TEAM1_COLOR.G, SIEGE_TEAM1_COLOR.B )
			vint_set_property( target_name_handle,"tint", SIEGE_TEAM1_COLOR.R, SIEGE_TEAM1_COLOR.G, SIEGE_TEAM1_COLOR.B )
		elseif( target_team == 1 )then
			--target is edf
			vint_set_property( target_team_handle, "visible", true )
			vint_set_property( target_logo_handle, "image", "ui_hud_edf_logo_white" )
			vint_set_property( target_logo_handle, "scale", 0.8,0.8 )
			vint_set_property( target_logo_handle, "tint", SIEGE_TEAM2_COLOR.R, SIEGE_TEAM2_COLOR.G, SIEGE_TEAM2_COLOR.B )
			vint_set_property( target_name_handle,"tint", SIEGE_TEAM2_COLOR.R, SIEGE_TEAM2_COLOR.G, SIEGE_TEAM2_COLOR.B )
		else
			vint_set_property( target_team_handle, "visible", true )
			vint_set_property( target_logo_handle, "image", "ui_hud_tip_icon" )
			vint_set_property( target_logo_handle, "tint", DARK_ORANGE.R, DARK_ORANGE.G, DARK_ORANGE.B )
			vint_set_property( target_name_handle,"tint", GRAY.R, GRAY.G, GRAY.B )
		end
	else
		vint_set_property( target_team_handle, "visible", false )
	end
	
	local target_bg2_handle = vint_object_find( "siege_bg2", siege_parent_handle )
	
	--make locked targets look different
	--locked targets are in groups that show how many targets are in each group
	if( target_locked == true )then
		vint_set_property( siege_parent_handle,"alpha",1.0)
		vint_set_property( target_name_handle,"tint", DARK_ORANGE.R, DARK_ORANGE.G, DARK_ORANGE.B )
		vint_set_property( target_health_handle,"visible", false )
		vint_set_property( target_distance_handle,"visible", false )
		vint_set_property( target_direction_handle,"visible", false )
		vint_set_property( target_direction_handle2,"visible",false )
		vint_set_property( target_team_handle,"visible", false )
		vint_set_property( target_logo_handle,"visible", false )
		vint_set_property( target_bg2_handle, "visible", false )
		vint_set_property( vint_object_find( "siege_health2", siege_parent_handle ), "visible", false )
		vint_set_property( vint_object_find( "siege_meter", siege_parent_handle ), "visible", false )
		vint_set_property( vint_object_find( "siege_hud_lock", siege_parent_handle ), "visible", true )
	else
		vint_set_property( siege_parent_handle,"alpha",1.0)
		vint_set_property( target_name_handle,"tint", ORANGE.R, ORANGE.G, ORANGE.B )
		vint_set_property( target_bg2_handle, "visible", true )
		vint_set_property( target_health_handle,"visible", true )
		vint_set_property( target_distance_handle,"visible", true )
		vint_set_property( target_direction_handle,"visible", true )
		vint_set_property( target_team_handle,"visible", true )
		vint_set_property( target_logo_handle,"visible", true )
		vint_set_property( vint_object_find( "siege_health2", siege_parent_handle ), "visible", true )
		vint_set_property( vint_object_find( "siege_meter", siege_parent_handle ), "visible", true )
		vint_set_property( vint_object_find( "siege_hud_lock", siege_parent_handle ), "visible", false )
	end

	--store the health
	--prev_health[index] = target_health
	prev_health[target_index] = target_health
	prev_names[target_index] = target_name

	local siege_group_anchor = {0,0}
	siege_group_anchor[1], siege_group_anchor[2] = vint_get_property( siege_parent_handle, "anchor" )
	--debug_print("vint","*1**** siege_group_anchor["..tostring(target_index).."] = "..tostring(siege_group_anchor[1]).."\n\n")
	
end
