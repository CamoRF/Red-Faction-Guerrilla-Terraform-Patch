Install_bar_size_x = 0
Install_bar_size_y = 0

-- ##############################################################
function rfg_ui_init_load_cleanup()
end

-- ##############################################################
function rfg_ui_init_load_init()
	vint_dataitem_add_subscription( "InitLoad", "update", "update_info" )

	vint_set_property( vint_object_find( "tick_5_fadeout" ), "end_event", "tween_end" )

	Install_bar_size_x, Install_bar_size_y = vint_get_property( vint_object_find( "install_bar" ), "screen_size" )	
end

function tween_end()
	vint_set_time_index(0)
end

function update_info(data_item_handle, event_name)
	local image_name, text, installing, install_percent, is_install_paused, install_time_remaining, install_warning, hide_load_bar = vint_dataitem_get(data_item_handle)
	
	--Pro Tip: any image you want to show up on the init load screen must be set in script like the images below
	--because the peg doesn't get loaded until after the doc
	vint_set_property( vint_object_find( "background" ), "image", image_name )
	vint_set_property( vint_object_find( "loading_shape" ), "image", "ui_loading_init_loadshape" )

	local install_group = vint_object_find( "install_group" )
	local tick_fill_main = vint_object_find( "tick_fill_main" )
	local text_group = vint_object_find( "text_group" )
	
	--if there was an error installing or we are changing languages then hide everything except the background	
	if (hide_load_bar == true) then
		vint_set_property( install_group, "visible", false )
		vint_set_property( tick_fill_main, "visible", false )	
		vint_set_property( text_group, "visible", false )	
		vint_set_property( vint_object_find("loading_shape"), "visible", false )	
   	else
		-- MLG: We need to reset all of our fonts here because the game may have switched them up on us since this is still early in the boot process.  This fixes a bug where text would
		--        either not show up at all or with the wrong font because the fonts were completly loaded when the doc was loaded.
		vint_set_property( vint_object_find("time_remaining"), "font", "font_numbers" )
		vint_set_property( vint_object_find("install_warning"), "font", "font_body" )
		vint_set_property( vint_object_find("text_clone"), "font", "font_header" )

		vint_set_property( text_group, "visible", true )	
		vint_set_property( vint_object_find("loading_shape"), "visible", true )	

		local text_handle = vint_object_find( "text_clone" )
		vint_set_property( text_handle, "text_tag", text )

		if (installing == true) then
			vint_set_property( install_group, "visible", true )
			vint_set_property( tick_fill_main, "visible", false )

			vint_set_property( vint_object_find("time_remaining"), "text_tag", install_time_remaining )
			vint_set_property( vint_object_find("install_warning"), "text_tag", install_warning )

			local new_size_x = install_percent * Install_bar_size_x
			vint_set_property( vint_object_find( "install_bar" ), "screen_size", new_size_x, Install_bar_size_y )
		else
			vint_set_property( install_group, "visible", false )
			vint_set_property( tick_fill_main, "visible", true )
		end
	end

end
