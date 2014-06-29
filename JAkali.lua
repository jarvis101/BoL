local version = "2.06"

local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "JAkali"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Jarvis101/BoL/master/JAkali.lua?rand="..math.random(1000)
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

if myHero.charName ~= "Akali" then return end

require "SOW"
require "VPrediction"

function OnLoad()
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:RegisterAfterAttackCallback(AutoAttackRese)

	Menu()
	init()
	PrintChat("<font color='#aaff34'>JAkali</font>")
end

function Menu()
	AkMen = scriptConfig("JAkali", "JAkali")
	
	AkMen:addParam("Ak", "Main Settings", SCRIPT_PARAM_INFO, "")
	
	AkMen:addSubMenu("Combo Settings", "CSettings")
	AkMen.CSettings:addParam("CuseIgnite","Use Ignite if killable", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseQ","Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseW","Use W in Combo", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseE","Use E in Combo", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseR","Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseRchase","only use R to chase", SCRIPT_PARAM_ONOFF, true)
	AkMen.CSettings:addParam("CuseRchaseHP","if enemy is below % HP", SCRIPT_PARAM_SLICE, 50, 0, 101, 0)
	AkMen.CSettings:addParam("CuseRchaseDistance","Minimum Distance to chase", SCRIPT_PARAM_SLICE, 350, 0, 800, 0)
	
	AkMen:addSubMenu("Harass Settings", "HSettings")
	AkMen.HSettings:addParam("HuseQ","Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
	AkMen.HSettings:addParam("HuseE","Use E in Harass", SCRIPT_PARAM_ONOFF, true)
	AkMen.HSettings:addParam("FuseQ","Use Q to farm", SCRIPT_PARAM_ONOFF, true)
	AkMen.HSettings:addParam("FuseE","Use E to farm", SCRIPT_PARAM_ONOFF, true)
	
	AkMen:addSubMenu("Lane Clear Settings", "LCSettings")
	AkMen.LCSettings:addParam("LCuseQ","Use Q to farm", SCRIPT_PARAM_ONOFF, true)
	AkMen.LCSettings:addParam("LCuseE","Use E to farm", SCRIPT_PARAM_ONOFF, true)
	AkMen.LCSettings:addParam("LCuseAA","AutoAttack", SCRIPT_PARAM_ONOFF, true)
	AkMen.LCSettings:addParam("LCmMove","Move to Mouse", SCRIPT_PARAM_ONOFF, true)
	
	AkMen:addSubMenu("Skill Settings", "SSettings")
	AkMen.SSettings:addParam("Qblock","Block Q use if target is marked", SCRIPT_PARAM_ONOFF, true)
	AkMen.SSettings:addParam("useEonlyifQ","Only use E on Q marked targets", SCRIPT_PARAM_ONOFF, true)
	
	AkMen:addSubMenu("Kill Steal", "KS")
	AkMen.KS:addParam("Q","Use Q", SCRIPT_PARAM_ONOFF, true)
	AkMen.KS:addParam("E","Use E", SCRIPT_PARAM_ONOFF, true)
	AkMen.KS:addParam("R","Use R", SCRIPT_PARAM_ONOFF, true)
	
	AkMen:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	AkMen:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	AkMen:addParam("Farm","Farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	AkMen:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	AkMen:addParam("Flee","Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	
	AkMen:addSubMenu("Item Settings", "ISettings")
	AkMen.ISettings:addParam("iCombo", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
	AkMen.ISettings:addParam("smartdfg", "Use smart DFG", SCRIPT_PARAM_ONOFF, false)
	AkMen.ISettings:addParam("null", "Use DFG if it reduces #", SCRIPT_PARAM_ONOFF, true)
	AkMen.ISettings:addParam("DFGnComboControl", "of Combos to kill to (0 is ks)", SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
	
	AkMen:addSubMenu("Draw Settings", "DSettings")
	AkMen.DSettings:addParam("drawQ", "Draw Q radius", SCRIPT_PARAM_ONOFF, true)
	AkMen.DSettings:addParam("drawE", "Draw E radius", SCRIPT_PARAM_ONOFF, true)
	AkMen.DSettings:addParam("drawWcd", "W count down", SCRIPT_PARAM_ONOFF, true)
	AkMen.DSettings:addParam("drawR", "Draw R radius", SCRIPT_PARAM_ONOFF, true)
	AkMen.DSettings:addParam("drawTar", "Draw red circle on target", SCRIPT_PARAM_ONOFF, true)
	AkMen.DSettings:addParam("drawKill", "Draw Killable", SCRIPT_PARAM_ONOFF, true)
	
	AkMen:permaShow("Combo")
    AkMen:permaShow("LaneClear")
    AkMen:permaShow("Harass")
	AkMen:permaShow("Flee")
	
	AkMen:addSubMenu("Orbwalker", "SOWiorb")	
	SOWi:LoadToMenu(AkMen.SOWiorb)
end

function checkItems()
    Omen = GetInventorySlotItem(3143)
    BilgeWaterCutlass = GetInventorySlotItem(3144)
	HexTech = GetInventorySlotItem(3146)
    OmenR = (Omen ~= nil and myHero:CanUseSpell(Omen))
	HexTechR = (HexTech ~= nil and myHero:CanUseSpell(HexTech))
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
	Lich = GetInventorySlotItem(3100)
	LichR = (Lich ~= nil and myHero:CanUseSpell(Lich) == READY)
	DFG = GetInventorySlotItem(3128)
	DFGR = (DFG ~= nil and myHero:CanUseSpell(DFG) == READY)
end

function init()
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1300, DAMAGE_PHYSICAL)	
	ts.name = "Akali"
	AkMen:addTS(ts)
	AttackDistance = 125
	lastAttack = 0
	enemyMinions = minionManager(MINION_ENEMY, 800, myHero)
	jungleMinions = minionManager(MINION_JUNGLE, 800, myHero)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
	end
	haveBuff = false
	minionAtkVal = 0
	AAwind = 0
	AAanim = 0
	Wpos = nil
end

function getAAdmg(targ)
	local Mdmg = getDmg("P", targ, myHero)
	local Admg = getDmg("AD", targ, myHero)
	local returnval = Mdmg + Admg
	return returnval
end

function OnDraw()
	if AkMen.DSettings.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, ARGB(214,1,33,0))
	end
	if AkMen.DSettings.drawE then
		DrawCircle(myHero.x, myHero.y, myHero.z, 325, ARGB(214,1,33,0))
	end
	if AkMen.DSettings.drawR then
		DrawCircle(myHero.x, myHero.y, myHero.z, 800, ARGB(214,1,33,0))
	end
	if AkMen.DSettings.drawKill then
		for i=1, heroManager.iCount, 1 do
			local champ = heroManager:GetHero(i)
			if ValidTarget(champ) and champ.team ~= myHero.team then
				DrawText3D(analyzeCombat(champ), champ.x, champ.y, champ.z, 20, RGB(255, 255, 255), true)
			end
		end
	end
	if AkMen.DSettings.drawTar and Target ~= nil then 
		DrawCircle(Target.x, Target.y, Target.z, 50, ARGB(214, 214, 1,33))
	end
	if AkMen.DSettings.drawWcd and Wcd ~= nil then
		DrawText3D(Wcount(), Wpos.x, Wpos.y, Wpos.z, 30, RGB(255,255,255), true)
	end
end

function Wcount()
	return tostring(math.ceil(Wcd - os.clock()))
end

function OnTick()
	--Combo
	Qrdy = (myHero:CanUseSpell(_Q) == READY)
	Wrdy = (myHero:CanUseSpell(_W) == READY)
	Erdy = (myHero:CanUseSpell(_E) == READY)
	Rrdy = (myHero:CanUseSpell(_R) == READY)
	Irdy = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	ts:update()
	enemyMinions:update()
	checkItems() --thanks fuggi--
	Target = ts.target
	AttackDistance = 150
	KS()
	if AkMen.Combo then
		Combo(Target)
	end
	if AkMen.Harass then
		Harass(Target)
	end
	if AkMen.LaneClear then
		LaneClear()
	end
	if AkMen.Flee then
		Flee()
	end
end

function OnCreateObj(obj)
	if obj.isMe and (obj.name == "purplehands_buf.troy" or obj.name == "enrage_buf.troy") then
		haveBuff = true
	end
	if obj.name == "akali_smoke_bomb_tar_team_green.troy" then
		Wpos = obj
		Wcd = os.clock() + 8
	end
end

function OnDeleteObj(obj)
	if obj.isMe and (obj.name == "purplehands_buf.troy" or obj.name == "enrage_buf.troy") then
		haveBuff = false
	end
	if obj.name == "akali_smoke_bomb_tar_team_green.troy" then
		Wcd = nil
		Wpos = nil
	end
end

function OnProcessSpell(obj, spell)
	if obj.isMe and spell.name:lower():find("attack") then
		AAwind = spell.windUpTime
		AAanim = spell.animationTime
	end
end

function Flee()
	local mPos = getNearestMinion(mousePos)
	if Rrdy and mPos ~= nil and GetDistance(mPos, mousePos) < GetDistance(mousePos) then
		useR(mPos) 
	else 
		local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
        local Position = myHero + (Vector(MousePos) - myHero):normalized()*300
        myHero:MoveTo(Position.x, Position.z)
	end
end

function getNearestMinion(unit)

	local closestMinion = nil
	local nearestDistance = 0

		enemyMinions:update()
		jungleMinions:update()
		for index, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= player.team and minion.dead == false then
				if GetDistance(minion) <= 800 then
					if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
		for index, minion in pairs(jungleMinions.objects) do
			if minion ~= nil and minion.valid and minion.dead == false then
				if GetDistance(minion) <= 800 then
                    if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
		for i = 1, heroManager.iCount, 1 do
			local minion = heroManager:getHero(i)
			if ValidTarget(minion, 800) then
				if GetDistance(minion) <= 800 then
                    if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
	return closestMinion
end

function Combo(targ)
	if targ ~= nil then
		if AkMen.ISettings.iCombo and DFGR and GetDistance(targ) < 500 then
			useDFG(targ)
		end
		if AkMen.ISettings.iCombo and HexTechR and GetDistance(targ) < 500 then
			CastSpell(HexTech, targ)
		end
		if AkMen.ISettings.iCombo and OmenR and GetDistance(targ) < 500 then
			CastSpell(Omen, targ)
		end
		if AkMen.ISettings.iCombo and BilgeWaterCutlassR and GetDistance(targ) < 500 then
			CastSpell(BilgeWaterCutlass, targ)
		end
		if AkMen.CSettings.CuseIgnite and Irdy and GetDistance(targ) < 600 and targ.health <= (50 + (20 * myHero.level))then
			CastSpell(ignite, targ)
		end
		if AkMen.CSettings.CuseQ and Qrdy then
			checkQ(targ)
		end
		if AkMen.CSettings.CuseE and Erdy then
			checkE(targ)
		end
		if AkMen.CSettings.CuseR and Rrdy then
			
			if AkMen.CSettings.CuseRchase then
				if ((Target.health/Target.maxHealth)*100) < AkMen.CSettings.CuseRchaseHP and GetDistance(Target) > AkMen.CSettings.CuseRchaseDistance and GetDistance(Target, myHero) < 800 then
					PrintChat("trying to r")
					useR(targ)
				end
			else
				useR(targ)
			end
		end
		if AkMen.CSettings.CuseW and Wrdy then
			useW(targ)
		end
	end
end

function Harass(targ)
	if Target ~= nil then
		if AkMen.HSettings.HuseQ and Qrdy then
			if Qrdy and AttackDistance < 600 then
				AttackDistance = 600
			end
			useQ(targ)
		end
		if AkMen.HSettings.HuseE and Erdy then
			checkE(targ)
		end
	end
	if AkMen.HSettings.FuseE or AkMen.HSettings.FuseQ then
		
		local tar = nil
		local minRange = 1000
		local isEable = false
		enemyMinions:update()
		if AkMen.HSettings.FuseE then
			enemyMinions.range = 320
		end
		if AkMen.HSettings.FuseQ then
			enemyMinions.range = 600
		end
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				minRange = GetDistance(minion)
				if minion.health < getDmg("E", minion, myHero) and minRange < 315 and minRange > 175 and AkMen.HSettings.FuseE then
					tar = minion
					minionAtkVal = 2
					isEable = true
					break
				elseif  minion.health < getDmg("Q", minion, myHero) and minRange < 600 and minRange > 315 and AkMen.HSettings.FuseQ and not isEable then
					tar = minion
					minionAtkVal = 3
					break
				else
					tar = nil
				end
			end
		end
		if tar ~= nil then
			if AkMen.HSettings.FuseQ and Qrdy and minionAtkVal == 3 then
				if GetDistance(tar) < 600 then
					useQ(tar)
				end
			end
			if AkMen.HSettings.FuseE and Erdy and minionAtkVal == 2 then
				if GetDistance(tar) < 300 then
				useE(tar)
				end
			end
		end
	end
end


function LaneClear()
	local mosthp = 0
	local leasthp = 10000
	local tar = nil
	local Admg = 0
	enemyMinions:update()
	jungleMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if minion ~= nil then
			if minion.health < leasthp then
				tar = minion
				leasthp = minion.health
			end
		end
	end
	for i, minion in pairs(jungleMinions.objects) do
		if minion ~= nil then
			if minion.health > mosthp then
				tar = minion
				mosthp = minion.health
			end
		end
	end
	if tar ~= nil then
		if AkMen.LCSettings.LCuseQ and Qrdy then
			useQ(tar)
		end
		if AkMen.LCSettings.LCuseE and Erdy then
			useE(tar)
		end
	end
end

function useQ(targ)
	if VIP_USER and GetDistance(targ, myHero) < 600 then
		Packet("S_CAST", {spellId = _Q, targetNetworkId = targ.networkID}):send()
	else
		if GetDistance(targ, myHero) < 600 then
			CastSpell(_Q, targ)
		end
	end
end

function useE(targ)
	if VIP_USER and GetDistance(targ, myHer0) < 325 then
		 Packet("S_CAST", {spellId = _E}):send()
	else
	if GetDistance(targ, myHero) < 325 then
		CastSpell(_E)
	end
	end
end

function useR(targ)
	if VIP_USER and GetDistance(targ, myHero) < 800 then
		Packet("S_CAST", {spellId = _R, targetNetworkId = targ.networkID}):send()
	end
	if GetDistance(targ, myHero) < 800 then
		CastSpell(_R, targ)
	end
end

function useW(targ)
	if targ == nil then targ = myHero end
	if VIP_USER and GetDistance(targ, myHero) < 700 then
		Packet("S_CAST", {spellId = _Q, toX = targ.x, toY = targ.z, fromX = targ.x, fromY = targ.z}):send()
	end
	if GetDistance(targ, myHero) < 700 then
		CastSpell(_W, targ)
	end
end

function useDFG(targ)
	if AkMen.ISettings.smartdfg then
		local Qdmg = getDmg("Q", targ, myHero, 3)
		local Edmg = getDmg("E", targ, myHero)
		local Rdmg = getDmg("R", targ, myHero)
		local AAdmg = getDmg("AD", targ, myHero)
		local Lichdmg = (Lich and getDmg("LICHBANE", targ, myHero) or 0)
		local HexTechdmg = (HexTech and getDmg("HXG", targ, myHero) or 0)
		local Blgdmg = (BilgeWaterCutlass and getDmg("BWC", targ, myHero) or 0)
		local dfgdmg = (DFG and getDmg("DFG", targ, myHero) or 0)
		local Cdmg = Qdmg + Edmg + Rdmg + AAdmg
		
		if targ.health > Cdmg*DFGnComboControl + HexTechdmg + Blgdmg + Lichdmg and targ.health - dfgdmg < ((Cdmg*DFGnComboControl)- Cdmg) + ((HexTechdmg + Blgdmg + Lichdmg + Cdmg)*1.2) then
			CastSpell(DFG, targ)
		end
	else
		local dfgdmg = (DFG and getDmg("DFG", targ, myHero) or 0)
		if targ.health > dfgdmg then
			CastSpell(DFG, targ)
		end
	end
end

function analyzeCombat(targ)
	local Qdmg = getDmg("Q", targ, myHero, 3)
	local Edmg = getDmg("E", targ, myHero)
	local Rdmg = getDmg("R", targ, myHero)
	local AAdmg = getDmg("AD", targ, myHero)
	local Cdmg = Qdmg + Edmg + Rdmg + AAdmg
	local Lichdmg = (Lich and getDmg("LICHBANE", targ, myHero) or 0)
	local HexTechdmg = (HexTech and getDmg("HXG", targ, myHero) or 0)
	local Blgdmg = (BilgeWaterCutlass and getDmg("BWC", targ, myHero) or 0)
	local rTxt = ""
	
	if not LichR and not HexTechR and not BilgeWaterCutlassR then
		if (targ.health < Rdmg and Rrdy) or (targ.health < Qdmg and Qrdy) then
			rTxt = "MURDER HIM!"
		elseif targ.health < Qdmg + Edmg and Qrdy and Rrdy then
			rTxt = "Q + E"
		elseif targ.health < Cdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif not LichR and BilgeWaterCutlassR then
		if targ.health < Rdmg and Rrdy then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and Qrdy and Erdy then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Blgdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Blgdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Blgdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif not LichR and HexTechR then
		if targ.health < Rdmg and Rrdy then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and Qrdy and Erdy then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif LichR and not HexTechR then
		if targ.health < Rdmg and Rrdy then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and Qrdy and Erdy then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Lichdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Lichdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Lichdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif LichR and HexTechR then
		if targ.health < Rdmg and Rrdy then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and Qrdy and Erdy then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Lichdmg + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Lichdmg + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Lichdmg + HexTechdmg and Qrdy and Erdy and Rrdy then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	else
		rTxt = "Harrassable(error)"
	end
	return rTxt
end

function checkQ(targ)
	if targ ~= nil then
		if GetDistance(targ, myHero) < 600 then
			if not TargetHaveBuff("AkaliMota", targ) and AkMen.SSettings.Qblock then
				useQ(targ)
			end
			if not TargetHaveBuff("AkaliMota", targ) and targ.health < getDmg("Q", targ, myHero) and AkMen.SSettings.Qblock then
				useQ(targ)
			end
			if not AkMen.SSettings.Qblock then
				useQ(targ)
			end
		end
	end
end

function checkE(targ)
	if GetDistance(targ, myHero) > 325 then return false end
	if AkMen.SSettings.useEonlyifQ and TargetHaveBuff("AkaliMota", targ) then
		useE(targ)
	end
	if AkMen.SSettings.useEonlyifQ and targ.health < getDmg("E",targ,myHero) then
		useE(targ)
	end
	if not AkMen.SSettings.useEonlyifQ then
		useE(targ)
	end
end

function KS()
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) then
			if AkMen.KS.Q and Qrdy and GetDistance(champ, myHero) < 600 and champ.health < getDmg("Q",champ,myHero) then useQ(champ) end
			if AkMen.KS.E and Erdy and GetDistance(champ, myHero) < 325 and champ.health < getDmg("E",champ,myHero) then useE(champ) end
			if AkMen.KS.R and Rrdy and GetDistance(champ, myHero) < 800 and champ.health < getDmg("R",champ,myHero) then useR(champ) end
		end
	end
end
