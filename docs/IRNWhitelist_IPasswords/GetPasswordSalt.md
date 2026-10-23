---
title: IRNWhitelist.IPasswords:GetPasswordSalt
---

```lua
🟦 string or nil IRNWhitelist.IPasswords:GetPasswordSalt(string steamid64)
```

## Description
---

Get player password salt.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

## Returns
---

`1` **`string or nil`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.IPasswords:GetPasswordSalt(steamid64) ~= nil
```
