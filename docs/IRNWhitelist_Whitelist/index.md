---
title: IRNWhitelist.Whitelist
---

List of all available functions and methods in the `IRNWhitelist.Whitelist` module.

## Classes and Structures
---

### `WhitelistedPlayer`

`1` **`boolean`** **once?** *(public)*  
&emsp;Is player added once

`2` **`boolean`** **state** *(public)*  
&emsp;Is player added to the whitelist

`3` **`string`** **steamid64** *(public)*  
&emsp;Player SteamID64

## Methods
---

`boolean IRNWhitelist.Whitelist:`[**`AddPlayer`**](AddPlayer.md)`(string steamid64, boolean? once)`  
&emsp;Add player to the whitelist

`WhitelistedPlayer IRNWhitelist.Whitelist:`[**`GetPlayer`**](GetPlayer.md)`(string steamid64)`  
&emsp;Get information about player from whitelist

`IRNWhitelist.Whitelist:`[**`Load`**](Load.md)`()`  
&emsp;Main module loader function

`number IRNWhitelist.Whitelist:`[**`PlayersCount`**](PlayersCount.md)`()`  
&emsp;Get count of whitelisted players

`boolean IRNWhitelist.Whitelist:`[**`RemovePlayer`**](RemovePlayer.md)`(string steamid64)`  
&emsp;Remove player from the whitelist

`boolean IRNWhitelist.Whitelist:`[**`RemovePlayerOnce`**](RemovePlayerOnce.md)`(string steamid64)`  
&emsp;Remove once player from the whitelist

`IRNWhitelist.Whitelist:`[**`SetPlayers`**](SetPlayers.md)`(table players)`  
&emsp;Replace all whitelisted players to provided players

## Functions
---

`game.`[**`IsPasswordProtected`**](IsPasswordProtected.md)`()`  
&emsp;No description provided.

`boolean IRNWhitelist.Whitelist.`[**`Clear`**](Clear.md)`()`  
&emsp;Clear whitelist (remove all players from the whitelist)

`boolean IRNWhitelist.Whitelist.`[**`ClearDuplicates`**](ClearDuplicates.md)`()`  
&emsp;Remove duplicated players from whitelist

`string IRNWhitelist.Whitelist.`[**`FormatReason`**](FormatReason.md)`(string steamid64, string ipAddress, string name)`  
&emsp;Reason formatter (helper function)

`table<string, IRNWhitelist.Whitelist.`[**`GetPlayers`**](GetPlayers.md)`()`  
&emsp;Get all whitelisted players (table: key = Player SteamID64, value = once?)

`boolean IRNWhitelist.Whitelist.`[**`IsOn`**](IsOn.md)`()`  
&emsp;Check is whitelist is enabled

`boolean IRNWhitelist.Whitelist.`[**`IsPlayerWhitelisted`**](IsPlayerWhitelisted.md)`(string steamid64)`  
&emsp;Check if player whitelisted or not

`boolean IRNWhitelist.Whitelist.`[**`NeedPassword`**](NeedPassword.md)`()`  
&emsp;Check if player need to provide password to join (on enabled whitelist)

`IRNWhitelist.Whitelist.`[**`SetNeedPassword`**](SetNeedPassword.md)`(boolean bool)`  
&emsp;Set password neeed white player joining (on enabled whitelist)

`IRNWhitelist.Whitelist.`[**`SetOn`**](SetOn.md)`(boolean bool)`  
&emsp;Change whitelist state (enable or disable)
