IRNWhitelist.Utils = {}

--- Load whitelist module
---@param name string Module filename (without .lua and sv_)
---@return any
function IRNWhitelist.Utils.Module(name)
	if not isstring(name) then
		return {}
	end

	local path = string.format("irn_whitelist/modules/sv_%s.lua", name)
	if not file.Exists(path, "LUA") then
		return {}
	end

	return include(path)
end

--- Format string with table (Relace all 'fmt' strings from key-values into 'tbl')
---@param str string String to format
---@param fmt? string Format string
---@param tbl string[] String formats
---@return string
function IRNWhitelist.Utils.FormatString(str, fmt, tbl)
	if not isstring(str) then
		return ""
	end
	if not istable(tbl) then
		return str
	end
	fmt = isstring(fmt) and fmt or "{{%s}}"

	for k, v in pairs(tbl) do
		if not isstring(k) then
			continue
		end
		v = tostring(v)

		str = string.Replace(str, string.format(fmt, k), v)
		str = string.Replace(str, string.format(fmt, k:upper()), v)
		str = string.Replace(str, string.format(fmt, k:lower()), v)
	end

	return str
end

--- Translate number (integer) to bool value
---@param int number The number to convert
---@param rev? boolean Reverse output (1 = false, 0 = true)
---@return boolean
function IRNWhitelist.Utils.Int2Bool(int, rev)
	if not isnumber(int) then
		return false
	end

	int = math.Clamp(int, 0, 1)
	rev = tobool(rev)

	return rev and int == 0 or int == 1
end

--- Generate server password pin-code
---@param digits? number Digits count
---@return string
function IRNWhitelist.Utils.GeneratePIN(digits)
	if not isnumber(digits) then
		return ""
	end
	digits = math.max(digits, 4)

	local pin = ""
	for _ = 1, digits do
		pin = pin .. tostring(math.random(0, 9))
	end

	return pin
end

--- Set or reset server password (for reset - 'password' = nil or 'password' = "")
---@param password string? The new server password
function IRNWhitelist.Utils.SetServerPassword(password)
	if password == nil or (isstring(password) and #password < 1) then
		RunConsoleCommand("sv_password", "")
	elseif isstring(password) and #password > 0 then
		RunConsoleCommand("sv_password", password)
	end
end

--- Get IP from IP:Port
---@param ipa string IP:Port
---@return string
function IRNWhitelist.Utils.ParseIP(ipa)
	if not isstring(ipa) then
		return ""
	end

	return string.Explode(":", ipa)[1]
end

--- Write string into a log file
---@param str string The string to log
---@return boolean
function IRNWhitelist.Utils.Log(str)
	if not isstring(str) then
		return false
	end
	if not IRNWhitelist.CVars:Get("logs", "bool", false) then
		return false
	end

	local date = os.date(IRNWhitelist.CVars:Get("date_format", "string", "%x"))
	local time = os.date(IRNWhitelist.CVars:Get("time_format", "string", "%X"))

	IRNWhitelist.Files:Create("logs.txt", "")
	return IRNWhitelist.Files:AppendLine("logs", string.format("[%s] [%s] %s", date, time, str))
end

--- Clear sequential table from double values
---@param tbl any[] Table to clear doubles in
---@return table
function IRNWhitelist.Utils.TableClearDoubles(tbl)
	if not istable(tbl) or not table.IsSequential(tbl) then
		return {}
	end

	local target_tbl = {}
	for _, v in ipairs(tbl) do
		if target_tbl[v] then
			continue
		end

		target_tbl[v] = true
	end

	return table.GetKeys(target_tbl)
end

--- Insert all string.gmatch values into table
---@param str string The string to search in
---@param pattern string The pattern to search for
---@return table
function IRNWhitelist.Utils.GmatchToTable(str, pattern)
	if not isstring(str) or not isstring(pattern) then
		return {}
	end

	local tbl = {}
	for v in string.gmatch(str, pattern) do
		table.insert(tbl, v)
	end

	return tbl
end

--- Generate printable player name
---@param plyOrName Player|string Player or player name
---@param sid64? string Player SteamID64
---@param logs_print? boolean For logs?
---@return string
function IRNWhitelist.Utils.PrintPlayerName(plyOrName, sid64, logs_print)
	if not IsValid(plyOrName) and not isstring(plyOrName) then
		return ""
	end
	logs_print = tobool(logs_print)

	if IsValid(plyOrName) then
		if not plyOrName:IsPlayer() then
			return ""
		end

		return string.format("%s%s(%s)", plyOrName:Nick(), logs_print and "" or " ", plyOrName:SteamID64())
	else
		if #plyOrName < 1 then
			return ""
		end
		if not isstring(sid64) or #sid64 < 1 then
			return plyOrName
		end
		if not IRNWhitelist.Players.IsValidSteamID64(sid64) then
			return plyOrName
		end

		local ply = player.GetBySteamID64(sid64)
		if IsValid(ply) then
			return IRNWhitelist.Utils.PrintPlayerName(ply)
		end

		return plyOrName == sid64 and sid64 or string.format("%s%s(%s)", plyOrName, logs_print and "" or " ")
	end
end

--- Generate password salt or server pepper
---@param length? number Salt or pepper length
---@return string
function IRNWhitelist.Utils.GenPasswordSaltPepper(length)
	length = tonumber(length) or 32

	local result = {}
	local charsetLength = #charset

	math.randomseed(os.time() + math.random(1, 10000))
	for i = 1, length do
		local randIndex = math.random(1, charsetLength)
		result[i] = string.sub(charset, randIndex, randIndex)
	end

	return table.concat(result)
end

--- Generate password hash
---@param password string Password to generate hash from
---@param salt? string Unique password salt
---@param pepper string Unique server pepper
---@return string
---@return string
function IRNWhitelist.Utils.GenPasswordHash(password, salt, pepper)
	if not isstring(password) then
		return "", ""
	end
	salt = (isstring(salt) and #salt > 0) and salt or IRNWhitelist.Utils.GenPasswordSaltPepper()
	pepper = (isstring(pepper) and #pepper > 0) and pepper or IRNWhitelist.Utils.GenPasswordSaltPepper(48)

	local currentHash = password .. salt .. pepper
	for _ = 1, 10000 do
		currentHash = util.SHA256(currentHash)
	end

	return currentHash, salt
end

--- Check if password match with his hash
---@param input_password string Input password
---@param input_salt string Input salt
---@param need_hash string Needed hash
---@param pepper string Unique server pepper
---@return boolean
function IRNWhitelist.Utils.PasswordsMatch(input_password, input_salt, need_hash, pepper)
	if not isstring(input_password) or #input_password < 1 then
		return false
	end
	if not isstring(input_salt) or #input_salt < 1 then
		return false
	end
	if not isstring(need_hash) or #need_hash < 1 then
		return false
	end

	return need_hash == IRNWhitelist.Utils.GenPasswordHash(input_password, input_salt, pepper)
end
