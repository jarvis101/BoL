

require "SOW"
require "Vprediction"
if VIP_USER then
	require "Prodiction"
end

if myHero.charName ~= "LeeSin" then PrintChat("You're not lee sin, you're "..myHero.charName.."!") return end

local AllyTable = {}
local EnemyTable = {}
local turrets = GetTurrets()
local Prod
local ProdQ
local ProdI
local myQ = myHero:GetSpellData(_Q)
local myW = myHero:GetSpellData(_W)
local myE = myHero:GetSpellData(_E)
local myR = myHero:GetSpellData(_R)
local Rrange = 375
local Qrange = 1100
local Wrange = 700
local Erange = 425
local Qtime = os.clock
local Wtime = os.clock
local Etime = os.clock
local JkickPos = nil

local jumpkick = false
local ksr = false

local ward
local wardR 
local WardTime = os.clock()
local Hydra
local HydraR
local RuinedKing 
local Omen
local Tiamat
local BilgeWaterCutlass
local Youmuu
local HydraR 
local RuinedKingR
local OmenR
local TiamatR 
local BilgeWaterCutlassR
local YoumuuR 
local SwordofDivine 

local JungleMinions
local Minions 
local FleeJ 
local FleeM 
local AllyMin

local wardPoints
local WPspecial
local hitBoxes

local mdraw
local Wsec = false
local Fsec = false

function init_tables()
	wardPoints = {
		--{ x =  10600.58, y = 69.96, z = 2037.02 },
		--{ x =  11102.92, y = -70.54, z = 2615.42 },
		p1 = {
			
			{ x =  5370.155, y = 54.80, z = 7504.09 },
			{ x =  8301.40, y = -65.47, z = 6500.795 },
			{ x =  2333.93, y = 108.23, z = 4316.03 },
			{ x =  4182.96, y = 109.439, z = 2503.61 },
			{ x =  4969.88, y = 54.41, z = 2376.66 },
			{ x =  5797.31, y = 53.02, z = 3470.74 },
			{ x =  7634.12, y = 56.86, z = 3887.32 },
			{ x =  7357.33, y = 56.915, z = 4075.35 },
			{ x =  6502.56, y = 61.03, z = 5366.69 },
			{ x =  7967.31, y = 55.097, z = 2997.25 },
			{ x =  9321.02, y = 66.03, z = 2870.20 },
			{ x =  8840.28, y = 60.97, z = 3570.637 },
			{ x =  10073.69, y = 49.39, z = 3364.71 },
			{ x =  6858.46, y = 52.59, z = 1464.09 },
			{ x =  9953.51, y = 69.18, z = 2029.57 },
			{ x =  3377.52, y = 55.65, z = 5524.49 },
			{ x =  3283.23, y = 55.56, z = 5057.66 },
			{ x =  8700.68, y = 54.44, z = 4619.40 },
			{ x = 2425.26, y = 60.19, z = 5971.97 },
			{ x = 1694.11, y = 53.56, z = 7663.27 },
			{ x = 1289.31, y = 44.72, z = 8793.63 },
			{ x = 2428.33, y = 53.36, z = 10055.94 },
			{ x = 4621.51, y = -62.81, z = 10773.10 },
			{ x = 5062.05, y = -62.90, z = 10294.80 },
			{ x = 6412.95, y = -63.89, z = 8342.43 },
			{ x = 7643.02, y = -64.74, z = 5966.23 },
			{ x = 8174.08, y = 54.27, z = 1972.46 },
			{ x = 11463.72, y = -61.82, z = 4260.54 },
			{ x = 11353.78, y = 53.84, z = 5792.79 },
			{ x = 9953.59, y = 55.12, z = 6596.66 },
			{ x = 10449.16, y = 55.27, z = 7369.82 },
			{ x = 11246.14, y = 62.62, z = 8345.20 },
			{ x = 12304, y = 54.82, z = 6335.27 },
			{ x = 11672.55, y = 50.35, z = 9706.66 },
			{ x = 9445.07, y = 52.48, z = 11991.54 },
			{ x = 8153.57, y = 49.93, z = 11206.17 },
			{ x = 6207.45, y = 54.63, z = 11474.52 },
			{ x = 5950.83, y = 53.95, z = 10856.94 },
			{ x = 6607.18, y = 56.04, z = 9920.79 },
			{ x = 7432.66, y = 55.58, z = 9109.00 },
			{ x = 8153.57, y = 49.93, z = 11206.17 },
			{ x = 6207.45, y = 54.63, z = 11474.52 },
			{ x = 5950.83, y = 53.95, z = 10856.94 },
			{ x = 6607.18, y = 56.04, z = 9920.79 },
			{ x = 7432.66, y = 55.58, z = 9109.00 },
			{ x = 4002.22, y = 51.98, z = 8065.74 },
		},
		
		p2 = {
			{ x =  5771.72, y = -54.70, z = 7908.60 },
			{ x =  8550.15, y = 56.20, z = 6867.02 },
			{ x =  2368.46, y = 56.20, z = 4896.56 },
			{ x =  4604.18, y = 54.28, z = 2551.77 },
			{ x =  5511.51, y = 55.29, z = 2324.30 },
			{ x =  6240.17, y = 51.67, z = 3712.23 },
			{ x =  8199.14, y = 55.37, z = 3926.97 },
			{ x =  7384.68, y = 53.34, z = 4539.62 },
			{ x =  6681.84, y = 55.597, z = 5876.46 },
			{ x =  8031.159, y = 54.276, z = 2632.80 },
			{ x =  9195.29, y = 67.835, z = 2473.39 },
			{ x =  9182.98, y = -63.26, z = 3942.33 },
			{ x =  9850.75, y = -60.35, z = 3950.40 },
			{ x =  7071.21, y = 54.39, z = 1908.33 },
			{ x =  9872.03, y = 52.98, z = 1562.07 },
			{ x =  3043.24, y = 57.10, z = 5041.53 },
			{ x =  3497.89, y = 55.65, z = 5545.92 },
			{ x =  9114.60, y = -60.31, z = 4550.98 },
			{ x = 2799.04, y = 54.99, z = 6221.92 },
			{ x = 1840.84, y = 54.92, z = 8085.89 },
			{ x = 1732.97, y = 54.92, z = 8705.24 },
			{ x = 2803.87, y = -64.63, z = 10301.02 },
			{ x = 4656.49, y = 51.20, z = 11344.77 },
			{ x = 5495.71, y = 54.82, z = 10065.66 },
			{ x = 6646.85, y = 56.02, z = 8527.19 },
			{ x = 7459.78, y = 54.125, z = 5776.79 },
			{ x = 8099.56, y = 52.60, z = 1481.36 },
			{ x = 11746.04, y = 52.00, z = 4478.99 },
			{ x = 11589.12, y = 54.92, z = 6298.78 },
			{ x = 10404.91, y = 54.87, z = 6792.94 },
			{ x = 10681.96, y = 54.87, z = 6901.92 },
			{ x = 11550.38, y = 53.45, z = 8670.70 },
			{ x = 12758.82, y = 55.31, z = 6549.91 },
			{ x = 11817.62, y = 106.83, z = 10119.40 },
			{ x = 9823.50, y = 106.22, z = 12130.48 },
			{ x = 7697.02, y = 53.90, z = 10941.29 },
			{ x = 6022.06, y = 39.59, z = 11933.42 },
			{ x = 6444.79, y = 54.64, z = 10768.62 },
			{ x = 6648.39, y = 54.64, z = 10386.56 },
			{ x = 7189.93, y = 56.02, z = 8636.079 },
			{ x = 7697.02, y = 53.90, z = 10941.29 },
			{ x = 6022.06, y = 39.59, z = 11933.42 },
			{ x = 6444.79, y = 54.64, z = 10768.62 },
			{ x = 6648.39, y = 54.64, z = 10386.56 },
			{ x = 7189.93, y = 56.02, z = 8636.08 },
			{ x = 3642.75, y = 54.04, z = 7749.98 },
		}
	}
	
	WPspecial = {
		16,
		17,
	}
	
	hitBoxes = {

			["Red_Minion_MechRange"] = 65.0, 
			["Blue_Minion_MechMelee"] = 65, 
			["MonkeyKingClone"] = 65, 
			["Red_Minion_MechCannon"] = 65.0, 
			["Blue_Minion_MechCannon"] = 65.0, 
			["Red_Minion_MechMelee"] = 65.0,
			["Blue_Minion_MechMelee"] = 65.0,
			["ShacoBox"] = 10,
			["Red_Minion_Melee"] = 48.0,
			["Blue_Minion_Melee"] = 48.0,
			["Blue_Minion_Wizard"] = 48.0,
			["Red_Minion_Wizard"] = 48.0,
			["Red_Minion_Basic"] = 48.0,
			["Blue_Minion_Basic"] = 48.0,
			["RabidWolf"] = 65.0,
			["GiantWolf"] = 65.0,
			["Wolf"] = 50.0,
			["Wraith"] = 50.0,
			["LesserWraith"] = 50.0,
			["GreatWraith"] = 80.0,
			["Golem"] = 80.0,
			["SmallGolem"] = 80.0,
			["AncientGolem"] = 100.0,
			["LizardElder"] = 65.0,
			["YoungLizard"] = 50.0,
			["Lizard"] = 50.0,
			["blueDragon"] = 100.0,
			["redDragon"] = 100.0,
			["OrderTurretDragon"] = 88.4,
			["Dragon"] = 100.0,
			["Worm"] = 100.0,

	}
	
	wardID = {
		3205,
		3207,
		2049,
		2045,
		3340,
		2044,
		3361,
		3362,
		3154,
		3160,
		3340
	}
end

function OnDraw()
	if Config.Draw.Qrange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, 1100, ARGB(214,66,33,33))
	end
	if Config.Draw.Wrange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(214,1,33,33))
	end
	if Config.Draw.Erange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(214,66,33,33))
	end
	if Config.Draw.Rrange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(214,255,0,0))
	end
	if Config.Draw.WJrange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, ARGB(214,1,1,33))
	end
	if Config.Draw.Jumps then
		for i,point in pairs(wardPoints.p1) do
			DrawCircle(point.x, point.y, point.z, 100, ARGB(214, 1,255,1))
		end
		for i,point in pairs(wardPoints.p2) do
			DrawCircle(point.x, point.y, point.z, 100, ARGB(214, 1,1,255))
		end
	end
	if mdraw ~= nil and mdraw ~= 0 then DrawCircle(mdraw.x, mdraw.y, mdraw.z, 100, ARGB(200, 255,255,255)) end
end

function checkitems()	

	ward = nil
	
	for i, num in pairs(wardID) do
		local foo = GetInventorySlotItem(num)
		local fooR = (foo ~= nil and myHero:CanUseSpell(foo) == READY)
		if fooR then
			ward = foo
			break
		end
	end
	
	Hydra = GetInventorySlotItem(3074)
	RuinedKing = GetInventorySlotItem(3153)
	Omen = GetInventorySlotItem(3143)
	Tiamat = GetInventorySlotItem(3077)
	BilgeWaterCutlass = GetInventorySlotItem(3144)
	Youmuu = GetInventorySlotItem(3142)
	HydraR = (Hydra ~= nil and myHero:CanUseSpell(Hydra))
	RuinedKingR = (RuinedKing ~= nil and myHero:CanUseSpell(RuinedKing))
	OmenR = (Omen ~= nil and myHero:CanUseSpell(Omen))
	TiamatR = (Tiamat ~= nil and myHero:CanUseSpell(Tiamat))
	BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
	YoumuuR = (Youmuu ~= nil and myHero:CanUseSpell(Youmuu))
	SwordofDivine = GetInventorySlotItem(3131)
	SwordofDivineR = (SwordofDivine ~= nil and myHero:CanUseSpell(SwordofDivine))
end

function useitems(targ)
	if BilgeWaterCutlassR then CastSpell(BilgeWaterCutlass, targ) end
	if YoumuuR then CastSpell(Youmuu) end
	if OmenR then CastSpell(Omen) end
	if RuinedKingR then CastSpell(RuinedKing, targ) end
	if TiamatR then CastSpell(Tiamat) end
	if HydraR then CastSpell(Hydra) end
	if SwordofDivineR then CastSpell(SwordofDivine) end
end

function OnLoad()
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team == myHero.team and champ ~= myHero then
			table.insert(AllyTable, champ)
		end
		if champ.team ~= myHero.team then
			table.insert(EnemyTable, champ)
		end
	end
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:RegisterAfterAttackCallback(AutoAttackRese)
	if VIP_USER then
		Prod = ProdictManager.GetInstance()
		ProdQ = Prod:AddProdictionObject(_Q, 1000, 1800, 0.250, 70)
		ProdI = Prod:AddProdictionObject(_W, 600, 1400, 0.250, 100)
	end
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1300, DAMAGE_PHYSICAL)	
	ts.name = "Target"
	Menu()
	Config:addTS(ts)
	mypos = myHero
	JungleMinions = minionManager(MINION_JUNGLE, 1250, myHero, MINION_SORT_HEALTH_ASC)
	Minions = minionManager(MINION_ENEMY, 1250, myHero, MINION_SORT_HEALTH_ASC)
	FleeJ = minionManager(MINION_JUNGLE, 400, mousePos, MINION_SORT_HEALTH_ASC)
	FleeM = minionManager(MINION_ENEMY, 400, mousePos, MINION_SORT_HEALTH_ASC)
	AllyMin = minionManager(MINION_ALLY, 400, mousePos, MINION_SORT_HEALTH_ASC)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerSmite") then 
		smite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerSmite") then 
		smite = SUMMONER_2
	else 
		smite = nil
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then 
		flash = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then 
		flash = SUMMONER_2
	else 
		flash = nil
	end
	init_tables()
end

function Menu()
	Config = scriptConfig("OP Lee", "Config")
	
	Config:addParam("log","log",SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("O"))
	Config:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config:addParam("Debug","Debug", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("P"))
	Config:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Config:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	Config:addParam("Mobile","Mobility", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	Config:addParam("Insec","Insec", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Config:addParam("WardJump","WardJump", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	
	
	Config:addSubMenu("Combo", "CSettings")
		Config.CSettings:addParam("useQ","Use 1st Q in combo", SCRIPT_PARAM_ONOFF, true)
		Config.CSettings:addParam("useW","Use 1st W to chase/position", SCRIPT_PARAM_ONOFF, false)
		Config.CSettings:addParam("useE","Use 1st E in combo", SCRIPT_PARAM_ONOFF, true)
		Config.CSettings:addParam("useR","Use R in combo", SCRIPT_PARAM_ONOFF, true)
		Config.CSettings:addParam("Rthree","only use R hits >2 ppl(WIP)", SCRIPT_PARAM_ONOFF, false)
		Config.CSettings:addSubMenu("Damage Settings","delay")
			Config.CSettings.delay:addParam("useQ","use 2nd Q in combo", SCRIPT_PARAM_ONOFF, true)
			Config.CSettings.delay:addParam("useW","use 2nd W in combo", SCRIPT_PARAM_ONOFF, true)
			Config.CSettings.delay:addParam("useE","use 2nd E in combo", SCRIPT_PARAM_ONOFF, true)
			Config.CSettings.delay:addParam("delayQ","Delay Q for damage", SCRIPT_PARAM_ONOFF, true)
			Config.CSettings.delay:addParam("delayW","Delay W for damage", SCRIPT_PARAM_ONOFF, true)
			Config.CSettings.delay:addParam("delayE","Delay E for damage", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Harass", "HSettings")
		Config.HSettings:addParam("useQ","Use 1st Q in combo", SCRIPT_PARAM_ONOFF, true)
		Config.HSettings:addParam("useW","Use 1st W to chase/position", SCRIPT_PARAM_ONOFF, false)
		Config.HSettings:addParam("useE","Use 1st E in combo", SCRIPT_PARAM_ONOFF, true)
		Config.HSettings:addSubMenu("Damage Settings","delay")
			Config.HSettings.delay:addParam("useQ","use 2nd Q in combo", SCRIPT_PARAM_ONOFF, true)
			Config.HSettings.delay:addParam("useW","use 2nd W in combo", SCRIPT_PARAM_ONOFF, true)
			Config.HSettings.delay:addParam("useE","use 2nd E in combo", SCRIPT_PARAM_ONOFF, true)
			Config.HSettings.delay:addParam("delayQ","Delay Q for damage", SCRIPT_PARAM_ONOFF, true)
			Config.HSettings.delay:addParam("delayW","Delay W for damage", SCRIPT_PARAM_ONOFF, true)
			Config.HSettings.delay:addParam("delayE","Delay E for damage", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("LaneClear", "LSettings")
		Config.LSettings:addParam("useQ","Use 1st Q in combo", SCRIPT_PARAM_ONOFF, true)
		Config.LSettings:addParam("useW","Use 1st W to chase/position", SCRIPT_PARAM_ONOFF, false)
		Config.LSettings:addParam("useE","Use 1st E in combo", SCRIPT_PARAM_ONOFF, true)
		Config.LSettings:addSubMenu("Damage Settings","delay")
			Config.LSettings.delay:addParam("useQ","use 2nd Q in combo", SCRIPT_PARAM_ONOFF, true)
			Config.LSettings.delay:addParam("useW","use 2nd W in combo", SCRIPT_PARAM_ONOFF, true)
			Config.LSettings.delay:addParam("useE","use 2nd E in combo", SCRIPT_PARAM_ONOFF, true)
			Config.LSettings.delay:addParam("delayQ","Delay Q for damage", SCRIPT_PARAM_ONOFF, true)
			Config.LSettings.delay:addParam("delayW","Delay W for damage", SCRIPT_PARAM_ONOFF, true)
			Config.LSettings.delay:addParam("delayE","Delay E for damage", SCRIPT_PARAM_ONOFF, true)	
	
	Config:addSubMenu("Skill Settings","SSettings")
		Config.SSettings:addParam("Vpred", "Use Vprediction", SCRIPT_PARAM_ONOFF, true)
		Config.SSettings:addParam("Prod", "Use Prodiction(VIP ONLY)", SCRIPT_PARAM_ONOFF, false)
		Config.SSettings:addParam("Packet", "Use Packets(VIP ONLY)", SCRIPT_PARAM_ONOFF, true)
		Config.SSettings:addParam("CheckQCollisions","check for minion collision on Q", SCRIPT_PARAM_ONOFF, false)
		Config.SSettings:addParam("smite","Smite minion collisions for Q", SCRIPT_PARAM_ONOFF, false)
		Config.SSettings:addParam("alwaysinsec","always insec R", SCRIPT_PARAM_ONOFF, true)
	
	
	Config:addSubMenu("Insec Settings", "InSettings")
		Config.InSettings:addParam("jkick","Ward Jump Insec", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings:addParam("flash","Use Flash if W on CD", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings:addParam("Pflash","Prioritize flash over ward jump", SCRIPT_PARAM_ONOFF, false)
		Config.InSettings:addParam("Pred","use prediction for insec", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings:addParam("mouse","Move to mouse(otherwise will move to target)", SCRIPT_PARAM_ONOFF, false)
		Config.InSettings:addParam("col","Ignore Collision for insec", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings:addSubMenu("Direction Settings", "Direct")
			Config.InSettings.Direct:addParam("rand4", "Set to 7 to disable", SCRIPT_PARAM_INFO, "")
			Config.InSettings.Direct:addParam("Lpos","Last Position", SCRIPT_PARAM_SLICE, 5, 1, 7, 0)
			Config.InSettings.Direct:addParam("Apos","Ally Position", SCRIPT_PARAM_SLICE, 4, 1, 7, 0)
			Config.InSettings.Direct:addParam("Tpos","Tower Position", SCRIPT_PARAM_SLICE, 3, 1, 7, 0)
			Config.InSettings.Direct:addParam("Mpos","Mouse Position", SCRIPT_PARAM_SLICE, 6, 1, 7, 0)
			Config.InSettings.Direct:addParam("Dpos","to/from dragon", SCRIPT_PARAM_SLICE, 2, 1, 7, 0)
			Config.InSettings.Direct:addParam("Bpos","to/from baron", SCRIPT_PARAM_SLICE, 1, 1, 7, 0)
		Config.InSettings:addSubMenu("Flash Insec", "Fsec")
			Config.InSettings.Fsec:addParam("Qmob", "Use Q to get to target", SCRIPT_PARAM_ONOFF, true)
			Config.InSettings.Fsec:addParam("Wmob", "Use W to get to target", SCRIPT_PARAM_ONOFF, false)
			Config.InSettings.Fsec:addParam("mouse", "Move To Mouse", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings:addSubMenu("Ward Insec", "Wsec")
			Config.InSettings.Wsec:addParam("Qmob", "Use Q to get to target", SCRIPT_PARAM_ONOFF, true)
			Config.InSettings.Wsec:addParam("mouse", "Move To Mouse", SCRIPT_PARAM_ONOFF, true)
	
		Config:addSubMenu("Mobile Settings", "MSettings")
		Config.MSettings:addParam("rand6", "Only one can be on, or will", SCRIPT_PARAM_INFO, "")
		Config.MSettings:addParam("rand6", "default to jump spots only", SCRIPT_PARAM_INFO, "")
		Config.MSettings:addParam("WJloc", "Only jump from jump spots", SCRIPT_PARAM_ONOFF, true)
		Config.MSettings:addParam("WJperm", "Jump on W CD", SCRIPT_PARAM_ONOFF, false)
	
	
	Config.InSettings:addSubMenu("Kick to Ally", "Apos")
	local foo = 1
	Config.InSettings.Apos:addParam("rand5", "Set to 5 to disable", SCRIPT_PARAM_INFO, "")
	for i, ally in pairs(AllyTable) do
		if foo == 1 then Config.InSettings.Apos:addParam("AA",tostring(ally.charName), SCRIPT_PARAM_SLICE, foo, 1, 5, 0) end
		if foo == 2 then Config.InSettings.Apos:addParam("AB",tostring(ally.charName), SCRIPT_PARAM_SLICE, foo, 1, 5, 0) end
		if foo == 3 then Config.InSettings.Apos:addParam("AC",tostring(ally.charName), SCRIPT_PARAM_SLICE, foo, 1, 5, 0) end
		if foo == 4 then Config.InSettings.Apos:addParam("AD",tostring(ally.charName), SCRIPT_PARAM_SLICE, foo, 1, 5, 0) end
		
		foo = foo + 1
	end
	Config.InSettings.Apos:addParam("Ahp","Don't kick to if ally hp < %", SCRIPT_PARAM_SLICE, 20, 5, 101, 0)
	
	Config.InSettings:addSubMenu("Kick to Turret", "Tpos")
		Config.InSettings.Tpos:addParam("rand2", "max distance from turret", SCRIPT_PARAM_INFO, "")
		Config.InSettings.Tpos:addParam("dist", "to land target", SCRIPT_PARAM_SLICE, 200, 200, 775, 0)
		Config.InSettings.Tpos:addParam("rand1", "If injured ally near", SCRIPT_PARAM_INFO, "")
		Config.InSettings.Tpos:addParam("AvT","turret then next priority", SCRIPT_PARAM_ONOFF, true)
		Config.InSettings.Tpos:addParam("AvTpcnt","MinHealth", SCRIPT_PARAM_SLICE, 20, 5, 101, 0)
	
	Config:addSubMenu("Kill Steal", "KS")
	Config.KS:addParam("bool","Use Kill Steal", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("useQ","KS with Q", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("useE","KS with E", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("useR","KS with R", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("useI","KS with Ignite", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Draw Settings", "Draw")
	Config.Draw:addParam("Qrange","Draw Q range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("Wrange","Draw W range", SCRIPT_PARAM_ONOFF, false)
	Config.Draw:addParam("Erange","Draw E range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("Rrange","Draw R range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("WJrange","Draw Ward Jump range", SCRIPT_PARAM_ONOFF, true)
	Config.Draw:addParam("Jumps","Draw jump spots", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Orbwalker", "SOWiorb")
	SOWi:LoadToMenu(Config.SOWiorb)
end

function OnTick()
	
	Qrdy = (myHero:CanUseSpell(_Q) == READY)
	Wrdy = (myHero:CanUseSpell(_W) == READY)
	Erdy = (myHero:CanUseSpell(_E) == READY)
	Rrdy = (myHero:CanUseSpell(_R) == READY)
	Irdy = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	Srdy = (smite ~= nil and myHero:CanUseSpell(smite) == READY)
	Frdy = (flash ~= nil and myHero:CanUseSpell(flash) == READY)
	ts:update()
	Target = ts.target
	checkitems()
	
	if VIP_USER and Config.SSettings.Prod and Target ~= nil then
		PQP=ProdQ:GetPrediction(Target)
		PQI = ProdI:GetPrediction(Target)
	end
	
	if Config.KS.bool then
		KS()
	end
	
	if Target ~= nil and ValidTarget(Target) then
		if Config.Combo then Combo() end
		if Config.Harass then Harass() end
		if Config.Insec then Insec() end
	end
	if Config.LaneClear then LaneClear() end
	if Config.Mobile then Mobile() end
	if Config.WardJump then WJ() end
	if Config.Debug then Debug() end
	if Config.log then Log() end
end



function KS()
	for i, enemy in pairs(EnemyTable) do 
		if ValidTarget(enemy) then
			if Config.KS.useQ and Qrdy and enemy.health < getDmg("Q", enemy, myHero) and GetDistance(enemy, myHero) < 1100 then
				QoneCheck(enemy)
			end
			if Config.KS.useE and Erdy and enemy.health < getDmg("E", enemy, myHero) and GetDistance(enemy, myHero) < 400 then 
				useE()
			end
			if Rrdy and Config.KS.useR and enemy.health < getDmg("R", enemy, myHero) and GetDistance(enemy, myHero) < 300 then
				ksr = true
				useR(enemy)
			end
			if ignite ~= nil then
				if Irdy and Config.KS.useI and enemy.health < getDmg("IGNITE", enemy, myHero) and GetDistance(enemy, myHero) < 550 then
					CastSpell(ignite, enemy)
				end
			end
		end
	end
end

function Combo()
	
	if GetDistance(Target,myHero) < 400 then useitems(Target) end
	
	if Wrdy and Config.CSettings.useW and myW.name == "BlindMonkWOne" then
		WoneCheck(Target)
	end
	if Erdy and Config.CSettings.useE and myE.name == "BlindMonkEOne" then
		EoneCheck(Target)
	end
	if Qrdy and Config.CSettings.useQ and myQ.name == "BlindMonkQOne" then
		QoneCheck(Target)
	end
	if Config.CSettings.delay.useW and Wrdy and myW.name ~= "BlindMonkWOne" then
		if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.CSettings.delay.delayW and os.clock() and GetDistance(Target, myHero) < 250 then return end
		useW()
	end
	if Config.CSettings.delay.useE and Erdy and myE.name ~= "BlindMonkEOne" then
		if Config.CSettings.delay.delayE and TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and os.clock() and GetDistance(Target, myHero) < 250 then return end
		EtwoCheck(Target)
	end
	if Rrdy and Config.CSettings.useR then
		if Config.CSettings.Rthree then
			if GetDistance(Target) < 325 then 
				if Config.CSettings.Rthree then
					local foo = CheckUltCollision(Target)
					if foo then useR(Target) end
				end
				if Config.CSettings.Rthree == false then
					useR(Target)
				end
			end
		end
	end
	if Qrdy and Config.CSettings.delay.useQ and myQ.name ~= "BlindMonkQOne" then
		if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.CSettings.delay.delayQ and os.clock() and GetDistance(Target, myHero) < 250 then return end
		QtwoCheck(Target)
	end
end

function Harass()
	if Wrdy and Config.HSettings.useW and myW.name == "BlindMonkWOne" then
		WoneCheck(Target)
	end
	if Erdy and Config.HSettings.useE and myE.name == "BlindMonkEOne" then
		EoneCheck(Target)
	end
	if Qrdy and Config.HSettings.useQ and myQ.name == "BlindMonkQOne" then
		QoneCheck(Target)
	end
	if Config.HSettings.delay.useW and Wrdy and myW.name ~= "BlindMonkWOne" then
		if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.HSettings.delay.delayW and os.clock() < (Wtime + 2.4) and GetDistance(Target, myHero) < 250 then return end
		useW(nil)
	end
	if Config.HSettings.delay.useE and Erdy and myE.name ~= "BlindMonkEOne" then
		if Config.HSettings.delay.delayE and TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and os.clock() < (Etime + 2.2) and GetDistance(Target, myHero) < 250 then return end
		EtwoCheck(Target)
	end
	if Qrdy and Config.HSettings.delay.useQ and myQ.name ~= "BlindMonkQOne" then
		if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.HSettings.delay.delayQ and os.clock() < (Qtime + 2.0) and GetDistance(Target, myHero) < 250 then return end
		QtwoCheck(Target)
	end
end

function LaneClear()
	Minions:update()
	JungleMinions:update()
	
	
	
	local tarMin = nil
	local distance = 9999
	for i, minion in pairs(Minions.objects) do
		if minion ~= nil and GetDistance(minion,myHero) < 1100 then
			local foo = GetDistance(minion, myHero)
			if foo < distance then
				tarMin = minion
				distance = foo
			end
		end
	end
	for i, minion in pairs(JungleMinions.objects) do
		if minion ~= nil then
			local foo = GetDistance(minion, myHero)
			if foo < distance then
				tarMin = minion
				distance = foo
			end
		end
	end
	if tarMin ~= nil then
	
		if TiamatR and GetDistance(tarMin) < 500 then CastSpell(Tiamat) end
		if HydraR and GetDistance(tarMin) < 500 then CastSpell(Hydra) end
	
		if Wrdy and Config.LSettings.useW and myW.name == "BlindMonkWOne" then
			WoneCheck(tarMin)
		end
		if Erdy and Config.LSettings.useE and myE.name == "BlindMonkEOne" then
			EoneCheck(tarMin)
		end
		if Qrdy and Config.LSettings.useQ and myQ.name == "BlindMonkQOne" then
			QoneCheck(tarMin)
		end
		if Config.LSettings.delay.useW and Wrdy and myW.name ~= "BlindMonkWOne" then
			if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.LSettings.delay.delayW and os.clock() < (Wtime + 2.4) and GetDistance(tarMin, myHero) < 250 then return end
			useW(nil)
		end
		if Config.LSettings.delay.useE and Erdy and myE.name ~= "BlindMonkEOne" then
			if Config.LSettings.delay.delayE and TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and os.clock() < (Etime + 2.2) and GetDistance(tarMin, myHero) < 250 then return end
			EtwoCheck(tarMin)
		end
		if Qrdy and Config.LSettings.delay.useQ and myQ.name ~= "BlindMonkQOne" then
			if TargetHaveBuff("blindmonkpassive_cosmetic", myHero) and Config.LSettings.delay.delayQ and os.clock() < (Qtime + 2.0) and GetDistance(tarMin, myHero) < 250 then return end
			QtwoCheck(tarMin)
		end
	end
end

function WJ()
	if Wrdy and myW.name == "BlindMonkWOne" then
		if os.clock()-WardTime < 1 and os.clock()-WardTime > 0.001 then
			useW(recentWard)
		else
			if ward ~= nil then
				if GetDistance(mousePos, myHero) < 590 then
					CastSpell(ward, mousePos.x, mousePos.z)
				else 
					local pos = GetReverseVector(myHero, mousePos, 600)
					if pos ~= nil then CastSpell(ward, pos.x, pos.z) end
				end
			end
		end
	end
end

function SWJ(pos)
	if Wrdy and myW.name == "BlindMonkWOne" then
		if os.clock()-WardTime < 1 and os.clock()-WardTime > 0.001 then
			useW(recentWard)
		else
			if ward ~= nil then
				if pos ~= nil then
					CastSpell(ward, pos.x, pos.z)
				end
			end
		end
	end
end

function SWJcheck(id, pval)
	for i, foo in pairs(WPspecial) do
		if foo == id and pval ~= nil then
			if pval == 1 then
				if GetDistance(wardPoints.p1[id]) < 50 then
					return GetReverseVector(wardPoints.p2[id], wardPoints.p1[id], 100)
				end
			elseif pval == 2 then
				if GetDistance(wardPoints.p2[id]) < 50 then
					return GetReverseVector(wardPoints.p1[id], wardPoints.p2[id], 100)
				end
			else
				PrintChat("Error on determining ward placement position --- WJ01")
			end
		end
	end
	return nil
end

function Mobile(isInsec, noward)
	if Config.MSettings.WJperm and not Config.MSettings.WJloc then 
		if Wrdy and myW.name == "BlindMonkWOne" then
			WJ()
		end
	elseif Config.MSettings.WJloc then 
		if Wrdy and myW.name == "BlindMonkWOne" then
			
			for i, pos in pairs(wardPoints.p1) do
				if GetDistance(pos, myHero) < 100 then
					PrintChat("I'm Here!")
					local foo = SWJcheck(i, 1)
					if foo ~= nil then
						SWJ(foo)
					else
						SWJ(wardPoints.p2[i])
					end
				end
			end
			for i, pos in pairs(wardPoints.p2) do
				if GetDistance(pos, myHero) < 100 then
					PrintChat("I'm Here!")
					local foo = SWJcheck(i, 2)
					if foo ~= nil then
						SWJ(foo)
					else
						SWJ(wardPoints.p1[i])
					end
				end
			end
		end
	end
	local foo = getNearestTarget(mousePos, false)
	if foo ~= nil and GetDistance(foo, myHero) < 1100 then
		QoneCheck(foo)
	end
	if isInsec == nil then
		local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
		local Position = myHero + (Vector(MousePos) - myHero):normalized()*250
		myHero:MoveTo(Position.x, Position.z)
	else
		local posvec = Vector(Target.x,Target.y,Target.z)
		local pos = myHero + (Vector(posvec) - myHero):normalized()*250
		myHero:MoveTo(Target.x, Target.z)
	end
end




function Insec()
	--[[	OLD INSEC LOGIC
			
	if (Frdy and Rrdy and Config.InSettings.flash) then
		if GetDistance(Target, myHero) > 350 then
			if Config.InSettings.mouse then
				Mobile(nil, nil)
			else
				Mobile(true, nil)
			end
		else
			useR(Target)
		end
	elseif Config.InSettings.jkick and Rrdy then
		if GetDistance(Target, myHero) > 300 then
			if Config.InSettings.mouse then
				Mobile(nil, true)
			else
				Mobile(true,true)
			end
		else
			if JkickPos == nil then JkickPos = GetInsecFunc(1, Target) end
			if Wrdy and myW.name == "BlindMonkWOne" and JkickPos ~= nil then					
				if os.clock()-WardTime < 1 and os.clock()-WardTime > 0.001 then
					JkickPos = nil
					useW(recentWard)
				elseif ward ~= nil then
					if GetDistance(JkickPos, myHero) > 590 then	PrintChat("error with jkickpos") JkickPos = nil return end
					if JkickPos == nil then PrintChat("nil error") end
					CastSpell(ward, JkickPos.x, JkickPos.z)
				end
			elseif not Wrdy or myW.name ~= "BlindMonkWOne" and Rrdy then
				useR(Target)
			end
		end
	end
	
	END OF OLD INSEC LOGIC
	
	]]--
	
	if Config.InSettings.flash and Config.InSettings.Pflash then
		FlashInsec(Target)
	end
	if Config.InSettings.jkick then
		WardInsec(Target)
	end
	if Config.InSettings.flash and not Wrdy and not Wsec then
		FlashInsec(Target)
	end		
end

function OnCreateObj(object)
	if object.name == "blindMonk_Q_resonatingStrike_tar_blood.troy" and Config.Mobile then
		useQ(nil)
	end
	if object.name == "VisionWard" or object.name == "SightWard" then
		recentWard = object
		WardTime = os.clock()
	end
end

function OnDestroyObj(obj)
end

function OnProcessSpell(obj, spell)
	if obj.isMe and spell.name == "BlindMonkRKick" then
		if CheckInsec() then
			if flash ~= nil then
				if Frdy and Fsec then
					local foo, foo2 = GetInsecFunc(1, Target)
					CastSpell(flash, foo.x, foo.z)
				end
			end
		end
	end
	if obj.isMe and spell.name == "BlindMonkQOne" then Qtime = os.clock() end
	if obj.isMe and spell.name == "BlindMonkWOne" then Wtime = os.clock() end
	if obj.isMe and spell.name == "BlindMonkEOne" then Etime = os.clock() end
end

function InsecLogic()
	
end

function FlashInsec(targ)
	local foo = GetDistance(targ, myHero)
	if foo > 300 then
		if Config.InSettings.Fsec.Qmob then
			QoneCheck(targ)
			QtwoCheck(targ)
		end
		if Config.InSettings.Fsec.Wmob then
			if foo > 600 and foo < 1400 then
				local pos = GetReverseVector(targ, myHero, (foo - 590))
				SWJ(pos)
			end
		end
		if Config.InSettings.Fsec.mouse then
			local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
			local Position = myHero + (Vector(MousePos) - myHero):normalized()*250
			myHero:MoveTo(Position.x, Position.z)	
		end
	end
	if foo < 300 then
		if Fsec == false then
			Fsec = true
			useR(targ)
		else
			Fsec = false
		end
	end
end

function WardInsec(targ)
	local foo = GetDistance(targ)
	if Wsec and foo > 350 then Wsec = false PrintChat("Error : 02, if you're not ulting, report on forums!") end
	if foo > 300 then
		if Config.InSettings.Wsec.Qmob then
			QoneCheck(targ)
			QtwoCheck(targ)
		end
		if Config.InSettings.Wsec.mouse then
			local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
			local Position = myHero + (Vector(MousePos) - myHero):normalized()*250
			myHero:MoveTo(Position.x, Position.z)	
		end
	end
	if foo < 300 then
		if JkickPos == nil then 
			if Config.InSettings.Pred then
				local foonew = PredInsec()
				if foonew ~= nil then 
					JkickPos = GetInsecFunc(1, foonew)
				else
					JkickPos = GetInsecFunc(1, Target)
				end
			else
				JkickPos = GetInsecFunc(1, Target)
			end
		end
		if Wrdy and myW.name == "BlindMonkWOne" and JkickPos ~= nil then					
			if os.clock()-WardTime < 1 and os.clock()-WardTime > 0.001 then
				JkickPos = nil
				Wsec = true
				useW(recentWard)
			elseif ward ~= nil then
				if GetDistance(JkickPos, myHero) > 600 then	PrintChat("Error : 01 - If not ulting, report on forums!") JkickPos = nil return end
				if JkickPos == nil then PrintChat("nil error") end
				CastSpell(ward, JkickPos.x, JkickPos.z)
			end
		end
		if Rrdy and GetDistance(JkickPos) < 100 then Wsec then
			Wsec = false
			useR(Target)
		end
	end
end

function CheckInsec()
	if ksr then
		ksr = false
		return false
	end
	if Config.SSettings.alwaysinsec then
		return true
	else
		if Config.Insec then
			return true
		end
	end
	return false
end

function QtwoCheck(targ)
	if GetDistance(targ) < 1300 and  TargetHaveBuff("BlindMonkQOne", targ) then
		useQ(nil)
	end
end

function WoneCheck(targ)
	if targ.team == myHero.team and GetDistance(targ,myHero) < Wrange then
		useW(targ)
	end
end

function EoneCheck(targ)
	if GetDistance(targ) < Erange then
		useE()
	end
end

function EtwoCheck(targ)
	if GetDistance(targ) < 500 then useE() end
end

function Rcheck(targ)
	if GetDistance(targ) < Rrange then useR(targ) end
end

local toggle = 0
local jltable = {
	p1 = {},
	p2 = {},
}

function Debug()
	PrintChat("Data logged")
	if toggle == 0 then toggle = 1
	elseif toggle == 1 then toggle = 2
	elseif toggle == 2 then toggle = 1
	end

	if toggle == 1 then
		PrintChat("hello")
		local str = "{ x = "
		local str = (str..tostring(mousePos.x)..", y = "..tostring(mousePos.y)..", z = "..tostring(mousePos.z).." },")
		PrintChat(str)
		table.insert(jltable.p1, str)
	end
	if toggle == 2 then
		PrintChat("hello")
		local str = "{ x = "
		local str = (str..tostring(mousePos.x)..", y = "..tostring(mousePos.y)..", z = "..tostring(mousePos.z).." },")
		PrintChat(str)
		table.insert(jltable.p2, str)
	end
	--PrintChat(tostring(mousePos.x))
	--PrintChat(tostring(mousePos.y))
	--PrintChat(tostring(mousePos.z))
	--[[
	for i = 1, 4000 do
		local foo = GetInventorySlotItem(i)
		local havefoo = (foo ~= nil and myHero:CanUseSpell(foo))
		if havefoo then PrintChat(tostring(i)) end
	end
	]]--
	Config.Debug = false
	
end

function Log()
	--[[
	PrintChat("Data logged")
	local PATH = BOL_PATH.."Scripts\\Data"
    local file = io.open(PATH.."\\Jlocs.txt", "w")
	
	for i, str in pairs(jltable.p1) do
		file:write(str.."\n")
	end
	file:write("\n")
	file:write("\n")
	for i, str in pairs(jltable.p2) do
		file:write(str.."\n")
	end
	file:close()
	jltable = {p1 = {}, p2 = {},}
	Config.log = false
	]]--
end

function getNearestTarget(unit, ally)

	local closestMinion = nil
	local nearestDistance = 0

		FleeM:update()
		FleeJ:update()
		if ally then AllyMin:update() end
		if ally then
			closestMinion = nil
			nearestDistance = 0
			for index, minion in pairs(AllyMin.objects) do
				if minion ~= nil and minion.valid and minion.dead == false then
					if GetDistance(minion) <= 1000 then
						if nearestDistance < GetDistance(unit, minion) then
							nearestDistance = GetDistance(minion)
							closestMinion = minion
						end
					end
				end
			end
			for _, minion in pairs(AllyTable)do
				if ValidTarget(minion, 700) then
					if GetDistance(minion) <= 700 then
						if nearestDistance < GetDistance(unit, minion) then
							nearestDistance = GetDistance(minion)
							closestMinion = minion
						end
					end
				end
			end
		else
			for index, minion in pairs(FleeM.objects) do
				if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= player.team and minion.dead == false then
					if GetDistance(minion) <= 1000 then
						if nearestDistance < GetDistance(unit, minion) then
							nearestDistance = GetDistance(minion)
							closestMinion = minion
						end
					end
				end
			end
			for index, minion in pairs(FleeJ.objects) do
				if minion ~= nil and minion.valid and minion.dead == false then
					if GetDistance(minion) <= 1000 then
						if nearestDistance < GetDistance(unit, minion) then
							nearestDistance = GetDistance(minion)
							closestMinion = minion
						end
					end
				end
			end
			for _, minion in pairs(EnemyTable)do
				if ValidTarget(minion, 800) then
					if GetDistance(minion) <= 800 then
						if nearestDistance < GetDistance(unit, minion) then
							nearestDistance = GetDistance(minion)
							closestMinion = minion
						end
					end
				end
			end
		end
	return closestMinion
end

function GetInsecFunc(ID, targ)
	if ID == 7 then return nil end
	if Config.InSettings.Direct.Tpos == ID then return InsecTurret(ID, targ), "turret" end
	if Config.InSettings.Direct.Apos == ID then return InsecAlly(ID, targ), "ally" end
	if Config.InSettings.Direct.Lpos == ID then return InsecLastPos(ID, targ), "lastpos" end
	if Config.InSettings.Direct.Mpos == ID then return InsecMpos(ID, targ), "mpos" end
	if Config.InSettings.Direct.Dpos == ID then return InsecDpos(ID, targ), "dragpos" end
	if Config.InSettings.Direct.Bpos == ID then return InsecBpos(ID, targ), "barpos" end
end

function InsecLastPos(ID, targ)
	local foo = GetVector(targ, myHero)
	if foo ~= nil then return foo else return GetInsecFunc(ID + 1, targ) end
end

function InsecMpos(ID, targ)
	local foo = GetVector(targ, mousePos)
	if foo ~= nil then return foo else return GetInsecFunc(ID + 1, targ) end
end

function InsecDpos(ID, targ)
	local drag = Vector(9427.4746093705,-60.899047851463,4180.5200195313)
	if GetDistance(targ, drag) < (1200 + 400)  and GetDistance(targ, drag) > 700 then
		local foo = GetVector(targ,drag)
		if foo ~= nil then return foo end
	elseif GetDistance(targ,drag) < 500 then
		local foo = GetReverseVector(targ,drag)
		if foo ~= nil then return foo end
	else return GetInsecFunc(ID + 1, targ) end
end

function InsecBpos(ID, targ)
	local baron = Vector(4582.2392578125,-63.07861328125,10240.887695313)
	if GetDistance(targ, baron) < (1200 + 400)  and GetDistance(targ, baron) > 800 then
		local foo = GetVector(targ,baron)
		if foo ~= nil then return foo end
	elseif GetDistance(targ,baron) < 500 then
		local foo = GetReverseVector(targ,baron)
		if foo ~= nil then return foo end
	else return GetInsecFunc(ID + 1, targ) end
end

function InsecTurret(ID, targ)
	local turret = GetNearestTurret(targ)
	if turret.team == myHero.team then
		if GetDistance(turret, targ) > 775 and GetDistance(turret, targ) < Config.InSettings.Tpos.dist + 1200 then
			if Config.InSettings.Tpos.AvT then
				for i, ally in pairs(AllyTable) do
					if GetDistance(ally, turret) < 400 and ((ally.health/ally.maxHealth)*100) < Config.InSettings.Tpos.AvTpcnt then
						return GetInsecFunc(ID + 1, targ)
					else
						return GetVector(targ, turret)
					end
				end
			else
				return GetVector(targ, turret)
			end
		end
		if GetDistance(turret, targ) > Config.InSettings.Tpos.dist + 1200 then
			return GetInsecFunc(ID + 1, targ)
		end
		if GetDistance(turret,targ) < 775 then
			return GetInsecFunc(ID + 1, targ)
		end
	end
	if turret.team ~= myHero.team then
		return GetInsecFunc(ID + 1, targ)
	end
end

function InsecAlly(ID, targ)
	local ally = nil
	ally = getAlly(1, targ)
	if ally == nil then return GetInsecFunc(ID + 1, targ) end
	if ally ~= nil then
		return GetVector(targ, ally)
	end
end

function getAlly(Prior, targ)
	
	for i, ally in pairs(AllyTable) do
		if i == 1 and Config.InSettings.Apos.AA == Prior then
			if GetDistance(ally, targ) < 1200 + 300 and GetDistance(ally, targ) > 500 then
				if Config.InSettings.Apos.Ahp < ((ally.health/ally.maxHealth)*100) then
					return ally
				else
					return getAlly(Prior + 1, targ)
				end
			else 
				return getAlly(Prior + 1, targ)
			end
		end
		if i == 2 and Config.InSettings.Apos.AB == Prior then
			if GetDistance(ally, targ) < 1200 + 300 then
				if Config.InSettings.Apos.Ahp < ((ally.health/ally.maxHealth)*100) then
					return ally
				else
					return getAlly(Prior + 1, targ)
				end
			else 
				return getAlly(Prior + 1, targ)
			end
		end
		if i == 3 and Config.InSettings.Apos.AC == Prior then
			if GetDistance(ally, targ) < 1200 + 300 then
				if Config.InSettings.Apos.Ahp < ((ally.health/ally.maxHealth)*100) then
					return ally
				else
					return getAlly(Prior + 1, targ)
				end
			else 
				return getAlly(Prior + 1, targ)
			end
		end
		if i == 4 and Config.InSettings.Apos.AD == Prior then
			if GetDistance(ally, targ) < 1200 + 300 then
				if Config.InSettings.Apos.Ahp < ((ally.health/ally.maxHealth)*100) then
					return ally
				else
					if Prior == 4 then return nil else getAlly(Prior + 1, targ) end
				end
			else 
				if Prior == 4 then return nil else getAlly(Prior + 1, targ) end
			end
		end
	end
	if Prior < 4 then return getAlly(Prior + 1, targ) else return nil end
end

function GetReverseVector(targ, dest, distance)
	local vectorX,y,vectorZ = (Vector(dest) - Vector(targ)):normalized():unpack()
	if distance == nil then distance = 150 end
	local pos = Vector(targ.x + (vectorX * distance),y, targ.z + (vectorZ * distance))
	return pos
end

function GetVector(targ, dest, distance)
	local vectorX,y,vectorZ = (Vector(dest) - Vector(targ)):normalized():unpack()
	if distance == nil then distance = 150 end
	local pos = Vector(targ.x - (vectorX * distance),y, targ.z - (vectorZ * distance))
	return pos
end

function GetNearestTurret(targ)
	--Purple = T2
	--blue = T1
	local distance = 99999
	local closest = nil
	for _, turret in pairs(turrets) do
		if GetDistance(turret, targ) < distance then
			distance = GetDistance(turret, targ)
			closest = turret
		end
	end
	return closest
end

function Vpred(targ, isQ)
	local CastPosition = nil
	local HitChance = nil
	if isQ then
		CastPosition, HitChance = VP:GetLineCastPosition(targ, 0.250, 70, 1000, 1800)
		return CastPosition, HitChance
	end
	if not isQ then
		CastPosition = VP:GetCircularCastPosition(targ, 0.250, 70, 2000, 1500)
		if CastPosition ~= nil then return CastPosition end
	end
end







function PredInsec()
	if Config.SSettings.Vpred and not Config.SSettings.Prod then
		local pos, hit = VP:GetLineCastPosition(Target, 0.250, 100, 600, 1500)
		if (hit == 2 or hit == 4 or hit == 5) and pos ~= nil then
			return pos
		else return nil end
	end
	if Config.SSettings.Prod and not Config.SSettings.Vpred then
		if PQI ~= nil and GetDistance(PQI, myHero) < 300 then 
			return PQI
		else
			return nil
		end
	end
	if (not Config.SSettings.Prod and not Config.SSettings.Vpred) or (Config.SSettings.Prod and Config.SSettings.Vpred) then
		return nil
	end
end


function useQ(targ)
	if targ == nil then
		if VIP_USER and Config.SSettings.Packet then
			Packet("S_CAST", {spellId = _Q}):send()
		else
			CastSpell(_Q)
		end
	else
		if VIP_USER and Config.SSettings.Packet then
			Packet("S_CAST", {spellId = _Q, toX = targ.x, toY = targ.z , fromX = targ.x , fromY = targ.z }):send()
		else
			CastSpell(_Q, targ.x, targ.z)
		end
	end
end

function useW(targ)
	if targ~=nil then 
		CastSpell(_W, targ)	
	else
		if VIP_USER and Config.SSettings.Packet then
			Packet("S_CAST", {spellId = _W}):send()
		else
			CastSpell(_W)
		end
	end
end

function useE()
	if VIP_USER and Config.SSettings.Packet then
		 Packet("S_CAST", {spellId = _E}):send()
	else
		CastSpell(_E)
	end
end

function useR(targ)
	if VIP_USER and Config.SSettings.Packet then
		Packet("S_CAST", {spellId = _R, targetNetworkId = targ.networkID}):send()
	else 
		CastSpell(_R, targ)
	end
end

function GetHitBox(unit)
	if unit ~= nil then
		local foo = hitBoxes[unit.charName]
		if foo ~= nil then return foo else return 65 end
	else
		return 65
	end
end

--[[
function QoneCheck(targ)
	local collision = nil
	if targ.type == "obj_AI_Minion" and GetDistance(targ, myHero) < Qrange then useQ(targ) end
	if Config.SSettings.CheckQCollisions and targ.type ~= "obj_AI_Minion" and (not Config.InSettings.col and Config.Insec) then
		local foo, foo2 = CheckMinionCollision(targ)
		if foo2 and foo ~= nil and Config.SSettings.smite and smite ~= nil and GetDistance(foo2, myHero) < 750 then
			if Srdy and SmiteDmg() > foo.health then
				CastSpell(smite, foo)
			end
		end
		if foo2 then return end
	end
	if Config.SSettings.Vpred and not Config.SSettings.Prod then
		local foo, hit = Vpred(targ, true)
		if hit == 2 or hit == 4 or hit == 5 then
			if foo ~= nil and GetDistance (foo,myHero) < Qrange then
				useQ(foo)
			end
		end
	elseif Config.SSettings.Prod and not Config.SSettings.Vpred and VIP_USER then
		if PQP ~= nil and GetDistance (PQP,myHero) < Qrange then useQ(PQP) end			
	elseif GetDistance (targ,myHero) < Qrange then
		useQ(targ)
	end
end
]]--
function QoneCheck(targ)
	local hit
	local pos
	local useq = false
	if targ.type == "obj_AI_Minion" and GetDistance(targ, myHero) < 1100 then useQ(targ) end
	if Config.SSettings.Vpred and not Config.SSettings.Prod then
		pos, hit = Vpred(targ,true)
		if (hit == 2 or hit == 4 or hit == 5) and pos ~= nil then
			useq = true
		end
	end
	if Config.SSettings.Prod and not Config.SSettings.Vpred then
		if PQP ~= nil and GetDistance(PQP, myHero) < 1100 then 
			pos = PQP 
			useq = true 
		end
	end
	if ((not Config.SSettings.Prod and not Config.SSettings.Vpred) or (Config.SSettings.Prod and Config.SSettings.Vpred)) and GetDistance(targ, myHero) < 1100 then
		pos = targ
		useq = true
	end
	
	
	if Config.SSettings.CheckQCollisions and targ.type ~= "obj_AI_Minion" then
		if Config.Insec then
			if not Config.InSettings.col then
				local minion, bval
				if pos ~= nil then minion, bval = CheckMinionCollision(pos) else minion, bval = CheckMinionCollision(targ) end
				if bval then
					if minion ~= nil then
						mdraw = minion
						local foo = handle_Col(minion,bval)
						useq = foo
					end
				else
					useq = true
					mdraw = 0
				end
			end
		else
			local minion, bval
			if pos ~= nil then minion, bval = CheckMinionCollision(pos) else minion, bval = CheckMinionCollision(targ) end
			if bval then
				useq = false
				if minion ~= nil then
					mdraw = minion
					handle_Col(minion,bval)
				end
			else
				useq = true
				mdraw = 0
			end
		end
	end
	if useq then
		useQ(pos)
	end
end

function handle_Col(minion, col)
	if col then
		if minion ~= nil and Config.SSettings.smite and smite ~= nil and GetDistance(minion, myHero) < 750 then
			if Srdy and SmiteDmg() > minion.health then
				CastSpell(smite, minion)
			end
		end
	end
end

function CheckCollision(unit, targ)
	if targ ~= nil and unit ~= nil then
		local projection, pointline, isonsegment = VectorPointProjectionOnLineSegment(Vector(myHero), targ, Vector(unit))
		if projection ~= nil and pointline ~= nil and isonsegment ~= nil then
			if isonsegment and (GetDistanceSqr(unit, projection) <= (GetHitBox(unit) + 75)^2) then
				return true
			end
		end
	end
	return false
end

function CheckMinionCollision(targ)
	Minions:update()
	JungleMinions:update()
	
	local result = false
	for i, minion in ipairs(Minions.objects) do
		if minion ~= nil then
			if CheckCollision(minion, targ) then
				return minion, true
			end
		end
	end
	for i, minion in ipairs(JungleMinions.objects) do
		if minion ~= nil then
			if CheckCollision(minion, targ) then
				return minion, true
			end
		end
	end
	return nil, false
end

function CheckUltCollision(targ)
	local vectorX,y,vectorZ = (Vector(myHero) - Vector(targ)):normalized():unpack()
	local pos = Vector(targ.x - (vectorX * 1200),y, targ.z - (vectorZ * 1200))
	local hits = 1
	for i, enemy in pairs(EnemyTable) do
		local projection, pointline, isonsegment = VectorPointProjectionOnLineSegment(myHero.visionPos, pos, pos)
		if isonsegment and (GetDistanceSqr(targ.visionPos, projection) <= (70 + 70)^2) then
			hits = hits + 1
		end
	end
	if hits > 2 then return true else return false end
end

function SmiteDmg()
	if myHero.level == 1 then return 390 end
	if myHero.level == 2 then return 410 end
	if myHero.level == 3 then return 430 end
	if myHero.level == 4 then return 450 end
	if myHero.level == 5 then return 480 end
	if myHero.level == 6 then return 510 end
	if myHero.level == 7 then return 540 end
	if myHero.level == 8 then return 570 end
	if myHero.level == 9 then return 600 end
	if myHero.level == 10 then return 640 end
	if myHero.level == 11 then return 680 end
	if myHero.level == 12 then return 720 end
	if myHero.level == 13 then return 760 end
	if myHero.level == 14 then return 800 end
	if myHero.level == 15 then return 850 end
	if myHero.level == 16 then return 900 end
	if myHero.level == 17 then return 950 end
	if myHero.level == 18 then return 1000 end
end