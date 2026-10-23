IRNWhitelist.Settings = {
	_Allowed = {
		joinkick_reason = "string",
		password_check = "bool",
		kick = "bool",
		kick_bots = "bool",
		kick_reason = "string",
		date_format = "string",
		time_format = "string",
		logs = "bool",
		save_names = "bool",
		save_settings = "bool",
		language = "string",
		ipasswords_enable = "bool",
		ipasswords_pepper = "string",
	},
}

--- Change parameter value
---@param param string Parameter name
---@param value string|number|boolean Parameter value
---@return boolean
function IRNWhitelist.Settings:Set(param, value)
	if not isstring(param) or not table.HasValue(table.GetKeys(self._Allowed), param:lower()) then
		return false
	end
	if value == nil then
		return false
	else
		local cv_type = self._Allowed[param]
		if (cv_type == "int" or cv_type == "float") and not isnumber(value) then
			return false
		elseif cv_type == "bool" and not isbool(value) then
			return false
		elseif cv_type == "string" and not isstring(value) then
			return false
		end
	end

	local settings = self.Read()
	settings[param] = value

	hook.Run("IRNWhitelistSettingsParamSet", param, value) -- Calls when settings parameter has been set
	return self:Write(settings)
end

--- Save settings
---@return boolean
function IRNWhitelist.Settings:Save()
	local settings = {}
	for cvar_name, cvar_type in pairs(self._Allowed) do
		settings[cvar_name] = IRNWhitelist.CVars:Get(cvar_name, cvar_type, nil)
	end

	hook.Run("IRNWhitelistSettingsSaved", settings) -- Calls when settings has been saved
	return self:Write(settings)
end

--- Read settings
---@return table
function IRNWhitelist.Settings.Read()
	return IRNWhitelist.Files:ReadJSON("settings")
end

--- Write new settings to file
---@param settings table New settings
---@return boolean
function IRNWhitelist.Settings:Write(settings)
	if not IRNWhitelist.CVars:Get("save_settings", "bool", false) then
		return false
	end

	if not istable(settings) then
		return false
	end
	for cv_name, cv_type in pairs(self._Allowed) do
		if (cv_type == "int" or cv_type == "float") and not isnumber(settings[cv_name]) then
			return false
		elseif cv_type == "bool" and not isbool(settings[cv_name]) then
			return false
		elseif cv_type == "string" and not isstring(settings[cv_name]) then
			return false
		end
	end

	hook.Run("IRNWhitelistSettingsWrited", settings) -- Calls when settings has been writed to file
	return IRNWhitelist.Files:WriteJSON("settings", settings)
end

--- Check if file and all parameters exists
---@return boolean
function IRNWhitelist.Settings:Exists()
	if not IRNWhitelist.Files:Exists("settings.json") then
		return false
	end

	local settings = self.Read()
	for cv_name, cv_type in pairs(self._Allowed) do
		if (cv_type == "int" or cv_type == "float") and not isnumber(settings[cv_name]) then
			return false
		elseif cv_type == "bool" and not isbool(settings[cv_name]) then
			return false
		elseif cv_type == "string" and not isstring(settings[cv_name]) then
			return false
		end
	end

	return true
end

--- Apply settings
function IRNWhitelist.Settings:Apply()
	for name, v in pairs(self.Read()) do
		if not self._Allowed[name] then
			continue
		end

		IRNWhitelist.CVars:Set(name, self._Allowed[name], v)
	end
	hook.Run("IRNWhitelistSettingsApplied", self.Read()) -- Calls when settings has been applied
end

--- Collect all settings into table (key = parameter name, value = parameter value)
---@return table
function IRNWhitelist.Settings:Collect()
	local tbl = {}
	for k, v in pairs(IRNWhitelist.CVars:Collect()) do
		local t = self._Allowed[k]
		if not t then
			continue
		end

		if t == "int" or t == "float" then
			tbl[k] = tonumber(v)
		elseif t == "bool" then
			tbl[k] = IRNWhitelist.Utils.Int2Bool(tonumber(v))
		else
			tbl[k] = v
		end
	end

	return tbl
end

--- Main module load function
function IRNWhitelist.Settings:Load()
	hook.Add("PostGamemodeLoaded", "irn_whitelist.save_settings", function()
		if self:Exists() then
			self:Apply()
		else
			self:Save()
		end

		hook.Remove("PostGamemodeLoaded", "irn_whitelist.save_settings")
	end)
end
