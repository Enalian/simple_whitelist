IRNWhitelist.Lang = {
	Default = "en",
}

--- Get phrase at default (en) language
---@param phrase string Input phhrase
---@return string
local function GetDefaultPhrase(phrase)
	if not isstring(phrase) then
		return ""
	end

	local phrases = IRNWhitelist.Lang._CacheDefault
	if not istable(phrases) then
		phrases = IRNWhitelist.Lang.GetPhrases(IRNWhitelist.Lang.Default)
	end
	if not istable(phrases) then
		return phrase
	end

	local parts = string.Explode(".", phrase)
	local i = 1
	local next = phrases[parts[i]]
	while next ~= nil do
		if isstring(next) then
			return next
		elseif istable(next) then
			i = i + 1
			next = next[parts[i]]
		else
			return phrase
		end
	end

	return phrase
end

--- If 'str' is empty return 'default 'else 'str'
---@param str string Input string
---@param default any Default value
---@return any
local function empty_or(str, default)
	return (not isstring(str) or #str < 1) and default or str
end

--- Get language phrases
---@param lang string Phrases language
---@param no_warn? boolean Ignore warnings
---@return table
function IRNWhitelist.Lang.GetPhrases(lang, no_warn)
	if not isstring(lang) then
		return {}
	end
	lang = lang:lower()
	no_warn = tobool(no_warn)

	local path = string.format("irn_whitelist/languages/cs_%s.lua", lang)
	if not file.Exists(path, "LUA") then
		if not no_warn and SERVER then
			IRNWhitelist.Console:Warn("Language '{{1}}' not found.", lang)
		end
		return {}
	end

	local tbl = include(path)
	if not istable(tbl) then
		if not no_warn then
			IRNWhitelist.Console:Warn("Language '{{1}}' is corruped. (isn't a table)", lang)
		end
		return {}
	end

	return tbl
end

--- Get language phrase
---@param phrase string Input phrase
---@param lang? string Phrase language
---@param no_warn? boolean Ignore warnings
---@return string
function IRNWhitelist.Lang:GetPhrase(phrase, lang, no_warn)
	if not isstring(phrase) then
		return ""
	end
	no_warn = tobool(no_warn)

	local old_phrase = phrase
	phrase = string.match(phrase:lower(), "^[%w_]+%.[%w_%.]*[%w_]+$") or string.match(phrase:lower(), "^[%w_]+$")
	if not isstring(phrase) then
		return old_phrase
	end
	phrase = phrase:gsub("^%%", ""):gsub("%%$", "")

	local phrases = isstring(lang) and (lang == self.Default and self._CacheDefault or self.GetPhrases(lang))
		or (self._Cache or self._CacheDefault)
	if not istable(phrases) or table.Count(phrases) < 1 then
		if not no_warn then
			IRNWhitelist.Console:Warn("Corruped language '{{1}}' table.", self.Now)
		end
		return phrase
	end

	if isstring(phrases[phrase]) then
		return phrases[phrase]
	end

	local parts = string.Explode(".", phrase)
	local i = 1
	local next = phrases[parts[i]]
	while next ~= nil do
		if isstring(next) then
			return next
		elseif istable(next) then
			i = i + 1
			next = next[parts[i]]
		else
			if not no_warn then
				IRNWhitelist.Console.Warn(
					"Unknown phrase '{{1}}' (part of: {{2}}) type: {{3}} (language: {{4}})",
					table.concat(parts, ".", 1, i),
					phrase,
					type(next),
					self.Now
				)
			end
			return GetDefaultPhrase(phrase)
		end
	end

	if not no_warn then
		IRNWhitelist.Console:Warn("Phrase '{{1}}' not found in '{{2}}' language.", phrase, self.Now)
	end
	return GetDefaultPhrase(phrase)
end

--- Format phrase by strings
---@param phrase string Input phrase
---@param ... any Format strings
---@return string
function IRNWhitelist.Lang:FormatPhrase(phrase, ...)
	if not isstring(phrase) then
		return ""
	end

	local args = { ... }
	local params = {}
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	local parsed_phrase = self:GetPhrase(phrase, params.lang, params.no_warn)
	if not params.no_percent then
		for _, tag in
			ipairs(
				IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(parsed_phrase, "%%([%w_%.]+)%%"))
			)
		do
			parsed_phrase = string.Replace(
				parsed_phrase,
				string.format("%%%s%%", tag),
				self:GetPhrase(tag, params.lang, params.no_warn)
			)
		end
	end
	if #args < 1 then
		return parsed_phrase
	end

	local tbl = {}
	for k, v in ipairs(args) do
		local text = tostring(v)
		if not params.no_percent then
			for _, tag in
				ipairs(IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(text, "%%([%w_%.]+)%%")))
			do
				text =
					string.Replace(text, string.format("%%%s%%", tag), self:GetPhrase(tag, params.lang, params.no_warn))
			end
		end

		tbl[tostring(k)] = text
	end

	return IRNWhitelist.Utils.FormatString(parsed_phrase, nil, tbl)
end

--- Format string with vararg inputs
---@param str string Input string
---@param ... any Format strings
---@return string
function IRNWhitelist.Lang:FormatString(str, ...)
	if not isstring(str) then
		return ""
	end

	local args = { ... }
	local params = {}
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	if not params.no_percent then
		for _, tag in
			ipairs(IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(str, "%%([%w_%.]+)%%")))
		do
			str = string.Replace(str, string.format("%%%s%%", tag), self:GetPhrase(tag, params.lang, params.no_warn))
		end
	end
	if #args < 1 then
		return str
	end

	local tbl = {}
	for k, v in ipairs(args) do
		local text = tostring(v)
		if not params.no_percent then
			for _, tag in
				ipairs(IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(text, "%%([%w_%.]+)%%")))
			do
				text =
					string.Replace(text, string.format("%%%s%%", tag), self:GetPhrase(tag, params.lang, params.no_warn))
			end
		end

		tbl[tostring(k)] = text
	end

	return IRNWhitelist.Utils.FormatString(str, nil, tbl)
end

--- Get list of all languages
---@return table
function IRNWhitelist.Lang.GetLanguages()
	local tbl = {}
	for _, v in ipairs(file.Find("irn_whitelist/languages/cs_*.lua", "LUA") or {}) do
		table.insert(tbl, string.Replace(string.Replace(v, "cs_", ""), ".lua", ""):lower())
	end

	return IRNWhitelist.Utils.TableClearDoubles(tbl)
end

--- Get mode name for language name format
---@param name1 string Localized version of language name
---@param name2 string English version of language name
---@param mode? number Print mode
---@return string
local function getModeName(name1, name2, mode)
	if not isnumber(mode) then
		mode = 0
	end
	mode = math.Clamp(mode, 0, 2)

	if mode == 0 then
		return string.format("%s (%s)", name1, name2)
	elseif mode == 1 then
		return name1
	elseif mode == 2 then
		return name2
	else
		return ""
	end
end

--- Get language name
---@param lang string Input language
---@param mode? number Print mode
---@return string
function IRNWhitelist.Lang:GetName(lang, mode)
	if not isstring(lang) then
		lang = self:GetNow()
	end
	lang = lang:lower()

	if not self:Has(lang) then
		return getModeName("Unknown", "Unknown", mode)
	end

	local name1 = self:GetPhrase("language_name", lang)
	if #name1 < 1 or name1 == "language_name" then
		name1 = "Unknown"
	end

	local name2 = self:GetPhrase("language_name_en", lang)
	if #name2 < 1 or name2 == "language_name_en" then
		name2 = lang
	end

	return getModeName(name1, name2, mode)
end

--- Get now language name
---@param mode? number Print mode
---@return string
function IRNWhitelist.Lang:GetNowName(mode)
	return self:GetName(self:GetNow(), mode)
end

--- Check if language exists
---@param lang string Input language
---@return boolean
function IRNWhitelist.Lang:Has(lang)
	if not isstring(lang) then
		return false
	end

	return table.HasValue(self.GetLanguages(), lang:lower())
end

--- Change current language
---@param new_lang string New language
---@return boolean
function IRNWhitelist.Lang:Set(new_lang)
	return IRNWhitelist.CVars:Set("language", "string", new_lang)
end

--- Get current language
---@return string
function IRNWhitelist.Lang:GetNow()
	local now = self.Now
	if #now < 1 then
		now = self.Default
	end
	return now
end
IRNWhitelist.Lang.Get = IRNWhitelist.Lang.GetNow

--- Main load module function
function IRNWhitelist.Lang:Load()
	self.CVar = self.CVar or (SERVER and IRNWhitelist.CVars:ConVar("language") or GetConVar("gmod_language"))
	if not self.CVar then
		return
	end

	self.Default = empty_or(self.CVar:GetDefault(), "en")
	self.Now = empty_or(self.CVar:GetString(), self.Default)

	self._Cache = self.GetPhrases(self.Now)
	self._CacheDefault = self.GetPhrases(self.Default, true)

	if table.IsEmpty(self._CacheDefault) then
		IRNWhitelist.Console:Critical("Default language '{{1}}' not found! Reinstall the addon.", self.Default)
	end
end

if CLIENT then
	hook.Add("InitPostEntity", "irn_whitelist.lang_load", function()
		IRNWhitelist.Lang:Load()
	end)
end
