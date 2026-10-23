---
title: Hooks
---

List of all available custom hooks and events.

## Events & Hooks
---

[**`IRNWhitelistCleared`**](IRNWhitelistCleared.md)`()`  
&emsp;Calls when whitelist has been cleared.

[**`IRNWhitelistDateFormatChanged`**](IRNWhitelistDateFormatChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_date_format' has been changed.

[**`IRNWhitelistDuplicatesCleared`**](IRNWhitelistDuplicatesCleared.md)`()`  
&emsp;Calls when whitelist has been cleared from duplicated players.

[**`IRNWhitelistEnabled`**](IRNWhitelistEnabled.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_enable' has been changed.

[**`IRNWhitelistIPasswordRemove`**](IRNWhitelistIPasswordRemove.md)`(string steamid64)`  
&emsp;Calls when player individual password has been removed.

[**`IRNWhitelistIPasswordSet`**](IRNWhitelistIPasswordSet.md)`(string steamid64, string password)`  
&emsp;Calls when player individual password has been set.

[**`IRNWhitelistIPasswordsModuleEnabled`**](IRNWhitelistIPasswordsModuleEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_ipasswords_enable' has been changed.

[**`IRNWhitelistIPasswordsRemovedAll`**](IRNWhitelistIPasswordsRemovedAll.md)`()`  
&emsp;Calls when all player individual passwords has been removed.

[**`IRNWhitelistJoinKickReasonChanged`**](IRNWhitelistJoinKickReasonChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_joinkick_reason' has been changed.

[**`IRNWhitelistKickBotsEnabled`**](IRNWhitelistKickBotsEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_kick_bots' has been changed.

[**`IRNWhitelistKickPlayersAndBotsEnabled`**](IRNWhitelistKickPlayersAndBotsEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_kick' has been changed.

[**`IRNWhitelistKickReasonChanged`**](IRNWhitelistKickReasonChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_kick_reason' has been changed.

[**`IRNWhitelistLanguageChanged`**](IRNWhitelistLanguageChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_language' has been changed.

[**`IRNWhitelistLogsEnabled`**](IRNWhitelistLogsEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_logs' has been changed.

[**`IRNWhitelistPasswordCheckEnabled`**](IRNWhitelistPasswordCheckEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_password_check' has been changed.

[**`IRNWhitelistPlayerAdded`**](IRNWhitelistPlayerAdded.md)`(string steamid64, boolean once)`  
&emsp;Calls when player has been added to the whitelist.

[**`IRNWhitelistPlayerNicknameSet`**](IRNWhitelistPlayerNicknameSet.md)`(string steamid64, string name)`  
&emsp;Calls when player nickname has been set.

[**`IRNWhitelistPlayerRemoved`**](IRNWhitelistPlayerRemoved.md)`(string steamid64)`  
&emsp;Calls when player has been removed from the whitelist.

[**`IRNWhitelistPlayerRemovedOnce`**](IRNWhitelistPlayerRemovedOnce.md)`(string steamid64)`  
&emsp;Calls when once player has been removed from the whitelist.

[**`IRNWhitelistPlayersSetted`**](IRNWhitelistPlayersSetted.md)`(table players)`  
&emsp;Calls when list of whitelisted players has been set.

[**`IRNWhitelistSaveNamesEnabled`**](IRNWhitelistSaveNamesEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_save_names' has been changed.

[**`IRNWhitelistSaveSettingsEnabled`**](IRNWhitelistSaveSettingsEnabled.md)`(boolean nv)`  
&emsp;Calls when ConVar 'whitelist_save_settings' has been changed.

[**`IRNWhitelistServerPepperChanged`**](IRNWhitelistServerPepperChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_ipasswords_pepper' has been changed.

[**`IRNWhitelistSettingsApplied`**](IRNWhitelistSettingsApplied.md)`(table data1)`  
&emsp;Calls when settings has been applied.

[**`IRNWhitelistSettingsParamSet`**](IRNWhitelistSettingsParamSet.md)`(string param, string or number or boolean value)`  
&emsp;Calls when settings parameter has been set.

[**`IRNWhitelistSettingsSaved`**](IRNWhitelistSettingsSaved.md)`(table settings)`  
&emsp;Calls when settings has been saved.

[**`IRNWhitelistSettingsWrited`**](IRNWhitelistSettingsWrited.md)`(table settings)`  
&emsp;Calls when settings has been writed to file.

[**`IRNWhitelistTimeFormatChanged`**](IRNWhitelistTimeFormatChanged.md)`(string newValue)`  
&emsp;Calls when ConVar 'whitelist_time_format' has been changed.
