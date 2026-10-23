---
title: IRNWhitelist.IPasswords:HasPassword
---

```lua
🟦 boolean IRNWhitelist.IPasswords:HasPassword(string steamid64)
```

## Description
---

Check if player has individual password.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
if not IRNWhitelist.IPasswords:HasPassword(steamid64) then
```
