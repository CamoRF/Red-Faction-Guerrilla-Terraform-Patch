
Previous_health				= 0

Health_bar_main_handle		= 0
Health_anim_handle			= 0
Health_flash_anim_handle	= 0
Health_original_x				= 0
Health_original_y				= 0
Health_anchor_x				= 0
Health_anchor_y				= 0

Radiation_icon					= 0
Radiation_anim					= 0

-- ##############################################################
function init_handles_health()
	Health_bar_main_handle = vint_object_find( "health_bar_main" )
	Health_anim_handle = vint_object_find( "health_meter_anim" )
	Health_flash_anim_handle = vint_object_find( "health_meter_flash_anim" )

	Health_original_x,Health_original_y = vint_get_property( vint_object_find("health_meter_main"), "anchor" )
	Health_anchor_x,Health_anchor_y = vint_get_property( vint_object_find("health_anchor"), "anchor" )	
end

-- ##############################################################
function rfg_ui_hud_health_cleanup()
end

-- ##############################################################
function rfg_ui_hud_health_init()
	-- get the handles
	init_handles_health()
	-- subscribe to the data item whose name is ButtonAStatus, and we listen for updates, so that
	-- it then calls our function button_a_status_change
	vint_dataitem_add_subscription( "HealthUpdate", "update", "health_change" )
	vint_set_property( Health_bar_main_handle, "visible", false )
	vint_set_property( vint_object_find("health_meter_main"), "visible", false )

	Radiation_icon = vint_object_find("radiation_icon")
	vint_set_property(Radiation_icon, "visible", false)

	Radiation_anim = vint_object_find("radiation_anim")
	vint_set_child_tween_state( Radiation_anim, TWEEN_STATE_DISABLED)

end

-- ##############################################################
function health_change(data_item_handle, event_name)
	-- get all the data items at once (it puts the 1 values in tmp1-1)
	local health_pct, radiation, real_health, car_health, armor_level, car_on_fire = vint_dataitem_get(data_item_handle)
	local visible = true
	local alpha_bar = (1.0 - health_pct)
	if(alpha_bar >= 1.0)then
		alpha_bar = 1.0	
	end
	--set the meter
	local handle
	--are we taking radiation damage?  If so change the image
	if(radiation == true) then
		local size_x, size_y, scale_x, scale_y
		
		vint_set_property(Health_bar_main_handle, "tint", 1.0,1.0,1.0)

		handle = vint_object_find("top_left_gradient")
		vint_set_property(handle, "image", "ui_hud_radiation")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("top_right_gradient")
		vint_set_property(handle, "image", "ui_hud_radiation")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("bottom_left_gradient")
		vint_set_property(handle, "image", "ui_hud_radiation")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("bottom_right_gradient")
		vint_set_property(handle, "image", "ui_hud_radiation")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		--start radiation animation
		Radiation_icon = vint_object_find("radiation_icon")
		vint_set_property(Radiation_icon, "visible", true)

		Radiation_anim = vint_object_find("radiation_anim")
		vint_set_child_tween_state( Radiation_anim, TWEEN_STATE_RUNNING)

	else
		vint_set_property(Health_bar_main_handle, "tint", 0.22,0.03,0.03)

		local size_x, size_y, scale_x, scale_y
		
		handle = vint_object_find("top_left_gradient")
		vint_set_property(handle, "image", "ui_hud_blood_gradient")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("top_right_gradient")
		vint_set_property(handle, "image", "ui_hud_blood_gradient")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("bottom_left_gradient")
		vint_set_property(handle, "image", "ui_hud_blood_gradient")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		handle = vint_object_find("bottom_right_gradient")
		vint_set_property(handle, "image", "ui_hud_blood_gradient")
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(handle)
		vint_set_property(handle, "image_size", size_x * scale_x, size_y * scale_y)

		--kill radiation icon
		Radiation_icon = vint_object_find("radiation_icon")
		vint_set_property(Radiation_icon, "visible", false)

		Radiation_anim = vint_object_find("radiation_anim")
		vint_set_child_tween_state( Radiation_anim, TWEEN_STATE_DISABLED)
	end
	--did we just die and respawn in? now that we magically have full health, nuke the splats
	if( health_pct >= 1.0 )then
		vint_set_property( Health_bar_main_handle, "visible", false )
	else
		vint_set_property( Health_bar_main_handle, "visible", true )
	end
	--set the alpha of the full screen health
	vint_set_property( Health_bar_main_handle, "visible", visible )
	vint_set_property( Health_bar_main_handle, "alpha", alpha_bar )
	
	local new_scale = 0
	local armor_scale = 0
	local bg_scale = 0
	local duration = 0.33
	local start_time = 0
	if(car_health == false)then
		if(armor_level == 0)then
			handle = vint_object_find("armor_meter_main")
			vint_set_property(handle, "visible", false )
			new_scale = real_health * (358.0 * 0.5)
			bg_scale = (358.0 * 0.5)
			handle = vint_object_find("health_meter_main")
			vint_set_property(handle, "anchor", Health_anchor_x,Health_original_y )	
		end
		if(armor_level == 1)then
			handle = vint_object_find("armor_meter_main")
			vint_set_property(handle, "visible", false )
			new_scale = real_health * (358.0)
			bg_scale = 358.0
			handle = vint_object_find("health_meter_main")
			vint_set_property(handle, "anchor", Health_original_x,Health_original_y )	
		end
		if(armor_level == 2)then
			handle = vint_object_find("armor_meter_main")
			vint_set_property(handle, "visible", true )
			local adjusted_health = (real_health * 2.0) - 1
			if( adjusted_health >= 0 )then
				new_scale = 1.0 * 358.0
				armor_scale = adjusted_health * 372.0
			else
				armor_scale = 0.0 * 372.0
				new_scale = real_health * (358.0) * 2.0
			end
			bg_scale = 358.0
			handle = vint_object_find("health_meter_main")
			vint_set_property(handle, "anchor", Health_original_x,Health_original_y )	
		end
		start_time = 0.48
	else
		handle = vint_object_find("armor_meter_main")
		vint_set_property(handle, "visible", false )
		armor_scale = 0.0 * 372.0
		new_scale = real_health * (358.0)
		bg_scale = 358.0
		start_time = 6.0
		handle = vint_object_find("health_meter_main")
		vint_set_property(handle, "anchor", Health_original_x,Health_original_y )
	end
	if( real_health < 1.0 )then
		vint_set_property( vint_object_find("health_meter_main"), "visible", true )
		vint_set_child_tween_state( Health_anim_handle, TWEEN_STATE_DISABLED )

		handle = vint_object_find("the_health_meter_fill")
		vint_set_property(handle, "alpha", 0 )
		if(car_health == false)then
			local red = (1.0 - real_health)
			if(red <= 0.5 )then
				red = 0.5
			end
			handle = vint_object_find("the_health_meter")
			vint_set_property(handle, "tint", red,0,0 )
			vint_set_property(handle, "visible",true )
			handle = vint_object_find("the_health_meter2")
			vint_set_property(handle, "tint", red,0,0 )
			vint_set_property(handle, "visible",true )

			handle = vint_object_find("the_health_meter_fill")
			vint_set_property(handle, "tint", 0.5,0,0 )
			vint_set_property(handle, "visible",false )

			if(real_health <= 0.60)then
				vint_set_child_tween_state( Health_flash_anim_handle, TWEEN_STATE_IDLE )
			else
				vint_set_property( vint_object_find("health_meter_main"), "alpha", 1.0 )
				vint_set_child_tween_state( Health_flash_anim_handle, TWEEN_STATE_DISABLED )
			end
			handle = vint_object_find("health_dag_group")
			vint_set_property(handle, "visible", false )
			
			if( real_health <= 0 )then
				vint_set_property( vint_object_find("health_meter_main"), "visible", false )
			end
			
		else
			handle = vint_object_find("the_health_meter")
			vint_set_property(handle, "visible",false )
			handle = vint_object_find("the_health_meter2")
			vint_set_property(handle, "visible",false )

			handle = vint_object_find("the_health_meter_fill")
			vint_set_property(handle, "tint", 1.0, 0.74, 0.26 )
			vint_set_property(handle, "visible",true )
			vint_set_property(handle, "alpha", 1 )
			if( car_on_fire == true )then
				vint_set_property(handle, "tint", 0.5,0,0 )
			end

			if(real_health <= 0.30)then
				vint_set_child_tween_state( Health_flash_anim_handle, TWEEN_STATE_IDLE )
			else
				vint_set_property( vint_object_find("health_meter_main"), "alpha", 1.0 )
				vint_set_child_tween_state( Health_flash_anim_handle, TWEEN_STATE_DISABLED )
			end

			handle = vint_object_find("health_dag_group")
			vint_set_property(handle, "visible", false )

			vint_set_property( Health_anim_handle, "start_time", vint_get_time_index() )
			vint_set_child_tween_state( Health_anim_handle, TWEEN_STATE_RUNNING )
		end
	else
		if(car_health == false)then
			handle = vint_object_find("the_health_meter")
			vint_set_property(handle, "tint", 0.5,0,0 )
			vint_set_property(handle, "visible",true )
			handle = vint_object_find("the_health_meter2")
			vint_set_property(handle, "tint", 0.5,0,0 )
			vint_set_property(handle, "visible",true )
			handle = vint_object_find("the_health_meter_fill")
			vint_set_property(handle, "tint", 0.5,0,0 )
			vint_set_property(handle, "visible",false )
			vint_set_property(handle, "alpha", 0 )
		else
			handle = vint_object_find("the_health_meter_fill")
			vint_set_property(handle, "tint", 1.0, 0.74, 0.26 )
			vint_set_property(handle, "alpha", 1 )
			vint_set_property(handle, "visible",true )

			handle = vint_object_find("the_health_meter")
			vint_set_property(handle, "visible",false )
			handle = vint_object_find("the_health_meter2")
			vint_set_property(handle, "visible",false )
		end
		vint_set_property( Health_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( Health_anim_handle, TWEEN_STATE_RUNNING )
		vint_set_property( vint_object_find("health_meter_main"), "alpha", 1.0 )
		vint_set_child_tween_state( Health_flash_anim_handle, TWEEN_STATE_DISABLED )
	end

	handle = vint_object_find( "health_meter_main_alpha_twn_1" )
	vint_set_property(handle, "start_time", start_time )
	vint_set_property(handle, "duration", duration )

	handle = vint_object_find("armor_meter")
	vint_set_property(handle, "scale", armor_scale, 50.0)

	handle = vint_object_find("the_health_meter_clip")
	vint_set_property(handle, "clip_size", new_scale, 6.0)

	handle = vint_object_find("the_health_meter_bg")
	vint_set_property(handle, "scale", bg_scale, 6.0)

	Previous_health = real_health
end