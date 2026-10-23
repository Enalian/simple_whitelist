---
title: IRNWhitelist.Whitelist.FormatReason
---

```lua
🟦 string IRNWhitelist.Whitelist.FormatReason(string steamid64, string ipAddress, string name)
```

## Description
---

Reason formatter (helper function).

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string`** **ipAddress**  
&emsp;Player IPAddress.

`3` **`string`** **name**  
&emsp;Player nickname.

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
return false, IRNWhitelist.Whitelist.FormatReason(steamid64, ipAddress, name)
```
