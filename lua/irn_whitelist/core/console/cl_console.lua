IRNWhitelist.Console = {}

--- Print raw information text into client console
---@param str string Text to print
function IRNWhitelist.Console.InfoRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	MsgC(Color(162, 162, 255), "[SimpleWhitelist] [*] ", color_white, str .. "\n")
end

--- Print information into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Info(phrase, ...)
	self.InfoRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw help message text into client console
---@param str string Text to print
function IRNWhitelist.Console.HelpRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	MsgC(Color(162, 162, 162), "[SimpleWhitelist] [?] ", color_white, str .. "\n")
end

--- Print help message into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Help(phrase, ...)
	self.HelpRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw error text into client console
---@param str string Text to print
function IRNWhitelist.Console.ErrorRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	MsgC(Color(255, 162, 162), "[SimpleWhitelist] [-] ", color_white, str .. "\n")
end

--- Print error into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Error(phrase, ...)
	self.ErrorRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw critical error text into client console
---@param str string Text to print
function IRNWhitelist.Console.CriticalRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	str = str .. "\n"
	MsgC(Color(255, 0, 0), "[SimpleWhitelist] [!] ", color_white, str)
	ErrorNoHalt(str)
end

--- Print critical error into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Critical(phrase, ...)
	self.CriticalRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw warning text into client console
---@param str string Text to print
function IRNWhitelist.Console.WarnRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	MsgC(Color(255, 255, 162), "[SimpleWhitelist] [%] ", color_white, str .. "\n")
end

--- Print warning into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Warn(phrase, ...)
	self.WarnRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw success message text into client console
---@param str string Text to print
function IRNWhitelist.Console.SuccessRaw(str)
	if not isstring(str) or #str < 1 then
		return
	end

	MsgC(Color(162, 255, 162), "[SimpleWhitelist] [+] ", color_white, str .. "\n")
end

--- Print success message into client console
---@param phrase string Phrase (or text) to print
---@param ... string Format strings
function IRNWhitelist.Console:Success(phrase, ...)
	self.SuccessRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end
