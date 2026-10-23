---
title: IRNWhitelist.IPasswords:GetPasswordHash
---

```lua
🟦 string or nil IRNWhitelist.IPasswords:GetPasswordHash(string steamid64)
```

## Description
---

Get player password hash.

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
return IRNWhitelist.IPasswords:GetPasswordHash(steamid64), self:GetPasswordSalt(steamid64)
```
