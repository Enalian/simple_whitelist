---
title: IRNWhitelist.IPasswords:GetPasswordHashSalt
---

```lua
🟦 string or nil, string or nil IRNWhitelist.IPasswords:GetPasswordHashSalt(string steamid64)
```

## Description
---

Get player password hash and salt.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

## Returns
---

`1` **`string or nil`**  
&emsp;Return value.

`2` **`string or nil`**  
&emsp;Return value.

## Example
---

```lua
local hash, salt = IRNWhitelist.IPasswords:GetPasswordHashSalt(steamid64)
```
