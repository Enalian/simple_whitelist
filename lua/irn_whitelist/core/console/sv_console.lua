IRNWhitelist.Console = {}

function IRNWhitelist.Console.Info(phrase, ...)
	MsgC(
		Color(162, 162, 255),
		"[SimpleWhitelist] [*] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...) .. "\n"
	)
end

function IRNWhitelist.Console.Help(phrase, ...)
	MsgC(
		Color(162, 162, 162),
		"[SimpleWhitelist] [?] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...) .. "\n"
	)
end

function IRNWhitelist.Console.Error(phrase, ...)
	local params = {}
	local args = { ... }
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	MsgC(
		Color(255, 162, 162),
		"[SimpleWhitelist] [-] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, unpack(args)) .. "\n"
	)
	if not params.no_log then
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatString(string.format("%%log.error%% %%%s%%", phrase), unpack(args))
		)
	end
end

function IRNWhitelist.Console.Critical(phrase, ...)
	local params = {}
	local args = { ... }
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	local parsed_phrase = IRNWhitelist.Lang:FormatPhrase(phrase, unpack(args)) .. "\n"
	MsgC(Color(255, 0, 0), "[SimpleWhitelist] [!] ", color_white, parsed_phrase)
	ErrorNoHalt(parsed_phrase)
	if not params.no_log then
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatString(string.format("%%log.critical%% %%%s%%", phrase), unpack(args))
		)
	end
end

function IRNWhitelist.Console.Warn(phrase, ...)
	local params = {}
	local args = { ... }
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	MsgC(
		Color(255, 255, 162),
		"[SimpleWhitelist] [%] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, unpack(args)) .. "\n"
	)
	if not params.no_log then
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatString(string.format("%%log.warn%% %%%s%%", phrase), unpack(args))
		)
	end
end

function IRNWhitelist.Console.Success(phrase, ...)
	local params = {}
	local args = { ... }
	if istable(args[#args]) then
		params = args[#args]
		table.remove(args, #args)
	end

	MsgC(
		Color(162, 255, 162),
		"[SimpleWhitelist] [+] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, unpack(args)) .. "\n"
	)
	if not params.no_log then
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatString(string.format("%%log.success%% %%%s%%", phrase), unpack(args))
		)
	end
end
