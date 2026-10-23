IRNWhitelist.IPasswords = {
	_SQLTable = "whitelist_ipasswords",
}

--- Set new player password
---@param steamid64 string Player SteamID64
---@param password string New password
---@return boolean
function IRNWhitelist.IPasswords:SetPassword(steamid64, password)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end
	if not isstring(password) or #password < 1 then
		return false
	end
	if not IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid64) then
		return false
	end

	local hash, salt = self:GenPasswordHash(password)
	sql.Query(
		string.format(
			"INSERT INTO %s (steamid64, hash, salt) VALUES (%s, %s, %s) ON CONFLICT(steamid64) DO UPDATE SET hash = EXCLUDED.hash, salt = EXCLUDED.salt;",
			self._SQLTable,
			sql.SQLStr(steamid64),
			sql.SQLStr(hash),
			sql.SQLStr(salt)
		)
	)

	hook.Run("IRNWhitelistIPasswordSet", steamid64, password)
	return true
end

--- Remove player individual password
---@param steamid64 string Player SteamID64
---@return boolean
function IRNWhitelist.IPasswords:RemovePassword(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end
	if not self:HasPassword(steamid64) then
		return false
	end

	sql.Query(string.format("DELETE FROM %s WHERE steamid64 = %s;", self._SQLTable, sql.SQLStr(steamid64)))

	hook.Run("IRNWhitelistIPasswordRemove", steamid64)
	return true
end

--- Remove all player individual passwords
function IRNWhitelist.IPasswords:RemoveAllPasswords()
	sql.Query(string.format("DELETE FROM %s;", self._SQLTable))
	hook.Run("IRNWhitelistIPasswordsRemovedAll")
end

--- Check if player has individual password
---@param steamid64 string Player SteamID64
---@return boolean
function IRNWhitelist.IPasswords:HasPassword(steamid64)
	return self:GetPasswordSalt(steamid64) ~= nil
end

--- Get player password salt
---@param steamid64 string Player SteamID64
---@return string|nil
function IRNWhitelist.IPasswords:GetPasswordSalt(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return
	end

	return sql.QueryValue(
		string.format("SELECT salt FROM %s WHERE steamid64 = %s;", self._SQLTable, sql.SQLStr(steamid64))
	)
end

--- Get player password hash
---@param steamid64 string Player SteamID64
---@return string|nil
function IRNWhitelist.IPasswords:GetPasswordHash(steamid64)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return
	end

	return sql.QueryValue(
		string.format("SELECT hash FROM %s WHERE steamid64 = %s;", self._SQLTable, sql.SQLStr(steamid64))
	)
end

--- Get player password hash and salt
---@param steamid64 string Player SteamID64
---@return string|nil
---@return string|nil
function IRNWhitelist.IPasswords:GetPasswordHashSalt(steamid64)
	return self:GetPasswordHash(steamid64), self:GetPasswordSalt(steamid64)
end

--- Generate password hash and/or salt
---@param password string Input password
---@param salt? string Input salt
---@return string
---@return string
function IRNWhitelist.IPasswords:GenPasswordHash(password, salt)
	return IRNWhitelist.Utils.GenPasswordHash(password, salt, self.GetPepper())
end

--- Check if password and his hash matches
---@param password string Input password
---@param salt string Input password salt
---@param hash string Needed hash
---@return boolean
function IRNWhitelist.IPasswords:PasswordsMatch(password, salt, hash)
	return IRNWhitelist.Utils.PasswordsMatch(password, salt, hash, self.GetPepper())
end

--- Check function for whitelist hook
---@param steamid64 string Player SteamID64
---@param password string Player input password
---@return boolean
function IRNWhitelist.IPasswords:Check(steamid64, password)
	if not IRNWhitelist.Players.IsValidSteamID64(steamid64) then
		return false
	end
	if not isstring(password) or #password < 1 then
		return false
	end

	if not self.IsEnabled() then
		return true
	end
	if not self:HasPassword(steamid64) then
		return true
	end

	local hash, salt = self:GetPasswordHashSalt(steamid64)
	return self:PasswordsMatch(password, salt, hash)
end

--- Enable individual passwords module
---@return boolean
function IRNWhitelist.IPasswords.Enable()
	return IRNWhitelist.CVars:Set("ipasswords_enable", true)
end

--- Disable individual passwords module
---@return boolean
function IRNWhitelist.IPasswords.Disable()
	return IRNWhitelist.CVars:Set("ipasswords_enable", false)
end

--- Toggle (on/off) individual passwords module
---@return boolean
function IRNWhitelist.IPasswords.Toggle()
	return IRNWhitelist.CVars:Toggle("ipasswords_enable")
end

--- Check if individual passwords module enabled or not
---@return boolean
function IRNWhitelist.IPasswords.IsEnabled()
	return IRNWhitelist.CVars:Get("ipasswords_enable", "bool", false)
		and IRNWhitelist.CVars:Get("password_check", "bool", false)
end

--- Set new password pepper
---@param new_pepper? string New password pepper
---@return boolean
function IRNWhitelist.IPasswords.SetPepper(new_pepper)
	new_pepper = (isstring(new_pepper) and #new_pepper > 0) and new_pepper
		or IRNWhitelist.Utils.GenPasswordSaltPepper(48)
	return IRNWhitelist.CVars:Set("ipasswords_pepper", new_pepper)
end

--- Get password pepper
---@return string
function IRNWhitelist.IPasswords.GetPepper()
	return IRNWhitelist.CVars:Get("ipasswords_pepper", "string", "")
end

--- Main module load function
function IRNWhitelist.IPasswords:Load()
	sql.Query(
		string.format(
			"CREATE TABLE IF NOT EXISTS %s ( steamid64 VARCHAR(20) PRIMARY KEY NOT NULL, hash TEXT NOT NULL, salt TEXT NOT NULL )",
			self._SQLTable
		)
	)
end
