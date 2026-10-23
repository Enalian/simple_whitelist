local PANEL = {
	dockCoef = 8,
	panelW = 800,
	panelH = 600,
}

local function T(phrase, ...)
	return IRNWhitelist.Lang:FormatPhrase(phrase, ...)
end

function PANEL:Init()
	self:SetSize(self.panelW, self.panelH)
	self:Center()
	self:MakePopup()
	self:SetCenterTitle(T("menu.title"))
	self:SetTitle("")
	self:ShowAnimation()

	self.Data = {}
	self._Init = false

	self:CalcStartY()
	self:EnableBlock()
	self:SettingsBlock()
	self:PlayersBlock()

	timer.Simple(1, function()
		if not IsValid(self) then
			return
		end
		if not self._Init then
			net.Start("irn_whitelist.command")
			net.WriteString("open")
			net.SendToServer()
		end
	end)
end

function PANEL:CalcStartY()
	local _, y = self:GetDockPadding()
	self.StartY = y
end

function PANEL:EnableBlock(update)
	if update and IsValid(self.EnableCB) then
		self.EnableCB:SetValue(self.Data.Enable)
		return
	end

	self.EnableCB = vgui.Create("MantleCheckBox", self)
	self.EnableCB:SetWide(self:GetWide() / 2 - self.dockCoef / 2)
	self.EnableCB:SetPos(self.dockCoef, self.StartY)
	self.EnableCB:SetTxt(T("menu.enable_cb"))
	self.EnableCB.OnChange = function(_, value)
		net.Start("irn_whitelist.command")
		net.WriteString("enable")
		net.WriteBool(value)
		net.SendToServer()
	end
end

function PANEL:SettingsBlock(update)
	if not IsValid(self.EnableCB) then
		return
	end

	if update then
		if not istable(self.Data) or not istable(self.Data.Settings) then
			return
		end

		for _, v in ipairs(self.Settings.LanguageSelect.ComboBox.choices) do
			if v.data == self.Data.Settings.language then
				self.Settings.LanguageSelect.ComboBox:SetValue(v.text)
				self.Settings.LanguageSelect.ComboBox.SelectedData = v.data
				break
			end
		end
		self.Settings.JoinKickReasonString:SetValue(self.Data.Settings.joinkick_reason or "")
		self.Settings.KickReasonString:SetValue(self.Data.Settings.kick_reason or "")
		self.Settings.DateFormatString:SetValue(self.Data.Settings.date_format or "")
		self.Settings.TimeFormatString:SetValue(self.Data.Settings.time_format or "")
		self.Settings.PasswordCheckBool:SetValue(self.Settings.SaveSettingsBool.password_check)
		self.Settings.KickPlayersBool:SetValue(self.Settings.SaveSettingsBool.kick_players)
		self.Settings.KickBotsBool:SetValue(self.Settings.SaveSettingsBool.kick_bots)
		self.Settings.EnableLogsBool:SetValue(self.Settings.SaveSettingsBool.enable_logs)
		self.Settings.SaveNamesBool:SetValue(self.Settings.SaveSettingsBool.save_names)
		self.Settings.SaveSettingsBool:SetValue(self.Settings.SaveSettingsBool.save_settings)

		return
	end

	self.Settings = vgui.Create("MantlePanel", self)
	self.Settings:SetPos(self.EnableCB:GetX(), self.EnableCB:GetY() + self.EnableCB:GetTall() + self.dockCoef)
	self.Settings:SetSize(self.EnableCB:GetWide(), self.panelH - self.Settings:GetY() - self.dockCoef)
	self.Settings:SetCustomColor(Mantle.color.focus_panel)

	self.Settings.Title = vgui.Create("MantleText", self.Settings)
	self.Settings.Title:SetTall(30)
	self.Settings.Title:Dock(TOP)
	self.Settings.Title:DockMargin(0, 0, 0, 8)
	self.Settings.Title:SetText(T("menu.settings_title"))
	self.Settings.Title:SetFont(self.CacheFont(22, true))
	self.Settings.Title:SetAlign(TEXT_ALIGN_CENTER)
	self.Settings.Title:SetVAlign(TEXT_ALIGN_CENTER)

	self.Settings.Scroll = vgui.Create("MantleScrollPanel", self.Settings)
	self.Settings.Scroll:Dock(FILL)

	self.Settings.LanguageSelect = vgui.Create("Panel", self.Settings.Scroll:GetCanvas())

	self.Settings.LanguageSelect.Title = vgui.Create("Panel", self.Settings.LanguageSelect)
	self.Settings.LanguageSelect.Title:SetTall(18)
	self.Settings.LanguageSelect.Title:Dock(TOP)
	self.Settings.LanguageSelect.Title:SetText(T("menu.server_language"))
	self.Settings.LanguageSelect.Title.Paint = function(s)
		draw.SimpleText(s:GetText(), "Fated.16", w, h, Mantle.color.text)
	end

	self.Settings.LanguageSelect.ComboBox = vgui.Create("MantleComboBox", self.Settings.LanguageSelect)
	self.Settings.LanguageSelect.ComboBox:Dock(TOP)
	self.Settings.LanguageSelect.ComboBox:SetPlaceholder(T("menu.server_language_ph"))
	for _, v in ipairs(IRNWhitelist.Lang.GetLanguages()) do
		self.Settings.LanguageSelect.ComboBox:AddChoice(IRNWhitelist.Lang:GetName(v), v)
	end
	self.Settings.LanguageSelect.ComboBox.OnSelect = function(s, id, text, data)
		if not IsValid(s) then
			data = text
			text = id
			id = s
		end

		self.Settings.LanguageSelect.ComboBox.SelectedData = data
	end

	timer.Simple(0, function()
		self.Settings.LanguageSelect:SetTall(
			self.Settings.LanguageSelect.ComboBox:GetY() + self.Settings.LanguageSelect.ComboBox:GetTall()
		)
		self.Settings.LanguageSelect:Dock(TOP)
		self.Settings.LanguageSelect:DockMargin(0, 0, 0, 8)
	end)

	self.Settings.JoinKickReasonString = vgui.Create("MantleEntry", self.Settings.Scroll:GetCanvas())
	self.Settings.JoinKickReasonString:Dock(TOP)
	self.Settings.JoinKickReasonString:DockMargin(0, 0, 0, 8)
	self.Settings.JoinKickReasonString:SetTitle(T("menu.joinkick_reason"))
	self.Settings.JoinKickReasonString:SetPlaceholder(T("menu.joinkick_reason_ph"))

	self.Settings.KickReasonString = vgui.Create("MantleEntry", self.Settings.Scroll:GetCanvas())
	self.Settings.KickReasonString:Dock(TOP)
	self.Settings.KickReasonString:DockMargin(0, 0, 0, 8)
	self.Settings.KickReasonString:SetTitle(T("menu.kick_reason"))
	self.Settings.KickReasonString:SetPlaceholder(T("menu.kick_reason_ph"))

	self.Settings.DateFormatString = vgui.Create("MantleEntry", self.Settings.Scroll:GetCanvas())
	self.Settings.DateFormatString:Dock(TOP)
	self.Settings.DateFormatString:DockMargin(0, 0, 0, 8)
	self.Settings.DateFormatString:SetTitle(T("menu.date_format"))
	self.Settings.DateFormatString:SetPlaceholder(T("menu.date_format_ph"))

	self.Settings.TimeFormatString = vgui.Create("MantleEntry", self.Settings.Scroll:GetCanvas())
	self.Settings.TimeFormatString:Dock(TOP)
	self.Settings.TimeFormatString:DockMargin(0, 0, 0, 8)
	self.Settings.TimeFormatString:SetTitle(T("menu.time_format"))
	self.Settings.TimeFormatString:SetPlaceholder(T("menu.time_format_ph"))

	self.Settings.PasswordCheckBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.PasswordCheckBool:Dock(TOP)
	self.Settings.PasswordCheckBool:DockMargin(0, 0, 0, 8)
	self.Settings.PasswordCheckBool:SetTxt(T("menu.password_check"))

	self.Settings.KickPlayersBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.KickPlayersBool:Dock(TOP)
	self.Settings.KickPlayersBool:DockMargin(0, 0, 0, 8)
	self.Settings.KickPlayersBool:SetTxt(T("menu.kick_players"))

	self.Settings.KickBotsBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.KickBotsBool:Dock(TOP)
	self.Settings.KickBotsBool:DockMargin(0, 0, 0, 8)
	self.Settings.KickBotsBool:SetTxt(T("menu.kick_bots"))

	self.Settings.EnableLogsBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.EnableLogsBool:Dock(TOP)
	self.Settings.EnableLogsBool:DockMargin(0, 0, 0, 8)
	self.Settings.EnableLogsBool:SetTxt(T("menu.enable_logs"))

	self.Settings.SaveNamesBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.SaveNamesBool:Dock(TOP)
	self.Settings.SaveNamesBool:DockMargin(0, 0, 0, 8)
	self.Settings.SaveNamesBool:SetTxt(T("menu.save_names"))
	self.Settings.SaveNamesBool:SetTooltip(T("menu.save_names_tooltip"))

	self.Settings.SaveSettingsBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.SaveSettingsBool:Dock(TOP)
	self.Settings.SaveSettingsBool:DockMargin(0, 0, 0, 8)
	self.Settings.SaveSettingsBool:SetTxt(T("menu.save_settings"))
	self.Settings.SaveSettingsBool:SetTooltip(T("menu.save_settings_tooltip"))

	self.Settings.IPasswordsBool = vgui.Create("MantleCheckBox", self.Settings.Scroll:GetCanvas())
	self.Settings.IPasswordsBool:Dock(TOP)
	self.Settings.IPasswordsBool:DockMargin(0, 0, 0, 8)
	self.Settings.IPasswordsBool:SetTxt(T("menu.ipasswords_enable"))
	self.Settings.IPasswordsBool:SetTooltip(T("menu.ipasswords_enable_tooltip"))

	self.Settings.SaveBtn = vgui.Create("MantleBtn", self.Settings.Scroll:GetCanvas())
	self.Settings.SaveBtn:Dock(TOP)
	self.Settings.SaveBtn:DockMargin(0, 0, 0, 8)
	self.Settings.SaveBtn:SetTxt(T("menu.save_settings_btn"))
	self.Settings.SaveBtn:SetRipple(true)
	self.Settings.SaveBtn.DoClick = function()
		local data = {
			language = self.Settings.LanguageSelect.ComboBox.SelectedData,
			joinkick_reason = self.Settings.JoinKickReasonString:GetValue(),
			kick_reason = self.Settings.KickReasonString:GetValue(),
			date_format = self.Settings.DateFormatString:GetValue(),
			time_format = self.Settings.TimeFormatString:GetValue(),
			kick_players = self.Settings.KickPlayersBool:GetValue(),
			kick_bots = self.Settings.KickBotsBool:GetValue(),
			enable_logs = self.Settings.EnableLogsBool:GetValue(),
			save_names = self.Settings.SaveNamesBool:GetValue(),
			save_settings = self.Settings.SaveSettingsBool:GetValue(),
		}

		if not data.language or #data.language < 1 then
			self:Notify(T("menu.field_incorrectly_selected", "%menu.server_language%"), 2)
			return
		end

		if not data.joinkick_reason or #data.joinkick_reason < 1 then
			self:Notify(T("menu.field_incorrectly_filled", "%menu.joinkick_reason%"), 2)
			return
		end

		if not data.kick_reason or #data.kick_reason < 1 then
			self:Notify(T("menu.field_incorrectly_filled", "%menu.kick_reason%"), 2)
			return
		end

		if not data.date_format or #data.date_format < 1 then
			self:Notify(T("menu.field_incorrectly_filled", "%menu.date_format%"), 2)
			return
		end

		if not data.time_format or #data.time_format < 1 then
			self:Notify(T("menu.field_incorrectly_filled", "%menu.time_format%"), 2)
			return
		end

		net.Start("irn_whitelist.command")
		net.WriteString("save_settings")
		net.WriteCompressedTable(data)
		net.SendToServer()
		self:Notify(T("menu.settings_saved"), 2)
	end
end

function PANEL:PlayersBlock(update)
	if not IsValid(self.EnableCB) then
		return
	end

	if update then
		self.Players.Table:Clear()
		if #self.Data.Players < 1 then
			self.Players.Table:AddItem("", "", "")
			self.Players.Table:RemoveRow(1)
		else
			for _, v in ipairs(self.Data.Players) do
				self.Players.Table:AddItem(v.nickname or "-", v.sid, v.once and "Yes" or "No")
			end
		end

		return
	end

	self.Players = vgui.Create("MantlePanel", self)
	self.Players:SetPos(self.EnableCB:GetX() + self.EnableCB:GetWide() + self.dockCoef, self.EnableCB:GetY())
	self.Players:SetSize(
		self.panelW - self.Players:GetX() - self.dockCoef,
		self.panelH - self.Players:GetY() - self.dockCoef
	)
	self.Players:SetCustomColor(Mantle.color.focus_panel)

	self.Players.Title = vgui.Create("MantleText", self.Players)
	self.Players.Title:SetTall(30)
	self.Players.Title:Dock(TOP)
	self.Players.Title:DockMargin(0, 0, 0, 8)
	self.Players.Title:SetText(T("menu.table_title"))
	self.Players.Title:SetFont(self.CacheFont(22, true))
	self.Players.Title:SetAlign(TEXT_ALIGN_CENTER)
	self.Players.Title:SetVAlign(TEXT_ALIGN_CENTER)

	self.Players.BtnPanel = vgui.Create("Panel", self.Players)
	self.Players.BtnPanel.PerformLayout = function(s, w, h)
		s.AddBtn:SetWide(w / 2 - self.dockCoef / 2)
		s.AddOfflineBtn:SetWide(s.AddBtn:GetWide())
		s.AddOfflineBtn:SetX(s.AddBtn:GetWide() + self.dockCoef)
	end

	self.Players.BtnPanel.AddBtn = vgui.Create("MantleBtn", self.Players.BtnPanel)
	self.Players.BtnPanel.AddBtn:SetTxt(T("menu.add_player"))
	self.Players.BtnPanel.AddBtn:SetRipple(true)
	self.Players.BtnPanel.AddBtn.DoClick = function()
		Mantle.ui.player_selector(function(pl)
			net.Start("irn_whitelist.command")
			net.WriteString("add_player")
			net.WriteString(pl:SteamID64())
			net.WriteBool(false)
			net.SendToServer()
		end)
	end

	self.Players.BtnPanel.AddOfflineBtn = vgui.Create("MantleBtn", self.Players.BtnPanel)
	self.Players.BtnPanel.AddOfflineBtn:SetTxt(T("menu.add_offline_player"))
	self.Players.BtnPanel.AddOfflineBtn:SetRipple(true)
	self.Players.BtnPanel.AddOfflineBtn.DoClick = function()
		Mantle.ui.text_box(T("menu.aop_title"), T("menu.aop_desc"), function(sid64)
			net.Start("irn_whitelist.command")
			net.WriteString("add_player")
			net.WriteString(sid64:lower():Replace(",y", ""):Replace(", y", ""))
			net.WriteBool(sid64:EndsWith(",y") or sid64:EndsWith(", y"))
			net.SendToServer()
		end)
	end

	timer.Simple(0, function()
		self.Players.BtnPanel:SetTall(
			self.Players.BtnPanel.AddOfflineBtn:GetY() + self.Players.BtnPanel.AddOfflineBtn:GetTall()
		)
		self.Players.BtnPanel:Dock(BOTTOM)
		self.Players.BtnPanel:DockMargin(0, 8, 0, 0)
	end)

	self.Players.Table = vgui.Create("MantleTable", self.Players)
	self.Players.Table:Dock(FILL)
	self.Players.Table:AddColumn(T("menu.column_nickname"), 150)
	self.Players.Table:AddColumn(T("menu.column_sid64"), 150)
	self.Players.Table:AddColumn(T("menu.column_once"), nil, nil, true)
	self.Players.Table:AddItem("", "", "")
	self.Players.Table:RemoveRow(1)
	self.Players.Table:SetRightClickAction(function(row)
		timer.Simple(0, function()
			local dm = Mantle.ui.derma_menu()

			dm:AddOption(T("menu.del_player"), function()
				net.Start("irn_whitelist.command")
				net.WriteString("del_player")
				net.WriteString(row[2])
				net.SendToServer()
			end, "icon16/delete.png")

			dm:AddOption(T("menu.player_set_ipassword"), function()
				Mantle.ui.text_box(T("menu.sip_title"), T("menu.sip_desc"), function(password)
					net.Start("irn_whitelist.command")
					net.WriteString("set_ipassword")
					net.WriteString(row[2])
					net.WriteString(password)
					net.SendToServer()
				end)
			end, "icon16/server_key.png")
		end)
	end)
end

function PANEL:Setup(data)
	if not istable(data) or table.IsSequential(data) or table.IsEmpty(data) then
		return
	end

	self.Data = data
	self._Init = true

	self:EnableBlock(true)
	self:SettingsBlock(true)
	self:PlayersBlock(true)
end

function PANEL.CacheFont(sz, isBold)
	if not isnumber(sz) or sz < 1 then
		return "Fated.16"
	end
	isBold = tobool(isBold)

	if isfunction(Mantle.func.cache_font) then
		return Mantle.func.cache_font(sz, isBold)
	else
		local font = string.format("Fated.%i%s", sz, isBold and "b" or "")
		surface.SetFont(font)
		return font
	end
end

vgui.Register("IRNWhitelist_Menu", PANEL, "MantleFrame")
