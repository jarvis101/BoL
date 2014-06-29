local PATH = BOL_PATH.."Scripts\\Data"
local fileData = ""
local fcount = 0
filename = "Data."..os.clock().."."

function OnLoad()
	Menu()
end

function Menu()
	Config = scriptConfig("Config", "Config")
	Config:addParam("Debug", "Debug", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("X"))
end

function OnTick()
	if Config.Debug then Debug() end
end

function Debug()
	local file = io.open(PATH..filename..fcount..".txt", "w")
	file:write(mousePos.x.."\n")
	file:write(mousePos.y.."\n")
	file:write(mousePos.z.."\n\n")
	file:close()
	fcount = fcount + 1
	PrintChat("mousePox.x logged as "..mousePos.x.." .")
	PrintChat("mousePox.y logged as "..mousePos.y.." .")
	PrintChat("mousePox.z logged as "..mousePos.z.." .")
	Config.Debug = false
end