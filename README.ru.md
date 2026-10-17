# Simple Whitelist

Белый список с расширенным функционалом и меню на [Mantle](https://github.com/Enalian/mantle).

Вся документация для разработчиков доступна [здесь](https://enalian.github.io/simple_whitelist).

Установка **Mantle** не является обязательной, без него просто не будет доступно меню.

Чистая версия без меню находится в ветке [`core`](https://github.com/Enalian/simple_whitelist/blob/core).

## 🇬🇧 English version

English version of this file you can read [here](https://github.com/Enalian/simple_whitelist/blob/master/README.md).

## 🍂 Консольные команды

| Команда | Описание |
|---|---|
| `whitelist_on` | Включить белый список. |
| `whitelist_off` | Выключить белый список. |
| `whitelist_toggle` | Переключить (включить или выключить) белый список. |
| `whitelist_status` | Посмотреть состояние (настройки) белого списка. |
| `whitelist_add <SteamID(64)/AccountID/Никнейм> [Единоразово?]` | Добавить игрока в белый список. |
| `whitelist_remove <SteamID(64)/AccountID/Никнейм>` | Удалить игрока из белого списка. |
| `whitelist_set <SteamID(64)/AccountID/Никнейм> [Единоразово?]` | Очистить белый список и добавить в него игрока. |
| `whitelist_clear` | Очистить белый список. |
| `whitelist_clear_duplicates` | Очистить белый список от дублирующийся игроков. |
| `whitelist_players` | Посмотреть список игроков в белом списке. |
| `whitelist_save_settings` | Сохранить текущие настройки в файл. |
| `whitelist_load_settings` | Загрузить настройки из файла. |

## ⚪ Заполнители для причин

| Заполнитель | Описание | Пример |
|:---:|:---|:---|
| `{{player}}` | Никнейм игрока | `Enalian` |
| `{{player.steamid}}` | [SteamID](https://wiki.facepunch.com/gmod/Player:SteamID) игрока | `STEAM_0:0:0` |
| `{{player.steamid64}}` | [SteamID64](https://wiki.facepunch.com/gmod/Player:SteamID64) игрока | `76561197960265728` |
| `{{player.accountid}}` | [AccountID](https://wiki.facepunch.com/gmod/Player:AccountID) игрока | `123456789` |
| `{{player.ip}}` | IP-Адрес игрока | `127.0.0.1` |
| `{{n}}` | Новая строка | `\n` |
| `{{t}}` | Символ табуляции | `\t` |
| `{{date}}` | Дата | `09/16/98` |
| `{{time}}` | Время | `23:48:10` |
| `{{datetime}}` | Дата + время | `09/16/98 23:48:10` |

## 🕛 Форматы времени для whitelist_date_format и whitelist_time_format

| Формат | Описание | Пример |
|:---:|:---|:---|
| `%a` | Аббривеатурное имя дня недели | `Wed` |
| `%A` | Полное имя дня недели | `Wednesday` |
| `%b` | Аббривеатурное имя месяца | `Sep` |
| `%B` | Полное имя месяца | `September` |
| `%d` | День месяца [01-31] | `16` |
| `%H` | Час в 24-часовом формате [00-23] | `23` |
| `%I` | Час в 12-часовом формате [01-12] | `11` |
| `%j` | День года [001-365] | `259` |
| `%m` | Месяц [01-12] | `09` |
| `%M` | Минута [00-59] | `48` |
| `%p` | Либо `am`, либо `pm` | `pm` |
| `%S` | Секунда [00-60] | `10` |
| `%w` | День недели [0-6 = Воскресенье-Суббота] | `3` |
| `%W` | Неделя в году [00-53] | `37` |
| `%x` | Дата (Тоже, что и `%m/%d/%y`) | `09/16/98` |
| `%X` | Время (Тоже, что и `%H:%M:%S`) | `23:48:10` |
| `%y` | Год (две цифры) [00-99] | `98` |
| `%Y` | Полный год | `1998` |
| `%z` | Часовой пояс | `-0300` |
| `%%` | Знак процента | `%` |

## 📩 Установка

### Steam Workshop

Рекомендуется подписаться на [аддон в Workshop]() и добавить аддон в коллекцию сервера. Это позволит аддону обновляться самостоятельно без его ручной переустановки.

### Самостоятельная загрузка

Скачайте [последний релиз](https://github.com/Enalian/simple_whitelist/releases/latest/download/simple_whitelist.zip) со страницы [Releases](https://github.com/Enalian/simple_whitelist/releases) и распакуйте его в папку `garrysmod/addons`. 

## 📝 Лицензия

Распространяется под лицензией [MIT](https://github.com/Enalian/simple_whitelist/blob/master/LICENSE). Вы можете свободно изменять и использовать код в своих проектах.

Copyright **(C)** 2026 Enalian.
