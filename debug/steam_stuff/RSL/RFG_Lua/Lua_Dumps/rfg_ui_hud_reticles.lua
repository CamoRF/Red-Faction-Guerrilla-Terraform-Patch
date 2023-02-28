
-- handles for each menu item
NUM_MENU_HANDLES_RETICULES = 8
ASSUALT_AMMO_PAD		= -5
ASSUALT_CHARGE_PAD	= 10
-- choice on menu screen
TARGETING_INFO_NONE		= 0
TARGETING_INFO_FRIENDLY	= 1
TARGETING_INFO_ENEMY		= 2
AMMO_METER_HANDLES		= 5
AMMO_METER_WIDTH		= 1
ALPHA_MAX_RETIC		= 0.67
ALPHA_MIN_RETIC		= 0
ALPHA_INCR_RETIC		= 0.1
ALPHA_INACTIVE_RETIC	= 0.15
ALPHA_IN_RETIC			= true

NUM_CHARGES = 12

OVERHEAT_BASE_POS_X	= 0
OVERHEAT_BASE_POS_Y	= 0

GRINDER_METER_BASE_X	= 0
GRINDER_METER_BASE_Y	= 0

Weapon_data_x = 0
Weapon_data_y = 0

Obj_handles_retic = {0,0,0,0,0,0}
Assault_handles_retic = {2,3,4,5,6}
Tween_handles_retic = {0,0,0,0,0}
Reticule_target_handles = {0,0,0,0,0}
Charge_handles_retic = { NUM_CHARGES = 0 }
Charge_tween_handles = { NUM_CHARGES = 0 }
Weapon_data_main_handle = 0

Reticule_main_handle 			= 0
Charge_handle 				= 0
Ammo_main_handle 			= 0
Grinder_meter_handle 			= 0
Overheat_meter_handle 			= 0
Overheat_fill						= 0
Overheat_fill_shadow 			= 0
Reticle_target_sec_handle 		= 0
Weapon_swap_main_handle 		= 0
Ammo_meter_handle 				= 0
Ammo_meter_bg_handle 			= 0

Weapon_data_ammo_handle			= 0
Weapon_data_icon_handle			= 0
Weapon_data_name_handle			= 0
Weapon_data_upgrade_handle		= 0
Weapon_data_faction_handle		= 0
Weapon_swap_tr_handle			= 0
Weapon_swap_tl_handle			= 0
Weapon_swap_br_handle			= 0
Weapon_swap_bl_handle			= 0
Backpack_passive_handle			= 0
Backpack_active_handle			= 0
	
Weapon_data_bg_2					= 0
Weapon_data_bg_3					= 0
Weapon_data_bg_4					= 0

Ammo_text1 							= 0
Ammo_text2 							= 0
Ammo_cliptext1 					= 0
Ammo_cliptext2 					= 0
Ammo_box 							= 0
Charge_handle 						= 0

Fine_aim_handle 					= 0

No_limit_handle 					= 0
No_limit_shadow_handle 			= 0
No_limit_reserve_handle			= 0

Left_fill_handle 					= 0
Left_fill_shadow_handle 		= 0
Right_fill_handle 				= 0
Right_fill_shadow_handle 		= 0

--Hit_anim_handle 					= 0
Overheat_anim_handle 			= 0
Overheat_tween1_handle			= 0
Reload_anim_handle				= 0
Reload_tween_handle				= 0

Lock_on_anim_handle				= 0
Locked_anim_handle				= 0
Lock_on_handle						= 0

Update_ammo_tween1_handle		= 0
Update_ammo_tween2_handle		= 0
Hide_cliptext_tween1_handle	= 0
Hide_cliptext_tween2_handle	= 0
Reload_pulse_tween_handle		= 0
Reticule_alpha_handle 			= 0
Reticule_scale_handle 			= 0

Hit_anim1 							= 0
Hit_tween1 							= 0
Hit_anim2 							= 0
Hit_tween1b							= 0
Hit_anim3 							= 0
Hit_tween1c 						= 0


Ammobox_images = { 
	"ui_hud_reti_ammobox1",
	"ui_hud_reti_ammobox2",
	"ui_hud_reti_ammobox3" }

-- handle of the current weapon
INVALID_WEAPON			= -1
Current_weapon			= INVALID_WEAPON
Alphas_retic			= {1,0,0,0,0}
Weapon_hud_visible	= false
Zoomed_in				= false
Charge_counter			= 0
Max_charges				= 0
Was_reloading			= false


-- ##############################################################
function init_reticles_handles()
	--reticles - please note that weapons which do not have a specific reticule use the assault icon
	
	Reticule_target_handles[1] = vint_object_find( "reticule_target" )
	for i=2,4 do
			Reticule_target_handles[i] = vint_object_find( "reticule_target_"..i )
	end
	Reticule_target_handles[5] = vint_object_find( "reticule_target_gyro_offset" )
	
	for i=1,5 do
		Obj_handles_retic[i] = vint_object_find( "assault0"..i )
	end
		
	for i=1,5 do
		Tween_handles_retic[i] = vint_object_find( "fade_assault0"..i )
	end

	for i=1,NUM_CHARGES do
		Charge_handles_retic[i] = vint_object_find( "charge_"..i )
		Charge_tween_handles[i] = vint_object_find( "charge_alpha_tween_"..i )
		vint_set_property( Charge_tween_handles[i], "state", TWEEN_STATE_DISABLED ) 
		vint_set_property( Charge_handles_retic[i], "visible", false )
		vint_set_property( Charge_handles_retic[i], "alpha", .33 )
	end

	--ammo meter
	Ammo_meter_handle 				= vint_object_find( "ammo_meter" )
	Ammo_meter_bg_handle 			= vint_object_find( "ammo_meter_bg" )

	Reticule_main_handle 			= vint_object_find( "reticle_main" )
	Charge_handle 						= vint_object_find( "charge_main" )
	Ammo_main_handle 					= vint_object_find( "ammo_main" )
	Grinder_meter_handle 			= vint_object_find( "grinder_meter" )
	Overheat_meter_handle 			= vint_object_find( "overheat_meter" )
	Overheat_fill						= vint_object_find( "overheat_fill" )
	Overheat_fill_shadow 			= vint_object_find( "overheat_fill_shadow" )
	Weapon_data_main_handle			= vint_object_find( "weapon_data_main" )
	Reticle_target_sec_handle 		= vint_object_find( "reticule_target_ridingshotgun" )
	Weapon_swap_main_handle 		= vint_object_find( "weapon_swap_main" )

	Weapon_data_ammo_handle			= vint_object_find( "weapon_data_ammo" )
	Weapon_data_icon_handle			= vint_object_find( "weapon_data_icon" )
	Weapon_data_name_handle			= vint_object_find( "weapon_data_name" )
	Weapon_data_upgrade_handle		= vint_object_find( "weapon_data_upgrade" )
	Weapon_data_faction_handle		= vint_object_find( "weapon_data_faction" )
	Weapon_swap_tr_handle			= vint_object_find( "weapon_swap_tr" )
	Weapon_swap_tl_handle			= vint_object_find( "weapon_swap_tl" )
	Weapon_swap_br_handle			= vint_object_find( "weapon_swap_br" )
	Weapon_swap_bl_handle			= vint_object_find( "weapon_swap_bl" )
	Backpack_passive_handle			= vint_object_find( "weapon_data_pack1" )
	Backpack_active_handle			= vint_object_find( "weapon_data_pack2" )

	Weapon_data_bg_2					= vint_object_find( "weapon_data_bg_2" )
	Weapon_data_bg_3					= vint_object_find( "weapon_data_bg_3" )
	Weapon_data_bg_4					= vint_object_find( "weapon_data_bg_4" )

	Ammo_text1 							= vint_object_find( "ammo_text1" )
	Ammo_text2 							= vint_object_find( "ammo_text2" )
	Ammo_cliptext1 					= vint_object_find( "ammo_cliptext1" )
	Ammo_cliptext2 					= vint_object_find( "ammo_cliptext2" )
	Ammo_box 							= vint_object_find( "ammo_box" )

	Fine_aim_handle 					= vint_object_find( "assault_fine_aim" )

	No_limit_handle 					= vint_object_find( "ammo_text_nolimit" )
	No_limit_shadow_handle 			= vint_object_find( "ammo_text_nolimit_shdw" )
	No_limit_reserve_handle			= vint_object_find( "ammo_nolimit_reserve" )

	Left_fill_handle 					= vint_object_find( "left_fill" )
	Left_fill_shadow_handle 		= vint_object_find( "left_fill_shadow" )
	Right_fill_handle 				= vint_object_find( "right_fill" )
	Right_fill_shadow_handle 		= vint_object_find( "right_fill_shadow" )

	--Hit_anim_handle 					= vint_object_find( "hit_anim" )
	Overheat_anim_handle 			= vint_object_find( "overheat_anim" )
	Overheat_tween1_handle			= vint_object_find( "overheat_tween1" )
	Reload_anim_handle				= vint_object_find( "reload_anim" )
	Reload_tween_handle				= vint_object_find( "reload_tween1" )

	Lock_on_anim_handle				= vint_object_find( "lock_on_anim" )
	Locked_anim_handle				= vint_object_find( "locked_anim" )
	Lock_on_handle						= vint_object_find( "lock_on" )

	Update_ammo_tween1_handle		= vint_object_find( "update_ammo_tween1" )
	Update_ammo_tween2_handle		= vint_object_find( "update_ammo_tween2" )
	Hide_cliptext_tween1_handle	= vint_object_find( "hide_cliptext_tween1" )
	Hide_cliptext_tween2_handle	= vint_object_find( "hide_cliptext_tween2" )	
	Reload_pulse_tween_handle		= vint_object_find( "reload_pulse" ) 
	Reticule_alpha_handle 			= vint_object_find( "reticule_alpha" )
	Reticule_scale_handle 			= vint_object_find( "reticule_scale" )

	Hit_anim1 							= vint_object_find( "hit_anim1" )
	Hit_tween1 							= vint_object_find( "hit_tween1" )
	Hit_anim2 							= vint_object_find( "hit_anim2" )
	Hit_tween1b							= vint_object_find( "hit_tween1b" )
	Hit_anim3 							= vint_object_find( "hit_anim3" )
	Hit_tween1c 						= vint_object_find( "hit_tween1c" )



	vint_set_property( Lock_on_handle, "visible", false )	

	vint_set_property( Grinder_meter_handle, "visible", false )
	vint_set_property( Overheat_meter_handle, "visible", false )

	vint_set_property( Reticule_target_handles[2], "visible", false )
	vint_set_property( Reticule_target_handles[3], "visible", false )
	vint_set_property( Reticule_target_handles[4], "visible", false )

   vint_set_property( Reticle_target_sec_handle, "visible", false )

	--vint_set_child_tween_state( Hit_anim_handle, TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Hit_anim1 , TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Hit_anim2 , TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Hit_anim3 , TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Lock_on_anim_handle, TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( Locked_anim_handle, TWEEN_STATE_DISABLED )

	vint_set_property( Update_ammo_tween1_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_property( Update_ammo_tween2_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_property( Hide_cliptext_tween1_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_property( Hide_cliptext_tween2_handle, "state", TWEEN_STATE_DISABLED )
	vint_set_property( Reload_pulse_tween_handle, "state" , TWEEN_STATE_DISABLED )
	vint_set_property( Reticule_alpha_handle, "state" , TWEEN_STATE_DISABLED )
	vint_set_property( Reticule_scale_handle, "state" , TWEEN_STATE_DISABLED )
		
	Weapon_data_x, Weapon_data_y = vint_get_property( Weapon_data_main_handle, "anchor" )
	OVERHEAT_BASE_POS_X, OVERHEAT_BASE_POS_Y = vint_get_property(vint_object_find("overheat_meter"),"anchor")
	GRINDER_METER_BASE_X, GRINDER_METER_BASE_Y = vint_get_property(vint_object_find("grinder_meter"),"anchor")

end

-- ##############################################################
function rfg_ui_hud_reticles_cleanup()
end

-- ##############################################################
function rfg_ui_hud_reticles_init()

	-- get the handles
	init_reticles_handles()

	-- subscribe to the data item whose name is ButtonAStatus, and we listen for updates, so that
	-- it then calls our function button_a_status_change
	vint_dataitem_add_subscription( "WeaponFire", "update", "fire_change" )
	vint_dataitem_add_subscription( "WeaponPosn", "update", "weapon_posn" )
	vint_dataitem_add_subscription( "SafehouseInfo", "update", "safehouse_update" )

end

-- ##############################################################
function safehouse_update(data_item_handle, event_name)

	-- First, let's figure out if we're rendering weapon info or backpack info and whether it's visible
	local visible, show_weapon_info, item_name, icon_name = vint_dataitem_get(data_item_handle)

	--do we need to show this stuff?
	vint_set_property( Weapon_data_main_handle, "visible", visible )
	vint_set_property( Weapon_swap_main_handle, "visible", visible )

	local reticle_main_handle = vint_object_find( "reticle_main" )

	if (visible == false) then
		-- show the real reticule
		vint_set_property( Reticule_main_handle, "visible", true )
		vint_set_property( Ammo_main_handle, "visible", true )
		vint_set_property( Charge_handle, "visible", true )
	else

		-- pop the name in
		vint_set_property( Weapon_data_name_handle, "text_tag", item_name )

		--load the correct icon
		if (icon_name ~= nil) then
			vint_set_property( Weapon_data_icon_handle, "visible", true )
			vint_set_property( Weapon_data_icon_handle, "image", icon_name )
			vint_set_property( Weapon_data_icon_handle, "scale", 0.8, 0.8 )
		else
			vint_set_property( Weapon_data_icon_handle, "visible", false )
		end

		if (show_weapon_info == true) then

			-- get the reset of the data items
			local _, _, _, _, posn_x, posn_y, scale_x, scale_y, clip_ammo, total_ammo  = vint_dataitem_get(data_item_handle)

			--hide real reticule
			vint_set_property( Reticle_main_handle, "visible", false )
			vint_set_property( Ammo_main_handle, "visible", false )
			vint_set_property( Charge_handle, "visible", false )
			vint_set_property( Backpack_passive_handle, "visible", false )
			vint_set_property( Backpack_active_handle, "visible", false )
			
			--deal with safe house reticule

			--set the weapon ammo text
			vint_set_property( Weapon_data_ammo_handle, "text_tag", clip_ammo.."/"..total_ammo )

			--set the weapon upgrade text
			vint_set_property( Weapon_data_upgrade_handle, "text_tag", "UPGRADE ME" )

			--set the position of the main reticule
			local set_x = posn_x + (scale_x*0.5)
			local set_y = posn_y + (scale_y*0.5)
			vint_set_property( Weapon_swap_main_handle, "anchor", set_x, set_y )

			--set the position of the corner pieces
			local temp_x = scale_x *0.5
			local temp_y = scale_y *0.5
			vint_set_property( Weapon_swap_tr_handle, "anchor", temp_x, -temp_y )
			vint_set_property( Weapon_swap_tl_handle, "anchor", -temp_x, -temp_y )
			vint_set_property( Weapon_swap_br_handle, "anchor", temp_x, temp_y )
			vint_set_property( Weapon_swap_bl_handle, "anchor", -temp_x, temp_y )
			
			--set the position of the data module
			local reticule_x, reticule_y = vint_get_property( Weapon_swap_main_handle, "anchor")
			local new_ret_x = reticule_x + (scale_x*0.5)
			local new_ret_y = reticule_y
			vint_set_property( Weapon_data_main_handle, "anchor", new_ret_x, new_ret_y )

			--set the right weapon faction
			local faction = get_faction(item_name)

			if( faction == 1 )then
				vint_set_property( Weapon_data_faction_handle, "image", "ui_hud_marauder_logo" )
			elseif( faction == 2 )then
				vint_set_property( Weapon_data_faction_handle, "image", "ui_hud_ultor_logo" )
			elseif( faction == 3 )then
				vint_set_property( Weapon_data_faction_handle, "image", "ui_hud_edf_logo_large" )
			else
				vint_set_property( Weapon_data_faction_handle, "image", "ui_hud_guerilla_logo_large" )
			end
			vint_set_property( Weapon_data_faction_handle, "scale", 1.3,1.3 )
			vint_set_property( Weapon_data_faction_handle, "alpha", 0.33 )
		else
			-- backpacks!
			local _, _, _, _, hint_text, activation_button_text = vint_dataitem_get(data_item_handle)
			local orange = " [color:#faa00aff]"
			vint_set_property( Backpack_passive_handle, "visible", false )

			if (hint_text ~= nil) then
				vint_set_property( Backpack_active_handle, "visible", true )
				vint_set_property( Backpack_active_handle, "text_tag", activation_button_text .. orange .. hint_text )
			else
				vint_set_property( Backpack_active_handle, "visible", false )
			end

			--vint_set_property( Backpack_active_handle, "text_tag", activation_button_text ..  orange .. active_hint )

			local weapon_data_x_bump = Weapon_data_x + 50

			vint_set_property(Weapon_data_main_handle, "anchor", weapon_data_x_bump, Weapon_data_y)

			-- hide
			vint_set_property(Weapon_swap_tr_handle, "visible", false)
			vint_set_property(Weapon_swap_tl_handle, "visible", false)
			vint_set_property(Weapon_swap_br_handle, "visible", false) 
			vint_set_property(Weapon_swap_bl_handle, "visible", false)

			vint_set_property(Weapon_data_bg_2,"visible",false)
			vint_set_property(Weapon_data_bg_3,"visible",false)
			vint_set_property(Weapon_data_bg_4,"visible",false)

			--
			vint_set_property( Weapon_data_ammo_handle, "visible", false )
			vint_set_property( Weapon_data_upgrade_handle, "visible", false )

			-- hide the faction logo
			vint_set_property( Weapon_data_faction_handle, "visible", false)

		end
	end
end

-- ##############################################################
function get_faction(weapon_name)
	--set this to 4 because the guerilla is the largest list
	local ret_val = 4

	--is this weapon marauder
	if( (weapon_name == "gutter") or ( weapon_name == "shotgun" ) )then
		ret_val = 1
	--is this weapon ultor
	elseif((weapon_name == "nano_rifle") or ( weapon_name == "rail_driver" ))then
		ret_val = 2
	--is this weapon EDF
	elseif((weapon_name == "enforcer") or ( weapon_name == "m16" ) or ( weapon_name == "edf_pistol" ) or ( weapon_name == "sniper_rifle" ))then
		ret_val = 3
	end

	--return the faction
	return ret_val
end

-- ##############################################################
function weapon_change(weapon_name, weapon_reticule_name, gyro_enabled, gyro_orientation_z, gyro_orientation_x)

	local valid_weapon = (weapon_name ~= nil and weapon_reticule_name ~= nil)

	--there are 14+ sledgehammers, if the weapon name contains sledgehammer flag it as not using ammo
	local i,j
	if (weapon_name ~= nil) then
		i, j = string.find(weapon_name, "sledge")
	end
	local weapon_uses_ammo = (i == nil and weapon_name ~= "gutter" and weapon_name ~= "repair_tool" and weapon_name ~= "flag_edf" and weapon_name ~= "flag_guerrilla")

	local change_occurred = false
	if (Current_weapon ~= weapon_name) then
		change_occurred = true
	end

	-- Set our current weapon, if it's valid
	if (valid_weapon == true) then
		Current_weapon = weapon_name
	else
		Current_weapon = INVALID_WEAPON
	end

	-- hide everything!
	for i = 1,5 do
		if ( Obj_handles_retic[i] ~= 0 ) then
			
			vint_set_property( Obj_handles_retic[i], "visible", false )
			handle_charge_ammo()
			
		end		

	end

	if ( Reticule_target_handles[1] ~= 0) then
		vint_set_property( Reticule_target_handles[1], "visible", false )
	end
	if ( Reticule_target_handles[5] ~= 0) then
		vint_set_property( Reticule_target_handles[5], "visible", false )
	end

	vint_set_property( Ammo_meter_handle, "visible", false )
	vint_set_property( Ammo_meter_bg_handle, "visible", false )

	local new_time = vint_get_time_index()

  	if(valid_weapon == false or weapon_uses_ammo == false) then
		vint_set_property( Ammo_text1,"visible",false )
		vint_set_property( Ammo_text2,"visible",false )
		vint_set_property( Ammo_cliptext1,"visible",false )
		vint_set_property( Ammo_cliptext2,"visible",false )
		vint_set_property( Ammo_box,"visible",false )
	end
	
	-- validate this is a good handle
	if (valid_weapon == true) then
		-- Show the reticule
		vint_set_property(Obj_handles_retic[1], "visible", false)
		vint_set_property(Reticule_target_handles[1], "visible", true)
		vint_set_property(Reticule_target_handles[1], "image", weapon_reticule_name)
		
		local xpos, ypos = vint_get_global_anchor( Reticule_target_handles[1] )
			
		if (gyro_enabled == true) then
			vint_set_property(Reticule_target_handles[5], "visible", true)
			vint_set_property(Reticule_target_handles[5], "image", weapon_reticule_name)
			
			local gyro_xpos = xpos - gyro_orientation_z
			local gyro_ypos = ypos - gyro_orientation_x
			vint_set_property( Reticule_target_handles[5], "anchor", gyro_xpos , gyro_ypos )
		end

		if (change_occurred) then
			-- Intro animation for reticule
			
			vint_set_property( Reticule_scale_handle, "state" , TWEEN_STATE_RUNNING )
			vint_set_property( Reticule_scale_handle, "start_time", new_time )
			vint_set_property( Reticule_scale_handle, "start_value", 1.5, 1.5 )
			vint_set_property( Reticule_scale_handle, "end_value", 1, 1 )

			-- code to scoot the ammo group over if we are using mines
			-- but, first, get the position of the main reticle and its scale (note we ONLY want X here!)
			local parent_scale_x, parent_scale_y = vint_get_property(Reticule_target_handles[1], "scale")
			local reticule_size_x, reticule_size_y = vint_get_property( Reticule_target_handles[1], "screen_size" )
			local charge_x, charge_y = vint_get_global_anchor(  Reticule_target_handles[1] )
			local charge_xdummy, charge_ytoset = vint_get_global_anchor( Charge_handle )

			-- since we only want to modify X, we need to get the current y value for ammo_main...
			local xdummy, ytoset = vint_get_property( Ammo_main_handle, "anchor" )

			xpos = xpos + reticule_size_x * parent_scale_x * 0.5
			charge_x = charge_x - ASSUALT_CHARGE_PAD - reticule_size_x * parent_scale_x * 0.5

			vint_set_property( Ammo_main_handle, "anchor", xpos , ytoset )
			vint_set_property( Charge_handle, "anchor",charge_x , charge_ytoset )
			
			if(ALPHA_IN_RETIC) then
				vint_set_property( Reticule_alpha_handle, "state" , TWEEN_STATE_RUNNING )
				vint_set_property( Reticule_alpha_handle, "start_time", new_time )
				vint_set_property( Reticule_alpha_handle, "start_value", 0 )
				vint_set_property( Reticule_alpha_handle, "end_value",	1 )
			else

				vint_set_property( Reticule_alpha_handle, "state" , TWEEN_STATE_DISABLED )
			
			end

		end

		-- Show our ammo
		vint_set_property(Ammo_meter_handle, "visible", true)
		vint_set_property(Ammo_meter_bg_handle, "visible", true)

	end	

end

-- ##############################################################
function weapon_posn(data_item_handle, event_name)

	local x, y = vint_dataitem_get(data_item_handle)

	-- set the position of the reticule!
	-- vint_set_property( Reticule_target_handles[1], "anchor", x, y )

end

-- ##############################################################
function handle_charge_ammo()
	--have we thrown any charges???
	if( Charge_counter >= 1 )then
		for i = 1,Max_charges do 
			if ( Charge_counter >= i ) then
				vint_set_property( Charge_handles_retic[i], "alpha", 0.67 )
			elseif ( Charge_counter > 0) then
				vint_set_property( Charge_handles_retic[i], "alpha", 0.15 )
			end
			vint_set_property( Charge_handles_retic[i], "visible", true )	
		end
	--we are using charges but have thrown 0
	elseif(Current_weapon == "charge_placer" or ((Current_weapon == "mine_placer") and rfg_is_multiplayer())) then
		for i = 1,Max_charges do 
			vint_set_property( Charge_handles_retic[i], "alpha", 0.15 )
			vint_set_property( Charge_handles_retic[i], "visible", true )
		end
	--no charges placed so hide the charge boxes
	else
		for i = 1,12 do 
			vint_set_property( Charge_handles_retic[i], "visible", false )	
		end
	end
end

-- ##############################################################
function fire_change(data_item_handle, event_name)

	-- get all the data items at once (it puts the 4 values in tmp1-4)
	local bogus, reload_warning, can_fire, is_reloading, weapon_name, weapon_icon_name, weapon_reticule_name, 
		accuracy_percent, ammo_rounds, ammo_reserve, ammo_magazine_size, targeting, local_player_hit_someone_this_frame,
		is_overheated, overheat_percent, is_turret, secondary_can_fire, lock_on, show_ammo_counter, multi_rockets,
		charges, status, gyro_enabled, gyro_orientation_z, gyro_orientation_x = vint_dataitem_get(data_item_handle)
	local actual_accuracy = accuracy_percent

	-- Multi rocket display
	if (multi_rockets ~= nil) then
		local rocket_icon_1 = vint_object_find("rocket_1")
		local rocket_icon_2 = vint_object_find("rocket_2")
		local rocket_icon_3 = vint_object_find("rocket_3")
	
		if (multi_rockets == -1) then
			vint_set_property(rocket_icon_1, "visible", false)
			vint_set_property(rocket_icon_2, "visible", false)
			vint_set_property(rocket_icon_3, "visible", false)
		else
			vint_set_property(rocket_icon_1, "visible", true)
			vint_set_property(rocket_icon_2, "visible", true)
			vint_set_property(rocket_icon_3, "visible", true)
		
			if (multi_rockets == 0) then
				-- No rockets cued up
				vint_set_property(rocket_icon_1, "alpha", 0.33)
				vint_set_property(rocket_icon_2, "alpha", 0.33)
				vint_set_property(rocket_icon_3, "alpha", 0.33)
			elseif (multi_rockets == 1) then
				-- Current weapon uses multi-rockets, 1 is cued up
				vint_set_property(rocket_icon_1, "alpha", 1.0)
				vint_set_property(rocket_icon_2, "alpha", 0.33)
				vint_set_property(rocket_icon_3, "alpha", 0.33)
			elseif (multi_rockets == 2) then
				-- Current weapon uses multi-rockets, 2 are cued up
				vint_set_property(rocket_icon_1, "alpha", 1.0)
				vint_set_property(rocket_icon_2, "alpha", 1.0)
				vint_set_property(rocket_icon_3, "alpha", 0.33)
			elseif (multi_rockets == 3) then
				-- Current weapon uses multi-rockets, 3 are cued up
				vint_set_property(rocket_icon_1, "alpha", 1.0)
				vint_set_property(rocket_icon_2, "alpha", 1.0)
				vint_set_property(rocket_icon_3, "alpha", 1.0)
			end
		end
	end
	
	--are we locking on?
	if (lock_on == 0 ) then		
		
		--we are not locking so hide lock reticule and pause animation
		vint_set_property( Lock_on_handle, "visible", false )		

		vint_set_child_tween_state( Lock_on_anim_handle, TWEEN_STATE_DISABLED )
		vint_set_child_tween_state( Locked_anim_handle, TWEEN_STATE_DISABLED )
	
	elseif (lock_on == 1) then

		--we ARE locking so show lock reticule and play locking animation
		vint_set_property( Lock_on_handle, "visible", true )		

		vint_set_property( Lock_on_anim_handle, "start_time", vint_get_time_index())
		vint_set_child_tween_state( Lock_on_anim_handle, TWEEN_STATE_RUNNING )

	elseif (lock_on == 2) then
		
		vint_set_property( Lock_on_handle, "visible", true )		

		--we have lock so switch to locked animation
		vint_set_property( Locked_anim_handle, "start_time", vint_get_time_index())
		vint_set_child_tween_state( Locked_anim_handle, TWEEN_STATE_RUNNING )
	
	end

	--set max number of charges
	
	if (weapon_name == "charge_placer" or weapon_name == "mine_placer") then
	
		Max_charges = rfg_get_max_charges()

	end

	--store the charges out in lua
	Charge_counter = charges
	handle_charge_ammo()
	
	local cnt = 0
	for i = charges, 1, -1 do
		if ( status > 0 ) then
			vint_set_property( Charge_tween_handles[i], "state", TWEEN_STATE_RUNNING ) 
			cnt = status - 1
			status = cnt
		else
			vint_set_property( Charge_tween_handles[i], "state", TWEEN_STATE_DISABLED ) 
		end
	end

	for i = charges+1, 12 do
		vint_set_property( Charge_tween_handles[i], "state", TWEEN_STATE_DISABLED ) 
	end

	--handle for unlimited infinite ammo
	vint_set_property( No_limit_handle, "visible", false )
	vint_set_property( No_limit_shadow_handle, "visible", false )
	vint_set_property( No_limit_reserve_handle, "visible", false )
	
	-- update weapon id
	weapon_change(weapon_name, weapon_reticule_name, gyro_enabled, gyro_orientation_z, gyro_orientation_x)

	if ( accuracy_percent < 0 ) then
		local tmp = accuracy_percent
		accuracy_percent = -tmp
	end

	--error("value of ammo_rounds '"..ammo_rounds.."' ")
	local ammo_percent = 0
	local ammo_clip_count = 0
	local ammo_total = ammo_reserve

	if ( ammo_magazine_size > 0 ) then
		ammo_percent = -(ammo_rounds/ammo_magazine_size)*12
		ammo_clip_count = ( ammo_reserve/ammo_magazine_size )
	end

	--set the scale of the ammo meter to that of the ammo amount in clip
	vint_set_property( Ammo_meter_handle, "scale", AMMO_METER_WIDTH, ( -1 * ammo_percent ) )
		
	local overheat_color		= 1 - ((overheat_percent - 50) / 50)

	if (overheat_percent > 0) then

		vint_set_property( Overheat_meter_handle, "visible", true )
		
		vint_set_property( Overheat_fill, "scale", overheat_percent * 0.7, 5 )
		vint_set_property( Overheat_fill_shadow, "scale", overheat_percent * 0.7, 5 )

		if ( is_overheated ) then			
			vint_set_property( Overheat_anim_handle, "is_paused", false ) 
			vint_set_property( Overheat_tween1_handle, "state", TWEEN_STATE_RUNNING ) 
			vint_set_property( Overheat_meter_handle, "tint", 0.92, 0.0, 0.0 ) 		

		elseif ( overheat_percent >= 50 ) then

			vint_set_property( Overheat_meter_handle, "tint", 0.92, overheat_color * 0.8, 0.0 )

		else
			vint_set_property( Ammo_main_handle, "alpha", 0.80 )
			vint_set_property( Overheat_anim_handle, "is_paused", true ) 
			vint_set_property( Overheat_tween1_handle, "state", TWEEN_STATE_DISABLED )
			vint_set_property( Overheat_meter_handle, "tint", 0.92, 0.80, 0.00 )
		end

		if(weapon_name == "repair_tool") then

			vint_set_property( Overheat_meter_handle, "anchor", OVERHEAT_BASE_POS_X + 14, OVERHEAT_BASE_POS_Y - 5 )

		else

			vint_set_property( Overheat_meter_handle, "anchor", OVERHEAT_BASE_POS_X, OVERHEAT_BASE_POS_Y )

		end

	else

		vint_set_property( Overheat_meter_handle, "visible", false )

		vint_set_property( Ammo_main_handle, "alpha", 0.80 )
		vint_set_property( Overheat_anim_handle, "is_paused", true ) 
		vint_set_property( Overheat_tween1_handle, "state", TWEEN_STATE_DISABLED )
		vint_set_property( Overheat_meter_handle, "tint", 0.92, 0.80, 0.00 )

	end
	
	--vint_set_property( Reticule_target_handles[1], "image", weapon_reticule_name )
	--vint_set_property( Fine_aim_handle, "visible", false )

	if (weapon_name == "grinder" or weapon_name == "turret_MediumTank" or weapon_name == "turret_HeavyTank" or weapon_name == "turret_jetter_rocket") then
		--handle grinder charge meter
		local parent_scale_x, parent_scale_y = vint_get_property(Reticule_main_handle, "scale")
		local meter_fill = accuracy_percent * .32 * parent_scale_x
		local FUDGE = 0

		if (weapon_name == "turret_MediumTank" or weapon_name == "turret_HeavyTank") then		
			-- if tank move the meter down 10 
			FUDGE = 10						
		elseif (weapon_name == "turret_jetter_rocket") then
			FUDGE = 50						
		else				
			-- if grinder give the meter a slight overlap
			meter_fill = accuracy_percent * .33 * parent_scale_x
		end

		-- accuracy_percent will be from 0-100
		vint_set_property( Grinder_meter_handle, "visible", true )
		
		vint_set_property( Left_fill_handle, "screen_size", meter_fill, 3)
		vint_set_property( Left_fill_shadow_handle, "screen_size", meter_fill, 3)
		vint_set_property( Right_fill_handle, "screen_size", meter_fill, 3)
		vint_set_property( Right_fill_shadow_handle, "screen_size", meter_fill, 3)

		-- reposition meter depending on if it's a tank or the grinder
		vint_set_property( Grinder_meter_handle, "anchor", GRINDER_METER_BASE_X, GRINDER_METER_BASE_Y + FUDGE )

	else
		vint_set_property( Grinder_meter_handle, "visible", false )
	end


	if(weapon_name == "turret_jetter_rocket") then

		ALPHA_IN_RETIC = false

		vint_set_property(Reticule_target_handles[1], "image", "ui_hud_reti_rockets")
		vint_set_property(Reticule_target_handles[5], "image", "ui_hud_reti_rockets")
		vint_set_property(Reticle_target_sec_handle, "image", "ui_hud_reti_assault2")
		vint_set_property(Reticle_target_sec_handle, "scale", 0.80, 0.80)

		vint_set_property(Reticle_target_sec_handle, "visible", true)

	elseif(weapon_name == "turret_MediumTank" or weapon_name == "turret_HeavyTank") then
		weapon_reticule_name = "ui_hud_reti_tank"

		vint_set_property(Reticle_target_sec_handle, "image", "ui_hud_reti_tankturret" )
		vint_set_property(Reticle_target_sec_handle, "visible", true)				
	else

		vint_set_property(Reticle_target_sec_handle, "visible", false)
	
	end


	if(secondary_can_fire == true) then
		vint_set_property(Reticle_target_sec_handle, "alpha", 1.0)
	else
		vint_set_property(Reticle_target_sec_handle, "alpha", 0.33)
	end

	-- handle zoom sound.  Note that the actual accuracy passed in will be less than
	-- zero if the player is scoped!!
	if (actual_accuracy < 0) then
		if (Zoomed_in == false) then
			rfg_play_audio( "SYS_WEP_ZOOM_IN_ASSAULT" )
		end
		Zoomed_in = true
	elseif ( Zoomed_in == true ) then
		rfg_play_audio( "SYS_WEP_ZOOM_OUT_ASSAULT" )
		Zoomed_in = false		
	end

	local ax, ay = vint_get_property(vint_object_find("ammo_group"), "anchor")
	
	local scale_item = vint_object_find( "scale_group" )
	local doc_scale_x, doc_scale_y = vint_get_property( scale_item, "scale")
		
	--rz, because we have scaling!
	--ax = ax / doc_scale_x
	
	local ax_ref_point = ax

	local new_time = vint_get_time_index()
	local duration = vint_get_property(Update_ammo_tween1_handle, "duration")

	if ( Was_reloading == false and (is_reloading == true)) then

		-- we have just finished reloading
		new_time = vint_get_time_index()
		duration = vint_get_property(Update_ammo_tween1_handle, "duration")

		-- if Update_ammo_tween2_handle hasn't finished yet...
		if ( vint_get_property( Update_ammo_tween2_handle, "state") ~= TWEEN_STATE_FINISHED ) then
			ax_ref_point = vint_get_property( Update_ammo_tween2_handle, "end_value")
			vint_set_property( Update_ammo_tween2_handle, "state", TWEEN_STATE_DISABLED )
			vint_set_property( Hide_cliptext_tween2_handle, "state", TWEEN_STATE_DISABLED )
		end

		vint_set_property( Update_ammo_tween1_handle, "state", TWEEN_STATE_RUNNING ) 		
		vint_set_property( Hide_cliptext_tween1_handle, "state", TWEEN_STATE_RUNNING ) 
		vint_set_property( Reload_pulse_tween_handle, "state", TWEEN_STATE_RUNNING )
		vint_set_property( Update_ammo_tween1_handle, "start_time", new_time ) 		
		vint_set_property( Hide_cliptext_tween1_handle, "start_time", new_time )
		vint_set_property( Reload_pulse_tween_handle, "start_time", new_time + duration )
		vint_set_property( Update_ammo_tween1_handle, "start_value", ax, ay )
		vint_set_property( Update_ammo_tween1_handle, "end_value", (ax_ref_point - 36), ay )
		vint_set_property( Hide_cliptext_tween1_handle, "start_value", 1 )
		vint_set_property( Hide_cliptext_tween1_handle, "end_value", 0 )

	elseif ( Was_reloading == true and (is_reloading == false)) then

		new_time = vint_get_time_index()
		duration = vint_get_property(Update_ammo_tween1_handle, "duration")

		-- if Update_ammo_tween1_handle hasn't finished yet...
		if ( vint_get_property( Update_ammo_tween1_handle, "state") ~= TWEEN_STATE_FINISHED ) then
			ax_ref_point = vint_get_property( Update_ammo_tween1_handle, "end_value")
			vint_set_property( Update_ammo_tween1_handle, "state", TWEEN_STATE_DISABLED )
			vint_set_property( Hide_cliptext_tween1_handle, "state", TWEEN_STATE_DISABLED )
		end

		vint_set_property( Update_ammo_tween2_handle, "state", TWEEN_STATE_RUNNING ) 		
		vint_set_property( Hide_cliptext_tween2_handle, "state", TWEEN_STATE_RUNNING ) 		
		vint_set_property( Reload_pulse_tween_handle, "state", TWEEN_STATE_DISABLED )
		vint_set_property( Update_ammo_tween2_handle, "start_time", new_time ) 		
		vint_set_property( Hide_cliptext_tween2_handle, "start_time", new_time)
		vint_set_property( Update_ammo_tween2_handle, "start_value", ax, ay )
		vint_set_property( Update_ammo_tween2_handle, "end_value", (ax_ref_point + 36), ay )
		vint_set_property( Hide_cliptext_tween2_handle, "start_value", 0 )
		vint_set_property( Hide_cliptext_tween2_handle, "end_value", 1 )
		
	end

	-- update was reloading flag
	Was_reloading = is_reloading

	-- notify the player that they need to reload
	if ( reload_warning ) then
		vint_set_property( Reload_anim_handle, "is_paused", false ) 
		vint_set_property( Reload_tween_handle, "state", TWEEN_STATE_RUNNING ) 
		vint_set_property( Ammo_main_handle, "tint", 0.75, 0.00, 0.00 ) 
	else
		vint_set_property( Ammo_main_handle, "alpha", 0.80 )
		vint_set_property( Reload_anim_handle, "is_paused", true ) 
		vint_set_property( Reload_tween_handle, "state", TWEEN_STATE_DISABLED )
		vint_set_property( Ammo_main_handle, "tint", 0.92, 0.80, 0.00 )
	end

	-- first validate this is a good weapon handle!
	if (Current_weapon ~= INVALID_WEAPON) then
		local r = 1.0
		local g = 1.0
		local b = 1.0

		if ( targeting == TARGETING_INFO_FRIENDLY ) then
			r = 0.0
			g = 0.72
			b = 0.0
		elseif ( targeting == TARGETING_INFO_ENEMY ) then
			r = 0.92
			g = 0.0
			b = 0.0
		else
			r = 0.92
			g = 0.8
			b = 0.0
		end

		vint_set_property( Lock_on_handle, "tint", r, g, b )
		vint_set_property( Reticle_target_sec_handle, "tint",r, g, b )
		
		for i = 1,5 do
			vint_set_property( Obj_handles_retic[i], "tint",r, g, b )
		end
		vint_set_property( Fine_aim_handle, "tint", r, g, b)
		vint_set_property( Reticule_target_handles[1], "tint", r, g, b )

		local ammo_text1 = vint_object_find( "ammo_text1" )
		local ammo_text2 = vint_object_find( "ammo_text2" )
		local ammo_cliptext1 = vint_object_find( "ammo_cliptext1" )
		local ammo_cliptext2 = vint_object_find( "ammo_cliptext2" )
		local ammo_box_x, ammo_box_y = vint_get_property( Ammo_box, "anchor")
		local ammo_cliptext_x, ammo_cliptext_y = vint_get_property( ammo_cliptext1, "anchor" )
		local ammo_text1_x, ammo_text1_y = vint_get_property( ammo_text1, "anchor")

		--start remote charge stuff
		if((Current_weapon == "charge_placer") or ((Current_weapon == "mine_placer") and rfg_is_multiplayer())) then

			vint_set_property( Ammo_meter_handle, "visible", false )
			vint_set_property( Ammo_meter_bg_handle, "visible", false )
			
			vint_set_property( Charge_handle, "visible", true )
			
			vint_set_property( Ammo_cliptext1, "visible", true )
			vint_set_property( Ammo_cliptext1, "text_tag", ammo_rounds )
			vint_set_property( Ammo_cliptext2, "visible", true )
			vint_set_property( Ammo_cliptext2, "text_tag", ammo_rounds )
			
			--hide the second number and the box around it
			vint_set_property( Ammo_text1, "visible", false )
			vint_set_property( Ammo_text1, "text_tag", ammo_total )
			vint_set_property( Ammo_text2, "visible", false )
			vint_set_property( Ammo_text2, "text_tag", ammo_total )

			vint_set_property( Ammo_box, "visible", false )

			--we are using charges so show the max charges
			for i = 1,Max_charges do 
				if ( Charge_counter >= i ) then
					vint_set_property( Charge_handles_retic[i], "alpha", 0.67 )
				else
					vint_set_property( Charge_handles_retic[i], "alpha", 0.15 )
				end
				vint_set_property( Charge_handles_retic[i], "visible", true )
			end

			if (Charge_counter == Max_charges) then
				can_fire = false;
			end

		elseif(Current_weapon == "singularity_bomb" or (Current_weapon == "mine_placer")) then

			vint_set_property( Ammo_cliptext1, "visible", true )
			vint_set_property( Ammo_cliptext1, "text_tag", ammo_rounds )
			vint_set_property( Ammo_cliptext2, "visible", true )
			vint_set_property( Ammo_cliptext2, "text_tag", ammo_rounds )
			
			--show only the total number of bombs and hide the box
			vint_set_property( Ammo_text1, "visible", false )
			vint_set_property( Ammo_text1, "text_tag", ammo_total )
			vint_set_property( Ammo_text2, "visible", false )
			vint_set_property( Ammo_text2, "text_tag", ammo_total )

			vint_set_property( Ammo_box, "visible", false )
		
		else
			--we switched weapons
			--have we thrown any charges
			handle_charge_ammo()
		end

		--find out how many digits ammo_total is, then set the 
		--appropriate image for the ammo_box
		if(ammo_total >= 0 and ammo_total < 10) then
			vint_set_property( Ammo_box, "image", Ammobox_images[1] )
			ammo_cliptext_x = ammo_text1_x + 10
			ammo_text1_x = ammo_box_x
		elseif(ammo_total > 9 and ammo_total < 100) then
			vint_set_property( Ammo_box, "image", Ammobox_images[2] )
			ammo_cliptext_x = ammo_text1_x + 6
			ammo_text1_x = ammo_box_x 
		elseif(ammo_total >= 100 and ammo_total < 200) then
			vint_set_property( Ammo_box, "image", Ammobox_images[3] )
			ammo_cliptext_x = ammo_text1_x + 6
			ammo_text1_x = ammo_box_x - 3
		else
			vint_set_property( Ammo_box, "image", Ammobox_images[3] )
			ammo_cliptext_x = ammo_text1_x
			ammo_text1_x = ammo_box_x
		end

		vint_set_property(Ammo_cliptext1, "anchor", ammo_cliptext_x, ammo_cliptext_y)
		vint_set_property(Ammo_cliptext2, "anchor", ammo_cliptext_x+1, ammo_cliptext_y+1.5)
		vint_set_property(Ammo_text1, "anchor", ammo_text1_x, ammo_text1_y)
		vint_set_property(Ammo_text2, "anchor", ammo_text1_x, ammo_text1_y+1.5)

		-- end remote charge stuff
		--set the ammo for all weapons for the time being
		--set the ammo for everything but the hammer and charges and gutter
		if (( Current_weapon ~= "sledgehammer" ) and ( Current_weapon ~= "charge_placer" ) and ( Current_weapon ~= "mine_placer" ) and ( Current_weapon ~= "gutter" ) and ( Current_weapon ~= "repair_tool" ) and ( Current_weapon ~= "flag_edf" ) and ( Current_weapon ~= "flag_guerrilla" )and ( Current_weapon ~= "singularity_bomb" )) then

			--show the ammo meter and meter bg		
			
			--HACK: Per Luke's Changes - replacing meter with number
			--for i = AMMO_METER_HANDLES,AMMO_METER_HANDLES+1 do
			--	vint_set_property( Obj_handles_retic[i], "visible", true )
			--end			

			--set clip ammo text
			vint_set_property( Ammo_cliptext1, "visible", true )
			vint_set_property( Ammo_cliptext1, "text_tag", ammo_rounds )
			vint_set_property( Ammo_cliptext2, "visible", true )
			vint_set_property( Ammo_cliptext2, "text_tag", ammo_rounds )

			vint_set_property( Ammo_text1, "visible", true )
			vint_set_property( Ammo_text1, "text_tag", ammo_total )
			vint_set_property( Ammo_text2, "visible", true )
			vint_set_property( Ammo_text2, "text_tag", ammo_total )	
			vint_set_property( Ammo_box, "visible", true )

			--we are out of ammo completely so dim the reticle out
			if( ammo_clip_count == 0 ) and ( ammo_rounds == 0 ) then

				ALPHA_IN_RETIC = true

				vint_set_property( Reticule_target_handles[1], "alpha", ALPHA_INACTIVE_RETIC )
				vint_set_property( Obj_handles_retic[1], "alpha", ALPHA_INACTIVE_RETIC )

				vint_set_property( Obj_handles_retic[2], "visible", false )
				vint_set_property( Obj_handles_retic[3], "visible", false )
				vint_set_property( Obj_handles_retic[4], "visible", false )
				vint_set_property( Obj_handles_retic[5], "visible", false )

			elseif ( ammo_total < 0 )then

				ALPHA_IN_RETIC = true

				vint_set_property( Ammo_text1, "visible", false )
				vint_set_property( Ammo_text2, "visible", false )
				vint_set_property( Ammo_cliptext1, "visible", false )
				vint_set_property( Ammo_cliptext2, "visible", false )
				vint_set_property( Ammo_box, "visible", false )
				
				vint_set_property( Ammo_meter_handle, "visible", false )
				vint_set_property( Ammo_meter_bg_handle, "visible", false )
			else

				for i = 1,AMMO_METER_HANDLES do
					vint_set_property( Obj_handles_retic[i], "alpha", ALPHA_MAX_RETIC )
				end
				vint_set_property( Reticule_target_handles[1], "alpha", ALPHA_MAX_RETIC )

				ALPHA_IN_RETIC = false
				
			end
			
		else
			vint_set_property( Reticule_target_handles[1], "alpha", ALPHA_MAX_RETIC )
			vint_set_property( Ammo_meter_handle, "alpha", ALPHA_MAX_RETIC )
			vint_set_property( Ammo_meter_bg_handle, "alpha", ALPHA_MAX_RETIC )
		end

		ALPHA_IN_RETIC = true

		if (can_fire == false) then
			for i = 1,AMMO_METER_HANDLES do
				vint_set_property( Obj_handles_retic[i], "alpha", ALPHA_INACTIVE_RETIC )
			end
			vint_set_property( Reticule_target_handles[1], "alpha", ALPHA_INACTIVE_RETIC )
			vint_set_property( Reticule_alpha_handle, "end_value", ALPHA_INACTIVE_RETIC )

		else
			for i = 1,AMMO_METER_HANDLES do
				vint_set_property( Obj_handles_retic[i], "alpha", ALPHA_MAX_RETIC )
			end
			vint_set_property( Reticule_target_handles[1], "alpha", ALPHA_MAX_RETIC )
			vint_set_property( Reticule_alpha_handle, "end_value", ALPHA_MAX_RETIC )
						
		end

		vint_set_property( No_limit_reserve_handle, "visible", false )

		if (show_ammo_counter == false) then
			-- hide the ammo box if this is true
			vint_set_property( Ammo_text1, "visible", false )
			vint_set_property( Ammo_text2, "visible", false )
			vint_set_property( Ammo_cliptext1, "visible", false )
			vint_set_property( Ammo_cliptext2, "visible", false )
			vint_set_property( Ammo_box, "visible", false )		
		else
		
			if (ammo_rounds == -1) then
				--handle unlimited ammo
				vint_set_property( No_limit_handle, "visible", true )
				vint_set_property( No_limit_shadow_handle, "visible", true )
				vint_set_property( Ammo_text1, "visible", false )
				vint_set_property( Ammo_text2, "visible", false )
				vint_set_property( Ammo_cliptext1, "visible", false )
				vint_set_property( Ammo_cliptext2, "visible", false )
				vint_set_property( Ammo_box, "visible", false )
			end

			if (ammo_reserve == -1) then
				vint_set_property( No_limit_handle, "visible", false )
				vint_set_property( No_limit_shadow_handle, "visible", false )
				vint_set_property( No_limit_reserve_handle, "visible", true )
				vint_set_property( Ammo_text1, "visible", false )
				vint_set_property( Ammo_text2, "visible", false )
				vint_set_property( Ammo_cliptext1, "visible", true )
				vint_set_property( Ammo_cliptext2, "visible", true )
				vint_set_property( Ammo_box, "visible", true )
			end
		end
	else
		vint_set_property( Ammo_meter_handle, "visible", false )
		vint_set_property( Ammo_meter_bg_handle, "visible", false )
	end

	if (local_player_hit_someone_this_frame == true and weapon_reticule_name ~= nil) then

		vint_set_property( Reticule_target_handles[2], "visible", true )
		vint_set_property( Reticule_target_handles[2], "image", weapon_reticule_name )
		vint_set_property( Reticule_target_handles[2], "tint", 0.8, 0, 0 )

		--if the player uses the shotgun play all 3 animations on every shot
		if(weapon_name == "shotgun") then
			
			local delay1 = 0.1875
			local delay2 = 0.375
			local start_time = vint_get_time_index()
			
			--start hit_anim1
			vint_set_property( Hit_anim1, "start_time", start_time )
			vint_set_child_tween_state( Hit_anim1, TWEEN_STATE_RUNNING )			

			vint_set_property( Reticule_target_handles[3], "visible", true )
			vint_set_property( Reticule_target_handles[3], "image", weapon_reticule_name )
			vint_set_property( Reticule_target_handles[3], "tint", 0.8, 0, 0 )

			--start hit_anim2
			vint_set_property( Hit_anim2, "start_time", start_time + delay1 )
			vint_set_child_tween_state( Hit_anim2, TWEEN_STATE_IDLE )

			vint_set_property( Reticule_target_handles[4], "visible", true )
			vint_set_property( Reticule_target_handles[4], "image", weapon_reticule_name )
			vint_set_property( Reticule_target_handles[4], "tint", 0.8, 0, 0 )

			--start hit_anim3
			vint_set_property( Hit_anim3, "start_time", start_time + delay2 )
			vint_set_child_tween_state( Hit_anim3, TWEEN_STATE_IDLE )

		else
			
			if (vint_get_property( Hit_tween1, "state" ) == TWEEN_STATE_RUNNING) then

				if (vint_get_property( Hit_tween1b, "state" ) == TWEEN_STATE_RUNNING) then

					if (vint_get_property( Hit_tween1c, "state" ) == TWEEN_STATE_RUNNING) then

						--do nothing

					else
					
						vint_set_property( Reticule_target_handles[4], "visible", true )
						vint_set_property( Reticule_target_handles[4], "image", weapon_reticule_name )
						vint_set_property( Reticule_target_handles[4], "tint", 0.8, 0, 0 )

						--start hit_anim3
						vint_set_property( Hit_anim3, "start_time", vint_get_time_index() )
						vint_set_child_tween_state( Hit_anim3, TWEEN_STATE_RUNNING )

					end

				else

					vint_set_property( Reticule_target_handles[3], "visible", true )
					vint_set_property( Reticule_target_handles[3], "image", weapon_reticule_name )
					vint_set_property( Reticule_target_handles[3], "tint", 0.8, 0, 0 )

					--start hit_anim2
					vint_set_property( Hit_anim2, "start_time", vint_get_time_index() )
					vint_set_child_tween_state( Hit_anim2, TWEEN_STATE_RUNNING )

				end

			else		
				--start hit_anim1
				vint_set_property( Hit_anim1, "start_time", vint_get_time_index() )
				vint_set_child_tween_state( Hit_anim1, TWEEN_STATE_RUNNING )

			end
			
		end 

	end

end


