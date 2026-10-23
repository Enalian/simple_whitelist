IRNWhitelist.Whitelist = {
	_PasswordProtected = false,
}

---@class WhitelistedPlayer
---@field steamid64 string Player SteamID64
---@field state boolean Is player added to the whitelist
---@field once? boolean Is player added once

--- Easy ConVar setup
---@param cv_name string The ConVar name
---@param cv_type string The ConVar type
---@param func_name string Function name
---@param disable_base_fn? boolean Don't create simple func_name Get function
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

--- Add player to the whitelist
---@param steamid64 string Player's SteamID64
---@param once? boolean Add player once?
---@return boolean
function IRNWhitelist.Whitelist:AddPlayer(steamid64, once)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end
	once = tobool(once)

	if self.IsPlayerWhitelisted(steamid64) then
		return false
	end

	self.ClearDuplicates()
	hook.Run("IRNWhitelistPlayerAdded", steamid64, once)
	return IRNWhitelist.Files:AppendLine("players", string.format("%s%s", steamid64, once and ", once" or ""))
end

--- Remove player from the whitelist
---@param steamid64 string Player's SteamID64
---@return boolean
function IRNWhitelist.Whitelist:RemovePlayer(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end

	if not self.IsPlayerWhitelisted(steamid64) then
		return false
	end

	self.ClearDuplicates()
	hook.Run("IRNWhitelistPlayerRemoved", steamid64)
	return IRNWhitelist.Files:RemoveLine("players", string.format("^%s", steamid64))
end

--- Remove once player from the whitelist
---@param steamid64 string Player's SteamID64
---@return boolean
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
	hook.Run("IRNWhitelistPlayerRemovedOnce", steamid64)
	return IRNWhitelist.Files:ReplaceLine("players", string.format("^%s,%%s*once", steamid64), steamid64)
end

--- Clear whitelist (remove all players from the whitelist)
---@return boolean
function IRNWhitelist.Whitelist.Clear()
	return IRNWhitelist.Files:WriteLines("players", {})
end

--- Remove duplicated players from whitelist
---@return boolean
function IRNWhitelist.Whitelist.ClearDuplicates()
	return IRNWhitelist.Files:RemoveDuplicateLines("players")
end

--- Replace all whitelisted players to provided players
---@param players table Players table (key = Player SteamID64, value = once? or SteamID64[])
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

	hook.Run("IRNWhitelistPlayersSetted", players)
end

--- Check if player whitelisted or not
---@param steamid64 string Player SteamID64
---@return boolean
function IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid64)
	return IRNWhitelist.Files:LineExists("players", string.format("^%s", steamid64))
end

--- Get all whitelisted players (table: key = Player SteamID64, value = once?)
---@return table<string, boolean>
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

--- Get count of whitelisted players
---@return number
function IRNWhitelist.Whitelist:PlayersCount()
	return table.Count(self.GetPlayers())
end

--- Get information about player from whitelist
---@param steamid64 string Player SteamID64
---@return WhitelistedPlayer
function IRNWhitelist.Whitelist:GetPlayer(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return {
			steamid64 = steamid64,
			state = false,
		}
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

--- Check is whitelist is enabled
---@return boolean
function IRNWhitelist.Whitelist.IsOn()
	return IRNWhitelist.CVars:Get("enable", "bool", false)
end

--- Change whitelist state (enable or disable)
---@param bool boolean New state (true = enable, false = disable)
function IRNWhitelist.Whitelist.SetOn(bool)
	if not isbool(bool) then
		return
	end

	IRNWhitelist.CVars:Set("enable", "bool", bool)
end

--- Check if player need to provide password to join (on enabled whitelist)
---@return boolean
function IRNWhitelist.Whitelist.NeedPassword()
	return IRNWhitelist.CVars:Get("password_check", "bool", false)
end

--- Set password neeed white player joining (on enabled whitelist)
---@param bool boolean Need password? (true = password needed, false = password not needed)
function IRNWhitelist.Whitelist.SetNeedPassword(bool)
	if not isbool(bool) then
		return
	end

	IRNWhitelist.CVars:Set("password_check", "bool", bool)
end

--- Reason formatter (helper function)
---@param steamid64 string Player SteamID64
---@param ipAddress string Player IPAddress
---@param name string Player nickname
---@return string
function IRNWhitelist.Whitelist.FormatReason(steamid64, ipAddress, name)
	if not isstring(steamid64) or not isstring(ipAddress) or not isstring(name) then
		return ""
	end

	local date = tostring(os.date(IRNWhitelist.CVars:Get("date_format", "string", "%x")))
	local time = tostring(os.date(IRNWhitelist.CVars:Get("time_format", "string", "%X")))

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
			["player.steamid64"] = steamid64,
			["player.steamid"] = util.SteamIDFrom64(steamid64),
			["player.accountid"] = accountId,
			["player.ip"] = ipAddress,

			n = "\n",
			t = "\t",

			time = time,
			date = date,
			datetime = string.format("%s %s", date, time),
		}
	)
end

--- Main module loader function
function IRNWhitelist.Whitelist:Load()
	hook.Add("CheckPassword", "irn_whitelist.check", function(steamid64, ipAddress, svPassword, clPassword, name)
		self._PasswordProtected = #svPassword > 0

		if self.IsOn() then
			if not self.IsPlayerWhitelisted(steamid64) then
				return false, self.FormatReason(steamid64, ipAddress, name)
			end

			if not IRNWhitelist.IPasswords:Check(steamid64, clPassword) then
				return false, "#GameUI_ServerRejectBadPassword"
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
