IRNWhitelist.Whitelist = {
	_PasswordProtected = false,
}

local function easyConVarFunc(cv_name, cv_type, func_name, disable_base_fn)
	if not isstring(cv_name) then
		return
	end
	if not IRNWhitelist.CVars:Has(cv_name) then
		return
	end

	if not isstring(cv_type) then
		return
	end
	if not table.HasValue({ "string", "int", "float", "bool" }, cv_type:lower()) then
		return
	end

	func_name = isstring(func_name) and func_name or string.gsub(cv_name, "^%l", string.upper)
	IRNWhitelist.Whitelist["Get" .. func_name] = function()
		return IRNWhitelist.CVars:Get(cv_name, cv_type)
	end
	if not disable_base_fn then
		IRNWhitelist.Whitelist[func_name] = IRNWhitelist.Whitelist["Get" .. func_name]
	end

	IRNWhitelist.Whitelist["Set" .. func_name] = function(val)
		if (cv_type == "int" or cv_type == "float") and not isnumber(val) then
			return
		elseif cv_type == "string" and not isstring(val) then
			return
		elseif cv_type == "bool" and not isbool(val) then
			return
		end

		IRNWhitelist.CVars:Set(cv_name, cv_type, val)
	end
end

function IRNWhitelist.Whitelist:AddPlayer(steamid64, once)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end
	once = tobool(once)

	if self.IsPlayerWhitelisted(steamid64) then
		return false
	end

	self.ClearDuplicates()
	return IRNWhitelist.Files:AppendLine("players", string.format("%s%s", steamid64, once and ", once" or ""))
end

function IRNWhitelist.Whitelist:RemovePlayer(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end

	if not self.IsPlayerWhitelisted(steamid64) then
		return false
	end

	self.ClearDuplicates()
	return IRNWhitelist.Files:RemoveLine("players", string.format("^%s", steamid64))
end

function IRNWhitelist.Whitelist:RemovePlayerOnce(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end

	if not self.IsPlayerWhitelisted(steamid64) then
		return false
	end

	local state = self:GetPlayer(steamid64)
	if not state.once then
		return false
	end

	self.ClearDuplicates()
	return IRNWhitelist.Files:ReplaceLine("players", string.format("^%s,%%s*once", steamid64), steamid64)
end

function IRNWhitelist.Whitelist.Clear()
	return IRNWhitelist.Files:WriteLines("players", {})
end

function IRNWhitelist.Whitelist.ClearDuplicates()
	return IRNWhitelist.Files:RemoveDuplicateLines("players")
end

function IRNWhitelist.Whitelist:SetPlayers(players)
	self.Clear()

	if isstring(players) then
		if IRNWhitelist.Players.IsValidSteamID64(players) then
			self:AddPlayer(players, false)
		end
	elseif istable(players) then
		for steamid64, onceOrSteamID64 in pairs(players) do
			if IRNWhitelist.Players.IsValidSteamID64(onceOrSteamID64) then
				self:AddPlayer(onceOrSteamID64, false)
			elseif IRNWhitelist.Players.IsValidSteamID64(steamid64) and isbool(onceOrSteamID64) then
				self:AddPlayer(steamid64, onceOrSteamID64)
			end
		end
	end
end

function IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid64)
	return IRNWhitelist.Files:LineExists("players", string.format("^%s", steamid64))
end

function IRNWhitelist.Whitelist.GetPlayers()
	local tbl = {}
	for _, line in ipairs(IRNWhitelist.Files:ReadLines("players") or {}) do
		for steamid64, raw_suffix in string.gmatch(line, "(%d+)([^%d]*)") do
			if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
				continue
			end

			local suffix = string.match(raw_suffix, "^%s*(.-)%s*$")
			local once = string.find(suffix:lower(), "once", 1, true) ~= nil

			tbl[steamid64] = once
		end
	end

	return tbl
end

function IRNWhitelist.Whitelist:PlayersCount()
	return table.Count(self.GetPlayers())
end

function IRNWhitelist.Whitelist:GetPlayer(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return
	end

	if self.IsPlayerWhitelisted(steamid64) then
		return {
			steamid64 = steamid64,
			state = false,
		}
	end

	return {
		steamid64 = steamid64,
		state = true,
		once = self.GetPlayers()[steamid64],
	}
end

function IRNWhitelist.Whitelist.IsOn()
	return IRNWhitelist.CVars:Get("enable", "bool", false)
end

function IRNWhitelist.Whitelist.SetOn(bool)
	if not isbool(bool) then
		return
	end

	IRNWhitelist.CVars:Set("enable", "bool", bool)
end

function IRNWhitelist.Whitelist.NeedPassword()
	return IRNWhitelist.CVars:Get("password_check", "bool", false)
end

function IRNWhitelist.Whitelist.SetNeedPassword(bool)
	if not isbool(bool) then
		return
	end

	IRNWhitelist.CVars:Set("password_check", "bool", bool)
end

function IRNWhitelist.Whitelist.FormatReason(steamid64, ipAddress, name)
	if not isstring(steamid64) or not isstring(ipAddress) or not isstring(name) then
		return ""
	end

	local date = os.date(IRNWhitelist.CVars:Get("date_format", "string", "%x"))
	local time = os.date(IRNWhitelist.CVars:Get("time_format", "string", "%X"))

	local accountId = steamid64
	local steamid64_parser = IRNWhitelist.Utils.Module("steamid64-parse")
	if isfunction(steamid64_parser.parse) then
		local x = steamid64_parser.parse(steamid64)
		accountId = tostring(x.Z)
	end

	return IRNWhitelist.Utils.FormatString(
		IRNWhitelist.CVars:Get("joinkick_reason", "string", "You are not whitelisted on this server."),
		nil,
		{
			player = name,
			["player.steamId64"] = steamid64,
			["player.steamId"] = util.SteamIDFrom64(steamid64),
			["player.accountId"] = accountId,
			["player.ip"] = ipAddress,

			n = "\n",
			time = time,
			date = date,
			datetime = string.format("%s %s", date, time),
		}
	)
end

function IRNWhitelist.Whitelist:Load()
	hook.Add("CheckPassword", "irn_whitelist.check", function(steamid64, ipAddress, svPassword, clPassword, name)
		self._PasswordProtected = #svPassword > 0

		if self.IsOn() then
			if not self.IsPlayerWhitelisted(steamid64) then
				return false, self.FormatReason(steamid64, ipAddress, name)
			end

			if self.NeedPassword() and svPassword ~= clPassword then
				return false, "#GameUI_ServerRejectBadPassword"
			end

			local ply = self:GetPlayer(steamid64)
			if ply and ply.once then
				self:RemovePlayer(steamid64)
			end
		end
	end, HOOK_HIGH)

	function game.IsPasswordProtected()
		return self._PasswordProtected
	end

	easyConVarFunc("joinkick_reason", "string", "JoinKickReason")
	easyConVarFunc("kick", "bool", "KickPlayers", true)
	easyConVarFunc("kick_bots", "bool", "KickBots", true)
	easyConVarFunc("kick_reason", "string", "KickReason")
	easyConVarFunc("date_format", "string", "DateFormat")
	easyConVarFunc("time_format", "string", "TimeFormat")
	easyConVarFunc("logs", "bool", "LogsEnabled", true)
	easyConVarFunc("save_names", "string", "SaveNames", true)
	easyConVarFunc("save_settings", "string", "SaveSettings", true)
end
