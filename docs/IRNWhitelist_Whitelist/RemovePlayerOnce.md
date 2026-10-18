---
title: IRNWhitelist.Whitelist:RemovePlayerOnce
---

```lua
🟦 boolean IRNWhitelist.Whitelist:RemovePlayerOnce(string steamid64)
```

## Description
---

Remove once player from the whitelist

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player's SteamID64

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
local ok = IRNWhitelist.Whitelist:RemovePlayerOnce("steamid64")
print(ok)
```
