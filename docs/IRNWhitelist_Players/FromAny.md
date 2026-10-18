---
title: IRNWhitelist.Players:FromAny
---

```lua
🟦 string|nil, string|nil IRNWhitelist.Players:FromAny(Player or string or number input)
```

## Description
---

Get player from any input

## Arguments
---

`1` **`Player or string or number`** **input**  
&emsp;Any input (SteamID, SteamID64, Nickname, AccountID, UserID, EntIndex)

## Returns
---

`1` **`string|nil`**  
&emsp;Return value.

`2` **`string|nil`**  
&emsp;Return value.

## Example
---

```lua
local steamid, name = IRNWhitelist.Players:FromAny(args[1])
```
