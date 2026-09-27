return {
	language_name = "English",
	language_name_en = "English",

	commands = {
		enable = "Whitelist enabled.",
		disable = "Whitelist disabled.",
		add_player_to_whitelist = "Player {{1}} was added to the whitelist{{2}}.", -- PLayer nickname, was added on a one-time basis
		remove_player_from_whitelist = "Player {{1}} was removed from the whitelist.", -- Player nickname
		whitelist_setted = "Whitelist has been cleared and player {{1}} was added to it{{2}}.", -- Ник игрока, Единоразово ли был добавлен
		whitelist_cleared = "Whitelist has been cleared.",
		whitelist_duplicates_cleared = "Duplicated players has been cleared.",
		whitelist_players_title = "Players ({{1}}) in the whitelist:", -- Players count
		whitelist_players_empty = "There are no players in the whitelist.",
		whitelist_settings_saved = "Whitelist settings was saved into 'data/simple_whitelist/settings.json' file.",
		whitelist_settiings_loaded = "Whitelist settings were loaded from the file.",
		whitelist_status = "Whitelist is now {{1}}.",

		help_add = "Usage: whitelist_add <SteamID(64)/Name> [once (1/0)]",
		help_remove = "Usage: whitelist_remove <SteamID(64)/Name>",
		help_set = "Usage: whitelist_set <SteamID(64)/Name> [once (1/0)]",

		invalid_player = "No players found matching the specified criteria ({{1}}).", -- criteria

		already_in_whitelist = "This player ({{1}}) is already whitelisted.", -- Player nickname
		not_in_whitelist = "This player ({{1}}) is not whitelisted.", -- Player nickname

		whitelist_empty = "Whitelist is empty.",
		whitelist_not_empty = "Whitelist is not empty.",

		whitelist_statuses = {
			on = "enabled",
			off = "disabled",
		},

		flags = {
			once = " once",
			once_players = " (once)",
		},
	},

	log = {
		success = "[SUCCESS]",
		warn = "[WARN]",
		error = "[ERROR]",
		critical = "[CRITICAL]",

		enable = {
			on = "Whitelist enabled by {{1}}",
			off = "Whitelist disabled by {{1}}",
		},

		save_settings = "Settings has been changed by {{1}}",
		add_player_to_whitelist = "Player {{2}} has been whitelisted by {{1}}",
		remove_player_from_whitelist = "Player {{2}} has been removed from the whitelist by {{1}}",
	},

	messages = {
		loaded = "[SimpleWhitelist] by Enalian v{{1}} loaded! (support: https://discord.gg/gRc4UcXwTY)",
	},

	menu = {
		title = "Whitelist menu",
		enable_cb = "Enable whitelist",
		settings_title = "Settings",
		server_language = "Server language",
		server_language_ph = "Choose server language...",
		joinkick_reason = "Join kick reason",
		joinkick_reason_ph = "Enter text...",
		kick_reason = "Kick reason",
		kick_reason_ph = "Enter text...",
		date_format = "Date format",
		date_format_ph = "Enter text...",
		time_format = "Time format",
		time_format_ph = "Enter text...",
		password_check = "Check password on server join?",
		kick_players = "Kick players? (on whitelist enabling)",
		kick_bots = "Kick bots? (on whitelist enabling)",
		enable_logs = "Enable logs?",
		save_names = "Save players names?",
		save_names_tooltip = "Save player names to the SQL table upon exit.",
		save_settings = "Save settings?",
		save_settings_tooltip = "Saves this settings on 'simple_whitelist/settings.json'",
		save_settings_btn = "Save settings",
		field_incorrectly_selected = "Field '{{1}}' is incorrectly selected. (Cannot be empty)",
		field_incorrectly_filled = "Field '{{1}}' is incorrectly filled. (Cannot be empty)",
		settings_saved = "Settings successfully saved.",
		table_title = "Whitelisted players",
		add_player = "Add new player",
		add_offline_player = "Add new offline player",
		aop_title = "Add offline player",
		aop_desc = "Enter player SteamID64 (For once adding - ',y' on end)",
		del_player = "Remove player",
		column_nickname = "Nickname",
		column_sid64 = "SteamID64",
		column_once = "Once?",
		not_sid64 = "This is a not SteamID64.",
	},
}
