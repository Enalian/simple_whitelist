---
title: IRNWhitelist.Whitelist.GetPlayers
---

```lua
🟦 table<string, boolean> IRNWhitelist.Whitelist.GetPlayers()
```

## Description
---

Get all whitelisted players (table: key = Player SteamID64, value = once?).

## Arguments
---

*This function does not take any arguments.*

## Returns
---

`1` **`table<string, boolean>`**  
&emsp;Return value.

## Example
---

```lua
for k, v in pairs(IRNWhitelist.Whitelist.GetPlayers()) do
```
