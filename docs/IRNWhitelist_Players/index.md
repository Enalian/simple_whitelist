---
title: IRNWhitelist.Players
---

List of all available functions and methods in the `IRNWhitelist.Players` module.

## Methods
---

`string or nil, string or nil IRNWhitelist.Players:`[**`FromAny`**](FromAny.md)`(Player or string or number input)`  
&emsp;Get player from any input.

`string or nil IRNWhitelist.Players:`[**`GetNickname`**](GetNickname.md)`(string steamid64)`  
&emsp;Get player nickname from database.

`IRNWhitelist.Players:`[**`Load`**](Load.md)`()`  
&emsp;Main module load function.

`boolean IRNWhitelist.Players:`[**`SetNickname`**](SetNickname.md)`(string steamid64, string name)`  
&emsp;Set player nickname (for database).

## Functions
---

`Player or nil IRNWhitelist.Players.`[**`GetByNickname`**](GetByNickname.md)`(string name)`  
&emsp;Get player by nickname.

`boolean IRNWhitelist.Players.`[**`IsValidSteamID`**](IsValidSteamID.md)`(string steamid)`  
&emsp;Check if SteamID valid.

`boolean IRNWhitelist.Players.`[**`IsValidSteamID64`**](IsValidSteamID64.md)`(string steamid64)`  
&emsp;Check if SteamID64 valid.
