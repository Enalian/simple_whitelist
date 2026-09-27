IRNWhitelist.Utils = {}

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

function IRNWhitelist.Utils.Int2Bool(int, rev)
	if not isnumber(int) then
		return false
	end

	int = math.Clamp(int, 0, 1)
	rev = tobool(rev)

	return rev and int == 0 or int == 1
end

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

function IRNWhitelist.Utils.SetServerPassword(password)
	if password == nil or (isstring(password) and #password < 1) then
		RunConsoleCommand("sv_password", "")
	elseif isstring(password) and #password > 0 then
		RunConsoleCommand("sv_password", password)
	end
end

function IRNWhitelist.Utils.ParseIP(ipa)
	if not isstring(ipa) then
		return {}
	end

	return string.Explode(":", ipa)[1]
end

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

function IRNWhitelist.Utils.GmatchToTable(str, pattern)
	if not isstring(str) or not isstring(pattern) then
		return ""
	end

	local tbl = {}
	for v in string.gmatch(str, pattern) do
		table.insert(tbl, v)
	end

	return tbl
end

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
