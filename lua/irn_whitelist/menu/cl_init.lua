--- Check player access
---@return boolean
local function hasAccess()
	local ply = LocalPlayer()
	if istable(ulx) then
		return ply:query("ulx whitelist")
	elseif istable(SAM) or istable(Lyn) then
		return ply:HasPermission("whitelist")
	else
		return ply:IsAdmin()
	end
end

local color_red = Color(255, 162, 162)

concommand.Add("whitelist_menu", function()
	if not istable(Mantle) then
		chat.AddText(color_red, IRNWhitelist.Lang:FormatString("[SimpleWhitelist] %menu.not_mantle%"))
		surface.PlaySound("buttons/button8.wav")
		return
	end

	if not hasAccess() then
		chat.AddText(color_red, IRNWhitelist.Lang:FormatString("[SimpleWhitelist] %menu.not_rights%"))
		surface.PlaySound("buttons/button2.wav")
		return
	end

	if IsValid(IRNWhitelist.MenuOpened) then
		IRNWhitelist.MenuOpened:Close()
	end
	IRNWhitelist.MenuOpened = vgui.Create("IRNWhitelist_Menu")
end)

net.Receive("irn_whitelist.command", function()
	local name = net.ReadString()
	if name == "notify" then
		if not IsValid(IRNWhitelist.MenuOpened) then
			return
		end

		local msg = net.ReadCompressedTable()
		local is_str = net.ReadBool()
		local str = is_str and IRNWhitelist.Lang:FormatString(unpack(msg))
			or IRNWhitelist.Lang:FormatPhrase(unpack(msg))

		IRNWhitelist.MenuOpened:Notify(str, 2)
	elseif name == "open" then
		local data = net.ReadCompressedTable()
		if not IsValid(IRNWhitelist.MenuOpened) then
			IRNWhitelist.MenuOpened = vgui.Create("IRNWhitelist_Menu")
		end
		IRNWhitelist.MenuOpened:Setup(data)
	end
end)
