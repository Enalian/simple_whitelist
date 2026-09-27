IRNWhitelist.Console = {}

function IRNWhitelist.Console.Info(phrase, ...)
	MsgC(
		Color(162, 162, 255),
		"[SimpleWhitelist] [*] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
end

function IRNWhitelist.Console.Help(phrase, ...)
	MsgC(
		Color(162, 162, 162),
		"[SimpleWhitelist] [?] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
end

function IRNWhitelist.Console.Error(phrase, ...)
	MsgC(
		Color(255, 162, 162),
		"[SimpleWhitelist] [-] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
end

function IRNWhitelist.Console.Critical(phrase, ...)
	MsgC(
		Color(255, 0, 0),
		"[SimpleWhitelist] [!] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
	ErrorNoHalt(phrase)
end

function IRNWhitelist.Console.Warn(phrase, ...)
	MsgC(
		Color(255, 255, 162),
		"[SimpleWhitelist] [%] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
end

function IRNWhitelist.Console.Success(phrase, ...)
	MsgC(
		Color(162, 255, 162),
		"[SimpleWhitelist] [+] ",
		color_white,
		IRNWhitelist.Lang:FormatPhrase(phrase, ...),
		color_white,
		"\n"
	)
end
