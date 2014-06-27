local version = "0.1"
--[[JTrist by Jarvis101
]]--


if myHero.charName ~= "Tristana" then return end
local AUTOUPDATE = true
local UPDATE_SCRIPT_NAME = "JTrist"
local UPDATE_NAME = "JTrist"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Jarvis101/BoL/master/JTrist.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>"..UPDATE_NAME..":</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH, "", 5)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)	 
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

require "SOW"
require "VPrediction"

local Wused = false
--[[
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
]]--
function Menu()

    JTrist = scriptConfig("JTrist", "JTrist")
	
    JTrist:addSubMenu("Combo", "CSettings")
    JTrist.CSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
    JTrist.CSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	JTrist.CSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    JTrist.CSettings:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
    JTrist.CSettings:addSubMenu("W Settings", "WSettings")
	JTrist.CSettings.WSettings:addParam("Ak", "Don't use W if more than #", SCRIPT_PARAM_INFO, "")
    JTrist.CSettings.WSettings:addParam("safeW", "enemies around", SCRIPT_PARAM_SLICE, 2, 1, 4, 0)
    JTrist.CSettings.WSettings:addParam("safeWrange", "Safety Distance", SCRIPT_PARAM_SLICE, 1000, 500 , 2000, 0)
	JTrist.CSettings.WSettings:addParam("vectoredW", "Try to jump in front of the target", SCRIPT_PARAM_ONOFF, true)
	
	JTrist:addSubMenu("Harass", "HSettings")
	JTrist.HSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
    JTrist.HSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
	JTrist.HSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
	JTrist.HSettings:addSubMenu("W Settings", "WSettings")
	JTrist.HSettings.WSettings:addParam("Ak", "Don't use W if more than #", SCRIPT_PARAM_INFO, "")
	JTrist.HSettings.WSettings:addParam("safeW", "enemies around", SCRIPT_PARAM_SLICE, 2, 1, 4, 0)
	JTrist.HSettings.WSettings:addParam("safeWrange", "Safety Distance", SCRIPT_PARAM_SLICE, 1000, 500 , 2000, 0)
	JTrist.HSettings.WSettings:addParam("vectoredW", "Try to jump in front of the target", SCRIPT_PARAM_ONOFF, true)
	
    JTrist:addSubMenu("IntOpt", "IntOpt")
    JTrist.IntOpt:addParam("IntOpt", "Interrupt channels and dangerous spells", SCRIPT_PARAM_ONOFF, true)

    JTrist:addSubMenu("ISettings", "ISettings")
    JTrist.ISettings:addParam("IuseC", "Use items in combo", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings:addSubMenu("Combo Items", "Citems")
    JTrist.ISettings.Citems:addParam("BOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, true)
    JTrist.ISettings.Citems:addParam("BWC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
    JTrist.ISettings.Citems:addParam("DFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("HEX", "Use Hextech Revolver", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("FQC", "Use Frost Queen's Claim", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("SOTD", "Use Sword of the Divine", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings.Citems:addParam("YGB", "Use Yomuu's Ghost Blade", SCRIPT_PARAM_ONOFF, true)
	JTrist.ISettings:addParam("IuseH", "IuseH", SCRIPT_PARAM_ONOFF, false)
	JTrist.ISettings:addSubMenu("Hitems", "Hitems")
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
    JTrist.KS:addParam("ksIgnite", "Killsteal with Ignite", SCRIPT_PARAM_ONOFF, true)

	
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
end

function OnLoad()
	getVersion()
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:RegisterAfterAttackCallback(AutoAttackReset)
	Menu()
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
end

function getAAdmg(targ)
	local Mdmg = getDmg("P", targ, myHero)
	local Admg = getDmg("AD", targ, myHero)
	local returnval = Mdmg + Admg
	return returnval
end

function getTrange()
	foo = ( 550 + (myHero.level - 1)*9)
	return foo
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
				--DrawText3D(analyzeCombat(champ), champ.x, champ.y, champ.z, 20, RGB(255, 255, 255), true)
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
		if champ.team ~= myHero.team then
			if GetDmg("W", champ, myHero) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < 900 then
				wkill = true
				targ = champ
				break
			end
			if GetDmg("R", champ, myHero) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < getTrange() then
				rkill = true
				targ = champ
				break
			end
			if (GetDmg("R", champ, myHero) + GetDmg("E", champ, myHero)) > champ.health and ValidTarget(champ) and GetDistance(champ, myHero) < 900 then
				rwkill = true
				targ = champ
				break
			end
		end
	end
	if targ ~= nil then
		if JTrist.KS.ksW and Wrdy and wkill then
			if VIP_USER then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
				if HitChance == 2 or HitChance == 4 or HitChance == 5 then
					Wused = true
					castW(CastPosition)
				end
			else
				Wused = true
				castW(targ)
			end
		end
		if JTrist.KS.ksR and Rrdy and rkill then
			castR(targ)
		end
		if JTrist.KS.ksW and JTrist.KS.ksR and Wrdy and Rrdy and rwkill then
			if VIP_USER then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
				if HitChance == 2 or HitChance == 4 or HitChance == 5 then
					Wused = true
					castW(CastPosition)
				end
			else
				Wused = true
				castW(targ)
			end
		end
	end
end

function Combo()
    if JTrist.CSettings.useQ then
        if Qrdy and (GetDistance(Target) < getTrange()) then
            castQ()
        end
    end
    if JTrist.CSettings.useW then
        if Wrdy and (GetDistance(Target) < 900) then
			if SafetyCheck(JTrist.CSettings.WSettings.safeWrange, Target) > JTrist.CSettings.WSettings.safeW then return
			else
				if VIP_USER then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
					if HitChance == 2 or HitChance == 4 or HitChance == 5 then
						if JTrist.CSettings.WSettings.vectoredW then
							local vectorX,y,vectorZ = (Vector(myHero) - Vector(targ)):normalized():unpack()
							CastPosition.x = CastPosition.x + (vectorX * 125)
							CastPosition.z = CastPosition.z + (vectorZ * 125)
							castW(CastPosition)
						else
							castW(CastPosition)
						end
					end
				else
					castW(Target)
				end
			end
        end
    end
    if JTrist.CSettings.useE then
        if Erdy and (GetDistance(Target) < getTrange()) then
            castE(Target)
        end
    end
    if JTrist.CSettings.useR then
        if Rrdy and (GetDistance(Target) < getTrange()) then
            castR(Target)
        end
    end
end

function Harass()
	if JTrist.HSettings.useW then
        if Wrdy and (GetDistance(Target) < 900) then
			if SafetyCheck(JTrist.HSettings.WSettings.safeWrange, Target) > JTrist.HSettings.WSettings.safeW then return
			else
				if VIP_USER then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
					if HitChance == 2 or HitChance == 4 or HitChance == 5 then
						if JTrist.HSettings.WSettings.vectoredW then
							local vectorX,y,vectorZ = (Vector(myHero) - Vector(targ)):normalized():unpack()
							CastPosition.x = CastPosition.x + (vectorX * 125)
							CastPosition.z = CastPosition.z + (vectorZ * 125)
							castW(CastPosition)
						else
							castW(CastPosition)
						end
					end
				else
					castW(Target)
				end
			end
        end
    end
	if JTrist.HSettings.useE then
		if Erdy and GetDistance(Target, myHero) < getTrange() then
			castE(Target)
		end
	end
end

function IntPult()
	if Wrdy and Rrdy and GetDistance(Target) < 750 and not Wused then
		if VIP_USER then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.250, 250, 900, 700)
			if HitChance == 2 or HitChance == 4 or HitChance == 5 then
				local vectorX,y,vectorZ = (Vector(myHero) - Vector(targ)):normalized():unpack()
				CastPosition.x = CastPosition.x + (vectorX * 125)
				CastPosition.z = CastPosition.z + (vectorZ * 125)
				Wused = true
				intTarg = Target
				castW(CastPosition)
			end
		else
			Wused = true
			castW(Target)
		end
	end
end

function OnCreateObj(object)
	if object.name == "tristana_rocketJump_land.troy" then
		if Wused == true then
			Wused = false
			castR(intTarg)
		end
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
		Packet("S_CAST", {spellId = _W, targ.x, targ.z}):send()
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

function analyzeCombat(targ)
	local Wdmg = getDmg("W", targ, myHero)
	local Edmg = getDmg("E", targ, myHero)
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
	if not DFGR then
		Cdmg = Wdmg + Edmg + Rdmg + idmg + Lichdmg + hexTechdmg + Blgdmg + dfgdmg
	else
		Cdmg = ((Wdmg + Edmg + Rdmg)*1.2) + idmg + Lichdmg + hexTechdmg + Blgdmg + dfgdmg
	end
	
	if targ.health < Burstdmg then
		rTxt = "Burst him!"
	else 
		rTxt = "Harassable"
	end
	
	return rTxt
end