
-- Target type enumeration
TARGETING_INFO_NONE		= 0
TARGETING_INFO_FRIENDLY	= 1
TARGETING_INFO_ENEMY		= 2

-- ##############################################################
function rfg_ui_sniper_cleanup()

end

-- ##############################################################
function rfg_ui_sniper_init()
	vint_dataitem_add_subscription( "SniperUpdate", "update", "sniper_update" )
	vint_set_property(vint_object_find("ammo_unlimited"),"visible", false)
end

-- ##############################################################
function sniper_update(data_item_handle, event_name)
	local clip, reserve, targeting = vint_dataitem_get(data_item_handle)

	local ammo_reserve = vint_object_find("ammo")
	local ammo_unlimited = vint_object_find("ammo_unlimited")

	--set reserve ammo
	vint_set_property(ammo_reserve,"text_tag", reserve)

	local ALPHA_EMPTY = 0.10
	local ALPHA_FULL = 1.00

	for i=1,4 do
		--full clip
		vint_set_property(vint_object_find("bullet"..i),"alpha", ALPHA_EMPTY)		
	end
	
	--turn off bullets in your clip
	for i=1,clip do
		vint_set_property(vint_object_find("bullet"..i),"alpha", ALPHA_FULL)
		vint_set_property(vint_object_find("bullet"..i),"visible", true)
	end

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

	vint_set_property( vint_object_find( "reticule" ), "tint", r, g, b )

end


