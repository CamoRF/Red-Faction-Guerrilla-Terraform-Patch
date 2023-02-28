
background_loop_images = {current = 1}

LS_LAYOUT_NONE		= 1
LS_LAYOUT_NEWS		= 2
LS_LAYOUT_LEVEL_NAME	= 3

MAX_LOAD_IMAGES		= 3
LS_image_handles	= {MAX_ITEMS = 0}
LS_stock_anim_handles	= {MAX_ITEMS = 0}
LS_diags_anim_handles	= {MAX_ITEMS = 0}
LS_news_diags_anim_handles	= {MAX_ITEMS = 0}
LS_news_anchor_anim_handles	= {MAX_ITEMS = 0}
LS_background_anim_handles	= {MAX_ITEMS = 0}
LS_num_images		= 0

-- ##############################################################
function rfg_ui_loading_cleanup()
	-- Get rid of the callback on the shifting pictures animation
	local cover_tween = vint_object_find("main_group_alpha_twn_end")
	remove_tween_end_callback(cover_tween)
end

-- ##############################################################
function rfg_ui_loading_init()
	-- Set up the callback for the shifting pictures animation
	local cover_tween = vint_object_find("main_group_alpha_twn_end")
	vint_set_property( cover_tween, "state", TWEEN_STATE_DISABLED )
	vint_set_property( cover_tween, "end_event", "load_background_loop")

	LS_image_handles[1] = vint_object_find( "main_group" )
	LS_stock_anim_handles[1] = vint_object_find( "stock_ticker_anim" )
	LS_diags_anim_handles[1] = vint_object_find( "diags_anim" )
	LS_news_diags_anim_handles[1] = vint_object_find( "news_loading_dags" )
	LS_news_anchor_anim_handles[1] = vint_object_find("news_anchor_anim" )
	LS_background_anim_handles[1] = vint_object_find("background_anim")
	
	-- Ask the game for the data to be displayed
	vint_datagroup_add_subscription( "LoadData", "update", "set_loading_info" )
	vint_datagroup_add_subscription( "LoadData", "insert", "set_loading_info" )	
	vint_datagroup_add_subscription( "LoadData", "remove", "remove_loading_image" )


end

-- ##############################################################
function add_loading_image()
	LS_num_images = LS_num_images + 1

	if (LS_num_images > 1) then
		-- this is not the first item, so we need to clone it from the first item
		LS_image_handles[LS_num_images] = vint_object_clone_rename( LS_image_handles[1], "main_group"..LS_num_images )

		LS_stock_anim_handles[LS_num_images] = vint_anim_clone_and_retarget( LS_stock_anim_handles[1], LS_image_handles[LS_num_images] )
		LS_diags_anim_handles[LS_num_images] = vint_anim_clone_and_retarget( LS_diags_anim_handles[1], LS_image_handles[LS_num_images] )
		LS_news_diags_anim_handles[LS_num_images] = vint_anim_clone_and_retarget( LS_news_diags_anim_handles[1], LS_image_handles[LS_num_images] )
		LS_news_anchor_anim_handles[LS_num_images] = vint_anim_clone_and_retarget( LS_news_anchor_anim_handles[1], LS_image_handles[LS_num_images] )
		LS_background_anim_handles[LS_num_images] = vint_anim_clone_and_retarget( LS_background_anim_handles[1], LS_image_handles[LS_num_images] )

		if (vint_get_property( vint_object_find("main_group_alpha_twn_end"), "state" ) == TWEEN_STATE_DISABLED) then
			vint_set_property( vint_object_find("main_group_alpha_twn_end"), "state", TWEEN_STATE_IDLE)
			vint_set_property( vint_object_find("image_fade_anim"), "start_time", vint_get_time_index() )
		end

		vint_set_property( LS_image_handles[LS_num_images], "depth", LS_num_images )
	end
	
	-- set it visible and set its depth
	vint_set_property( LS_image_handles[LS_num_images], "visible", true )
	
end

-- ##############################################################
function remove_loading_image()

	if (LS_num_images > 1) then
		vint_object_destroy( LS_image_handles[LS_num_images] )
		vint_object_destroy( LS_stock_anim_handles[LS_num_images] )
		vint_object_destroy( LS_diags_anim_handles[LS_num_images] )
		vint_object_destroy( LS_news_diags_anim_handles[LS_num_images] )
		vint_object_destroy( LS_news_anchor_anim_handles[LS_num_images] )
		vint_object_destroy( LS_background_anim_handles[LS_num_images] )
	else
		vint_set_property( LS_image_handles[1], "visible", false )
	end

	LS_num_images = LS_num_images - 1		
end

-- ##############################################################
function set_loading_info(data_item_handle, event_name)
	local index, layout_type, bg_image, image_rot, fg1_image, fg1_rot, fg2_image, fg2_rot, text1, text2, text3, text4, text5, ol_bg_image, ol_rotation, ol_fg1_image, 
				ol_fg1_rot, ol_string1, ol_string2, ol_string3, ol_string4, ol_string5 = vint_dataitem_get(data_item_handle)

	-- is this an add?
	if ( event_name == "insert" ) then
		add_loading_image()
	end

	local handle = LS_image_handles[index]
	local stock_anim_handle = LS_stock_anim_handles[index]
	local diags_anim_handle = LS_diags_anim_handles[index]
	local news_diags_anim_handle = LS_news_diags_anim_handles[index]
	local news_anchor_anim_handle = LS_news_anchor_anim_handles[index]
	local background_anim_handle = LS_background_anim_handles[index]


	local news_group_handle = vint_object_find("news_group", handle)
	local news_text_handle = vint_object_find("news_text", handle)
	local district_name_handle = vint_object_find("district_name", handle)
	local background_handle = vint_object_find("background", handle)
	local background_group_handle = vint_object_find("background_group", handle)
	local background1_handle = vint_object_find("background1", handle)
	local background2_handle = vint_object_find("background2", handle)
	local background3_handle = vint_object_find("background3", handle)
	local loading_bar_handle = vint_object_find("loading_bar", handle)
	local loading_text_handle = vint_object_find("MENU_LOADING", handle)
	local mask_cover_up_handle = vint_object_find("mask_cover_up", handle)
	local mask_cover_up2_handle = vint_object_find("mask_cover_up2", handle)
	local black_bg2_handle = vint_object_find("black_bg2", handle)
	local black_bar2_handle = vint_object_find("black_bar2", handle)
	local stock_ticker_text_1 = vint_object_find("stock_ticker1", handle)
	local stock_ticker_text_2 = vint_object_find("stock_ticker2", handle)
	local news_text_1 = vint_object_find("news_text_1", handle)
	local news_text_2 = vint_object_find("news_text_2", handle)
	local stock_ticker_tween_handle = vint_object_find("stock_ticker_anchor_twn", stock_anim_handle)
	local news_ticker_tween_handle = vint_object_find("news_ticker_anchor_twn", stock_anim_handle)

	local poster_group_handle = vint_object_find("poster_group", handle)
	local poster_handle = vint_object_find("poster", handle)
	local rapsheet_text_handle = vint_object_find("rapsheet_text", handle)
	local header_text_handle = vint_object_find("header_text", handle)

	vint_set_child_tween_state( news_diags_anim_handle, TWEEN_STATE_IDLE )
	vint_set_child_tween_state( news_anchor_anim_handle, TWEEN_STATE_IDLE )
	vint_set_child_tween_state( background_anim_handle, TWEEN_STATE_IDLE )

	vint_set_property( background_handle, "image", bg_image )
	vint_set_property( background1_handle, "image", bg_image )
	vint_set_property( background2_handle, "image", bg_image )
	vint_set_property( background3_handle, "image", bg_image )
			
	-- MW: Hack to fix interface scaling
	local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(background_handle)
	vint_set_property(background_handle, "image_size", size_x * scale_x, size_y * scale_y )
	
	size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(background1_handle)
	vint_set_property(background1_handle, "image_size", size_x * scale_x, size_y * scale_y )
	
	size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(background2_handle)
	vint_set_property(background2_handle, "image_size", size_x * scale_x, size_y * scale_y )
	
	size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(background3_handle)
	vint_set_property(background3_handle, "image_size", size_x * scale_x, size_y * scale_y )
	
	local doc_screen_x, doc_screen_y = rfg_get_ui_doc_res()
	local background_size_x = doc_screen_x + 10
	local background_size_y = doc_screen_y + 10
	
	vint_set_property( background_handle, "screen_size", background_size_x, doc_screen_y)
	vint_set_property( background1_handle, "screen_size", background_size_x, doc_screen_y)
	vint_set_property( background2_handle, "screen_size", background_size_x, doc_screen_y)
	vint_set_property( background3_handle, "screen_size", background_size_x, doc_screen_y)

	--turn everything off
	vint_set_property(news_group_handle, "visible", false)
	vint_set_property(loading_bar_handle, "visible", false)
	vint_set_property(loading_text_handle, "visible", false)
	vint_set_property(mask_cover_up_handle, "visible", false)
	vint_set_property(mask_cover_up2_handle, "visible", false)
	vint_set_property(poster_group_handle, "visible", false)
	vint_set_property(background_group_handle, "visible", false)

	vint_set_child_tween_state( stock_anim_handle, TWEEN_STATE_DISABLED )
	
	local screen_borders_handle = vint_object_find("screen_borders")
	vint_set_property( screen_borders_handle, "visible", false )
	vint_set_property( background_handle, "res_offset_x", "start" )
	vint_set_property( background_handle, "res_offset_y", "neg_start_twice" )
	vint_set_property( background_handle, "res_scale_x", "cutoff" )
	vint_set_property( background_handle, "res_scale_y", "cutoff" )
	
	if (layout_type == LS_LAYOUT_NEWS) then
		-- Setup all of the news layout stuff

		-- fg1_image 	= Anchor woman
		-- fg1_rot	= Anchor woman rotation
		-- fg2_image	= PIP
		-- fg2_rot	= PIP rotation
		-- text1	= PIP headline text (optional)
		-- text2	= News headline text (required)
		-- text3	= News ticker text (required)	
		-- text4	= Stock ticker text (required)
		-- text5	= Station ID text (required)
		-- ol_bg_image	= NULL	
		-- ol_rotation = 0.0
		-- ol_fg1_image = NULL
		-- ol_fg1_rot	= 0
		-- ol_string1	= NULL
		-- ol_string2	= NULL
		-- ol_string3	= NULL
		-- ol_string4	= NULL
		-- ol_string5	= NULL
	
		vint_set_property( screen_borders_handle, "visible", true )
		vint_set_property( background_handle, "res_offset_x", "center" )
		vint_set_property( background_handle, "res_offset_y", "center" )
		vint_set_property( background_handle, "res_scale_x", "maintain_ratio" )
		vint_set_property( background_handle, "res_scale_y", "maintain_ratio" )

		local image_handle = vint_object_find("news_anchor_image1", handle)
		vint_set_property(image_handle, "image", fg1_image)
			
		-- MW: Hack to fix interface scaling
		local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
		vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		
		image_handle = vint_object_find("news_anchor_image2", handle)
		vint_set_property(image_handle, "image", fg1_image)
			
		-- MW: Hack to fix interface scaling
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
		vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		
		image_handle = vint_object_find("news_anchor_image3", handle)
		vint_set_property(image_handle, "image", fg1_image)
			
		-- MW: Hack to fix interface scaling
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
		vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		
		image_handle = vint_object_find("news_anchor_image4", handle)
		vint_set_property(image_handle, "image", fg1_image)
			
		-- MW: Hack to fix interface scaling
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
		vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		
		image_handle = vint_object_find("pip_image", handle)
		vint_set_property(image_handle, "image", fg2_image)
			
		-- MW: Hack to fix interface scaling
		size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(image_handle)
		vint_set_property(image_handle, "image_size", size_x * scale_x, size_y * scale_y )
		
		--PIP headlines have been cut - JM
		--vint_set_property(vint_object_find("pip_headline", handle), "text_tag", text1)
		vint_set_property(vint_object_find("news_headline", handle), "text_tag", text2)
		vint_set_property(news_text_1, "text_tag", text3)
		vint_set_property(news_text_2, "text_tag", text3)
		vint_set_property(vint_object_find("station_id", handle), "text_tag", text5)
		vint_set_property(stock_ticker_text_1, "text_tag", text4)
		vint_set_property(stock_ticker_text_2, "text_tag", text4)

		vint_set_property(background_group_handle, "visible", true)

		--extend fade out anim for news stories by 5 secs
		vint_set_property( vint_object_find("main_group_alpha_twn_end"), "start_time", 15)
		
		--determing time for STOCK ticker tween based on width of text
		local SPEED = 32 --pixels per sec
		local time = 0
		local distance, bogus_y = vint_get_property( stock_ticker_text_1, "screen_size" )
		local parent_scale_x, parent_scale_y = vint_get_property(handle,"scale")

		time = distance / SPEED

		--set tween end points
		local start_x, start_y = vint_get_property(stock_ticker_tween_handle, "start_value")
		
		vint_set_property(stock_ticker_tween_handle, "end_value", start_x - (distance/parent_scale_x), start_y)
		vint_set_property(stock_ticker_tween_handle, "duration", time)
		
		--reposition 2nd text field
		local text1_x, text1_y = vint_get_property(stock_ticker_text_1, "anchor")
		vint_set_property(stock_ticker_text_2, "anchor", text1_x + (distance/parent_scale_x), text1_y)

		--------------------------------------------------------------

		--determing time for NEWS ticker tween based on width of text
		SPEED = 24
		distance, bogus_y = vint_get_property( news_text_1, "screen_size" )

		time = distance / SPEED

		--set tween end points
		start_x, start_y = vint_get_property(news_ticker_tween_handle, "start_value")		
		
		vint_set_property(news_ticker_tween_handle, "end_value", start_x - (distance/parent_scale_x), start_y)
		vint_set_property(news_ticker_tween_handle, "duration", time)
		
		--reposition 2nd text field
		text1_x, text1_y = vint_get_property(news_text_1, "anchor")
		vint_set_property(news_text_2, "anchor", text1_x + (distance/parent_scale_x), text1_y)		

		--start animation
		--vint_set_property(stock_anim_handle, "start_time", vint_get_time_index() )
		vint_set_child_tween_state( stock_anim_handle, TWEEN_STATE_IDLE )

		vint_set_property(news_group_handle, "visible", true)

		if(ol_bg_image ~= nil ) then
			vint_set_property(news_text_handle, "visible", false)
			
			vint_set_property(poster_group_handle, "visible", true)
			vint_set_property(poster_handle, "image", ol_bg_image)
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(poster_handle)
			vint_set_property(poster_handle, "image_size", size_x * scale_x, size_y * scale_y )
			
			vint_set_property(poster_group_handle, "rotation", ol_rotation)
			vint_set_property(rapsheet_text_handle, "text_tag", ol_string1)
			vint_set_property(header_text_handle, "text_tag", ol_string3)

			vint_set_property(poster_handle, "screen_size", 720, 832)
		else
			vint_set_property(news_text_handle, "visible", true)
			vint_set_property(poster_group_handle, "visible", false)
		end

	elseif (layout_type == LS_LAYOUT_LEVEL_NAME ) then
		
		-- Setup the old generic "LOADING - <LEVEL NAME>" in bottom left

		--fg1_image 	= NULL
		--fg1_rot	= NULL
		--fg2_image	= NULL
		--fg2_rot	= NULL
		--text1		= "LOADING"
		--text2		= "<LEVEL NAME>"
		--text3		= NULL
		--text4		= NULL
		--text5		= NULL
		-- ol_bg_image	= Poster background image (optional)	
		-- ol_rotation = Overall overlay image rotation
		-- ol_fg1_image = Poster foreground image (optional)
		-- ol_fg1_rot	= Poster foreground image rot (optional)
		-- ol_string1	= Poster string1 (optional)
		-- ol_string2	= Poster string2 (optional)
		-- ol_string3	= Poster string3 (optional)
		-- ol_string4	= Poster string4 (optional)
		-- ol_string5	= Poster string5 (optional)

		vint_set_property(loading_text_handle, "text_tag", text1)
		vint_set_property(district_name_handle, "text_tag", text2)

		vint_set_property(loading_bar_handle, "visible", true)	
		vint_set_property(loading_text_handle, "visible", true)
		vint_set_property(mask_cover_up_handle, "visible", true)
		vint_set_property(mask_cover_up2_handle, "visible", true)
		vint_set_property(black_bg2_handle, "visible", true)
		vint_set_property(black_bar2_handle, "visible", true)
		vint_set_property(black_bg2_handle, "visible", true)
		vint_set_property(black_bar2_handle, "visible", true)

		local parent_scalex, parent_scaley = vint_get_property(LS_image_handles[index], "scale")
		local MAX_SCREEN_WIDTH = 360 * parent_scalex
		local MAX_TEXT_WIDTH = 594 * parent_scalex
		local text_sizex, text_sizey = vint_get_property( district_name_handle, "screen_size")

		if(text_sizex > MAX_SCREEN_WIDTH) then		
			--if the text is really long scale it down [localization fix]
			if (text_sizex > MAX_TEXT_WIDTH) then
				
				vint_set_property( district_name_handle, "text_scale", 1.05, 1.05)

			end
		else
			vint_set_property(mask_cover_up2_handle, "visible", false)
			vint_set_property(black_bg2_handle, "visible", false)
			vint_set_property(black_bar2_handle, "visible", false)	
		end
		
		if(ol_bg_image ~= nil ) then
			vint_set_property(poster_group_handle, "visible", true)
			vint_set_property(poster_handle, "image", ol_bg_image)
			
			-- MW: Hack to fix interface scaling
			local size_x, size_y, scale_x, scale_y = rfg_get_bitmap_dimensions(poster_handle)
			vint_set_property(poster_handle, "image_size", size_x * scale_x, size_y * scale_y )
			
			vint_set_property(poster_group_handle, "rotation", ol_rotation)

			vint_set_property(rapsheet_text_handle, "visible", true)
			vint_set_property(header_text_handle, "visible", true)

			if(ol_string1 ~= nil) then
				vint_set_property(rapsheet_text_handle, "text_tag", ol_string1)
			else
				vint_set_property(rapsheet_text_handle, "visible", false)
			end

			if(ol_string3 ~= nil) then
				vint_set_property(header_text_handle, "text_tag", ol_string3)
			else
				vint_set_property(header_text_handle, "visible", false)
			end

			vint_set_property(poster_handle, "screen_size", 720, 832)
		else
			vint_set_property(poster_group_handle, "visible", false)
		end

	else
		-- Setup nothing but the backgroun (turn all the modules off!)

		-- All data is NULL!!!
	end
end

-- ##############################################################
function load_background_loop()

	-- update our current image
	background_loop_images.current = background_loop_images.current + 1
	if (background_loop_images.current > LS_num_images) then
		background_loop_images.current = 1
	end

	-- set all of the images to the background depth
	local cur_idx = background_loop_images.current
	for i = 1,LS_num_images do
		vint_set_property( LS_image_handles[cur_idx], "depth", i-1 )
		vint_set_property( LS_image_handles[cur_idx], "alpha", 1.0 )

		-- increment our current index
		cur_idx = cur_idx + 1
		if (cur_idx > LS_num_images) then
			cur_idx = 1
		end
	end

	-- now we are going to retarget the alpha anim, and start it over at the beginning
	vint_set_property( vint_object_find( "main_group_alpha_twn_start" ), "target_handle", LS_image_handles[background_loop_images.current] )
	vint_set_property( vint_object_find( "main_group_alpha_twn_end" ), "target_handle", LS_image_handles[background_loop_images.current] )
	vint_set_property( vint_object_find( "image_fade_anim"), "start_time", vint_get_time_index())	
end




--[[
-- ##############################################################
function set_loading_info(data_item_handle, event_name)
	local district_name, image_name1, image_name2, image_name3 = vint_dataitem_get(data_item_handle)


	local handle = vint_object_find("district_name")
	local text_sizex, text_sizey
	local mask_cover_up2 = vint_object_find("mask_cover_up2")
	local black_bg2 = vint_object_find("black_bg2")
	local black_bar2 = vint_object_find("black_bar2")
	local parent_scalex, parent_scaley = vint_get_property(vint_object_find("main_group"), "scale")
	local MAX_SCREEN_WIDTH = 360 * parent_scalex
	local MAX_TEXT_WIDTH = 594 * parent_scalex

	-- Set the name of the location
	vint_set_property( handle, "text_tag_crc", district_name )
	
	-- Get that background loop going
	background_loop_images[1] = image_name1
	background_loop_images[2] = image_name2
	background_loop_images[3] = image_name3
	background_loop_images.current = 1
	load_background_loop()

	text_sizex, text_sizey = vint_get_property( handle, "screen_size")

	if(text_sizex > MAX_SCREEN_WIDTH) then
		vint_set_property(mask_cover_up2, "visible", true)
		vint_set_property(black_bg2, "visible", true)
		vint_set_property(black_bar2, "visible", true)		

		--if the text is really long scale it down [localization fix]
		if (text_sizex > MAX_TEXT_WIDTH) then
			
			vint_set_property( handle, "text_scale", 1.05, 1.05)

		end

	else
		vint_set_property(mask_cover_up2, "visible", false)
		vint_set_property(black_bg2, "visible", false)
		vint_set_property(black_bar2, "visible", false)	
	end

end

-- ##############################################################
function load_background_loop()

	-- Set up local vars
	local old_image = 0
	local background_h = vint_object_find("background")
	local background_cover_h = vint_object_find("background_cover")
	
	-- Reset the timing on the picture shifting animation
	vint_set_property( vint_object_find( "background_cover_anim"), "start_time", vint_get_time_index())
	
	-- Adjust old and new image ints
	if background_loop_images.current == 1 then
		background_loop_images.current = 2
		old_image = 1
		
	elseif background_loop_images.current == 2 then
		background_loop_images.current = 3
		old_image = 2
		
	elseif background_loop_images.current == 3 then
		background_loop_images.current = 1
		old_image = 3
	end

	-- Place old image into cover, place new image into background
	vint_set_property( background_h, "image", background_loop_images[background_loop_images.current] )
	vint_set_property( background_cover_h, "image", background_loop_images[old_image] )
	
	-- Place cover on top so it can be faded back later
	vint_set_property( background_cover_h, "alpha", 1.0 )
end
--]]
