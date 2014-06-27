local version = "1.01"
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "JAnivia"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Jarvis101/BoL/master/JAnivia.lua"
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

if myHero.charName ~= "Anivia" then PrintChat("You're not playing Anivia, you're playing "..myHero.charName)return end

require "SOW"
require "VPrediction"

local EAratio

function Menu()
	JAnivia = scriptConfig("JTrist", "JTrist")
	
    JAnivia:addSubMenu("Combo", "CSettings")
    JAnivia.CSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    JAnivia.CSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
	JAnivia.CSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    JAnivia.CSettings:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
	JAnivia.CSettings:addParam("useI", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
	
	JAnivia:addSubMenu("Harass", "HSettings")
    JAnivia.HSettings:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
    JAnivia.HSettings:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
	JAnivia.HSettings:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
    JAnivia.HSettings:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
	
	JAnivia:addSubMenu("Skill Settings", "SSettings")
	JAnivia.SSettings:addParam("Vpred", "Use VPrediction", SCRIPT_PARAM_ONOFF, true)
    JAnivia.SSettings:addParam("Eblk", "Only use E on frozen targets", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings:addSubMenu("Fight or flight", "FOF")
	JAnivia.SSettings.FOF:addParam("efofr", "Enemy:Ally ratio(enemy)", SCRIPT_PARAM_SLICE, 5, 1, 5, 0)
	JAnivia.SSettings.FOF:addParam("afofr", "Enemy:Ally ratio(ally)", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	JAnivia.SSettings.FOF:addParam("fofd", "within # distance of me", SCRIPT_PARAM_SLICE, 1000, 400, 2000, 0)
	JAnivia.SSettings.FOF:addParam("fofhp", "Minimum safe HP%", SCRIPT_PARAM_SLICE, 20, 5, 100, 0)
	
	JAnivia:addSubMenu("Item Settings", "ISettings")
    JAnivia.ISettings:addParam("IuseC", "Use items in combo", SCRIPT_PARAM_ONOFF, true)
	JAnivia.ISettings:addSubMenu("Combo Items", "Citems")
    JAnivia.ISettings.Citems:addParam("BWC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
    JAnivia.ISettings.Citems:addParam("DFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
	JAnivia.ISettings.Citems:addParam("DFGwait", "Use DFG before E and R", SCRIPT_PARAM_ONOFF, true)
	JAnivia.ISettings.Citems:addParam("HEX", "Use Hextech Revolver", SCRIPT_PARAM_ONOFF, true)
	JAnivia.ISettings.Citems:addParam("FQC", "Use Frost Queen's Claim", SCRIPT_PARAM_ONOFF, true)
	
	JAnivia:addSubMenu("KS", "KS")
    JAnivia.KS:addParam("ksQ", "KS with Q", SCRIPT_PARAM_ONOFF, true)
    JAnivia.KS:addParam("ksE", "KS with E", SCRIPT_PARAM_ONOFF, true)
	JAnivia.KS:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
    JAnivia.KS:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)
	
	JAnivia:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	JAnivia:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	JAnivia:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	
	JAnivia:addSubMenu("draw", "draw")
    JAnivia.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    JAnivia.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, false)
	JAnivia.draw:addParam("drawW", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
	JAnivia.draw:addParam("drawW", "Draw R Range", SCRIPT_PARAM_ONOFF, false)
    JAnivia.draw:addParam("drawKill", "Draw Kill text", SCRIPT_PARAM_ONOFF, true)
	JAnivia:addSubMenu("Orbwalker", "SOWiorb")
	
	JAnivia:permaShow("Combo")
    JAnivia:permaShow("Harass")
    JAnivia:permaShow("LaneClear")
	
	SOWi:LoadToMenu(JAnivia.SOWiorb)
end

function OnLoad()
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
	ts.name = "Anivia"
	JAnivia:addTS(ts)
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
end

function OnDraw()
	--WIP
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
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team then
			local Qdmg = getDmg("Q", champ, myHero)
			local Edmg = getDmg("E", champ, myHero)
			local Rdmg = getDmg("R", champ, myHero)
			local Idmg = getDmg("IGNITE", champ, myHero)
			if JAnivia.KS.ksQ and GetDistance(champ, myHero) < 1100 and champ.health < Qdmg and ValidTarget(champ) then
				if JAnivia.SSettings.Vpred then
					CastPosition, HitChance, Position = VP:GetLineCastPosition(champ, 0.250, 150, 1100, 800)
					if HitChance == 2 or HitChance == 4 or HitChance == 5 then
						castQ(champ)
					end
				else 
					castQ(champ)
				end
			end
			if JAnivia.KS.ksE and GetDistance(champ, myHero) < 650 and champ.health < Edmg and ValidTarget(champ) then
				castE(champ)
			end
			if JAnivia.KS.ksR and GetDistance(champ, myHero) < 615 and champ.health < Rdmg and ValidTarget(champ) then
				castR(champ)
			end
			if JAnivia.KS.ksI and GetDistance(champ, myHero) < 500 and champ.health < Idmg and ValidTarget(champ) then
				CastSpell(ignite, champ)
			end
		end
	end
end

function Combo()
	--WIP
	if JAnivia.ISettings.IuseC then
		if JAnivia.ISettings.Citems.DFG and DFGR and GetDistance(Target, myHero) < 500 then
			CastSpell(DFG, Target)
		end
		if JAnivia.ISettings.Citems.HEX and HexTechR and GetDistance(Target, myHero) < 500 then
			CastSpell(HexTech, Target)
		end
		if JAnivia.ISettings.Citems.FQC and FQCR and GetDistance(Target, myHero) < 850 then
			CastSpell(FQC, Target)
		end
		if JAnivia.ISettings.Citems.BWC and BilgeWaterCutlassR and GetDistance(Target, myHero) < 500 then
			CastSpell(BilgeWaterCutlass)
		end
	end
	if JAnivia.CSettings.useQ then
		if GetDistance(Target, myHero) < 1100 then
			if JAnivia.SSettings.Vpred then
				CastPosition, HitChance, Position = VP:GetLineCastPosition(champ, 0.250, 150, 1100, 800)
				if HitChance == 2 or HitChance == 4 or HitChance == 5 then
					castQ(champ)
				end
			else 
				castQ(champ)
			end
		end
	end
		
end

function Harass()
	--WIP
end

function FoF()
	local fight = true
	local ecount = 0
	local acount = 1
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team then
			if GetDistance(champ, myHero) < JAnivia.SSettings.FOF.fofd then
				ecount = ecount + 1
			end
		end
		if champ.team == myHero.team and champ ~= myHero then
			if GetDistance(champ,myHero) < JAnivia.SSettings.FOF.fofd then
				acount = acount + 1
			end
		end
	end
	if acount*100/ecount < JAnivia.SSettings.FOF.afofr*100/JAnivia.SSettings.FOF.efofr then
		return false
	end
	if myHero.maxHealth/myHero.health < JAnivia.SSettings.FOF.fofhp then
		return false
	end
	return fight
end
