

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

function checkitems()
	local ward1 = GetInventorySlotItem(2049)
	local ward1R = (ward1 ~= nil and myHero:CanUseSpell(ward1) == READY)
	local ward2 = GetInventorySlotItem(2045)
	local ward2R = (ward2 ~= nil and myHero:CanUseSpell(ward2) == READY)
	local ward3 = GetInventorySlotItem(3340)
	local ward3R = (ward3 ~= nil and myHero:CanUseSpell(ward3) == READY)
	local ward4 = GetInventorySlotItem(2044)
	local ward4R = (ward4 ~= nil and myHero:CanUseSpell(ward4) == READY)
	local ward5 = GetInventorySlotItem(3361)
	local ward5R = (ward5 ~= nil and myHero:CanUseSpell(ward5) == READY)
	local ward6 = GetInventorySlotItem(3362)
	local ward6R = (ward6 ~= nil and myHero:CanUseSpell(ward6) == READY)
	local ward7 = GetInventorySlotItem(3154)
	local ward7R = (ward7 ~= nil and myHero:CanUseSpell(ward7) == READY)
	local ward8 = GetInventorySlotItem(3160)
	local ward8R = (ward8 ~= nil and myHero:CanUseSpell(ward8) == READY)
	local ward9 = GetInventorySlotItem(3340)
	local ward9R = (ward8 ~= nil and myHero:CanUseSpell(ward8) == READY)
	
	ward = nil
	
	if ward1R then ward = ward1
	elseif ward2R then ward = ward2
	elseif ward3R then ward = ward3
	elseif ward4R then ward = ward4
	elseif ward5R then ward = ward5
	elseif ward6R then ward = ward6
	elseif ward7R then ward = ward7
	elseif ward8R then ward = ward8
	elseif ward9R then ward = ward9	end
	
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
		ProdQ = Prod:AddProdictionObject(_Q, 1100, 1800, 0.250, 70)
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
end

function Menu()
	Config = scriptConfig("OP Lee", "Config")
	
	Config:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	Config:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	Config:addParam("Mobile","Mobility", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	Config:addParam("Insec","Insec", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Config:addParam("WardJump","WardJump", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	
	Config:addSubMenu("Skills", "SSettings")
	
	
	Config:addSubMenu("Combo", "CSettings")
	Config.CSettings:addParam("useQ","Use 1st Q in combo", SCRIPT_PARAM_ONOFF, true)
	Config.CSettings:addParam("useW","Use 1st W to chase/position", SCRIPT_PARAM_ONOFF, false)
	Config.CSettings:addParam("useE","Use 1st E in combo", SCRIPT_PARAM_ONOFF, true)
	Config.CSettings:addParam("useR","Use R in combo", SCRIPT_PARAM_ONOFF, true)
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
	Config.SSettings:addParam("Vpred","Use Vprediction", SCRIPT_PARAM_ONOFF, true)
	Config.SSettings:addParam("Prod","Use Prodiction(VIP ONLY)", SCRIPT_PARAM_ONOFF, false)
	Config.SSettings:addParam("Packet","Use Packets(VIP ONLY)", SCRIPT_PARAM_ONOFF, true)
	Config.SSettings:addParam("CheckQCollisions","check for minion collision on Q", SCRIPT_PARAM_ONOFF, true)
	Config.SSettings:addParam("smite","Smite minion collisions for Q", SCRIPT_PARAM_ONOFF, true)
	Config.SSettings:addParam("alwaysinsec","always insec R", SCRIPT_PARAM_ONOFF, true)
	
	
	Config:addSubMenu("Insec Settings", "InSettings")
	Config.InSettings:addParam("jkick","Jump kick if flash unavailable(WIP)", SCRIPT_PARAM_ONOFF, true)
	Config.InSettings:addParam("flash","Use Flash(WIP)", SCRIPT_PARAM_ONOFF, true)
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
		DrawCircle(myHero.x, myHero.y, myHero.z, 590, ARGB(214,1,1,33))
	end
end

function KS()
	for i, enemy in pairs(EnemyTable) do 
		if ValidTarget(enemy) then
			if Config.KS.useQ and Qrdy and enemy.health < getDmg("Q", enemy, myHero) and GetDistance(enemy, myHero) < 1100 then
				QoneCheck(enemy)
			end
			if Config.KS.useE and Erdy and enemy.health < getDmg("E", enemy, myHero) and GetDistance(enemy, myHero) < 400 then 
				useW()
			end
			if Rrdy and Config.KS.useR and enemy.health < getDmg("R", enemy, myHero) and GetDistance(enemy, myHero) < 325 then
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
		Rcheck(Target)
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
			if wardR then
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

function Mobile(isInsec, noward)
	if noward == nil then
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
				else
					local foo2 = getNearestTarget(mousePos, true)
					if foo2 ~= nil then
						if GetDistance(foo2, myHero) < 700 then useW(foo2) end
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
	if (Frdy and Rrdy and Config.InSettings.flash) then
		if GetDistance(Target, myHero) > 300 then
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
					PrintChat("should ward")
					if JkickPos == nil then PrintChat("nil error") end
					CastSpell(ward, JkickPos.x, JkickPos.z)
				else
					PrintChat("Ward not ready, no ward placed")
				end
			elseif not Wrdy or myW.name ~= "BlindMonkWOne" then
				useR(Target)
			end
		end
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
				if Frdy and Config.InSettings.flash then
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
	if GetDistance(targ) < 1300 then
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

function Debug()
	for i = 1, 4000 do
		local item = GetInventorySlotItem(i)
		local itemR = (item ~= nil and myHero:CanUseSpell(item))
		if itemR then PrintChat(tostring(i)) end
	end
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
	if Prior ~= 4 then return getAlly(Prior + 1, targ) end
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
		CastPosition, HitChance = VP:GetLineCastPosition(targ, 0.250, 70, 1100, 1800)
		return CastPosition, HitChance
	end
	if not isQ then
		CastPosition = VP:GetCircularCastPosition(targ, 0.250, 70, 2000, 1500)
		if CastPosition ~= nil then return CastPosition end
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

function GetHitBox(minion)
	if minion.charName:lower():find("mech") then return 65.0 end
	if minion.charName:lower():find("wizard") then return 48.0 end
	if minion.charName:lower():find("basic") then return 48.0 end
	if minion.charName:lower():find("wolf") then return 50.0 end
	if minion.charName:lower():find("wraith") then return 50.0 end
	if minion.charName:lower():find("golem") then return 80.0 end
	if minion.charName:lower():find("dragon") then return 100.0 end
	if minion.charName:lower():find("lizard") then return 80.0 end
	if minion.charName:lower():find("worm") then return 100.0 end
	return 50
end

function QoneCheck(targ)
	local collision = nil
	if targ.type == "obj_AI_Minion" and GetDistance(targ, myHero) < Qrange then useQ(targ) end
	if Config.SSettings.CheckQCollisions and targ.type ~= "obj_AI_Minion" then
		if (not Config.InSettings.col and Config.Insec) then
			local foo, foo2 = CheckMinionCollision(targ)
			if foo2 and foo2 ~= nil and Config.SSettings.smite and smite ~= nil and GetDistance(foo2, myHero) < 750 then
				if Srdy and SmiteDmg() > foo.health then
					CastSpell(smite, foo)
				end
			end
			if foo2 then PrintChat("Collision") return end
		end
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

function CheckCollision(unit, minion, from)
	if minion ~= nil and unit ~= nil and from ~= nil then
		local projection, pointline, isonsegment = VectorPointProjectionOnLineSegment(from, unit, Vector(minion.visionPos))
		if projection ~= nil and pointline ~= nil and isonsegment ~= nil then
			if isonsegment and (GetDistanceSqr(minion.visionPos, projection) <= (GetHitBox(minion) + 70)^2) then
				return true
			end
		end
	end
	return false
end

function CheckMinionCollision(targ)
	Minions:update()
	JungleMinions:update()
	from = myHero.visionPos
	
	local result = false
		for i, minion in ipairs(Minions.objects) do
			if CheckCollision(targ, minion, from) then
				return minion, true
			end
		end
		for i, minion in ipairs(JungleMinions.objects) do
			if CheckCollision(unit, minion, from) then
				return minion, true
			end
		end
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