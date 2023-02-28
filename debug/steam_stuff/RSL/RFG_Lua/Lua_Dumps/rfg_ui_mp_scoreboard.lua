--include "rfg_ui_mp_siege_shared.lua"

SB_UNSELECTED_DEPTH			= 11
SB_SELECTED_DEPTH			= 0

row_team1_data_item_handle	= {OBJECT_HANDLES_ROWS = 0}
row_team2_data_item_handle	= {OBJECT_HANDLES_ROWS = 0}
row_team1_group_handle		= {OBJECT_HANDLES_ROWS = 0}
row_team2_group_handle		= {OBJECT_HANDLES_ROWS = 0}
row_team1_total			= 0
row_team2_total			= 0
row_t1_group_size		= {0, 0}
row_t2_group_size		= {0, 0}

Player_row_ids			= {}
Player_row_parents		= {}

Attacking_team			= 0
Defending_team			= 0

Mode				= 0 
Score_limit			= -1

Scores				= {}

ORANGE				= {R=0.83,G=0.54,B=0}
BLACK				= {R=0,G=0,B=0}

Team1_sorted_data_item_handle	= {OBJECT_HANDLES_ROWS = 0}
Team2_sorted_data_item_handle	= {OBJECT_HANDLES_ROWS = 0}

HUD_TEAM1_COLOR			= {R = 0, G = 0, B = 0}
HUD_TEAM2_COLOR			= {R = 0, G = 0, B = 0}

--debug_print( "vint", "\nSome text here"..some_int_variable )

SCOREBOARD_MAX_ROW_HEIGHT	= 26.6


-- ##############################################################
function init_mp_scorboard_handles()
	--get the mode
	Mode = rfg_get_multiplayer_mode_name()
	--init_mp_siege_shared_handles(Mode)

	--store the height of the row group
	local parent_scale_x, parent_scale_y = vint_get_property( vint_object_find( "mp_sb_screen_group" ), "scale" )
	
	--get and store the screen size of the row group so we can use the height later when we need 
	--to clone the group and dynamically position it in the list
	local row_parent_handle = vint_object_find( "scoreboard_t1_row" )
	row_t1_group_size[1], row_t1_group_size[2] = vint_get_property( row_parent_handle, "screen_size" )
	-- Adjust the row size by the screen scale
	row_t1_group_size[1] = row_t1_group_size[1] / parent_scale_x
	row_t1_group_size[2] = row_t1_group_size[2] / parent_scale_y

	-- Make sure we don't exceed our max height
	if ( (row_t1_group_size[2]) > SCOREBOARD_MAX_ROW_HEIGHT ) then
		row_t1_group_size[2] = SCOREBOARD_MAX_ROW_HEIGHT
	end
	
	-- hide team one clone
	vint_set_property( row_parent_handle, "visible", false )

	--hide team two clone
	row_parent_handle = vint_object_find( "scoreboard_t2_row" )
	row_t2_group_size[1], row_t2_group_size[2] = vint_get_property( row_parent_handle, "screen_size" )
	-- Adjust the row size by the screen scale
	row_t2_group_size[1] = row_t2_group_size[1] / parent_scale_x
	row_t2_group_size[2] = row_t2_group_size[2] / parent_scale_y

	-- Make sure we don't exceed our max height
	if ( (row_t2_group_size[2]) > SCOREBOARD_MAX_ROW_HEIGHT ) then
		row_t2_group_size[2] = SCOREBOARD_MAX_ROW_HEIGHT
	end




	vint_set_property( row_parent_handle, "visible", false )

	vint_set_property( vint_object_find( "mp_sb_siege_labels" ),"visible", false )

	--set the teams score color
	HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B = rfg_get_mp_team_color(HUMAN_TEAM_GUERILLA)
	HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B = rfg_get_mp_team_color(HUMAN_TEAM_EDF)

	vint_set_property( vint_object_find( "team1_score" ),"tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B )
	vint_set_property( vint_object_find( "team2_score" ),"tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )

	vint_set_property( vint_object_find( "siege_team1_score" ),"tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B )
	vint_set_property( vint_object_find( "siege_team2_score" ),"tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B )
	
	vint_set_property( vint_object_find( "mp_sb_stamp_main" ),"visible",false )
	vint_set_property( vint_object_find( "edf_stamp" ),"visible",false )
	vint_set_property( vint_object_find( "guerrilla_stamp" ),"visible",false )
	vint_set_property( vint_object_find( "mp_sb_user_highlight" ),"visible", false )

	vint_set_child_tween_state( vint_object_find( "team_1_score_limit_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team_2_score_limit_anim" ), TWEEN_STATE_DISABLED )

	resize_stamps()
end

-- ##############################################################
function rfg_ui_mp_scoreboard_cleanup()
end

-- ##############################################################
function rfg_ui_mp_scoreboard_init()

	-- get the handles
	init_mp_scorboard_handles()

	-- subscribe to the data item whose name is ??, and we listen for updates, so that
	-- it then calls our function ??
	vint_dataitem_add_subscription( "multiplayer_hud_timer", "update", "set_time" )
	vint_dataitem_add_subscription( "multiplayer_scoreboard_team_header", "update", "set_team_header" )
	vint_dataitem_add_subscription( "multiplayer_scoreboard_ffa_header", "update", "set_ffa_header" )
	
	vint_dataitem_add_subscription( "multiplayer_scoreboard_score", "update", "set_score" )
	
	vint_datagroup_add_subscription( "multiplayer_scoreboard_players", "insert", "set_row_data" )
	vint_datagroup_add_subscription( "multiplayer_scoreboard_players", "update", "set_row_data" )
	vint_datagroup_add_subscription( "multiplayer_scoreboard_players", "remove", "remove_row" )

	vint_dataitem_add_subscription( "multiplayer_hud_mode_siege", "update", "set_siege_teams" )
	
	vint_dataevent_add_subscription("multiplayer_round_over", "update", "round_over")

	vint_set_property(  vint_object_find( "header_round_title" ),"visible",false )
	vint_set_property(  vint_object_find( "header_round_of" ),"visible",false )
	vint_set_property(  vint_object_find( "header_round_value1" ),"visible",false )
	vint_set_property(  vint_object_find( "header_round_value2" ),"visible",false )
	
	--[[START HACK
	set_row_data(event_name,row_index, is_active, is_local_player, is_selected, selected_interact_button_image, row_image, row_name, row_team,  
	row_value1, row_value1_visible, row_value2, row_value2_visible, row_value3, row_value3_visible,
	row_value4, row_value4_visible, row_value5, row_value5_visible)

	set_row_data("insert",1, true, true, true, "ui_xbox_a", nil, "BOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)
	set_row_data("insert",2, true, false, false, "ui_xbox_a", nil, "BOBdas", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",3, true, false, false, "ui_xbox_a", nil, "BagsOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",4, true, false, false, "ui_xbox_a", nil, "agBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",5, true, false, false, "ui_xbox_a", nil, "BafdgOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",6, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",7, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",8, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",9, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",10, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",11, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",12, true, false, false, "ui_xbox_a", nil, "agsfgafBOB", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",13, true, false, false, "ui_xbox_a", nil, "SUCKITDOWNJERKS", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",14, true, false, false, "ui_xbox_a", nil, "SUCKITDOWNJERKS", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",15, true, false, false, "ui_xbox_a", nil, "SUCKITDOWNJERKS", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	set_row_data("insert",16, true, false, false, "ui_xbox_a", nil, "SUCKITDOWNJERKS", 0,  
	"2", true, "3", true, "4", true,
	"5", true, "6", true)

	--END HACK]]

end
--###############################################################
function set_time(data_item_handle, event_name)
	local time = vint_dataitem_get(data_item_handle)
	local time_handle = vint_object_find( "header_time_value" )
	--set the round time
	vint_set_property( time_handle,"text_tag",time )

end

--###############################################################
function round_over(data_event_handle,event_name)
	local winner = vint_dataevent_get(data_event_handle)
	--debug_print("mp", "Round over! Winner = " .. tostring(winner) .. " | Event name: " .. tostring(event_name) .. "\n")

	vint_set_property( vint_object_find( "mp_sb_stamp_main" ),"visible",true )

	--is the round over
	if( winner == HUMAN_TEAM_GUERILLA )then
		--Guerrillas won
		vint_set_property( vint_object_find( "edf_stamp" ),"visible",false )
		vint_set_property( vint_object_find( "guerrilla_stamp" ),"visible",true )
		vint_set_property( vint_object_find( "guerrilla_winner" ),"text_tag","MENU_WINNER" )

		--vint_set_property( vint_object_find( "guerrilla_stamp" ), "tint", HUD_TEAM1_COLOR.R, HUD_TEAM1_COLOR.G, HUD_TEAM1_COLOR.B)

	elseif( winner == HUMAN_TEAM_EDF )then
		--EDF won
		vint_set_property( vint_object_find( "edf_stamp" ),"visible",true )
		vint_set_property( vint_object_find( "guerrilla_stamp" ),"visible",false )
		vint_set_property( vint_object_find( "edf_winner" ),"text_tag","MENU_WINNER")
		
		--vint_set_property( vint_object_find( "edf_stamp" ), "tint", HUD_TEAM2_COLOR.R, HUD_TEAM2_COLOR.G, HUD_TEAM2_COLOR.B)
	else
		--DRAW
		vint_set_property( vint_object_find( "edf_stamp" ),"visible",true )
		vint_set_property( vint_object_find( "guerrilla_stamp" ),"visible",true )
		--set the text to say draw
		vint_set_property( vint_object_find( "edf_winner" ),"text_tag","MENU_DRAW")
		vint_set_property( vint_object_find( "guerrilla_winner" ),"text_tag","MENU_DRAW" )
	end

	--stop the score limit tweens
	vint_set_child_tween_state( vint_object_find( "team_1_score_limit_anim" ), TWEEN_STATE_DISABLED )
	vint_set_child_tween_state( vint_object_find( "team_2_score_limit_anim" ), TWEEN_STATE_DISABLED )

	resize_stamps()
end

--##################################################################
function resize_stamps()
	local edf_handle = vint_object_find( "edf_winner" )
	local guerrilla_handle = vint_object_find( "guerrilla_winner" )	

	-- resize the edf stamp
	local outline_size_x, outline_size_y = vint_get_property( edf_handle, "screen_size" )
	outline_size_x = outline_size_x * 0.70

	vint_set_property( edf_handle, "scale", 1.0, 1.0 )
	local stamp_size_x, stamp_size_y = vint_get_property( edf_handle, "screen_size" )
	if (stamp_size_x > outline_size_x) then
		local new_scale = outline_size_x / stamp_size_x
		vint_set_property( edf_handle, "scale", new_scale, 1.0 )
	end

	-- resize the guerrilla stamp
	outline_size_x, outline_size_y = vint_get_property( guerrilla_handle, "screen_size" )
	outline_size_x = outline_size_x * 0.70

	
	vint_set_property( guerrilla_handle, "scale", 1.0, 1.0 )
	stamp_size_x, stamp_size_y = vint_get_property( guerrilla_handle, "screen_size" )
	if (stamp_size_x > outline_size_x) then
		local new_scale = outline_size_x / stamp_size_x
		vint_set_property( guerrilla_handle, "scale", new_scale, 1.0 )
	end
end

--###############################################################
function set_score(data_item_handle, event_name)
	local team1_score,team2_score, team1_round_wins, team2_round_wins = vint_dataitem_get(data_item_handle)
	
	local siege_score1_handle = vint_object_find( "header_siege_score1" )
	local siege_score2_handle = vint_object_find( "header_siege_score2" )
	local team1_score_handle = vint_object_find( "header_team1_score" )
	local team2_score_handle = vint_object_find( "header_team2_score" )

	vint_set_property( siege_score1_handle,"visible", false )
	vint_set_property( siege_score2_handle,"visible", false )
	vint_set_property( team1_score_handle,"visible", true )
	vint_set_property( team2_score_handle,"visible", true )

	
	vint_set_property( vint_object_find( "team1_score" ),"text_tag", tostring(team1_score) )
	vint_set_property( vint_object_find( "team2_score" ),"text_tag", tostring(team2_score) )
	--check the score limit
	--make a range to start checking score against

	local score_percent = floor(Score_limit*0.90)
	if( score_percent == 0 )then
		score_percent = Score_limit - 1
	end
	
	--debug_print("vint","Score_limit = "..Score_limit..", score_percent = "..score_percent.."\n")
	
	if( Score_limit > 0 )then
		if( team1_score >= score_percent )then
			vint_set_property(vint_object_find( "team_1_score_limit_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team_1_score_limit_anim" ), TWEEN_STATE_RUNNING )
		else
			vint_set_child_tween_state( vint_object_find( "team_1_score_limit_anim" ), TWEEN_STATE_DISABLED )
		end
		
		if( team2_score >= score_percent )then
			vint_set_property(vint_object_find( "team_2_score_limit_anim" ), "start_time", vint_get_time_index() )
			vint_set_child_tween_state( vint_object_find( "team_2_score_limit_anim" ), TWEEN_STATE_RUNNING )
		else
			vint_set_child_tween_state( vint_object_find( "team_2_score_limit_anim" ), TWEEN_STATE_DISABLED )
		end
	end

	Scores[1] = team1_score
	Scores[2] = team2_score

	vint_set_property( vint_object_find( "team1_round_num"), "text_tag", team1_round_wins )
	vint_set_property( vint_object_find( "team2_round_num"), "text_tag", team2_round_wins )
	
end

--###############################################################
function set_siege_teams(data_item_handle, event_name)
	local attacking, defending = vint_dataitem_get(data_item_handle)
	Attacking_team = attacking
	Defending_team = defending
end

-- ##############################################################
function set_team_header(data_item_handle, event_name)
	local is_visible, header_title, header_team1_name_val, header_team2_name_val, header_round_count, header_round_total, 
		the_limit = vint_dataitem_get(data_item_handle)

	if (is_visible == true) then
		vint_set_property(  vint_object_find( "header_ffa_group" ),"visible",false )
		vint_set_property(  vint_object_find( "header_team_group" ),"visible",true )

		local title_handle = vint_object_find( "header_title" )
		local team1_image_handle = vint_object_find( "header_team1_logo" )
		local team2_image_handle = vint_object_find( "header_team2_logo" )
		local team1_name_handle = vint_object_find( "header_team1_name" )
		local team2_name_handle = vint_object_find( "header_team2_name" )
		local round_val1_handle = vint_object_find( "header_round_value1" )
		local round_val2_handle = vint_object_find( "header_round_value2" )
		
		--set the mode title
		vint_set_property( title_handle,"text_tag",header_title )

		if(Mode == "siege")then
			vint_set_property( vint_object_find( "mp_sb_siege_labels" ),"visible", false )
			if(Attacking_team == 0)then
				vint_set_property( vint_object_find( "siege_label3" ),"text_tag", "!!DESTROYED" )
				vint_set_property( vint_object_find( "siege_label4" ),"text_tag", "!!REMAINING"  )
			elseif(Attacking_team == 1) then
				vint_set_property( vint_object_find( "siege_label3" ),"text_tag", "!!REMAINING" )
				vint_set_property( vint_object_find( "siege_label4" ),"text_tag", "!!DESTROYED" )
			end
		else
			vint_set_property( vint_object_find( "mp_sb_siege_labels" ),"visible", false )
		end

		--set the team names
		vint_set_property( team1_name_handle,"text_tag",header_team1_name_val )
		vint_set_property( team2_name_handle,"text_tag",header_team2_name_val )

		--set the round numbers
		vint_set_property( round_val1_handle,"text_tag",header_round_count )
		vint_set_property( round_val2_handle,"text_tag",header_round_total )

		Score_limit = the_limit
		--debug_print("vint","Score_limit = "..Score_limit.."\n")
	end
end

-- ##############################################################
function set_ffa_header(data_item_handle, event_name)
	local is_visible, header_title,badge,name,score,rank,rank_label = vint_dataitem_get(data_item_handle)
	
	if (is_visible == true) then
		vint_set_property(  vint_object_find( "header_ffa_group" ),"visible",true )
		vint_set_property(  vint_object_find( "header_team_group" ),"visible",false )

		local title_handle = vint_object_find( "header_title" )
		local badge_handle = vint_object_find( "ffa_badge" )
		local name_handle = vint_object_find( "ffa_gamertag" )
		local score_handle = vint_object_find( "ffa_score" )
		local rank_handle = vint_object_find( "ffa_rank" )
		local rank_label_handle = vint_object_find( "ffa_rank_label" )
		
		--set the mode title
		vint_set_property( title_handle,"text_tag",header_title )
		vint_set_property( badge_handle,"image_badge",badge )
		vint_set_property( badge_handle,"scale",1.2,1.2 )
		vint_set_property( name_handle,"text_tag",name )
		vint_set_property( score_handle,"text_tag",score )
		vint_set_property( rank_handle,"text_tag",rank )
		vint_set_property( rank_label_handle,"text_tag",rank_label )

		vint_set_property(  vint_object_find( "header_round_title" ),"visible",false )
		vint_set_property(  vint_object_find( "header_round_of" ),"visible",false )
		vint_set_property(  vint_object_find( "header_round_value1" ),"visible",false )
		vint_set_property(  vint_object_find( "header_round_value2" ),"visible",false )
	end
end

-- ##############################################################
function set_row_data(data_item_handle, event_name)
	local row_index, is_active, is_local_player, is_selected, selected_interact_button_image, row_image, row_name, row_team,  
		row_value1, row_value1_visible, row_value2, row_value2_visible, row_value3, row_value3_visible,
		row_value4, row_value4_visible, row_value5, row_value5_visible = vint_dataitem_get(data_item_handle)

--[[function set_row_data(event_name,row_index, is_active, is_local_player, is_selected, selected_interact_button_image, row_image, row_name, row_team,  
	row_value1, row_value1_visible, row_value2, row_value2_visible, row_value3, row_value3_visible,
	row_value4, row_value4_visible, row_value5, row_value5_visible)
	local data_item_handle = row_index]]
	if ( event_name == "insert" ) then
		local should_use_row1 = nil
		if(row_team == 0)then
			should_use_row1 = true
		elseif(row_team == 1) then
			should_use_row1 = false
		else
			-- No teams, so let's pick a row by trying to keep them balanced
			if (row_team1_total > row_team2_total) then
				should_use_row1 = false
			else
				should_use_row1 = true
			end
		end

		-- If we added a row, store it
		if (should_use_row1 ~= nil) then
			local row_id = nil
			if (should_use_row1 == true) then
				row_id = add_row_team1(data_item_handle)
				Player_row_parents[row_index] = row_team1_group_handle[row_id]
			else
				row_id = add_row_team2(data_item_handle)
				Player_row_parents[row_index] = row_team2_group_handle[row_id]
			end
			Player_row_ids[row_index] = row_id
		end
	end

	if (Player_row_ids[row_index] ~= nil) then
		local row_id = Player_row_ids[row_index]
		local row_parent_handle = Player_row_parents[row_index]
	
		--store a handle to all the row objects
		local row_image_handle = vint_object_find( "player_image", row_parent_handle )
		local row_name_handle = vint_object_find( "player_name", row_parent_handle )
		--local row_value1_handle = vint_object_find( "player_num1", row_parent_handle )
		local row_value2_handle = vint_object_find( "player_num2", row_parent_handle )
		local row_value3_handle = vint_object_find( "player_num3", row_parent_handle )
		local row_value4_handle = vint_object_find( "player_num4", row_parent_handle )
		local row_value5_handle = vint_object_find( "player_num5", row_parent_handle )

		--set the gamertag pic
		if (row_image == -1) then
			vint_set_property(row_image_handle, "visible", false)
		else
			vint_set_property(row_image_handle, "visible", true)
			vint_set_property(row_image_handle,"image_badge",row_image )
			vint_set_property(row_image_handle,"scale",0.9,0.9 )
		end
	
		--set the gamertag name
		vint_set_property( row_name_handle,"text_tag",row_name )
		sb_set_text_width( row_name_handle,204)
	
		--set the player value1
		--vint_set_property( row_value1_handle,"text_tag", tostring(row_value1) )

		--set the player value2
		vint_set_property( row_value2_handle,"text_tag", tostring(row_value2) )

		--set the player value3
		vint_set_property( row_value3_handle,"text_tag", tostring(row_value3) )
	
		--set the player value4
		vint_set_property( row_value4_handle,"text_tag", tostring(row_value4) )

		--set the player value5
		vint_set_property( row_value5_handle,"text_tag", tostring(row_value5) )

		vint_set_property( row_value2_handle,"visible", row_value2_visible )
		vint_set_property( vint_object_find( "sb_header_t1_score" ),"visible", row_value2_visible )
		vint_set_property( vint_object_find( "sb_header_t2_score" ),"visible", row_value2_visible )

		vint_set_property( row_value3_handle,"visible", row_value3_visible )
		vint_set_property( vint_object_find( "sb_header_t1_xp" ),"visible", row_value3_visible )
		vint_set_property( vint_object_find( "sb_header_t2_xp" ),"visible", row_value3_visible )

		vint_set_property( row_value4_handle,"visible", row_value4_visible )
		vint_set_property( vint_object_find( "sb_header_t1_icon2" ),"visible", row_value4_visible )
		vint_set_property( vint_object_find( "sb_header_t2_icon2" ),"visible", row_value4_visible )

		vint_set_property( row_value5_handle,"visible", row_value5_visible )
		vint_set_property( vint_object_find( "sb_header_t1_icon3" ),"visible", row_value5_visible )
		vint_set_property( vint_object_find( "sb_header_t2_icon3" ),"visible", row_value5_visible )
	
		--highlight the local user
		if(is_local_player)then
			local xtoset,ytoset = vint_get_property( row_parent_handle, "anchor" )
			vint_set_property( vint_object_find( "mp_sb_user_highlight" ),"anchor", xtoset, ytoset )
			vint_set_property( vint_object_find( "mp_sb_user_highlight" ),"visible", true )
		end

		if( is_active == true )then
			vint_set_property( row_parent_handle, "alpha", 1.0 )
		else
			vint_set_property( row_parent_handle, "alpha", 0.20 )
		end

		--hide/show the right dags	
		if( vint_mod( row_index, 2 ) == 1 )then
			vint_set_property( vint_object_find( "player_bg_dags", row_parent_handle ), "visible", true )
		else
			vint_set_property( vint_object_find( "player_bg_dags", row_parent_handle ), "visible", false )
		end

		--highlight the highlighted user
		if( is_selected )then
			local xtoset,ytoset = vint_get_property( row_parent_handle, "anchor" )
			vint_set_property( vint_object_find( "scoreboard_highlight_main" ),"anchor", xtoset, ytoset )
			--vint_set_property( row_value1_handle,"tint", BLACK.R,BLACK.G,BLACK.B )
			vint_set_property( row_value2_handle,"tint", BLACK.R,BLACK.G,BLACK.B )
			vint_set_property( row_value3_handle,"tint", BLACK.R,BLACK.G,BLACK.B )
			vint_set_property( row_value4_handle,"tint", BLACK.R,BLACK.G,BLACK.B )
			vint_set_property( row_value5_handle,"tint", BLACK.R,BLACK.G,BLACK.B )
			vint_set_property( vint_object_find( "player_bg_dags", row_parent_handle ),"visible", false )
			vint_set_property( row_parent_handle, "alpha", 1.0 )
			vint_set_property( row_parent_handle, "depth", SB_SELECTED_DEPTH )
		else
			--vint_set_property( row_value1_handle,"tint", ORANGE.R,ORANGE.G,ORANGE.B )
			vint_set_property( row_value2_handle,"tint", ORANGE.R,ORANGE.G,ORANGE.B )
			vint_set_property( row_value3_handle,"tint", ORANGE.R,ORANGE.G,ORANGE.B )
			vint_set_property( row_value4_handle,"tint", ORANGE.R,ORANGE.G,ORANGE.B )
			vint_set_property( row_value5_handle,"tint", ORANGE.R,ORANGE.G,ORANGE.B )
			vint_set_property( row_parent_handle, "depth", SB_UNSELECTED_DEPTH )
		end
	end
end

-- ##############################################################
function add_row_team1(data_item_handle)
	
	local prev = row_team1_total
	local new_cnt = row_team1_total + 1
	
	local row_parent_handle = vint_object_find( "scoreboard_t1_row" )
	
	if(prev == 0)then
		row_team1_group_handle[new_cnt] = row_parent_handle
	else
		-- k, clone the row group

		row_team1_group_handle[new_cnt] = vint_object_clone_rename(row_parent_handle, "scoreboard_t1_row"..new_cnt )
		
		-- k, setup the positions - get the previous item's position
		local anchor_x, anchor_y
		local new_y
		if ( prev ~= 0 ) then
			anchor_x, anchor_y = vint_get_property( row_team1_group_handle[prev], "anchor" )
	
			--local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "mp_sb_screen_group"),"scale")
			new_y = anchor_y + row_t1_group_size[2]
			vint_set_property( row_team1_group_handle[new_cnt], "anchor", anchor_x, new_y )
		end
	end

	--set the dag visibility
	if( vint_mod( new_cnt, 2 ) == 1 )then
		vint_set_property( vint_object_find( "player_bg_dags", row_team1_group_handle[new_cnt] ), "visible", true )
	else
		vint_set_property( vint_object_find( "player_bg_dags", row_team1_group_handle[new_cnt] ), "visible", false )
	end
	
	-- make visible
	vint_set_property( row_team1_group_handle[new_cnt], "visible", true )
		
	-- keep track of the data item handle
	row_team1_data_item_handle[new_cnt] = data_item_handle

	-- bump cnt
	row_team1_total = new_cnt
	set_scoreboard_size()

	return new_cnt
end

-- ##############################################################
function add_row_team2(data_item_handle)
	
	local prev = row_team2_total
	local new_cnt = row_team2_total + 1
	
	local row_parent_handle = vint_object_find( "scoreboard_t2_row" )
	
	if(prev == 0)then
		row_team2_group_handle[new_cnt] = row_parent_handle
	else
		-- k, clone the row group

		row_team2_group_handle[new_cnt] = vint_object_clone_rename(row_parent_handle, "scoreboard_t2_row"..new_cnt )
		
		-- k, setup the positions - get the previous item's position
		local anchor_x, anchor_y
		local new_y
		if ( prev ~= 0 ) then
			anchor_x, anchor_y = vint_get_property( row_team2_group_handle[prev], "anchor" )

			new_y = anchor_y + row_t2_group_size[2]
			vint_set_property( row_team2_group_handle[new_cnt], "anchor", anchor_x, new_y )
		end

	end
	
	--set the dag visibility
	if( vint_mod( new_cnt, 2 ) == 1 )then
		vint_set_property( vint_object_find( "player_bg_dags", row_team2_group_handle[new_cnt] ), "visible", true )
	else
		vint_set_property( vint_object_find( "player_bg_dags", row_team2_group_handle[new_cnt] ), "visible", false )
	end

	-- make visible
	vint_set_property( row_team2_group_handle[new_cnt], "visible", true )
		
	-- keep track of the data item handle
	row_team2_data_item_handle[new_cnt] = data_item_handle

	-- bump cnt
	row_team2_total = new_cnt
	set_scoreboard_size()

	return new_cnt
end

-- ##############################################################
function remove_row(data_item_handle, event_name)

	local row_team = 1
	for i=1, row_team2_total do
		if(data_item_handle == row_team2_data_item_handle[i])then
			row_team = 2
			--quit the loop
			i = row_team2_total
		end
	end
	-- k, simply delete the last one
	if(row_team == 1)then
		row_team1_data_item_handle[row_team1_total] = 0
		local new_cnt = row_team1_total - 1
		if(new_cnt ~= 0)then
			-- now delete this item!
			vint_object_destroy(row_team1_group_handle[row_team1_total])
		end
		row_team1_group_handle[row_team1_total] = 0
		row_team1_total = new_cnt
	else
		row_team2_data_item_handle[row_team2_total] = 0
		local new_cnt = row_team2_total - 1
		if(new_cnt ~= 0)then
			-- now delete this item!
			vint_object_destroy(row_team2_group_handle[row_team2_total])
		end
		row_team2_group_handle[row_team2_total] = 0
		row_team2_total = new_cnt
	end
	set_scoreboard_size()
end

function set_scoreboard_size()
	local top_handle = vint_object_find( "top_half_main" )
	local bott_handle = vint_object_find( "bottom_half_main" )
	local running_total
	local parent_scale_x,parent_scale_y = vint_get_property(vint_object_find("mp_sb_screen_group"),"scale")
	if(row_team1_total > row_team2_total)then
		running_total = row_team1_total
	else
		running_total = row_team2_total
	end
	--running_total = 15
	local bg1_x,bg1_y = vint_get_property( top_handle, "anchor" )
	local bg2_x,bg2_y = vint_get_property( bott_handle, "anchor" )

	local adjusted_y = bg1_y + ( running_total * row_t1_group_size[2] )
	
	debug_print("vint","adjusted_y1 = "..adjusted_y.."\n")
	
	local min_y = 60
	local max_y = 295
	if( adjusted_y < min_y )then
		adjusted_y = min_y
	end
	if(adjusted_y > max_y)then
		adjusted_y = max_y
	end

	vint_set_property( bott_handle, "anchor", bg2_x, adjusted_y )

	debug_print("vint","adjusted_y2 = "..adjusted_y.."\n")
	debug_print("vint","running_total = "..running_total.."\n")
	debug_print("vint","row_t1_group_size[2] = "..row_t1_group_size[2].."\n")
	debug_print("vint","parent_scale_y = "..parent_scale_y.."\n")

end

-- ##############################################################
function sb_set_text_width( text_handle, max_width )
	--resize the text if it is too big
	--get the scale
	local text_scale_x,text_scale_y = vint_get_property( text_handle, "text_scale" )
	local parent_scalex,parent_scaley = vint_get_property( vint_object_find( "mp_sb_screen_group" ), "scale" )

	local text_width,text_height = vint_get_property( text_handle, "screen_size" )
	local text_max_width = max_width * parent_scalex
	local new_scale = text_max_width/text_width * text_scale_x
	--make the text fit
	if( text_width > text_max_width )then
		vint_set_property( text_handle, "text_scale", new_scale, text_scale_y )
	else
		vint_set_property( text_handle, "text_scale",text_scale_x,text_scale_y )
	end
end
