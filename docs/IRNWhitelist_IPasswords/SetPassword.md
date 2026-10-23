---
title: IRNWhitelist.IPasswords:SetPassword
---

```lua
🟦 boolean, string? IRNWhitelist.IPasswords:SetPassword(string steamid64, string? password)
```

## Description
---

Set new player password.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string?`** **password** *(optional)*  
&emsp;New password.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

`2` **`string?`**  
&emsp;Return value.

## Example
---

```lua
local _, passwd = IRNWhitelist.IPasswords:SetPassword(steamid, args[2])
```
