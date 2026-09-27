return {
	language_name = "Русский",
	language_name_en = "Russian",

	commands = {
		enable = "Белый список включен.",
		disable = "Белый список выключен.",
		add_player_to_whitelist = "Игрок {{1}} был{{2}} добавлен в белый список.", -- Ник игрока, Единоразово ли был добавлен
		remove_player_from_whitelist = "Игрок {{1}} был удален из белого списка.", -- Ник игрока
		whitelist_setted = "Белый список был очищен и игрок {{1}}{{2}} был добавлен в него.", -- Ник игрока, Единоразово ли был добавлен
		whitelist_cleared = "Белый список был очищен.",
		whitelist_duplicates_cleared = "Дублирующися игроки были удалены.",
		whitelist_players_title = "Список игроков ({{1}}) в белом списке:", -- Кол-во игроков
		whitelist_players_empty = "Белый список сейчас пуст.",
		whitelist_settings_saved = "Настройки белого списка сохранены в 'data/simple_whitelist/settings.json'.",
		whitelist_settiings_loaded = "Настройки белого списка применены из файла.",
		whitelist_status = "Белый список сейчас {{1}}.",

		help_add = "Использование: whitelist_add <SteamID(64)/Ник> [единоразово (1/0)]",
		help_remove = "Использование: whitelist_remove <SteamID(64)/Ник>",
		help_set = "Использование: whitelist_set <SteamID(64)/Ник> [единоразово (1/0)]",

		invalid_player = "По заданным критериям ({{1}}) игрок не найден.", -- Критерий поиска (то, что ввел игрок)

		already_in_whitelist = "Данный игрок ({{1}}) уже находится в белом списке.", -- Ник игрока
		not_in_whitelist = "Данный игрок ({{1}}) не находится в белом списке.", -- Ник игрока

		whitelist_empty = "Белый список пуст.",
		whitelist_not_empty = "Белый список не пуст.",

		whitelist_statuses = {
			on = "включен",
			off = "выключен",
		},

		flags = {
			once = " единоразово",
			once_players = " (единоразово)",
		},
	},

	log = {
		success = "[УСПЕХ]",
		warn = "[ПРЕДУПРЕЖЕНИЕ]",
		error = "[ОШИБКА]",
		critical = "[КРИТИЧЕСКАЯ]",

		enable = {
			on = "{{1}} включил белый список.",
			off = "{{1}} выключил белый список.",
		},

		save_settings = "{{1}} сохранил настройки.",
		add_player_to_whitelist = "{{1}} добавил игрока {{2}} в белый список.",
		remove_player_from_whitelist = "{{1}} убрал игрока {{2}} из белого списка.",
	},

	messages = {
		loaded = "[SimpleWhitelist] от Enalian v{{1}} успешно загружен! (поддержка: https://discord.gg/gRc4UcXwTY)",
	},

	menu = {
		title = "Управление белым списком",
		enable_cb = "Включить белый список",
		settings_title = "Настройки",
		server_language = "Язык сервера",
		server_language_ph = "Выберите язык...",
		joinkick_reason = "Причина кика при входе на сервер",
		joinkick_reason_ph = "Введите причину...",
		kick_reason = "Причина кика при выходе (кике) с сервера",
		kick_reason_ph = "Введите причину...",
		date_format = "Формат даты",
		date_format_ph = "Введите формат...",
		time_format = "Формат времени",
		time_format_ph = "Введите формат...",
		password_check = "Проверять пароль при входе?",
		kick_players = "Кикать игроков при включении БС?",
		kick_bots = "Кикать ботов при включении БС?",
		enable_logs = "Включить логирование действий?",
		save_names = "Сохранять ли имена игроков?",
		save_names_tooltip = "Имена сохраняются в БД сервера при выходе игрока.",
		save_settings = "Сохранять текущие настройки в файл?",
		save_settings_tooltip = "Настройки сохраняются в файл 'settings.json' в папке аддона (simple_whitelist).",
		save_settings_btn = "Сохранить настройки",
		field_incorrectly_selected = "Поле '{{1}}' выбрано неверно (либо не выбрано вообще).",
		field_incorrectly_filled = "Поле '{{1}}' заполнено неверно (или не заполнено вообще).",
		settings_saved = "Настройки успешно сохранены.",
		table_title = "Игроки в белом списке",
		add_player = "Добавить нового игрока",
		add_offline_player = "Доб. нового игрока (в оффлайне)",
		aop_title = "Добавление нового игрока",
		aop_desc = "Введите SteamID64 игрока (Для единоразово добавления - ',y' в конце)",
		del_player = "Удалить игрока из БС",
		column_nickname = "Иия игрока",
		column_sid64 = "SteamID64",
		column_once = "Единор.?",
		not_sid64 = "Это не SteamID64.",
	},
}
