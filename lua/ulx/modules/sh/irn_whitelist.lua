function ulx.whitelist_menu(calling_ply)
	if not IsValid(calling_ply) then
		return ULib.tsayError(calling_ply, "Only from game!")
	end

	calling_ply:ConCommand("whitelist_menu")
end
local whitelist = ulx.command("Simple Whitelist", "ulx whitelist", ulx.whitelist_menu, "!whitelist", true)
whitelist:defaultAccess(ULib.ACCESS_SUPERADMIN)
whitelist:help("Open the whitelist menu.")
