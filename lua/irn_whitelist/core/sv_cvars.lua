IRNWhitelist.CVars = {
	_Vars = {},
}

--- Register new ConVar
---@param name string Name of new ConVar
---@param default string|number Default value of new ConVar
---@param flags? number|table ConVar flags
---@param helptext? string Help text of new ConVar
---@param min? number Minimum value of new ConVar
---@param max? number Maximum value of new ConVar
---@param on_change? fun(oldValue: string, newValue: string) OnChange function
---@return ConVar|nil
function IRNWhitelist.CVars:New(name, default, flags, helptext, min, max, on_change)
	if not isstring(name) then
		return
	end
	if self:Has(name) then
		return
	end

	if not isstring(default) and not isnumber(default) then
		return
	end

	if isstring(helptext) then
		helptext = "[SimpleWhitelist]: " .. helptext
	end

	local cvar = CreateConVar("whitelist_" .. name, default, flags, helptext, min, max)
	self._Vars[name] = cvar

	if isfunction(on_change) then
		cvars.AddChangeCallback(cvar:GetName(), function(_, oldValue, newValue)
			on_change(oldValue, newValue)
		end)
	end

	return cvar
end

--- Upper first char of input string
---@param str string Input string
---@return string
local function first_char_upper(str)
	if not isstring(str) then
		return ""
	end

	str = str:gsub("^%l", string.upper)
	return str
end

--- If 'str' is empty return 'default 'else 'str'
---@param str string Input string
---@param default any Default value
---@return any
local function empty_or(str, default)
	return (not isstring(str) or #str < 1) and default or str
end

--- Get ConVar value
---@param name string The ConVar name
---@param cv_type string The ConVar type
---@param default? any Default value
---@return any
function IRNWhitelist.CVars:Get(name, cv_type, default)
	if not isstring(name) or not isstring(cv_type) then
		return default
	end
	if not self:Has(name) then
		return default
	end

	cv_type = cv_type:lower()
	if table.HasValue({ "default", "min", "max", "flags", "helptext", "helpText", "name" }, cv_type) then
		return default
	end

	local cvar = self:ConVar(name)
	if not cvar then
		return default
	end

	local func_name = "Get" .. first_char_upper(cv_type)
	if not isfunction(cvar[func_name]) then
		return default
	end

	local val = cvar[func_name](cvar)
	if isstring(val) then
		default = empty_or(default, "")
	elseif isbool(val) then
		default = empty_or(default, false)
	end

	return empty_or(val, default)
end

--- Set ConVar value
---@param name string The ConVar name
---@param cv_type string|number|boolean The ConVar type
---@param value? string|number|boolean New ConVar value
---@return boolean
function IRNWhitelist.CVars:Set(name, cv_type, value)
	if not isstring(name) or not self:Has(name) then
		return false
	end

	if value == nil then
		if isnumber(cv_type) then
			value = math.floor(cv_type)
			cv_type = "int"
		elseif isbool(cv_type) then
			value = cv_type
			cv_type = "bool"
		elseif isstring(cv_type) then
			value = cv_type
			cv_type = "string"
		end
	end

	if not isstring(cv_type) then
		return false
	end
	cv_type = cv_type:lower()

	if value == nil then
		return false
	end

	local cvar = self:ConVar(name)
	if not cvar then
		return false
	end

	local func_name = "Set" .. first_char_upper(cv_type)
	local succ = pcall(cvar[func_name], cvar, value)

	return succ
end

--- Toggle boolean ConVar value
---@param name string The ConVar name
---@return boolean
function IRNWhitelist.CVars:Toggle(name)
	if not isstring(name) or not self._Vars[name] then
		return false
	end

	local val = self:Get(name, "bool")
	if val == nil then
		return false
	end

	return self:Set(name, "bool", not val)
end

--- Check if ConVar exists
---@param name string The ConVar name
---@return boolean
function IRNWhitelist.CVars:Has(name)
	if not isstring(name) then
		return false
	end

	return self:ConVar(name) ~= nil
end

--- Get raw ConVar type
---@param name string The ConVar name
---@return ConVar|nil
function IRNWhitelist.CVars:ConVar(name)
	if not isstring(name) then
		return
	end

	return self._Vars[name]
end

--- Collect all ConVars values
---@return table
function IRNWhitelist.CVars:Collect()
	local tbl = {}
	for k, v in pairs(self._Vars) do
		tbl[k] = v:GetString()
	end

	return tbl
end

--- Apply ConVar values from table
---@param cvrs table ConVars table (key = ConVar name, value = ConVar value)
---@return boolean
function IRNWhitelist.CVars:Apply(cvrs)
	if not istable(cvrs) or table.IsSequential(cvrs) or table.IsEmpty(cvrs) then
		return false
	end

	local res = {}
	for k, v in pairs(cvrs) do
		table.insert(res, self:Set(k, v))
	end

	for _, v in ipairs(res) do
		if not v then
			return false
		end
	end
	return true
end

--- Main module load function
function IRNWhitelist.CVars:Load()
	self:New("enable", 0, FCVAR_NOTIFY, "Enable whitelist. (1 - on, 0 - off)", 0, 1, function(oldValue, newValue)
		oldValue = IRNWhitelist.Utils.Int2Bool(tonumber(oldValue) or 0)
		newValue = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)

		if newValue then
			if not self:Get("password_check", "bool", false) then
				IRNWhitelist.Utils.SetServerPassword(IRNWhitelist.Utils.GeneratePIN(5))
			end

			local date = tostring(os.date(self:Get("date_format", "string", "%x")))
			local time = tostring(os.date(self:Get("time_format", "string", "%X")))

			for _, ply in ipairs(player.GetAll()) do
				local reason = IRNWhitelist.Utils.FormatString(
					self:Get("kick_reason", "string", "You are not whitelisted on this server."),
					nil,
					{
						player = ply:Nick(),
						["player.steamid"] = ply:SteamID(),
						["player.steamid64"] = ply:SteamID64(),
						["player.accountid"] = ply:AccountID(),
						["player.ip"] = IRNWhitelist.Utils.ParseIP(ply:IPAddress()),

						n = "\n",
						t = "\t",

						date = date,
						time = time,
						datetime = string.format("%s %s", date, time),
					}
				)

				if ply:IsBot() and self:Get("kick", "bool", true) and self:Get("kick_bots", "bool", false) then
					ply:Kick("You are not whitelisted on this server.")
				elseif ply:IsPlayer() and self:Get("kick", "bool", true) then
					ply:Kick("\n" .. reason .. "\n")
				end

				local wl_state = IRNWhitelist.Whitelist:GetPlayer(ply:SteamID64())
				if wl_state.once then
					IRNWhitelist.Whitelist:RemovePlayer(ply:SteamID64())
				end
			end
		end

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistEnabled", newValue) -- Calls when ConVar 'whitelist_enable' has been changed
		end
	end)

	self:New(
		"joinkick_reason",
		"This server is whitelisted.",
		FCVAR_ARCHIVE,
		"Kick reason on player join.",
		nil,
		nil,
		function(oldValue, newValue)
			IRNWhitelist.Settings:Set("joinkick_reason", newValue)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistJoinKickReasonChanged", newValue) -- Calls when ConVar 'whitelist_joinkick_reason' has been changed
			end
		end
	)

	self:New("password_check", 0, FCVAR_ARCHIVE, "Check password on player join.", 0, 1, function(oldValue, newValue)
		local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)
		IRNWhitelist.Settings:Set("password_check", nv)

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistPasswordCheckEnabled", nv) -- Calls when ConVar 'whitelist_password_check' has been changed
		end
	end)

	self:New("kick", 1, FCVAR_ARCHIVE, "Kick players on whitelist enabling.", 0, 1, function(oldValue, newValue)
		local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 1)
		IRNWhitelist.Settings:Set("kick", nv)

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistKickPlayersAndBotsEnabled", nv) -- Calls when ConVar 'whitelist_kick' has been changed
		end
	end)

	self:New("kick_bots", 0, FCVAR_ARCHIVE, "Kick bots on enabling whitelist", 0, 1, function(oldValue, newValue)
		local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)
		IRNWhitelist.Settings:Set("kick_bots", nv)

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistKickBotsEnabled", nv) -- Calls when ConVar 'whitelist_kick_bots' has been changed
		end
	end)

	self:New(
		"kick_reason",
		"You are not whitelisted on this server.",
		FCVAR_ARCHIVE,
		"Kick reason on player kick.",
		nil,
		nil,
		function(oldValue, newValue)
			IRNWhitelist.Settings:Set("kick_reason", newValue)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistKickReasonChanged", newValue) -- Calls when ConVar 'whitelist_kick_reason' has been changed
			end
		end
	)

	self:New(
		"date_format",
		"%x",
		FCVAR_ARCHIVE,
		"Date format (for reasons filler).",
		nil,
		nil,
		function(oldValue, newValue)
			IRNWhitelist.Settings:Set("date_format", newValue)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistDateFormatChanged", newValue) -- Calls when ConVar 'whitelist_date_format' has been changed
			end
		end
	)

	self:New(
		"time_format",
		"%X",
		FCVAR_ARCHIVE,
		"Time format (for reasons filler).",
		nil,
		nil,
		function(oldValue, newValue)
			IRNWhitelist.Settings:Set("time_format", newValue)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistTimeFormatChanged", newValue) -- Calls when ConVar 'whitelist_time_format' has been changed
			end
		end
	)

	self:New("logs", 0, FCVAR_ARCHIVE, "Write action logs.", 0, 1, function(oldValue, newValue)
		local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)
		IRNWhitelist.Settings:Set("logs", nv)

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistLogsEnabled", nv) -- Calls when ConVar 'whitelist_logs' has been changed
		end
	end)

	self:New("save_names", 1, FCVAR_ARCHIVE, "Save names to SQL table.", 0, 1, function(oldValue, newValue)
		local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 1)
		IRNWhitelist.Settings:Set("save_names", nv)

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistSaveNamesEnabled", nv) -- Calls when ConVar 'whitelist_save_names' has been changed
		end
	end)

	self:New(
		"save_settings",
		0,
		FCVAR_ARCHIVE,
		"Save ConVars settings into settings.json file.",
		0,
		1,
		function(oldValue, newValue)
			local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)
			IRNWhitelist.Settings:Set("save_settings", nv)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistSaveSettingsEnabled", nv) -- Calls when ConVar 'whitelist_save_settings' has been changed
			end
		end
	)

	self:New("language", "en", FCVAR_ARCHIVE, "Language/Язык", nil, nil, function(oldValue, newValue)
		IRNWhitelist.Settings:Set("language", newValue)
		IRNWhitelist.Lang:Load()

		if oldValue ~= newValue then
			hook.Run("IRNWhitelistLanguageChanged", newValue) -- Calls when ConVar 'whitelist_language' has been changed
		end
	end)

	self:New(
		"ipasswords_enable",
		0,
		FCVAR_ARCHIVE,
		"Enable individual password module.",
		0,
		1,
		function(oldValue, newValue)
			local nv = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)
			IRNWhitelist.Settings:Set("ipasswords_enable", nv)

			if oldValue ~= newValue then
				hook.Run("IRNWhitelistIPasswordsModuleEnabled", nv) -- Calls when ConVar 'whitelist_ipasswords_enable' has been changed
			end
		end
	)

	self:New(
		"ipasswords_pepper",
		IRNWhitelist.Utils.GenPasswordSaltPepper(48),
		FCVAR_ARCHIVE,
		"Server pepper (for password generation).",
		nil,
		nil,
		function(oldValue, newValue)
			IRNWhitelist.Settings:Set("ipasswords_pepper", newValue)
			if oldValue ~= newValue then
				IRNWhitelist.IPasswords:RemoveAllPasswords()
				hook.Run("IRNWhitelistServerPepperChanged", newValue) -- Calls when ConVar 'whitelist_ipasswords_pepper' has been changed
			end
		end
	)
end
