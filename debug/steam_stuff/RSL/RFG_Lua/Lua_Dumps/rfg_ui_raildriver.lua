
-- Target type enumeration
TARGETING_INFO_NONE		= 0
TARGETING_INFO_FRIENDLY	= 1
TARGETING_INFO_ENEMY		= 2

-- ##############################################################
function rfg_ui_raildriver_cleanup()

end

-- ##############################################################
function rfg_ui_raildriver_init()
	vint_dataitem_add_subscription( "RailDriverUpdate", "update", "rail_driver_update" )
	vint_set_property(vint_object_find("ammo_unlimited"),"visible", false)
end

-- ##############################################################
function rail_driver_update(data_item_handle, event_name)
	local clip, reserve, reload_pct, targeting = vint_dataitem_get(data_item_handle)

	local RELOAD_MAX = 600
	local ammo_reserve = vint_object_find("ammo_reserve")
	local ammo_unlimited = vint_object_find("ammo_unlimited")
	
	if (clip == 0) then
		vint_set_property(vint_object_find("reload_fill"), "scale", 0, 10)
	else
		vint_set_property(vint_object_find("reload_fill"), "scale", RELOAD_MAX * reload_pct, 10)
	end

	vint_set_property(vint_object_find("ammo_reserve"), "text_tag", reserve)
	vint_set_property(vint_object_find("ammo_clip"), "text_tag", clip)

	if(reserve == -1)then
		vint_set_property(ammo_unlimited,"visible", true)
		vint_set_property(ammo_reserve,"visible", false)
	else
		vint_set_property(ammo_unlimited,"visible", false)
		vint_set_property(ammo_reserve,"visible", true)
	end
	
	-- Set the color of the reticle based on what's targeted.
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
		r = 1.0
		g = 1.0
		b = 1.0
	end

	vint_set_property( vint_object_find( "reticule_center" ), "tint", r, g, b )
end