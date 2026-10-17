IRNWhitelist.Files = {
	_Dir = "simple_whitelist",
	_Path = "%s/%s",
}

--- Read RAW file content
---@param name string File name
---@return string
function IRNWhitelist.Files:ReadRAW(name)
	if not isstring(name) or #name < 1 then
		return ""
	end

	if not self:Exists(name) then
		return ""
	end

	return file.Read(string.format(self._Path, self._Dir, name), "DATA") or ""
end
IRNWhitelist.Files.Read = IRNWhitelist.Files.ReadRAW

--- Read file content as JSON
---@param name string File name
---@return table
function IRNWhitelist.Files:ReadJSON(name)
	if not name:EndsWith(".json") then
		name = name .. ".json"
	end

	local ctx = self:ReadRAW(name)
	if not ctx or #ctx < 1 then
		return {}
	end

	return util.JSONToTable(ctx) or {}
end

--- Read lines from file
---@param name string File name
---@return string[]
function IRNWhitelist.Files:ReadLines(name)
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end

	local ctx = self:ReadRAW(name)
	if not ctx or #ctx < 1 then
		return {}
	end

	return string.Explode("\n", ctx)
end

--- Write RAW data to file
---@param name string File name
---@param ctx string File data
---@return boolean
function IRNWhitelist.Files:WriteRAW(name, ctx)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not isstring(ctx) then
		return false
	end

	return file.Write(string.format(self._Path, self._Dir, name), ctx)
end
IRNWhitelist.Files.Write = IRNWhitelist.Files.WriteRAW

--- Write JSON data to file
---@param name string File name
---@param ctx table File data
---@return boolean
function IRNWhitelist.Files:WriteJSON(name, ctx)
	if not istable(ctx) then
		return false
	end
	if not name:EndsWith(".json") then
		name = name .. ".json"
	end

	return self:WriteRAW(name, util.TableToJSON(ctx, true) or "{}")
end

--- Write lines to file
---@param name string File name
---@param ctx string[] File data
---@return boolean
function IRNWhitelist.Files:WriteLines(name, ctx)
	if not istable(ctx) then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end

	return self:WriteRAW(name, table.concat(ctx, "\n"))
end

--- Append line to file
---@param name string File name
---@param ctx string Appending line
---@return boolean
function IRNWhitelist.Files:AppendLine(name, ctx)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end
	if not self:Exists(name) then
		return false
	end

	if not isstring(ctx) then
		return false
	end
	if self:LineExists(name, ctx) then
		return false
	end

	return file.Append(string.format(self._Path, self._Dir, name), "\n" .. ctx)
end

--- Remove line from file
---@param name string File name
---@param ctx string Removing line
---@param no_patterns? boolean Ignore patterns
---@return boolean
function IRNWhitelist.Files:RemoveLine(name, ctx, no_patterns)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end
	if not self:Exists(name) then
		return false
	end
	no_patterns = tobool(no_patterns)

	if not isstring(ctx) then
		return false
	end

	local lines = self:ReadLines(name)
	local new_lines = {}
	for _, line in ipairs(lines) do
		if no_patterns then
			if ctx ~= line then
				table.insert(new_lines, line)
			end
		else
			if string.find(ctx, line) == nil then
				table.insert(new_lines, line)
			end
		end
	end

	return self:WriteLines(name, new_lines)
end

--- Remove duplicate lines from file
---@param name string File name
---@return boolean
function IRNWhitelist.Files:RemoveDuplicateLines(name)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end
	if not self:Exists(name) then
		return false
	end

	local new_lines = {}
	for _, v in ipairs(self:ReadLines(name)) do
		if new_lines[v] or #v < 1 then
			continue
		end

		new_lines[v] = true
	end

	return self:WriteLines(name, table.GetKeys(new_lines))
end

--- Check if line exists at file
---@param name string File name
---@param ctx string Line for check
---@param no_patterns? boolean Ignore patterns
---@return boolean
function IRNWhitelist.Files:LineExists(name, ctx, no_patterns)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end
	if not self:Exists(name) then
		return false
	end
	no_patterns = tobool(no_patterns)

	if not isstring(ctx) then
		return false
	end

	for _, line in ipairs(self:ReadLines(name)) do
		if no_patterns then
			if ctx == line then
				return true
			end
		else
			if string.find(line, ctx) ~= nil then
				return true
			end
		end
	end

	return false
end

--- Replace line in file
---@param name string File name
---@param x string Line for replacing
---@param y string Line to replace
---@param no_patterns? boolean Ignore patterns
---@return boolean
function IRNWhitelist.Files:ReplaceLine(name, x, y, no_patterns)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".txt") then
		name = name .. ".txt"
	end
	if not self:Exists(name) then
		return false
	end

	if not isstring(x) or not isstring(y) then
		return false
	end
	if #x < 1 then
		return false
	end
	no_patterns = tobool(no_patterns)

	local ctx = self:ReadRAW(name)
	return self:WriteRAW(name, no_patterns and ctx:Replace(x, y) or ctx:gsub(x, y))
end

--- Create new file
---@param name string File name
---@param ctx string File content
---@return boolean
function IRNWhitelist.Files:Create(name, ctx)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".json") and not name:EndsWith(".txt") then
		return false
	end
	if self:Exists(name) then
		return false
	end

	if not isstring(ctx) then
		return false
	end

	return file.Write(string.format(self._Path, self._Dir, name), ctx)
end

--- Check if file exists
---@param name string File name
---@return boolean
function IRNWhitelist.Files:Exists(name)
	if not isstring(name) or #name < 1 then
		return false
	end
	if not name:EndsWith(".json") and not name:EndsWith(".txt") then
		return false
	end

	return file.Exists(string.format(self._Path, self._Dir, name), "DATA")
end

--- Main module load function
function IRNWhitelist.Files:Load()
	if not file.IsDir(self._Dir, "DATA") then
		file.CreateDir(self._Dir)
	end

	self:Create("players.txt", "")
end
