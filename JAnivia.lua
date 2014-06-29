local version = "1.10"
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
--THIS IS A WORK IN PROGRESS
local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "JAnivia"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Jarvis101/BoL/master/JAnivia.lua?rand="..math.random(1000)
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

local Qmiss = nil
local Rmiss = nil
local myQ = myHero:GetSpellData(_Q)
local myW = myHero:GetSpellData(_W)
local myE = myHero:GetSpellData(_E)
local myR = myHero:GetSpellData(_R)
local Target = nil

function Menu()
	JAnivia = scriptConfig("JAnivia", "JAnivia")
	
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
	
	JAnivia.SSettings:addSubMenu("Q Settings", "Qset")
	JAnivia.SSettings.Qset:addParam("Qdet", "Detonate Q on 1st contact", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings.Qset:addParam("rand1", "if ^ is false, will detonate on target only", SCRIPT_PARAM_INFO, "")
	
	JAnivia.SSettings:addSubMenu("W Settings", "Wset")
	JAnivia.SSettings.Wset:addParam("fightW", "use wall in a fight", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings.Wset:addParam("flightW", "use wall in flight", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings.Wset:addParam("autoW", "auto-wall", SCRIPT_PARAM_ONOFF, false)
	
	JAnivia.SSettings:addSubMenu("E Settings", "Eset")	
	JAnivia.SSettings.Eset:addParam("autoE", "Auto E closest enemy", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings.Eset:addParam("mana", "Minimum reserve mana%", SCRIPT_PARAM_SLICE, 20, 5, 100, 0)
	JAnivia.SSettings.Eset:addParam("Echilled", "Only E chilled targets", SCRIPT_PARAM_ONOFF, true)
	
	JAnivia.SSettings:addSubMenu("R Settings", "Rset")	
	JAnivia.SSettings.Rset:addParam("rdist", "Cancel R if enemy is further than", SCRIPT_PARAM_SLICE, 600, 400, 2000, 0)
	JAnivia.SSettings.Rset:addParam("cancelR", "Use the option above", SCRIPT_PARAM_ONOFF, true)
	JAnivia.SSettings.Rset:addParam("keepR", "Keep R up during LaneClear", SCRIPT_PARAM_ONOFF, true)
	
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
	
	niva = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1200, DAMAGE_PHYSICAL, false)
	niva.name = "Anivia"
	JAnivia:addTS(niva)
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
	niva:update()
	Target = niva.target
	
	Qrdy = (myHero:CanUseSpell(_Q) == READY)
	Wrdy = (myHero:CanUseSpell(_W) == READY)
	Erdy = (myHero:CanUseSpell(_E) == READY)
	Rrdy = (myHero:CanUseSpell(_R) == READY)
	Irdy = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	checkItems()
	
	if Qmiss ~=nil then
		DetQ()
	end
	if Rmiss ~= nil and JAnivia.SSettings.Rset.cancelR then
		if JAnivia.SSettings.Rset.keepR and not JAnivia.LaneClear then
			if not ValidR() then castR(nil) end
		end
	end
	KS()
	if JAnivia.SSettings.Wset.autoW then
		autoW()
	end
	if JAnivia.SSettings.Eset.autoE  then
		autoE()
	end
	if JAnivia.Combo and Target ~= nil then
		Combo()
	end
	if JAnivia.Harass and Target ~= nil then
		Harass()
	end
	if JAnivia.LaneClear and Target ~= nil then
		LaneClear()
	end
	if JAnivia.Debug then Debug() end
end

function KS()
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) and GetDistance(champ, myHero) < 1500 then
			local Qdmg = getDmg("Q", champ, myHero)
			local Edmg = getDmg("E", champ, myHero)
			local Rdmg = getDmg("R", champ, myHero)
			local Idmg = getDmg("IGNITE", champ, myHero)
			if JAnivia.KS.ksQ and champ.health < Qdmg and ValidTarget(champ) then
				local qcheck, qtype = Qchecks(champ)
				if qtype ~= nil then
					if qtype == "vpred" then
						castQ(qcheck)
					end
					if qtype == "free" then
						castQ(champ)
					end
				end
			end
			if JAnivia.KS.ksE and GetDistance(champ, myHero) < 650 and champ.health < Edmg and ValidTarget(champ) then
				castE(champ)
			end
			if JAnivia.KS.ksR and GetDistance(champ, myHero) and champ.health < Rdmg and ValidTarget(champ) then
				local rcheck, rtype = Rchecks(champ)
				if rtype ~= nil then
					if rtype == "vpred" then
						castR(rcheck)
					end
					if rtype == "free" then
						castR(champ)
					end
				end
			end
			if JAnivia.KS.ksI and GetDistance(champ, myHero) < 500 and champ.health < Idmg and ValidTarget(champ) then
				CastSpell(ignite, champ)
			end
		end
	end
end

function autoW()
	local closest = 999999
	local targ = nil
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) then
			if GetDistance(champ, myHero) < closest then 
				closest = GetDistance(champ, myHero) 
				targ = champ
			end
		end
	end
	if targ ~= nil then if Wchecks(targ) ~= nil then castW(targ) end end
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
	if JAnivia.CSettings.useQ and Qrdy then
		local qcheck, qtype = Qchecks(Target)
		if qtype ~= nil then
			if qtype == "vpred" then
				castQ(qcheck)
			end
			if qtype == "free" then
				castQ(Target)
			end
		end
	end
	if JAnivia.CSettings.useE and Erdy then
		local echeck = Echecks(Target)
		if echeck == true then
			castE(Target)
		end
	end
	if JAnivia.CSettings.useW and Wrdy then
		local wcheck = Wchecks(Target)
		if wcheck ~= nil then
			castW(wcheck)
		end
	end
	if JAnivia.CSettings.useR and Rrdy then
		local rtype, rcheck = Rchecks(Target)
		if rtype ~= nil then
			if rtype == "vpred" then
				castR(rcheck)
			end
			if rtype == "free" then
				castR(Target)
			end
		end
	end
end

function Harass()
	--WIP
end

function LaneClear()

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
	if ((myHero.health/myHero.maxHealth)*100) < JAnivia.SSettings.FOF.fofhp then
		return false
	end
	return fight
end

function OnProcessSpell(object, spell)
	if spell.name == myQ.name then
		Qmiss = object
	end
end

function OnCreateObj(object)
	if object.name == "cryo_FlashFrost_mis.troy" then
		Qmiss = object
	end
	if object.name == "cryo_storm_green_team.troy" then
		Rmiss = object
	end
end

function OnDeleteObj(object)
	if object.name == "cryo_FlashFrost_mis.troy" then
		Qmiss = nil
	end
	if object.name == "cryo_storm_green_team.troy" then
		Rmiss = nil
	end
end

function ValidR()
	local ccount = 0
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) then
			if GetDistance(champ, Rmiss) < JAnivia.SSettings.Rset.rdist then
				ccount = ccount + 1
			end
		end
	end
	if ccount > 0 then return true else return false end	
end

function DetQ()
	if JAnivia.SSettings.Qset.Qdet then
		for i=1, heroManager.iCount, 1 do
			local champ = heroManager:GetHero(i)
			if champ.team ~= myHero.team then
				if GetDistance(champ, Qmiss) < 150 then
					castQ(nil)
				end
			end
		end
	else
		if GetDistance(Target, Qmis) < 150 then
			castQ(nil)
		end
	end
end

function castQ(targ)
	if targ == nil and Qmiss ~= nil then
		if VIP_USER then
			Packet("S_CAST", {spellId = _Q}):send()
		else
			CastSpell(_Q)
		end
	end
	if targ ~= nil and Qmiss == nil then
		if VIP_USER then
				Packet('S_CAST', { spellId = _Q, toX = targ.x, toY = targ.z , fromX = targ.x , fromY = targ.z }):send()		
		else
				CastSpell(_Q, targ.x, targ.z)
		end
	end
end

function castE(targ)
	if VIP_USER then
		Packet("S_CAST", {spellId = _E,targetNetworkId = targ.networkID}):send()
	else
		CastSpell(_E, targ)
	end
end

function castW(targ)
	if VIP_USER then
		Packet("S_CAST", {spellId = _W, toX = targ.x, toY = targ.z , fromX = targ.x , fromY = targ.z }):send()	
	else
		CastSpell(_W, targ.x, targ.z)
	end
end

function castR(targ)
	if targ == nil and Rmiss ~= nil then
		if VIP_USER then
			Packet("S_CAST", {spellId = _R}):send()
		else
			CastSpell(_R)
		end
	end
	if targ ~= nil and Rmiss == nil then
		if VIP_USER then
			Packet('S_CAST', { spellId = _R, toX = targ.x, toY = targ.z , fromX = targ.x , fromY = targ.z }):send()		
		else
			CastSpell(_R, targ.x, targ.z)
		end
	end
end

function Qchecks(targ)
	if targ == nil then return nil, nil end
	local CastPosition = nil
	local HitChance = nil
	local Position = nil
	local retval = nil
	local rettype = nil
	if Qmis ~= nil then return nil, nil end
	if GetDistance(Target, myHero) < 1100 then
		if JAnivia.SSettings.Vpred then
			CastPosition, HitChance = VP:GetLineCastPosition(targ, 0.250, 150, 1100, 850)
			if HitChance == 2 or HitChance == 4 or HitChance == 5 and GetDistance(CastPosition, myHero) < 1100 then
				retval = CastPosition
				rettype = "vpred"
			end
		end
		if not JAnivia.SSettings.Vpred then
			retval = "free"
			rettype = "free"
		end
	end
	return retval, rettype
end


function Echecks(targ)
	if targ == nil then return false end
	if GetDistance(targ, myHero) < 650 then
		if JAnivia.SSettings.Eset.Echilled then
			if TargetHaveBuff("chilled", targ) then return true end
		else
			return true
		end
	end
	return false
end

function autoE()
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team then
			if Echecks(champ) == true then castE(champ) end
		end
	end
end

function Rchecks(targ)
	local rettype = nil
	local retval = nil
	if GetDistance(targ, myHero) < 650 then
		--[[if JAnivia.SSettings.Vpred then
			CastPosition, HitChance = VP:GetCircularCastPosition(targ, 0.250, 210, 650, 3000)
			if HitChance == 2 or HitChance == 4 or HitChance == 5 and GetDistance(CastPosition, myHero) < 650 then
				PrintChat("Should have cast R")
				retval = CastPosition
				rettype = "vpred"
			end
		end]]--
		--if not JAnivia.SSettings.Vpred then 
			retval = "free"
			rettype = "free"
	--	end
	end
	return rettype,retval
end

function Wchecks(targ)
	if FoF() and JAnivia.SSettings.Wset.fightW then
		local vectorX,y,vectorZ = (Vector(myHero) - Vector(targ)):normalized():unpack()
		local pos = Vector(targ.x - (vectorX * 175),y, targ.z - (vectorZ * 175))
		if GetDistance(pos, myHero) < 1000 then
			return pos 
		end
	end
	if not FoF() and JAnivia.SSettings.Wset.flightW then
		PrintChat("target = "..targ.charName.."!")
		local vectorX,y,vectorZ = (Vector(targ) - Vector(myHero)):normalized():unpack()
		local pos = Vector(targ.x - (vectorX * 175),y, targ.z - (vectorZ * 175))
		if GetDistance(pos, myHero) < 1000 then
			return pos 
		end
	end
	return nil
end