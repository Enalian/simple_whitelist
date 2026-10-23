IRNWhitelist.Console = {}

--- Send 'str' to log
---@param str string Text to log
---@param log_type string Logging type
---@param ... string|table Input arguments
local function logThisPls(str, log_type, ...)
	local args = { ... }
	local params = istable(args[#args]) and args[#args] or {}
	if not params.no_log then
		IRNWhitelist.Utils.Log(IRNWhitelist.Lang:FormatString(string.format("%%log.%s%% %s", log_type, str)))
	end
end

--- Print raw information text into server console
---@param str string Text to print
function IRNWhitelist.Console.InfoRaw(str)
	MsgC(Color(162, 162, 255), "[SimpleWhitelist] [*] ", color_white, str .. "\n")
end

--- Print information into server console
---@param phrase string Phrase to print
---@param ... string Format strings
function IRNWhitelist.Console:Info(phrase, ...)
	self.InfoRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw help message text into server console
---@param str string Text to print
function IRNWhitelist.Console.HelpRaw(str)
	MsgC(Color(162, 162, 162), "[SimpleWhitelist] [?] ", color_white, str .. "\n")
end

--- Print help message into server console
---@param phrase string Phrase to print
---@param ... string Format strings
function IRNWhitelist.Console:Help(phrase, ...)
	self.HelpRaw(IRNWhitelist.Lang:FormatPhrase(phrase, ...))
end

--- Print raw error text into server console
---@param str string Text to print
---@param no_log? boolean Need to be logged?
function IRNWhitelist.Console.ErrorRaw(str, no_log)
	logThisPls(str, "error", { no_log = no_log })
	MsgC(Color(255, 162, 162), "[SimpleWhitelist] [-] ", color_white, str .. "\n")
end

--- Print error into server console
---@param phrase string Phrase to print
---@param ... string|table Format strings
function IRNWhitelist.Console:Error(phrase, ...)
	local str = IRNWhitelist.Lang:FormatPhrase(phrase, ...)
	self.ErrorRaw(str, true)
	logThisPls(str, "error", ...)
end

--- Print raw critical error text into server console
---@param str string Text to print
---@param no_log? boolean Need to be logged?
function IRNWhitelist.Console.CriticalRaw(str, no_log)
	logThisPls(str, "critical", { no_log = no_log })

	local text = str .. "\n"
	MsgC(Color(255, 0, 0), "[SimpleWhitelist] [!] ", color_white, text)
	ErrorNoHalt(text)
end

--- Print critical error into server console
---@param phrase string Phrase to print
---@param ... string Format strings
function IRNWhitelist.Console:Critical(phrase, ...)
	local str = IRNWhitelist.Lang:FormatPhrase(phrase, ...)
	self.CriticalRaw(str, true)
	logThisPls(str, "critical", ...)
end

--- Print raw warning text into server console
---@param str string Text to print
---@param no_log? boolean Need to be logged?
function IRNWhitelist.Console.WarnRaw(str, no_log)
	logThisPls(str, "warn", { no_log = no_log })
	MsgC(Color(255, 255, 162), "[SimpleWhitelist] [%] ", color_white, str .. "\n")
end

--- Print warning into server console
---@param phrase string Phrase to print
---@param ... string Format strings
function IRNWhitelist.Console:Warn(phrase, ...)
	local str = IRNWhitelist.Lang:FormatPhrase(phrase, ...)
	self.WarnRaw(str, true)
	logThisPls(str, "warn", ...)
end

--- Print raw success message text into server console
---@param str string Text to print
---@param no_log? boolean Need to be logged?
function IRNWhitelist.Console.SuccessRaw(str, no_log)
	logThisPls(str, "success", { no_log = no_log })
	MsgC(Color(162, 255, 162), "[SimpleWhitelist] [+] ", color_white, str .. "\n")
end

--- Print success message into server console
---@param phrase string Phrase to print
---@param ... string Format strings
function IRNWhitelist.Console:Success(phrase, ...)
	local str = IRNWhitelist.Lang:FormatPhrase(phrase, ...)
	self.SuccessRaw(str, true)
	logThisPls(str, "success", ...)
end
