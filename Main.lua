-- Frans L 2015

-- initialize variables and start the game
function OnGameSetupINI()

	g_modID = "d59eed8df4f04bcebda26f0f1f4ee02b"

	-- map analyse
	g_victoryTerritorys = {} -- sector id
	g_victoryTerritoryAmount = 0
	g_dropzoneIDLastTime = nil
	g_dropzoneIDAmount = 0
	g_tAmount = 0 --territory
	g_hqAmount = 0 --headquarter
	
	-- player analyse
	g_aiPlayers = {} --playerAT
	g_aiPlayerAmount = 0
	--g_aiZoneImportance = 30
	g_popCap = 100 + g_popCapBonus
	g_aiBonusM = 100 + g_aiBonusMExtra
	g_aiBonusMStart = 150
	
	--team analyse
	g_team1 = nil
	g_team2 = nil
	g_team1Player = nil
	g_team2Player = nil
	
	--rng GOD
	g_luckBonusBorderMin = 25 --75
	g_luckBonusMultiplier = 0.03 --0.05
	g_luckBonusOddsMax = 12 -- 12
	g_luckBonusMultplierWorld = 1.09
	
	-- wasted entitys
	g_destroyInterval = 15
	g_entityDestroyTimeMax = 115
	g_entityDestroyTimeMin = 95
	g_toDestroy = {} -- --> {entity, delay}
	
	-- timeline
	g_chapter = 0
	g_sleepTimeLine = 0
	g_introTime = 10
	g_abilityTime = 80 + g_abilityBonusTime -- 85
	g_findingDropZoneTimeMin = 50 - math.ceil(World_GetPlayerCount()*1.5) + g_findingDropZoneBonusTime --45
	g_findingDropZoneTimeMax = 65 - math.ceil(World_GetPlayerCount()*1.5) + g_findingDropZoneBonusTime --65
	g_alarmTimer = 45 + g_alarmBonusTime --45
	g_findingDropZoneTime = 0 --current
	
	
	-- doParadrops
	g_dropZoneAmount = 0
	g_dropZoneInterval = 6 + g_dropZoneIntervalBonusTime
	g_paradropCAmount = 0 -- current
	g_paradropCAmountOpen = 0 --opened
	g_paradropMAmount = 3 -- times per dropzone
	g_paradropPlayerAT = nil
	g_paradropZoneID = nil
	g_paradropZoneEntity = nil
	
	-- objective
	g_objectiveBasic = {}
	g_objectivePingAmount = 1
	g_objectivePingID = {}
	
	-- texts
	g_introHead = Util_CreateLocString("DropZone" .. g_introHeadBonus)
	g_introText1 = Util_CreateLocString("Dropzone will be selected soon. Secure the zone")
	g_introText2 = Util_CreateLocString("and enjoy paradrops. Good luck! -Frans L") --Util_CreateLocString("Secure the zone and enjoy paradrops. - Frans L")
	g_selectedText = Util_CreateLocString("DropZone is located!")
	
	
	-- roman numbers
	g_Roman_numbers = {1, 5, 10, 50, 100, 500, 1000}
	g_Roman_chars = {"I", "V", "X", "L", "C", "D", "M" }
	
	
	-- icons
	g_iconRadio = "Icons_portraits_radio_post"
	
	-- extra abilities
	g_ability = {
		{blue = BP_GetAbilityBlueprint(g_modID .. ":" .. "officer_smoke_dz"), blueAI = BP_GetAbilityBlueprint(g_modID .. ":" .. "officer_smoke_dz")},
		{blue = BP_GetAbilityBlueprint(g_modID .. ":" .. "fear_propaganda_dz"), blueAI = BP_GetAbilityBlueprint(g_modID .. ":" .. "fear_propaganda_dz")},
		{blue = BP_GetAbilityBlueprint(g_modID .. ":" .. "coordinated_barrage_dz"), blueAI = BP_GetAbilityBlueprint(g_modID .. ":" .. "coordinated_barrage_dz")}
	}
	
	-- loot
	g_loot = { 
		{ -- 1 = pick
			{ -- 1 = equipment
				{blue = BP_GetEntityBlueprint(g_modID .. ":" .. "minesweeper"), critical = -1 },
				{blue = BP_GetEntityBlueprint(g_modID .. ":" .. "wirecutter"), critical = -1 },
				{blue = BP_GetEntityBlueprint(g_modID .. ":" .. "binocular"), critical = -1},
			}, 
			{ -- 2 = mediumpower
				{blue = BP_GetEntityBlueprint(g_modID .. ":" .. "ppsh"), critical = -1},
				{blue = BP_GetEntityBlueprint("flamethrower_roks3_mp"), critical = -1},
				{blue = BP_GetEntityBlueprint("soviet_guard_ptrs_mp"), critical = -1},
			},
			{ -- 3 = highpower
				{blue = BP_GetEntityBlueprint("axis_mg42_mp"), critical =-1 },
				{blue = BP_GetEntityBlueprint("west_german_lmg_mg34"), critical = -1},
				{blue = BP_GetEntityBlueprint("aef_m1919a6_lmg_mp"), critical = -1},
				{blue = BP_GetEntityBlueprint("aef_rifle_m1918a2_browning"), critical = -1},
			},
			{ -- 4 = antitank
				{blue = BP_GetEntityBlueprint("aef_bazooka_item_mp"), critical = -1},
				{blue = BP_GetEntityBlueprint("axis_panzerschreck_item_mp"), critical = -1},
				{blue = BP_GetEntityBlueprint("dp28_lmg_item"), critical = -1},
			},
		},
		{ -- 2 = team
			{ -- 1 = mortar
				{blue = BP_GetEntityBlueprint("m1_75mm_pack_howitzer_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("granatewerfer_34_81mm_mortar_mp"), critical = 0},
				{blue = BP_GetEntityBlueprint("pm41_82mm_mortar_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("le_ig_18_inf_support_gun_mp"), critical = 0 },
				
			},
			{ -- 2 = machinegun
				{blue = BP_GetEntityBlueprint("m1910_maxim_heavy_machine_gun_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("dhsk_38_machine_gun_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("mg42_hmg_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("kubelwagen_type_82_mp"), critical = 30 },
			},
			{ -- 3 = antitank
				{blue = BP_GetEntityBlueprint("raketenwerfer43_88mm_puppchen_antitank_gun_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("m1937_53-k_45mm_at_gun_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("m1942_76mm_divisional_gun_zis-3_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("pak40_75mm_at_gun_mp"), critical = 0 },
				{blue = BP_GetEntityBlueprint("m1_57mm_antitank_gun_mp"), critical = 0 },
			},
		},
		{ -- 3 = vehicle
			{ -- 1 = light
				{blue = BP_GetEntityBlueprint("halftrack_sdkfz_251_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("mortar_light_halftrack_250_7_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("armored_car_sdkfz_222_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("m20_utility_car_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("dodge_wc51_50cal_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("halftrack_sdkfz_251_20_ir_searchlight_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("m3a1_scout_car_mp"), critical = 40 },
				{blue = BP_GetEntityBlueprint("m8_greyhound_mp"), critical = 40 },
				
			},
			{ -- 2 = medium light
				{blue = BP_GetEntityBlueprint("halftrack_sdkfz_251_17_flak_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("jagdpanzer_iv_sdkfz_162_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("puma_sdkfz_234_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("panzer_ii_luchs_sdkfz_123_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("puma_sdkfz_234_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("su_76m_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("m5_halftrack_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("stug_iii_e_sdkfz_141_1_commander_mp"), critical = 50 },
				{blue = BP_GetEntityBlueprint("m5a1_stuart_mp"), critical = 50 },
			},
			{ -- 3 = normal (not heavy)
				{blue = BP_GetEntityBlueprint("m36_tank_destroyer_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("m4a3e8_sherman_easy_8_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("kv-8_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("sherman_soviet"), critical = 60 },
				{blue = BP_GetEntityBlueprint("ostwind_flak_panzer_west_german_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("panzer_iv_sdkfz_ausf_j_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("panzer_iv_commander_sdkfz_161_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("panzer_iv_sdkfz_161_mp"), critical = 60 },
				{blue = BP_GetEntityBlueprint("su_85_mp"), critical = 60 },
			},
		},
		{ -- 4 = heavy vehicle
			{ -- 1 = artillery
				{blue = BP_GetEntityBlueprint("katyusha_bm-13n_mp"), critical = 70 },
				{blue = BP_GetEntityBlueprint("halftrack_sdkfz_251_wurfrahmen_40_mp"), critical = 70 },
				{blue = BP_GetEntityBlueprint("panzerwerfer_sdkfz_4_1_mp"), critical = 70 },
				{blue = BP_GetEntityBlueprint("m7b1_priest_mp"), critical = 70 },
			},
			{ -- 2 = heavy
				{blue = BP_GetEntityBlueprint("brummbar_sturmpanzer_iv_sdkfz_166_mp"), critical = 100 },
				{blue = BP_GetEntityBlueprint("panther_sdkfz_171_mp"), critical = 100 },
				{blue = BP_GetEntityBlueprint("panther_sdkfz_171_commander_mp"), critical = 100 },
				{blue = BP_GetEntityBlueprint("panther_sdkfz_171_ausf_g_mp"), critical = 100 },
			},
			{ -- 3 = biggest
				{blue = BP_GetEntityBlueprint("sturmtiger_606_38cm_rw_61_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("jagdtiger_sdkfz_186_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("isu_152_spg_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("is-2_heavy_tank_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("king_tiger_sdkfz_182_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("tiger_ace_sdkfz_181_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("tiger_sdkfz_181_mp"), critical = 140 },
				{blue = BP_GetEntityBlueprint("elefant_sdkfz_184_mp"), critical = 140 },
			},
		},
	}
	
	g_lootPlane = { 
		basic = BP_GetAbilityBlueprint(g_modID .. ":" .. "paradrop_basic_1")
	}
	g_flashing = {} --flashed things
	
	--attribute function
	g_HighlightID = BP_GetAbilityBlueprint(g_modID .. ":" .. "sector_highlight")
	g_abilityCuttingA = BP_GetAbilityBlueprint(g_modID .. ":" .. "soviet_barbed_wire_cutting_ability_mp_1")
	
	
	--g_entFlame = BP_GetEntityBlueprint("hm-120_38_mortar_mp")
	--g_entFlame = BP_GetEntityBlueprint("axis_flamethrower_item_mp")
	g_entFlame = BP_GetEntityBlueprint("katyusha_bm-13n_mp")
	
	-- vp victory to impossible
	if g_modeAnnihilation == true then
		WinWarning_SetMaxTickers(90001,90001)
	end
	
	analyseMap() --find the dropzone areas
	analysePlayers() --find bots
	analyseTeams()
	installObjectives() --loads the objective
	Rule_AddInterval(destroyDropEntitys,g_destroyInterval) --updates destroy entities
	Rule_AddOneShot(timelineHandle,3) --main function 

end



--MAIN FUNCTION
function timelineHandle()
	Rule_RemoveMe()
	
	-- introduction
	if (g_chapter == 0) then
		Game_SubTextFade(g_introHead, g_introText1, g_introText2, 1.0, g_introTime, 1.0)
		g_sleepTimeLine = g_abilityTime
		
		if g_modeAnnihilation == true then
			VPTicker_SetTeamTickers(0, 90000, true)
			VPTicker_SetTeamTickers(1, 90000, true)
		end
			
	--give abilities
	elseif (g_chapter == 1) then
		giveAbilities()
		unlockAbilities() 
		UI_Notification2("New abilities unlocked. Use them wisely!",g_iconRadio)
		flashAbilities()
		Rule_AddOneShot(unFlashAbilities,1)
		
		local i = World_GetRand(g_findingDropZoneTimeMin, g_findingDropZoneTimeMax)
		g_sleepTimeLine = i
		g_chapter = 9
		giveAIBonus(g_aiBonusMStart) --ai needs help
		
	-- dropzone warning time
	elseif (g_chapter == 10 ) then
		
		-- select the zone
		local zone = nextDropzone()
		g_paradropZoneID = zone.id
		g_paradropZoneEntity = zone.entity
		
		--setAIImportanceBonus(g_paradropZoneEntity)
	
		Objective_Show(g_objectiveBasic, true)
		Objective_Start(g_objectiveBasic, false, false)
		doParadropObjectiveTimer(g_alarmTimer)
		g_objectivePingID[g_objectivePingAmount] = Objective_AddPing(g_objectiveBasic,World_GetTerritorySectorPosition(g_paradropZoneID))
		Util_MissionTitle(g_selectedText, 0.2, 5, 0.2)
		g_sleepTimeLine = g_alarmTimer
		giveAIBonus() --ai needs help
			
	-- dropzone begins
	elseif (g_chapter == 11) then
		--Objective_Show(g_objectiveBasic, false)
		g_sleepTimeLine = g_dropZoneInterval*(g_paradropMAmount+1)
		Rule_AddOneShot(dropzoneHandle, 1)
		
	-- dropzone ends
	elseif (g_chapter == 12) then
		Objective_Show(g_objectiveBasic, false)
		Objective_TogglePings(g_objectiveBasic, false)
		Objective_RemovePing(g_objectiveBasic,g_objectivePingID[g_objectivePingAmount])
		--Objective_Complete(g_objectiveBasic, false, false)
		
		--setAIImportanceBonus(g_paradropZoneEntity, false)
		
		analysePlayers() -- checks if someone have left
		
		local i = World_GetRand(g_findingDropZoneTimeMin, g_findingDropZoneTimeMax)
		g_sleepTimeLine = i
		g_chapter = 9
	end
	
	g_chapter = g_chapter + 1
	if (g_sleepTimeLine ~= -1) then
		Rule_AddOneShot(timelineHandle, g_sleepTimeLine)
	end
end


--choose the best place for Dropzone
--handles the RNG GOD
function nextDropzone()
	local score1 = World_GetTeamVictoryTicker(g_team1)
	local score2 = World_GetTeamVictoryTicker(g_team2)
	local diffScore = math.abs(score1-score2)
	local zone = Table_RandomItem(g_victoryTerritorys)
	
	-- rng god will give advances for losing player
	if g_modeAnnihilation == false and diffScore > g_luckBonusBorderMin then
		
		local team = {}
		for i = 1, 3 do --team1, team2, world
			team[i].Territory = {}
			team[i].Amount = 0
		end
		
		-- gather data
		for i = 1, g_victoryTerritoryAmount do
			if World_IsTerritorySectorOwnedByPlayer(team1Player, g_victoryTerritorys[i].id) then
				team[1].Amount = team[1].Amount +1
				team[1].Territory[team[1].Amount].id = g_victoryTerritorys[i].id
				team[1].Territory[team[1].Amount].entity = g_victoryTerritorys[i].entity
			elseif World_IsTerritorySectorOwnedByPlayer(team2Player, g_victoryTerritorys[i].id)then
				team[2].Amount = team[2].Amount +1
				team[2].Territory[team[2].Amount].id = g_victoryTerritorys[i].id
				team[2].Territory[team[2].Amount].entity = g_victoryTerritorys[i].entity
			else
				team[3].Amount = team[3].Amount +1
				team[3].Territory[team[3].Amount].id = g_victoryTerritorys[i].id
				team[3].Territory[team[3].Amount].entity = g_victoryTerritorys[i].entity
			end
		end
		
		local sTeam --selected team
		if (score1 > score2) then 
			sTeam = 2 else sTeam = 1
		end
		
		local rand = World_GetRand(1,99)
		local odds = 33 + math.min(((diffScore - g_luckBonusBorderMin)*g_luckBonusMultiplier),g_luckBonusOddsMax)
		
		-- if the losing player doesn't own anything
		if (team[sTeam].Amount == 0) then
			sTeam = 3
			odds = odds*g_luckBonusMultplierWorld
		end 
		
		local found = false
		
		-- if there is zone
		if team[sTeam].Amount > 0 and team[sTeam].Amount < 3 then
			for i = 1, team[sTeam].Amount do
				if (rand <= i*odds) then
					zone = team[sTeam].Territory[i]
					found = true
					break
				end
			end
		end
		
	end
	
	-- try avoid same dropzone in a row
	if g_dropzoneIDLastTime == zone.id then
		g_dropzoneIDAmount = g_dropzoneIDAmount + 1	
		if g_dropzoneIDAmount >= 2 then
			zone = Table_RandomItem(g_victoryTerritorys)
		end
	else
		g_dropzoneIDAmount = 0
		g_dropzoneIDLastTime = zone.id
	end
	
	return zone
end

-- give AI more resources
function giveAIBonus(bonus)
	if bonus == nil then
		bonus = g_aiBonusM
	end
	if g_aiPlayerAmount > 0 then
		for i = 1, g_aiPlayerAmount do
			Player_AddResource(g_aiPlayers[i],RT_Manpower,bonus)
		end
	end 
end

--[[
function setAIImportanceBonus(entity, add)
	if entity == nil then
		entity = g_paradropZoneEntity
	end
	if add == nil then
		add = true
	end
	
	if g_aiPlayerAmount > 0 then
		if add == true then	-- add
			for i = 1, g_aiPlayerAmount do
				AI_SetCaptureImportanceBonus(g_aiPlayers[i], entity, g_aiZoneImportance)
			end
		else --remove
			for i = 1, g_aiPlayerAmount do
				AI_ClearCaptureImportanceBonus(g_aiPlayers[i], entity)
			end
		end
	end
end
--]]

--When paradrops starts
function dropzoneHandle()
	Rule_RemoveMe()
	--local zoneID = Table_RandomItem(g_victoryTerritorys)
	--g_paradropZoneID = zoneID
	local playerAT = whoseTerritory(g_paradropZoneID)
	g_paradropPlayerAT = playerAT
	
	doParadrop()
	doParadropObjectiveTimer()
	Rule_AddDelayedIntervalEx(doParadropObjectiveTimer,0,g_dropZoneInterval,g_paradropMAmount-2)
	Rule_AddDelayedIntervalEx(doParadrop,0,g_dropZoneInterval,g_paradropMAmount-1)
	
	if g_paradropCAmount < 1*3 then -- 6 --6
		g_paradropMAmount = 3 
	elseif g_paradropCAmount < 1*3 + 4*4 then -- 22 -- 22
		g_paradropMAmount = 4
	elseif g_paradropCAmount < 1*3 + 4*4 + 4*5 then -- 42 -- 37
		g_paradropMAmount = 5
	elseif g_paradropCAmount < 1*3 + 4*4 + 4*5 + 4*6 then --60 -- 54
		g_paradropMAmount = 6 
	elseif g_paradropCAmount < 1*3 + 4*4 + 4*5 + 4*6 + 3*7 then -- 81 -- 72
		g_paradropMAmount = 7
	else
		g_paradropMAmount = 8
	end
	
end

-- ObjectiveTimer that handles the drop mission
function doParadropObjectiveTimer(atime)
	if (atime == nil) then
		atime = g_dropZoneInterval
	end
	g_paradropCAmount = g_paradropCAmount + 1
	local text = Util_CreateLocString("Paradrop " .. ToRomanNumerals(g_paradropCAmount) .. " is arriving!")
	Objective_UpdateText(g_objectiveBasic, text, nil, false)
	Objective_StartTimer(g_objectiveBasic, COUNT_DOWN, atime, 10)
end

-- decide which loot is the paradrop
function getLoot(a)
	if (a == nil) then
		a = g_paradropCAmountOpen
	end
	
	local loot = nil
	
	if a <= 10 then
		if a == 1 then
			loot = Table_RandomItem(g_loot[1][1]) --equipment
		elseif a == 2 then
			loot = Table_RandomItem(g_loot[1][1]) --equipment
		elseif a == 3 then
			loot = Table_RandomItem(g_loot[1][2]) --small arms --> 1
		elseif a == 4 then
			loot = Table_RandomItem(g_loot[1][2]) --small arms
		elseif a == 5 then
			loot = Table_RandomItem(g_loot[2][2]) --machinegun
		elseif a == 6 then
			loot = Table_RandomItem(g_loot[1][1]) --equipment
		elseif a == 7 then
			loot = Table_RandomItem(g_loot[2][1]) --mortar --> 2
		elseif a == 8 then
			loot = Table_RandomItem(g_loot[1][3]) --heavy arms
		elseif a == 9 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 10 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon --> 2
		end
	elseif a <= 20 then
		if a == 11 then
			loot = Table_RandomItem(g_loot[3][1]) --licht vehicle
		elseif a == 12 then
			loot = Table_RandomItem(g_loot[1][4]) --pick at
		elseif a == 13 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 14 then
			loot = Table_RandomItem(g_loot[2][2]) --machinegun
		elseif a == 15 then
			loot = Table_RandomItem(g_loot[3][1]) --licht vehicle
		elseif a == 16 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 17 then
			loot = Table_RandomItem(g_loot[1][3]) --heavy arms
		elseif a == 18 then
			loot = Table_RandomItem(g_loot[3][2]) --medium vehicle
		elseif a == 19 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 20 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		end
	elseif a <= 30 then
		if a == 21 then
			loot = Table_RandomItem(g_loot[2][1]) --mortar
		elseif a == 22 then
			loot = Table_RandomItem(g_loot[1][3]) --heavy arms
		elseif a == 23 then
			loot = Table_RandomItem(g_loot[3][2]) --medium vehicle
		elseif a == 24 then
			loot = Table_RandomItem(g_loot[1][4]) --pick at
		elseif a == 25 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 26 then
			loot = Table_RandomItem(g_loot[3][2]) --medium vehicle
		elseif a == 27 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 28 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 29 then
			loot = Table_RandomItem(g_loot[3][1]) --licht vehicle
		elseif a == 30 then
			loot = Table_RandomItem(g_loot[3][3]) --normal vehicle
		end
	elseif a <= 40 then
		if a == 31 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 32 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 33 then
			loot = Table_RandomItem(g_loot[3][2]) --medium vehicle
		elseif a == 34 then
			loot = Table_RandomItem(g_loot[1][4]) --pick at
		elseif a == 35 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 36 then
			loot = Table_RandomItem(g_loot[2][1]) --mortar
		elseif a == 37 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 38 then
			loot = Table_RandomItem(g_loot[3][3]) --normal vehicle
		elseif a == 39 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 40 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		end
	elseif a <= 50 then
		if a == 41 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 42 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 43 then
			loot = Table_RandomItem(g_loot[4][1]) --artillery
		elseif a == 44 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[3])) --vehicle
		elseif a == 45 then
			loot = Table_RandomItem(g_loot[1][4]) --pick at
		elseif a == 46 then
			loot = Table_RandomItem(g_loot[2][1]) --mortar
		elseif a == 47 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 48 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 49 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 50 then
			loot = Table_RandomItem(g_loot[4][2]) --heavy
		end
	elseif a <= 60 then
		if a == 51 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 52 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 53 then
			loot = Table_RandomItem(g_loot[4][1]) --artillery
		elseif a == 54 then
			loot = Table_RandomItem(g_loot[3][3]) --normal vehicle
		elseif a == 55 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 56 then
			loot = Table_RandomItem(g_loot[3][1]) --light vehicle
		elseif a == 57 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 58 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 59 then
			loot = Table_RandomItem(g_loot[4][2]) --heavy
		elseif a == 60 then
			loot = Table_RandomItem(Table_RandomItem(Table_RandomItem(g_loot))) --anything
		end
	elseif a <= 70 then
		if a == 61 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 62 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 63 then
			loot = Table_RandomItem(g_loot[3][3]) --normal vehicle
		elseif a == 64 then
			loot = Table_RandomItem(g_loot[4][1]) --artillery
		elseif a == 65 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
		elseif a == 66 then
			loot = Table_RandomItem(g_loot[3][2]) --medium vehicle
		elseif a == 67 then
			loot = Table_RandomItem(g_loot[4][2]) --heavy
		elseif a == 68 then
			loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
		elseif a == 69 then
			loot = Table_RandomItem(g_loot[2][3]) --team at
		elseif a == 70 then
			loot = Table_RandomItem(g_loot[4][2]) --super heavy
		end
	else -- > 70
		local b = World_GetRand(1,100) + a-70
		if b < 65 then -- > 65% at the start
			if World_GetRand(1,2) == 1 then
				loot = Table_RandomItem(Table_RandomItem(g_loot[2])) --team weapon
			else
				loot = Table_RandomItem(Table_RandomItem(g_loot[1])) --pick
			end
		elseif b < 95 then -- > 30% at the start
			if World_GetRand(1,2) == 1 then
				loot = Table_RandomItem(g_loot[3][3]) --normal vehicle
			else
				loot = Table_RandomItem(Table_RandomItem(g_loot[3])) --vehicle
			end
		else --> 5% at the start
			loot = Table_RandomItem(Table_RandomItem(Table_RandomItem(g_loot))) --anything
		end
	end
	
	
	return loot
	
end


--  start the dropping proccess
function doParadrop()
	local zoneID = g_paradropZoneID
	local playerAT = g_paradropPlayerAT
	
	local posOrg = World_GetTerritorySectorPosition(zoneID)
	local pos =  Prox_GetRandomPosition(posOrg,14,1)
	
	local plane = g_lootPlane.basic
	
	Player_AddAbility(playerAT, plane)
	Player_SetAbilityAvailability(playerAT,plane,ITEM_REMOVED)
	Command_PlayerPosDirAbility(playerAT, playerAT, pos, posOrg, plane, true)
	
	--Player_AddAbility(playerAT, g_HighlightID)
	--Player_SetAbilityAvailability(playerAT,g_HighlightID,ITEM_REMOVED)
	--Command_PlayerPosAbility(playerAT, playerAT, pos, g_HighlightID, true)
end

-- initialize objective
function installObjectives()
    g_objectiveBasic = {
		
		IsComplete = function()
            return false
        end,
		
        SetupUI = function() end,
        OnStart = function() end,
        OnComplete = function() end,
        OnFail = function() end,
		
        Intel_Start = nil, Intel_Complete = nil, Intel_Fail = nil, TitleEnd = nil, TitleFail = nil,
        Title = Util_CreateLocString("Paradrop"),
        Type = OT_Primary,
    }
    
    Objective_Register(g_objectiveBasic)
	
	Objective_TogglePings(g_objectiveBasic, true)
end

-- destroy old equipment if not used
function destroyDropEntitys()
	for key, i in ipairs(g_toDestroy) do
		i.delay = i.delay - g_destroyInterval
		if i.delay <= 0 then
			if (Entity_IsValid(i.id) == true) then
				if (World_OwnsEntity(i.entity) == true)	then
					if (i.dType == 1) then --disappear
						Entity_Destroy(i.entity)
					elseif (i.dType == 2) then --disappear
						Entity_Destroy(i.entity)
					elseif (i.dType == 3) then --disappear
						Entity_Destroy(i.entity)
						--Entity_ApplyCritical(i.entity,BP_GetCriticalBlueprint("vehicle_destroy_brew_up"),1)
					end
				end
			end
			table.remove(g_toDestroy,key)
		end 
	end
	
end


-- spawns small entity (attribute)
function paradropSpawnEntitySmall(player, target)
	g_paradropCAmountOpen = g_paradropCAmountOpen + 1
	
	local pos = Entity_GetPosition(target)
	local weaponTable = getLoot()
	local critical = weaponTable.critical
	local weapon = Entity_CreateENV(weaponTable.blue, pos, pos)
	
	local halfCritical = math.floor(critical/2)
	local destroyType = 1
	
	if (critical ~= -1) then
		destroyType = 2
		
		-- remove health
		local health = World_GetRand(20,(100-halfCritical))/100.0
		Entity_SetHealth(weapon,health)
		
		--if vehicle
		if (critical > 0) then
			destroyType = 3
			
			local group = EGroup_CreateIfNotFound("abandonStuff")
			EGroup_Clear (group)
			
			EGroup_Add(group, weapon)
			Entity_ApplyCritical(weapon,BP_GetCriticalBlueprint("vehicle_abandon"),1)
			--Command_PlayerEntityCriticalHit(World_GetPlayerAt(1), group, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_abandon"), 1, false)
		
			local i = World_GetRand(1,100)
			if i <= critical then --engine
				Entity_ApplyCritical(weapon,BP_GetCriticalBlueprint("vehicle_destroy_engine"),1)
				--Command_PlayerEntityCriticalHit(World_GetPlayerAt(1), group, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_destroy_engine"), 1, false)
			elseif i >= (100 - halfCritical) then --gun
				Entity_ApplyCritical(weapon,BP_GetCriticalBlueprint("vehicle_destroy_maingun"),1)
				--Command_PlayerEntityCriticalHit(World_GetPlayerAt(1), group, PCMD_CriticalHit, BP_GetCriticalBlueprint("vehicle_destroy_maingun"), 1, false)
			end
		end
	end
	
	local i = World_GetRand(g_entityDestroyTimeMin,g_entityDestroyTimeMax)
	
	--lifespan if not captured
	table.insert(g_toDestroy,
		{entity = weapon, delay = i, dType = destroyType, id = Entity_GetGameID(weapon)}
	)
end


--adds minesweeper to attribute
function addMinesweeperFunction(player, squad)
	Squad_AddAbility(squad,g_abilityCuttingA)
end

-- returns who own area... if no one's -> random
function whoseTerritory(id)
	local players = {}
	local amount = 0
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if (World_IsTerritorySectorOwnedByPlayer(player, id) == true) then
			amount = amount + 1
			players[amount] = player
		end
	end
	
	if amount > 0 then
		return Table_GetRandomItem(players)
	else
		return World_GetPlayerAt(World_GetRand(1,World_GetPlayerCount()))
	end
end


-- white text in the middle screen
function UI_Message2(text) 
	local text = Util_CreateLocString(text)
	UI_SystemMessageShow(text)
end

function UI_Notification2(text, icon) 
	local text = Util_CreateLocString(text)
	UI_CreateEventCueClickable(icon, "", text, text, print, 15, false)
end


-- give players new abilities
function giveAbilities()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		for key, a in ipairs(g_ability) do
			if AI_IsAIPlayer(player) == false then
				Player_AddAbility(player, a.blue)
				Player_SetAbilityAvailability(player,a.blue,ITEM_LOCKED)
			else
				Player_AddAbility(player, a.blueAI)
				Player_SetAbilityAvailability(player,a.blueAI,ITEM_LOCKED)
			end
		end
	end
end

-- let players use their abilities
function unlockAbilities()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		for key, a in ipairs(g_ability) do
			if AI_IsAIPlayer(player) == false then
				Player_SetAbilityAvailability(player,a.blue,ITEM_UNLOCKED)
			else
				Player_SetAbilityAvailability(player,a.blueAI,ITEM_UNLOCKED)
			end
		end
	end
end


function flashAbilities()
	for key, a in ipairs(g_ability) do 
		local id = UI_FlashAbilityButton(a.blue,true)
		table.insert(g_flashing, {flashID = id})
	end
end


function unFlashAbilities()
	for key, a in ipairs(g_flashing) do 
		UI_StopFlashing(a.flashID)
		--table.remove(g_flashing,key)
	end
end

-- check who is bot and etc
function analyseTeams()
	g_team1 = Player_GetTeam(World_GetPlayerAt(1))
	g_team2 = Team_GetEnemyTeam(team1)
	
	g_team1Player = World_GetPlayerAt(1)
	-- finding team2 example player
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_GetTeam(player) == g0_team2 then
			g_team2Player = player
		end
	end
end

-- check players stats and ajust them
function analysePlayers()
	g_aiPlayerAmount = 0
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if Player_GetMaxPopulation(player, CT_Personnel) == 100 then
			Player_SetPopCapOverride(player, g_popCap)
		end
		if AI_IsAIPlayer(player) == true then
			g_aiPlayerAmount = g_aiPlayerAmount + 1
			g_aiPlayers[g_aiPlayerAmount] = player
		end
	end
end


-- find proper dropzone areas
function analyseMap()
	
	local isVictoryPoint = function (egroupid, itemindex, entityID)
		if (Entity_IsVictoryPoint(entityID) == true) then
			local pos = Entity_GetPosition(entityID)
		 	local idd = World_GetTerritorySectorID(pos)
			g_victoryTerritoryAmount = g_victoryTerritoryAmount + 1
			table.insert(g_victoryTerritorys, {id = idd,entity = entityID})
		end
	end
	
    local eCapturePoints = EGroup_CreateIfNotFound("eCapturePoints")
	World_GetStrategyPoints(eCapturePoints, true)
	EGroup_ForEach(eCapturePoints, isVictoryPoint)

	-- if there is not any vps
	if g_victoryTerritoryAmount == 0 then
		local addAll = function (egroupid, itemindex, entityID)
			--if (Entity_IsStartingPosition == false) then
				local pos = Entity_GetPosition(entityID)
				local idd = World_GetTerritorySectorID(pos)
				local dist = World_DistancePointToPoint(World_Pos(0,0,0),pos) --near to the middle of a map
				g_victoryTerritoryAmount = g_victoryTerritoryAmount + 1
				table.insert(g_victoryTerritorys, {id = idd,entity = entityID, dis = dist})
			--end
		end
		
		local sortDistance = function(a1,a2)
			if a1.dis < a2.dis then
				return true
			end
		end
		
		EGroup_ForEach(eCapturePoints, addAll)
		table.sort(g_victoryTerritorys,sortDistance)
		
		if g_victoryTerritoryAmount > 3 then
			for i=4, g_victoryTerritoryAmount do
				table.remove(g_victoryTerritorys,4) --remove the 4th one, always
				g_victoryTerritoryAmount = g_victoryTerritoryAmount - 1
			end
		end
		
	end
end


-- return random object from table
function Table_RandomItem(atable)
	local list = {}
	local amount = 0
	for key, i in ipairs(atable) do
		amount = amount + 1
		list[amount] = i
	end
	
	if amount > 0 then
		return list[World_GetRand(1,amount)]
	else
		return nil
	end
end


--- Other's functions


-- Copyright (C) 2010 eliw00d
function Util_CreateLocString(text)
   local tmpstr = LOC(text)
   tmpstr[1] = text
   return tmpstr
end


-- Copyright (C) 2012 LoDC
-- edited
function ToRomanNumerals(s)
	
    if s <= 0 then return s end
	local ret = ""
        for i = #g_Roman_numbers, 1, -1 do
        local num = g_Roman_numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. g_Roman_chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = g_Roman_numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. g_Roman_chars[j] .. g_Roman_chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
	
end
