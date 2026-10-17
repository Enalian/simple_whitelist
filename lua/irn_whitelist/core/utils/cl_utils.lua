IRNWhitelist.Utils = {}

--- Format string with table (Relace all 'fmt' strings from key-values into 'tbl')
---@param str string String to format
---@param fmt? string Format string
---@param tbl string[] String formats
---@return string
function IRNWhitelist.Utils.FormatString(str, fmt, tbl)
	fmt = isstring(fmt) and fmt or "{{%s}}"
	if not isstring(str) then
		return ""
	end
	if not istable(tbl) then
		return str
	end

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
