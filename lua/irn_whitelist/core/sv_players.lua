IRNWhitelist.Players = {
	_SQLTable = "whitelist_nicknames",
}

function IRNWhitelist.Players.IsValidSteamID(steamid)
	if not isstring(steamid) then
		return false
	end

	return steamid:match("^STEAM_%d:%d:%d+$") ~= nil
end

function IRNWhitelist.Players.IsValidSteamID64(steamid64)
	if not isstring(steamid64) then
		return false
	end

	local steamid64_parse = IRNWhitelist.Utils.Module("steamid64-parse")
	if not isfunction(steamid64_parse.is_valid) then
		return false
	end

	return steamid64_parse.is_valid(steamid64)
end

function IRNWhitelist.Players.GetByNickname(name)
	local players = {}
	for _, v in ipairs(player.GetAll()) do
		if string.find(v:Nick(), name, 1, true) ~= nil then
			table.insert(players, v)
		end
	end

	if #players == 1 then
		return players[1]
	end

	return false
end

function IRNWhitelist.Players:SetNickname(steamid64, name)
	if not self.IsValidSteamID64(steamid64) then
		return
	end
	if not IRNWhitelist.CVars:Get("save_names", "bool", true) then
		return
	end

	sql.Query(
		string.format(
			"INSERT INTO %s (steamid64, name) VALUES (%s, %s) ON CONFLICT(steamid64) DO UPDATE SET name = EXCLUDED.name;",
			self._SQLTable,
			sql.SQLStr(steamid64),
			sql.SQLStr(name)
		)
	)
end

function IRNWhitelist.Players:GetNickname(steamid64)
	if not self.IsValidSteamID64(steamid64) then
		return steamid64
	end

	local ply = player.GetBySteamID64(steamid64)
	if IsValid(ply) then
		return ply:Nick()
	end

	return sql.QueryRow(
		string.format("SELECT name FROM %s WHERE steamid64 = %s;", self._SQLTable, sql.SQLStr(steamid64))
	) or steamid64
end

function IRNWhitelist.Players:FromAny(input)
	if not isstring(input) and not isnumber(input) then
		return nil, nil
	end

	if IsValid(input) and input:IsPlayer() then
		return input:SteamID64(), input:Nick()
	end

	if self.IsValidSteamID(input) then
		local ply = player.GetBySteamID(input)
		if IsValid(ply) and ply:IsPlayer() then
			return ply:SteamID64(), ply:Nick()
		else
			local steamid64 = util.SteamIDTo64(input)
			return steamid64, self:GetNickname(steamid64)
		end
	end

	if self.IsValidSteamID64(input) then
		local ply = player.GetBySteamID64(input)
		if IsValid(ply) and ply:IsPlayer() then
			return ply:SteamID64(), ply:Nick()
		else
			return input, self:GetNickname(input)
		end
	end

	if isnumber(input) then
		if IsValid(player.GetByAccountID(input)) and player.GetByAccountID(input):IsPlayer() then
			local ply = player.GetByAccountID(input)
			return ply:SteamID64(), ply:Nick()
		end

		if IsValid(Player(input)) and Player(input):IsPlayer() then
			local ply = Player(input)
			return ply:SteamID64(), ply:Nick()
		end

		if IsValid(Entity(input)) and Entity(input):IsPlayer() then
			local ply = Entity(input)
			return ply:SteamID64(), ply:Nick()
		end
	end

	if IsValid(self.GetByNickname(input)) and self.GetByNickname(input):IsPlayer() then
		local ply = self.GetByNickname(input)
		return ply:SteamID64(), ply:Nick()
	end

	return nil, nil
end

function IRNWhitelist.Players:Load()
	sql.Query(
		string.format(
			"CREATE TABLE %s ( steamid64 VARCHAR(20) PRIMARY KEY NOT NULL, name TEXT NOT NULL )",
			self._SQLTable
		)
	)

	gameevent.Listen("player_disconnect")
	hook.Add("player_disconnect", "irn_whitelist.set_nickname", function(data)
		if not IRNWhitelist.Utils.Int2Bool(data.bot) then
			self:SetNickname(util.SteamIDTo64(data.networkid), data.name)
		end
	end)
end
