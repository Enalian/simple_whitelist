---
title: IRNWhitelist.IPasswords:Check
---

```lua
🟦 boolean IRNWhitelist.IPasswords:Check(string steamid64, string password)
```

## Description
---

Check function for whitelist hook.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string`** **password**  
&emsp;Player input password.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
if not IRNWhitelist.IPasswords:Check(steamid64, clPassword) then
```
