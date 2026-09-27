IRNWhitelist.Commands = {}

function IRNWhitelist.Commands.New(name, do_func, desc)
	if not isstring(name) or not isfunction(do_func) then
		return
	end
	if isstring(desc) then
		desc = "[SimpleWhitelist]: " .. desc
		desc = desc:EndsWith(".") and desc or desc .. "."
	end
	name = "whitelist_" .. name

	concommand.Add(name, function(ply, _, args)
		if IsValid(ply) then
			return
		end

		do_func(args)
	end, nil, desc)
end

function IRNWhitelist.Commands:Load()
	self.New("on", function()
		IRNWhitelist.CVars:Set("enable", true)
		IRNWhitelist.Console.Success("commands.enable")
	end, "Enable whitelist")

	self.New("off", function()
		IRNWhitelist.CVars:Set("enable", false)
		IRNWhitelist.Console.Success("commands.disable")
	end, "Disable whitelist")

	self.New("toggle", function()
		IRNWhitelist.CVars:Toggle("enable")
		IRNWhitelist.Console.Success(
			string.format("commands.%s", IRNWhitelist.CVars:Get("enable", "bool", false) and "enable" or "disable")
		)
	end, "Toggle whitelist")

	self.New("status", function()
		IRNWhitelist.Console.Info(
			"commands.whitelist_status",
			string.format(
				"%%commands.whitelist_statuses.%s%%",
				IRNWhitelist.CVars:Get("enable", "bool", false) and "on" or "off"
			)
		)
	end, "Check whitelist status (on or off)")

	self.New("add", function(args)
		if not args[1] or (isstring(args[1]) and #args[1] < 1) then
			IRNWhitelist.Console.Help("commands.help_add")
			return
		end

		local steamid, name = IRNWhitelist.Players:FromAny(args[1])
		if not steamid then
			IRNWhitelist.Console.Error("commands.invalid_player", args[1])
			return
		end

		if IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid) then
			IRNWhitelist.Console.Error("commands.already_in_whitelist", name)
			return
		end

		local once = IRNWhitelist.Utils.Int2Bool(tonumber(args[2]) or 0)
		IRNWhitelist.Whitelist:AddPlayer(steamid, once)

		local print_name = IRNWhitelist.Utils.PrintPlayerName(name, steamid)
		IRNWhitelist.Console.Success(
			"commands.add_player_to_whitelist",
			print_name,
			once and "%commands.flags.once%" or ""
		)
	end, "Add player to whitelist")

	self.New("remove", function(args)
		if not args[1] or (isstring(args[1]) and #args[1] < 1) then
			IRNWhitelist.Console.Help("commands.help_remove")
			return
		end

		local steamid, name = IRNWhitelist.Players:FromAny(args[1])
		if not steamid then
			IRNWhitelist.Console.Error("commands.invalid_player", args[1])
			return
		end

		if not IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid) then
			IRNWhitelist.Console.Error("commands.not_in_whitelist", name)
			return
		end

		IRNWhitelist.Whitelist:RemovePlayer(steamid)

		local print_name = IRNWhitelist.Utils.PrintPlayerName(name, steamid)
		IRNWhitelist.Console.Success("commands.remove_player_from_whitelist", print_name)
	end, "Remove player from whitelist")

	self.New("set", function(args)
		if not args[1] or (isstring(args[1]) and #args[1] < 1) then
			IRNWhitelist.Console.Help("commands.help_set")
			return
		end

		local steamid, name = IRNWhitelist.Players:FromAny(args[1])
		if not steamid then
			IRNWhitelist.Console.Error("commands.invalid_player", args[1])
			return
		end

		local once = IRNWhitelist.Utils.Int2Bool(tonumber(args[2]) or 0)
		IRNWhitelist.Whitelist:SetPlayers({ [steamid] = once })

		local print_name = IRNWhitelist.Utils.PrintPlayerName(name, steamid)
		IRNWhitelist.Console.Success("commands.whitelist_setted", print_name, once and "%commands.flags.once%" or "")
	end, "Clear whitelist and add player")

	self.New("clear", function()
		if IRNWhitelist.Whitelist:PlayersCount() < 1 then
			IRNWhitelist.Console.Error("commands.whitelist_empty")
			return
		end

		IRNWhitelist.Whitelist.Clear()
		IRNWhitelist.Console.Success("commands.whitelist_cleared")
	end, "Clear whitelist")

	self.New("clear_duplicates", function()
		if IRNWhitelist.Whitelist:PlayersCount() < 1 then
			IRNWhitelist.Console.Error("commands.whitelist_empty")
			return
		end

		IRNWhitelist.Whitelist.ClearDuplicates()
		IRNWhitelist.Console.Success("commands.whitelist_duplicates_cleared")
	end)

	self.New("players", function()
		if IRNWhitelist.Whitelist:PlayersCount() < 1 then
			IRNWhitelist.Console.Info("commands.whitelist_players_empty")
			return
		end

		local msg = "%commands.whitelist_players_title%"
		for steamid64, once in pairs(IRNWhitelist.Whitelist:GetPlayers()) do
			local nickname = IRNWhitelist.Players:GetNickname(steamid64)

			msg = string.format(
				"%s\n\t%s",
				msg,
				string.format(
					"- %s%s%s",
					steamid64,
					nickname == steamid64 and "" or ", " .. nickname,
					once and "%commands.flags.once_players%" or ""
				)
			)
		end

		IRNWhitelist.Console.Info(msg, IRNWhitelist.Whitelist:PlayersCount())
	end, "List of all whitelisted players")

	self.New("save_settings", function()
		IRNWhitelist.Settings:Save()
		IRNWhitelist.Console.Success("commands.whitelist_settings_saved")
	end, "Save whitelist settings")

	self.New("load_settings", function()
		IRNWhitelist.Settings:Apply()
		IRNWhitelist.Console.Success("commands.whitelist_settings_loaded")
	end, "Load whitelist settings")
end
