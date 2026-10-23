# Simple Whitelist

Whitelist with extended functions and with menu written at [Mantle](https://github.com/Enalian/mantle).

All developer documentation is [here](https://enalian.github.io/simple_whitelist).

Installing **Mantle** is not mandatory; without it, the menu will not work, but all other functionality will remain operational.

## 🇷🇺 Русская версия

Русскую версию этого файла вы можете прочитать [здесь](https://github.com/Enalian/simple_whitelist/blob/master/README.ru.md).

## 🍂 Console commands (server only)

| Command | Arguments | Description |
|:---:|:---|:---|
| `whitelist_on` | *No arguments* | Enable whitelist. |
| `whitelist_off` | *No arguments* | Disable whitelist. |
| `whitelist_toggle` | *No arguments* | Toggle (disable or enable) whitelist. |
| `whitelist_status` | *No arguments* | Check whitelist state and settings. |
| `whitelist_add` | `<SteamID(64)/AccountID/Nickname> [Once? (1/0)]` | Add player to the whitelist. |
| `whitelist_remove` | `<SteamID(64)/AccountID/Nickname>` | Remove player from the whitelist. |
| `whitelist_set` | `<SteamID(64)/AccountID/Nickname> [Once? (1/0)]` | Clear whitelist and add player to it. |
| `whitelist_clear` | *No arguments* | Clear whitelist. |
| `whitelist_clear_duplicates` | *No arguments* | Remove duplicated players from the whitelist. |
| `whitelist_players` | *No arguments* | Посмотреть список игроков в белом списке. |
| `whitelist_settings_save` | *No arguments* | Save settings to the file. |
| `whitelist_settings_load` | *No arguments* | Load settings from the file. |
| `whitelist_joinkick_reason` | `<Reason>` | Reason for being kicked while the whitelist is enabled. |
| `whitelist_kick_reason` | `<Reason>` | Reason for being kicked when the whitelist is enabled. |
| `whitelist_kick` | `<1/0>` | Kick players and bots when the whitelist is enabled? (1 = Yes, 0 = No)  |
| `whitelist_kick_bots` | `<1/0>` | Kick bots when the whitelist is enabled? (1 = Yes, 0 = No) |
| `whitelist_password_check` | `<1/0>` | Require a password when logging into the server (while whitelists are in effect)? (1 = Yes, 0 = No) |
| `whitelist_date_format` | `<Format>` | Date format (for reasons). |
| `whitelist_time_format` | `<Format>` | Time format (for reasons). |
| `whitelist_save_names` | `<1/0>` | Save player names into server DB? (1 = Yes, 0 = No) |
| `whitelist_save_settings` | `<1/0>` | Save all settings into file? (1 = Yes, 0 = No) |
| `whitelist_logs` | `<1/0>` | Enable all messages and actions log? (1 = Yes, 0 = No) |
| `whitelist_language` | `<Language>` | Set server language. |
| `whitelist_ipasswords_enable` | `<1/0>` | Enable individual passwords module. |
| `whitelist_ipasswords_pepper` | `<Pepper>` | Set new pepper for individual passwords. |
| `whitelist_ipassword_set` | `<SteamID(64)/AccountID/Nickname> <Password>` | Set player individual password to join the server. |
| `whitelist_ipassword_remove` | `<SteamID(64)/AccountID/Nickname>` | Remove player individual password. |

## ⚪ Fillers for reason

| Filler | Description | Example |
|:---:|:---|:---|
| `{{player}}` | Player nickname | `Enalian` |
| `{{player.steamid}}` | Player [SteamID](https://wiki.facepunch.com/gmod/Player:SteamID) | `STEAM_0:0:0` |
| `{{player.steamid64}}` | Player [SteamID64](https://wiki.facepunch.com/gmod/Player:SteamID64) | `76561197960265728` |
| `{{player.accountid}}` | Player [AccountID](https://wiki.facepunch.com/gmod/Player:AccountID) | `123456789` |
| `{{player.ip}}` | Player IP-Address | `127.0.0.1` |
| `{{n}}` | New line | `\n` |
| `{{t}}` | Tab | `\t` |
| `{{date}}` | Date | `09/16/98` |
| `{{time}}` | Time | `23:48:10` |
| `{{datetime}}` | Date + time | `09/16/98 23:48:10` |

## 🕛 Time formats

Time formats for `whitelist_date_format` and `whitelist_time_format` can be found [here](https://wiki.facepunch.com/gmod/os.date#arguments).

## 📩 Installation

### Steam Workshop

It is recommended to subscribe on the [Workshop]() and add the addon to your server collection. This will allow the addon to update automatically without manual downloading.

### Manual Download

Grab the [latest release](https://github.com/Enalian/simple_whitelist/releases/latest/download/simple_whitelist.zip) from the [Releases](https://github.com/Enalian/simple_whitelist/releases) page and extract it into your `garrysmod/addons/` folder.

## 📝 License

This project is under the MIT terms - see the [LICENSE](https://github.com/Enalian/simple_whitelist/blob/master/LICENSE) file for details.

Copyright **(C)** 2026 Enalian.
