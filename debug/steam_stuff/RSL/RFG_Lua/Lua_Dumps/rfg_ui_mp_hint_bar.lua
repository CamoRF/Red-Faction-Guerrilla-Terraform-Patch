HUD_ORANGE				= {R=0.83,G=0.54,B=0}
HUD_BROWN				= {R=0.5,G=0.25,B=0}
HUD_GREEN				= {R=0.42,G=0.61,B=0.08}
HUD_HINT_PADDING			= 20
DPAD_UP					= 0
DPAD_RIGHT				= 1
DPAD_DOWN				= 2
DPAD_LEFT				= 3

PC_hint_group			= {MAX_HINT_ITEMS = 0}

function rfg_ui_mp_hint_bar_init()
	-- get the handles
	init_mp_hud_hint_bar_handles()
	-- subscribe to the data item whose name is , and we listen for updates, so that it then calls our function show_mps
	vint_dataitem_add_subscription( "mp_hint_bar_mode_spectator","update", "mp_spectator_camera" )
	vint_dataitem_add_subscription( "mp_hint_bar_mode_spectator_hints","update", "mp_spectator_hints" )
	
	PC_hint_group[1] = vint_object_find("hint1")
	PC_hint_group[2] = vint_object_find("hint2")
	PC_hint_group[3] = vint_object_find("hint3")
	PC_hint_group[4] = vint_object_find("hint4")
end

function init_mp_hud_hint_bar_handles()
	--hide spectator hints
	vint_set_property( vint_object_find( "mp_spectator_main" ),"visible", false )
	vint_set_property( vint_object_find( "mp_spectator_hints" ),"visible", false )	
end
function mp_spectator_camera(data_item_handle, event_name)
	local is_visible,hint_button_1,hint_text_1,hint_state, use_keys, icon1, icon2, icon3, icon4  = vint_dataitem_get(data_item_handle)
	vint_set_property( vint_object_find( "mp_spectator_main" ),"visible", is_visible )
	if(is_visible == true)then
		vint_set_property( vint_object_find( "dpad1" ),"image", hint_button_1 )
		vint_set_property( vint_object_find( "dpad_hint1" ),"text_tag", hint_text_1 )
		vint_set_property( vint_object_find( "dpad_icon_manual" ),"tint", HUD_BROWN.R,HUD_BROWN.G,HUD_BROWN.B )
		vint_set_property( vint_object_find( "dpad_icon_action" ),"tint", HUD_BROWN.R,HUD_BROWN.G,HUD_BROWN.B )
		vint_set_property( vint_object_find( "dpad_icon_player" ),"tint", HUD_BROWN.R,HUD_BROWN.G,HUD_BROWN.B )
		vint_set_property( vint_object_find( "dpad_icon_fish" ),"tint", HUD_BROWN.R,HUD_BROWN.G,HUD_BROWN.B )
		if( hint_state == DPAD_UP )then
			vint_set_property( vint_object_find( "dpad_icon_manual" ),"tint", HUD_ORANGE.R,HUD_ORANGE.G,HUD_ORANGE.B )
		elseif( hint_state == DPAD_RIGHT )then
			vint_set_property( vint_object_find( "dpad_icon_action" ),"tint", HUD_ORANGE.R,HUD_ORANGE.G,HUD_ORANGE.B )
		elseif( hint_state == DPAD_DOWN )then
			vint_set_property( vint_object_find( "dpad_icon_player" ),"tint", HUD_ORANGE.R,HUD_ORANGE.G,HUD_ORANGE.B )
		elseif( hint_state == DPAD_LEFT )then
			vint_set_property( vint_object_find( "dpad_icon_fish" ),"tint", HUD_ORANGE.R,HUD_ORANGE.G,HUD_ORANGE.B )
		end
		
		if ( use_keys == true) then 
			vint_set_property( vint_object_find( "pc_key_icon_up" ),"image", icon1 )
			vint_set_property( vint_object_find( "pc_key_icon_left" ),"image", icon2 )
			vint_set_property( vint_object_find( "pc_key_icon_down" ),"image", icon3 )
			vint_set_property( vint_object_find( "pc_key_icon_right" ),"image", icon4 )
		end
		
		vint_set_property( vint_object_find( "dpad1" ),"visible", not use_keys )
		vint_set_property( vint_object_find( "pc_key_icon_up" ),"visible", use_keys )
		vint_set_property( vint_object_find( "pc_key_icon_left" ),"visible", use_keys )
		vint_set_property( vint_object_find( "pc_key_icon_down" ),"visible", use_keys )
		vint_set_property( vint_object_find( "pc_key_icon_right" ),"visible", use_keys )
		
	end
end
function mp_spectator_hints(data_item_handle, event_name)
	local is_visible,hint_text_main, hint1, hint2, hint3, hint4  = vint_dataitem_get(data_item_handle)
	vint_set_property( vint_object_find( "mp_spectator_hints" ),"visible", is_visible )
	if(is_visible == true)then	
		if ((hint_text_main == "" or hint_text_main == nil)) then
		--use our separate hint icons for mouseover checks
			vint_set_property( vint_object_find( "spec_hint_main" ),"visible", false )
			vint_set_property( PC_hint_group[1],"visible", (hint1 ~= "" ))
			vint_set_property( PC_hint_group[1],"text_tag", hint1 )
			vint_set_property( PC_hint_group[2],"visible", (hint2 ~= ""))
			vint_set_property( PC_hint_group[2],"text_tag", hint2 )
			vint_set_property( PC_hint_group[3],"visible", (hint3 ~= "") )
			vint_set_property( PC_hint_group[3],"text_tag", hint3 )
			vint_set_property( PC_hint_group[4],"visible", (hint4 ~= "") )
			vint_set_property( PC_hint_group[4],"text_tag", hint4 )
			
			local parent_scalex,parent_scaley = vint_get_property( vint_object_find("mp_spectator_hints"), "scale" )
	
			
			for i = 2, 4 do
				if (vint_get_property( PC_hint_group[i-1], "visible" )) then 
					local width, height = vint_get_property( PC_hint_group[i-1], "screen_size" )
					local anchor_x, anchor_y = vint_get_property( PC_hint_group[i-1], "anchor" )
					local new_x = anchor_x + (width/parent_scalex) + HUD_HINT_PADDING
					vint_set_property(PC_hint_group[i], "anchor", new_x, anchor_y)
				end 
			end
			
		else
		--use normal gigantic text hint
			vint_set_property( vint_object_find( "spec_hint_main" ),"visible", true )
			vint_set_property( vint_object_find( "spec_hint_main" ),"text_tag", hint_text_main )
			vint_set_property( vint_object_find( "hint1" ),"visible", false )
			vint_set_property( vint_object_find( "hint2" ),"visible", false )
			vint_set_property( vint_object_find( "hint3" ),"visible", false )
			vint_set_property( vint_object_find( "hint4" ),"visible", false )
		end
	end
end
function rfg_ui_mp_hint_bar_cleanup() end