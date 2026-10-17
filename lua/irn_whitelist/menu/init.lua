util.AddNetworkString("irn_whitelist.command")

--- Check player access
---@param ply Player Checking player
---@return boolean
local function hasAccess(ply)
	if not IsValid(ply) then
		return false
	end

	if istable(ulx) then
		return ply:query("ulx whitelist")
	elseif istable(SAM) or istable(Lyn) then
		return ply:HasPermission("whitelist")
	else
		return ply:IsAdmin()
	end
end

net.Receive("irn_whitelist.command", function(_, ply)
	local name = net.ReadString()
	if not hasAccess(ply) then
		return
	end

	if name == "enable" then
		local enable = net.ReadBool()
		IRNWhitelist.CVars:Set("enable", "bool", enable)
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatPhrase(
				string.format("log.enable.%s", enable and "on" or "off"),
				IRNWhitelist.Utils.PrintPlayerName(ply)
			)
		)

		net.Start("irn_whitelist.command")
		net.WriteString("notify")
		net.WriteCompressedTable({ string.format("commands.%s", enable and "enable" or "disable") })
		net.WriteBool(false)
		net.Send(ply)
	elseif name == "save_settings" then
		local settings = net.ReadCompressedTable()
		IRNWhitelist.CVars:Apply(settings)
		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatPhrase("log.save_settings", IRNWhitelist.Utils.PrintPlayerName(ply, nil, true))
		)
	elseif name == "add_player" then
		local sid64 = net.ReadString()
		local once = net.ReadBool()

		if not IRNWhitelist.Players.IsValidSteamID64(sid64) then
			net.Start("irn_whitelist.command")
			net.WriteString("notify")
			net.WriteCompressedTable({ "menu.not_sid64" })
			net.WriteBool(false)
			net.Send(ply)
			return
		end

		if IRNWhitelist.Whitelist.IsPlayerWhitelisted(sid64) then
			net.Start("irn_whitelist.command")
			net.WriteString("notify")
			net.WriteCompressedTable({ "commands.already_in_whitelist", IRNWhitelist.Players:GetNickname(sid64) })
			net.WriteBool(false)
			net.Send(ply)
			return
		end

		IRNWhitelist.Whitelist:AddPlayer(sid64, once)
		net.Start("irn_whitelist.command")
		net.WriteString("notify")
		net.WriteCompressedTable({
			"commands.add_player_to_whitelist",
			IRNWhitelist.Players:GetNickname(sid64),
			once and "%commands.flags.once%" or "",
		})
		net.WriteBool(false)
		net.Send(ply)

		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatPhrase(
				"log.add_player_to_whitelist",
				IRNWhitelist.Utils.PrintPlayerName(ply, nil, true),
				IRNWhitelist.Utils.PrintPlayerName(IRNWhitelist.Players:GetNickname(sid64), sid64, true)
			)
		)
	elseif name == "del_player" then
		local sid64 = net.ReadString()
		if not IRNWhitelist.Players.IsValidSteamID64(sid64) then
			net.Start("irn_whitelist.command")
			net.WriteString("notify")
			net.WriteCompressedTable({ "menu.not_sid64" })
			net.WriteBool(false)
			net.Send(ply)
			return
		end

		local msg = {}
		if IRNWhitelist.Whitelist:RemovePlayer(sid64) then
			table.insert(msg, "commands.remove_player_from_whitelist")
			table.insert(msg, IRNWhitelist.Players:GetNickname(sid64))
		else
			table.insert(msg, "commands.not_in_whitelist")
			table.insert(msg, IRNWhitelist.Players:GetNickname(sid64))
		end

		net.Start("irn_whitelist.message")
		net.WriteString("notify")
		net.WriteCompressedTable(msg)
		net.WriteBool(false)
		net.Send(ply)

		IRNWhitelist.Utils.Log(
			IRNWhitelist.Lang:FormatPhrase(
				"log.remove_player_from_whitelist",
				IRNWhitelist.Utils.PrintPlayerName(ply, nil, true),
				IRNWhitelist.Utils.PrintPlayerName(IRNWhitelist.Players:GetNickname(sid64), sid64, true)
			)
		)
	elseif name == "open" then
		local data = {
			Enabled = IRNWhitelist.CVars:Get("enable", "bool", false),
			Settings = IRNWhitelist.Settings:Collect(),
			Players = {},
		}

		for k, v in pairs(IRNWhitelist.Whitelist.GetPlayers()) do
			table.insert(data.Players, {
				nickname = IRNWhitelist.Players:GetNickname(k),
				sid = k,
				once = v,
			})
		end

		net.Start("irn_whitelist.command")
		net.WriteString("open")
		net.WriteCompressedTable(data)
		net.Send(ply)
	end
end)
