--- If function at first argument wait self
---@param func function Needed function
---@return boolean
local function expects_self(func)
	local info = debug.getinfo(func, "uS")

	if info.what ~= "Lua" then
		return false
	end
	if info.nparams == 0 then
		return false
	end

	local success, arg_name = pcall(debug.getlocal, func, 1)
	return success and (arg_name == "self")
end

--- Easy API maker
---@param name string Function name ('*' = all functions)
---@param from_tbl table Table to copy function from
---@param to_tbl table Table to copy function to
---@param new_name string? New name of function
---@param bind_original_self? boolean Bind original self
---@param ignore_names? string[] Ignore names
local function easyApi(name, from_tbl, to_tbl, new_name, bind_original_self, ignore_names)
	if not isstring(name) or not istable(from_tbl) or not istable(to_tbl) then
		return
	end

	local function bind_func(k, target_k)
		local original_func = from_tbl[k]

		if not isfunction(original_func) then
			return
		end
		if isfunction(to_tbl[target_k]) then
			return
		end

		local need_self = bind_original_self
		if need_self == nil then
			need_self = expects_self(original_func)
		end

		if need_self then
			to_tbl[target_k] = function(...)
				return original_func(from_tbl, ...)
			end
		else
			to_tbl[target_k] = function(...)
				return original_func(...)
			end
		end
	end

	if name == "*" then
		for k, v in pairs(from_tbl) do
			if istable(ignore_names) and table.HasValue(ignore_names, k) then
				continue
			end

			if isfunction(v) then
				bind_func(k, k)
			end
		end
	else
		bind_func(name, new_name or name)
	end
end

--- Save addon settings
function IRNWhitelist:SaveSettings()
	self.Settings:Save()
end

--- Read addon settings
---@return table
function IRNWhitelist:ReadSettings()
	return self.Settings.Read()
end

--- Apply addon settings from settings file
function IRNWhitelist:ApplySettings()
	self.Settings:Apply()
end

--- Write addon settings to file
---@param settings table New settings
function IRNWhitelist:WriteSettings(settings)
	self.Settings:Write(settings)
end

--- Check if settings file and all parameters exists
---@return boolean
function IRNWhitelist:SettingsExists()
	return self.Settings:Exists()
end

--- Set new addon language
---@param lang string New language
function IRNWhitelist:SetLanguage(lang)
	self.Lang:Set(lang)
end

--- Get addon language
---@return string
function IRNWhitelist:GetLanguage()
	return self.Lang:GetNow()
end

--- Get language phrase
---@param phrase string Phrase
---@param ... any Format strings
---@return string
function IRNWhitelist:GetPhrase(phrase, ...)
	return self.Lang:FormatPhrase(phrase, ...)
end

--- Get addon languages
---@return string[]
function IRNWhitelist:GetLanguages()
	return self.Lang.GetLanguages()
end

--- Check if language has in addon
---@param lang string Needed language
---@return boolean
function IRNWhitelist:HasLanguage(lang)
	return self.Lang:Has(lang)
end

--- Remove player from whitelist
---@param steamid64 string Player SteamID64
---@param need_kick? boolean Need kick player?
function IRNWhitelist:RemovePlayer(steamid64, need_kick)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return
	end
	need_kick = tobool(need_kick)

	local ply = player.GetBySteamID64(steamid64)
	if IsValid(ply) and need_kick and self.Whitelist.IsOn() then
		local date = os.date(self:Get("date_format", "string", "%x"))
		local time = os.date(self:Get("time_format", "string", "%X"))

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

		ply:Kick("\n" .. reason .. "\n")
	end

	IRNWhitelist.Whitelist:RemovePlayer(steamid64)
end

IRNWhitelist.Files:Load()
IRNWhitelist.CVars:Load()
IRNWhitelist.Lang:Load()
IRNWhitelist.Commands:Load()
IRNWhitelist.Players:Load()
IRNWhitelist.Settings:Load()
IRNWhitelist.Whitelist:Load()

easyApi("*", IRNWhitelist.Whitelist, IRNWhitelist, nil, nil, { "Load" })

MsgC(Color(0, 255, 0), IRNWhitelist.Lang:FormatPhrase("messages.loaded", tostring(IRNWhitelist.VERSION)) .. "\n")
