local version = "1.45"

local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "JTrist"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Jarvis101/BoL/master/JTrist.lua?rand="..math.random(1000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if autoupdateenabled then
	GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
	function update()
		if ServerData ~= nil then
			local ServerVersion
			local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
			if sstart then
				send, tmp = string.find(ServerData, "\"", sstart+1)
			end
			if send then
				ServerVersion = string.sub(ServerData, sstart+1, send-1)
			end

			if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
				DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. ("..version.." => "..ServerVersion.."). Press F9 Twice to Re-load.</font>") end)     
			elseif ServerVersion then
				print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
			end		
			ServerData = nil
		end
	end
	AddTickCallback(update)
end

if myHero.charName ~= "Tristana" then return end

require "SOW"
require "VPrediction"

if VIP_USER then
	require "Prodiction"
end

local Wused = false
local Wrange = 900
local Wdelay = 0

local Prod
local ProdW

local ToInterrupt = {}

local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
    { charName = "Warwick", spellName = "InfiniteDuress"},
	{ charName = "Yasuo", spellName = "YasuoRKnockUpComboW"},
	{ charName = "Velkoz", spellName = "VelkozR"},
	{ charName = "MonkeyKing", spellName = "MonkeyKingSpinToWin"}
}

function InitInterrupt()
	for i = 1, heroManager.iCount, 1 do
		local enemy = heroManager:getHero(i)
		if enemy.team ~= myHero.team then
			for _, champ in pairs(InterruptList) do
				if enemy.charName == champ.charName then
					table.insert(ToInterrupt, champ.spellName)
				end
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 and JTrist.IntOpt and Rrdy then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
				if GetDistance(unit,myHero) <= (getTrange() - 10) then
					CastR(unit)
				end
			end
		end
	end
end

function Menu()

    JTrist = scriptConfig("JTrist", "JTrist")
	
    JTrist:addSubMenu("Combo", "CSettings")
    JTrist.CSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
    JTrist.CSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	JTrist.CSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    JTrist.CSettings:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
	JTrist.CSettings:addParam("useI", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
	
	JTrist:addSubMenu("Harass", "HSettings")
	JTrist.HSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
    JTrist.HSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
	JTrist.HSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
	
	JTrist:addSubMenu("Skill Settings", "SSettings")
	JTrist.SSettings:addSubMenu("W Settings", "WSettings")
	JTrist.SSettings.WSettings:addParam("Vpred", "Use Vprediction for W", SCRIPT_PARAM_ONOFF, true)
	JTrist.SSettings.WSettings:addParam("Prod", "(not working)", SCRIPT_PARAM_ONOFF, false)
	JTrist.SSettings.WSettings:addParam("Ak", "Don't use W if more than #", SCRIPT_PARAM_INFO, "")
	JTrist.SSettings.WSettings:addParam("safeW", "enemies around", SCRIPT_PARAM_SLICE, 4, 1, 4, 0)
	JTrist.SSettings.WSettings:addParam("safeWrange", "Safety Distance", SCRIPT_PARAM_SLICE, 1000, 500 , 2000, 0)
	JTrist.SSettings.WSettings:addParam("vectoredW", "Try to jump in front of the target", SCRIPT_PARAM_ONOFF, false)
	JTrist.SSettings.WSettings:addParam("Wdelay", "Give W 1s internal CD", SCRIPT_PARAM_ONOFF, true)
	JTrist.SSettings.WSettings:addParam("Wdval", "Delay for W cd", SCRIPT_PARAM_SLICE, 1.0, 0 , 2.5, 1)
    JTrist:addSubMenu("Interrupt Opts", "IntOpt")
    JTrist.IntOpt:addParam("IntOpt", "Interrupt channels and dangerous spells", SCRIPT_PARAM_ONOFF, true)

    JTrist:addSubMenu("Item Settings", "ISettings")
    JTrist.ISettings:addParam("IuseC", "Use items in combo", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings:addSubMenu("Combo Items", "Citems")
    JTrist.ISettings.Citems:addParam("BOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, true)
    JTrist.ISettings.Citems:addParam("BWC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
    JTrist.ISettings.Citems:addParam("DFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("DFGwait", "Use DFG before E and R", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("HEX", "Use Hextech Revolver", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("FQC", "Use Frost Queen's Claim", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("SOTD", "Use Sword of the Divine", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("YGB", "Use Yomuu's Ghost Blade", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings:addParam("IuseH", "Use items in harass", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings:addSubMenu("Harass Items", "Hitems")
    JTrist.ISettings.Hitems:addParam("BOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, false)
    JTrist.ISettings.Hitems:addParam("BWC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, false)
    JTrist.ISettings.Hitems:addParam("DFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings.Hitems:addParam("HEX", "Use Hextech Revolver", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings.Hitems:addParam("FQC", "Use Frost Queen's Claim", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings.Hitems:addParam("SOTD", "Use Sword of the Divine", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings.Hitems:addParam("YGB", "Use Yomuu's Ghost Blade", SCRIPT_PARAM_ONOFF, false)

    JTrist:addSubMenu("KS", "KS")
    JTrist.KS:addParam("ksW", "KS with W", SCRIPT_PARAM_ONOFF, true)
    JTrist.KS:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
    JTrist.KS:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)

	
	JTrist:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JTrist:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	JTrist:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	JTrist:addParam("Intercept","Intercept", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))

    JTrist:addSubMenu("draw", "draw")
    JTrist.draw:addParam("drawAA", "Draw AA/E/R Range", SCRIPT_PARAM_ONOFF, true)
    JTrist.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    JTrist.draw:addParam("drawKill", "Draw Kill text", SCRIPT_PARAM_ONOFF, true)
	JTrist:addSubMenu("Orbwalker", "SOWiorb")
	SOWi:LoadToMenu(JTrist.SOWiorb)
	
	JTrist:permaShow("Combo")
    JTrist:permaShow("Harass")
    JTrist:permaShow("Intercept")
end

function OnLoad()
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:RegisterAfterAttackCallback(AutoAttackReset)
	Menu()
	InitInterrupt()
	if VIP_USER then
		Prod = ProdictManager.GetInstance()
		ProdW = Prod:AddProdictionObject(_W, 900, 700, 0.250, 250)
	end
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
	end
	
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1100, DAMAGE_PHYSICAL)	
	ts.name = "Tristana"
	JTrist:addTS(ts)
end

function checkItems()
	HexTech = GetInventorySlotItem(3146)
	HexTechR = (HexTech ~= nil and myHero:CanUseSpell(HexTech))
	BilgeWaterCutlass = GetInventorySlotItem(3144)
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
	DFG = GetInventorySlotItem(3128)
	DFGR = (DFG ~= nil and myHero:CanUseSpell(DFG) == READY)
	FQC = GetInventorySlotItem(3092)
	FQCR = (FQC ~= nil and myHero:CanUseSpell(FQC) == READY)
	YGB = GetInventorySlotItem(3142)
	YGBR = (YGB ~= nil and myHero:CanUseSpell(YGB) == READY)
	BotRK = GetInventorySlotItem(3153)
	BotRKR = (BotRK ~= nil and myHero:CanUseSpell(BotRK) == READY)
	SotD = GetInventorySlotItem(3131)
	SotDR = (SotD ~= nil and myHero:CanUseSpell(YGB) == READY)
end

function getAAdmg(targ)
	local Mdmg = getDmg("P", targ, myHero)
	local Admg = getDmg("AD", targ, myHero)
	local returnval = Mdmg + Admg
	return returnval
end

function getTrange()
	return myHero.range + 150
end

function OnDraw()
	if JTrist.draw.drawAA then
		SOWi:DrawAARange()
	end
	if JTrist.draw.drawW then
		DrawCircle(myHero.x, myHero.y, myHero.z, 900, ARGB(214,1,33,0))
	end
	if JTrist.draw.drawKill then
		for i=1, heroManager.iCount, 1 do
			local champ = heroManager:GetHero(i)
			if ValidTarget(champ) and champ.team ~= myHero.team then
				DrawText3D(analyzeCombat(champ), champ.x, champ.y, champ.z, 20, RGB(255, 255, 255), true)
			end
		end
	end
end

function OnTick()
	ts:update()
	Target = ts.target	
	
	Qrdy = (myHero:CanUseSpell(_Q) == READY)
	Wrdy = (myHero:CanUseSpell(_W) == READY)
	Erdy = (myHero:CanUseSpell(_E) == READY)
	Rrdy = (myHero:CanUseSpell(_R) == READY)
	Irdy = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	checkItems()
	if VIP_USER and JTrist.SSettings.Prod and Target ~= nil then
		PQP=ProdQ:GetPrediction(Target)
	end
	KS()
	if JTrist.Combo and Target ~= nil then
		Combo()
	end
	if JTrist.Harass and Target ~= nil then
		Harass()
	end
	if JTrist.Intercept and Target ~= nil then
		IntPult()
	end
end

function KS()
	local targ = nil
	local wkill = false
	local rkill = false
	local rwkill = false
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) and GetDistance(champ,myHero) < 1500 then
			if getDmg("W", champ, myHero) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < 900 then
				wkill = true
				targ = champ
				break
			end
			if getDmg("R", champ, myHero) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < getTrange() then
				rkill = true
				targ = champ
				break
			end
			if (getDmg("R", champ, myHero) + getDmg("E", champ, myHero)) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < 900 then
				rwkill = true
				targ = champ
				break
			end
		end
	end
	if targ ~= nil then
		if JTrist.KS.ksW and Wrdy and wkill then
			local dest = CheckW(targ, false, false)
			if dest ~= nil then castW(dest) end
		end
		if JTrist.KS.ksR and Rrdy and rkill then
			castR(targ)
		end
		if JTrist.KS.ksW and JTrist.KS.ksR and Wrdy and Rrdy and rwkill then
			local dest = CheckW(targ, false, true)
			if dest ~= nil then castW(dest) end
		end
		if ignite ~= nil then
			if JTrist.KS.useI and targ.health < getDmg("IGNITE", targ, myHero) and GetDistance(targ, myHero) < 500 and Irdy then
				CastSpell(ignite, targ)
			end
		end
	end
end

function Combo()
	if JTrist.ISettings.IuseC then
		if JTrist.ISettings.Citems.BOTRK and BotRKR and GetDistance(Target, myHero) < 450 then
			CastSpell(BotRK, Target)
		end
		if JTrist.ISettings.Citems.DFG and DFGR and GetDistance(Target, myHero) < 500 then
			CastSpell(DFG, Target)
		end
		if JTrist.ISettings.Citems.HEX and HexTechR and GetDistance(Target, myHero) < 500 then
			CastSpell(HexTech, Target)
		end
		if JTrist.ISettings.Citems.FQC and FQCR and GetDistance(Target, myHero) < 850 then
			CastSpell(FQC, Target)
		end
		if JTrist.ISettings.Citems.YGB and YGBR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(YGB)
		end
		if JTrist.ISettings.Citems.SOTD and SotDR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(SotD)
		end
		if JTrist.ISettings.Citems.BWC and BilgeWaterCutlassR and GetDistance(Target, myHero) < 500 then
			CastSpell(BilgeWaterCutlass)
		end
	end
    if JTrist.CSettings.useQ then
        if Qrdy and (GetDistance(Target) < getTrange()) then
            castQ()
        end
    end
    if JTrist.CSettings.useW then
        local dest = CheckW(Target, JTrist.SSettings.WSettings.vectoredW, false)
		if dest ~= nil then castW(dest) end
    end
    if JTrist.CSettings.useE then
        if Erdy and (GetDistance(Target) < getTrange()) then
			if JTrist.ISettings.Citems.DFGwait and not DFGR then
				castE(Target)
			end
			if not JTrist.ISettings.Citems.DFGwait then
				castE(Target)
			end
        end
    end
    if JTrist.CSettings.useR then
        if Rrdy and (GetDistance(Target) < getTrange()) then
            if JTrist.ISettings.Citems.DFGwait and not DFGR then
				castR(Target)
			end
			if not JTrist.ISettings.Citems.DFGwait then
				castR(Target)
			end
        end
    end
	if ignite ~= nil then
		if JTrist.CSettings.useI and Irdy and GetDistance(Target, myHero) < 500 then
			CastSpell(ignite, Target)
		end
	end
end

function Harass()
	if JTrist.ISettings.IuseH then
		if JTrist.ISettings.Hitems.BOTRK and BotRKR and GetDistance(Target, myHero) < 450 then
			CastSpell(BotRK, Target)
		end
		if JTrist.ISettings.Hitems.DFG and DFGR and GetDistance(Target, myHero) < 500 then
			CastSpell(DFG, Target)
		end
		if JTrist.ISettings.Hitems.HEX and HexTechR and GetDistance(Target, myHero) < 500 then
			CastSpell(HexTech, Target)
		end
		if JTrist.ISettings.Hitems.FQC and FQCR and GetDistance(Target, myHero) < 850 then
			CastSpell(FQC, Target)
		end
		if JTrist.ISettings.Hitems.YGB and YGBR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(YGB)
		end
		if JTrist.ISettings.Hitems.SOTD and SotDR and GetDistance(Target, myHero) < getTrange() then
			CastSpell(SotD)
		end
		if JTrist.ISettings.Hitems.BWC and BilgeWaterCutlassR and GetDistance(Target, myHero) < 500 then
			CastSpell(BilgeWaterCutlass)
		end
	end
	if JTrist.HSettings.useW then
		local dest = checkW(Target, JTrist.SSettings.WSettings.vectoredW, false)
		if dest ~= nil then castW(dest) end
    end
	if JTrist.HSettings.useE then
		if Erdy and GetDistance(Target, myHero) < getTrange() then
			castE(Target)
		end
	end
end

function IntPult()
	if Wrdy and Rrdy and not Wused then
		local dest = CheckW(Target, true, true)
		if dest ~= nil then castW(dest) end
	end
end

function OnCreateObj(object)
	if object.name == "tristana_rocketJump_land.troy" then
		if Wused == true then
			Wused = false
			castR(Target)
		end
	end
	if object.name == "tristana_rocketJump_cas.troy" then
		Wdelay = os.clock()
	end
end

function castQ()
	if VIP_USER then
		Packet("S_CAST", {spellId = _Q}):send()
	else
		CastSpell(_Q)
	end
end

function castW(targ)
	if VIP_USER then
		Packet('S_CAST', { spellId = _W, toX = targ.x, toY = targ.z , fromX = targ.x , fromY = targ.z }):send()	
	else
		CastSpell(_W, targ.x, targ.z)
	end
end

function castE(targ)
	if VIP_USER then
		Packet("S_CAST", {spellId = _E, targetNetworkId = targ.networkID}):send()
	else
		CastSpell(_E, targ)
	end
end

function castR(targ)
	if VIP_USER then
		Packet("S_CAST", {spellId = _R, targetNetworkId = targ.networkID}):send()
	else
		CastSpell(_R, targ)
	end
end

function SafetyCheck(range, targ)
    local danger = 0
    for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) and GetDistance(champ, targ) < range and champ ~= targ then
			danger = danger + 1
		end
    end
    return danger
end

function CheckW(targ, vectored, forceR)
	if not Wrdy then return nil, nil end
	if JTrist.SSettings.WSettings.Wdelay and ((Wdelay + JTrist.SSettings.WSettings.Wdval) > os.clock()) then return nil, nil end
	local CastPosition = nil
	local HitChance = nil
	if JTrist.SSettings.WSettings.Vpred and not JTrist.SSettings.WSettings.Prod then
		CastPosition, HitChance = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
		if HitChance == 2 or HitChance == 4 or HitChance == 5 then
			if vectored then
				local foo = GetVector(CastPosition, myHero)
				if foo ~= nil and  GetDistance(foo, myHero) < Wrange then 
					if forceR then Wused = true end
					return foo 
				else 
					return nil 
				end
			else
				if GetDistance(CastPosition, myHero) < Wrange then 
					if forceR then Wused = true end
					return CastPosition 
				else 
					return nil 
				end
			end
		end
	end
	if not JTrist.SSettings.WSettings.Vpred and JTrist.SSettings.WSettings.Prod then
		if vectored then
			if PQP ~= nil then
				local foo = GetVector(targ, myHero)
				if foo ~= nil and GetDistance(foo, myHero) < Wrange then
					return foo
				end
			end
		else
			if PQP ~= nil and GetDistance (PQP,myHero) < Qrange then return PQP else return nil end
		end
	else
		if vectored then
			local foo = GetVector(targ, myHero)
			ttype = "free"
			if GetDistance(Destination, myHero) < Wrange then
				if forceR then Wused = true end
				return foo 
			else 
				return nil 
			end
		else
			if GetDistance(targ, myHero) < Wrange then 
				if forceR then Wused = true end
				return targ 
			else 
				return nil
			end
		end
	end			
end

function GetVector(targ, dest, distance)
	local vectorX,y,vectorZ = (Vector(dest) - Vector(targ)):normalized():unpack()
	if distance == nil then distance = 150 end
	local pos = Vector(targ.x - (vectorX * distance),y, targ.z - (vectorZ * distance))
	return pos
end

function analyzeCombat(targ)
	local Wdmg = getDmg("W", targ, myHero)
	local Edmg = getDmg("E", targ, myHero, 3)
	local Rdmg = getDmg("R", targ, myHero)
	local AAdmg = getDmg("AD", targ, myHero)
	local idmg = getDmg("IGNITE", targ, myHero)
	local Lichdmg = (Lich and getDmg("LICHBANE", targ, myHero) or 0)
	local HexTechdmg = (HexTech and getDmg("HXG", targ, myHero) or 0)
	local Blgdmg = (BilgeWaterCutlass and getDmg("BWC", targ, myHero) or 0)
	local dfgdmg = (DFG and getDmg("DFG", targ, myHero) or 0)
	local rTxt = ""
	
	if not Irdy then idmg = 0 end
	local Cdmg = 0
	if DFGR then
		Cdmg = ((Wdmg + Edmg + Rdmg)*1.2)
		if Lichdmg ~= nil then Cdmg = Cdmg + Lichdmg end
		if dfgdmg ~= nil then Cdmg = Cdmg + dfgdmg end
		if hexTechdmg ~= nil then Cdmg = Cdmg + hexTechdmg end
		if Blgdmg ~= nil then Cdmg = Cdmg + Blgdmg end
	else
		Cdmg = Wdmg + Edmg + Rdmg
		if Lichdmg ~= nil then Cdmg = Cdmg + Lichdmg end
		if HexTechdmg ~= nil then Cdmg = Cdmg + hexTechdmg end
		if Blgdmg ~= nil then Cdmg = Cdmg + Blgdmg end		
	end
	
	if targ.health < Cdmg then
		rTxt = "Burst him!"
	else 
		rTxt = "Harassable"
	end
	
	return rTxt
end