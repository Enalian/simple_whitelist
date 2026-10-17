# Simple Whitelist

Whitelist with extended functions and with menu written at [Mantle](https://github.com/Enalian/mantle).

All developer documentation is [here](https://enalian.github.io/simple_whitelist).

Installing **Mantle** is not mandatory; without it, the menu will not work, but all other functionality will remain operational.

Clear version without menu at [`core`](https://github.com/Enalian/simple_whitelist/blob/core) branch.

## 🇷🇺 Русская версия

Русскую версию этого файла вы можете прочитать [здесь](https://github.com/Enalian/simple_whitelist/blob/master/README.ru.md).

## 🍂 Console commands

| Command | Description |
|---|---|
| `whitelist_on` | Enable whitelist. |
| `whitelist_off` | Disable whitelist. |
| `whitelist_toggle` | Toggle (on or off) whitelist. |
| `whitelist_status` | Check whitelist settings and state. |
| `whitelist_add <SteamID(64)/AccountID/Nickname> [Once?]` | Add player to the whitelist. |
| `whitelist_remove <SteamID(64)/AccountID/Nickname>` | Remove player from the whitelist. |
| `whitelist_set <SteamID(64)/AccountID/Nickname> [Once?]` | Clear the whitelist then add the player to it. |
| `whitelist_clear` | Clear the whitelist. |
| `whitelist_clear_duplicates` | Remove duplicate players from the whitelist. |
| `whitelist_players` | List of all whitelisted players. |
| `whitelist_save_settings` | Save settings to the file. |
| `whitelist_load_settings` | Load settings from file. |

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
