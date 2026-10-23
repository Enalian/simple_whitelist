---
title: IRNWhitelistPlayerRemoved
---

```lua
🟦 hook.Add("IRNWhitelistPlayerRemoved", "identifier", function(string steamid64))
```

## Description
---

Calls when player has been removed from the whitelist.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player's SteamID64.

## Example
---

```lua
hook.Add("IRNWhitelistPlayerRemoved", "UniqueIdentifier", function(steamid64)
    -- Your code here
end)
```
