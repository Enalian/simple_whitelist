IRNWhitelist.CVars = {
	_Vars = {},
}

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

local function first_char_upper(str)
	if not isstring(str) then
		return
	end

	str = str:gsub("^%l", string.upper)
	return str
end

local function default_or(default, new_value)
	if isstring(default) then
		return (default == nil or #default < 1) and new_value or default
	end
	return default == nil and new_value or default
end

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
		default = default_or(default, "")
	elseif isbool(val) then
		default = default_or(default, false)
	end

	return default_or(val, default)
end

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

function IRNWhitelist.CVars:Toggle(name)
	if not isstring(name) or not self._Vars[name] then
		return
	end

	local val = self:Get(name, "bool")
	if val == nil then
		return false
	end

	return self:Set(name, "bool", not val)
end

function IRNWhitelist.CVars:Has(name)
	if not isstring(name) then
		return false
	end

	return self:ConVar(name) ~= nil
end

function IRNWhitelist.CVars:ConVar(name)
	if not isstring(name) then
		return
	end

	return self._Vars[name]
end

function IRNWhitelist.CVars:Collect()
	local tbl = {}
	for k, v in pairs(self._Vars) do
		tbl[k] = v:GetString()
	end

	return tbl
end

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

function IRNWhitelist.CVars:Load()
	self:New("enable", 0, FCVAR_NOTIFY, "Enable whitelist. (1 - on, 0 - off)", 0, 1, function(_, newValue)
		newValue = IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0)

		if newValue then
			if not self:Get("password_check", "bool", false) then
				IRNWhitelist.Utils.SetServerPassword(IRNWhitelist.Utils.GeneratePIN(5))
			end

			local date = os.date(self:Get("date_format", "string", "%x"))
			local time = os.date(self:Get("time_format", "string", "%X"))

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
	end)

	self:New(
		"joinkick_reason",
		"This server is whitelisted.",
		FCVAR_ARCHIVE,
		"Kick reason on player join.",
		nil,
		nil,
		function(_, newValue)
			IRNWhitelist.Settings:Set("joinkick_reason", newValue)
		end
	)

	self:New("password_check", 0, FCVAR_ARCHIVE, "Check password on player join.", 0, 1, function(_, newValue)
		IRNWhitelist.Settings:Set("password_check", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0))
	end)

	self:New("kick", 1, FCVAR_ARCHIVE, "Kick players on whitelist enabling.", 0, 1, function(_, newValue)
		IRNWhitelist.Settings:Set("kick", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 1))
	end)

	self:New("kick_bots", 0, FCVAR_ARCHIVE, "Kick bots on enabling whitelist", 0, 1, function(_, newValue)
		IRNWhitelist.Settings:Set("kick_bots", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0))
	end)

	self:New(
		"kick_reason",
		"You are not whitelisted on this server.",
		FCVAR_ARCHIVE,
		"Kick reason on player kick.",
		nil,
		nil,
		function(_, newValue)
			IRNWhitelist.Settings:Set("kick_reason", newValue)
		end
	)

	self:New("date_format", "%x", FCVAR_ARCHIVE, "Date format (for reasons filler).", nil, nil, function(_, newValue)
		IRNWhitelist.Settings:Set("date_format", newValue)
	end)

	self:New("time_format", "%X", FCVAR_ARCHIVE, "Time format (for reasons filler).", nil, nil, function(_, newValue)
		IRNWhitelist.Settings:Set("time_format", newValue)
	end)

	self:New("logs", 1, FCVAR_ARCHIVE, "Write action logs.", 0, 1, function(_, newValue)
		IRNWhitelist.Settings:Set("logs", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 1))
	end)

	self:New("save_names", 1, FCVAR_ARCHIVE, "Save names to SQL table.", 0, 1, function(_, newValue)
		IRNWhitelist.Settings:Set("save_names", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 1))
	end)

	self:New(
		"save_settings",
		0,
		FCVAR_ARCHIVE,
		"Save ConVars settings into settings.json file.",
		0,
		1,
		function(_, newValue)
			IRNWhitelist.Settings:Set("save_settings", IRNWhitelist.Utils.Int2Bool(tonumber(newValue) or 0))
		end
	)

	self:New("language", "en", FCVAR_ARCHIVE, "Language/Язык", nil, nil, function(_, newValue)
		IRNWhitelist.Settings:Set("language", newValue)
		IRNWhitelist.Lang:Load()
	end)
end
