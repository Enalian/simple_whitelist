---
title: IRNWhitelist.Whitelist:GetPlayer
---

```lua
🟦 WhitelistedPlayer IRNWhitelist.Whitelist:GetPlayer(string steamid64)
```

## Description
---

Get information about player from whitelist.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

## Returns
---

`1` **`WhitelistedPlayer`**  
&emsp;Return value.

## Example
---

```lua
local wl_state = IRNWhitelist.Whitelist:GetPlayer(ply:SteamID64())
```
