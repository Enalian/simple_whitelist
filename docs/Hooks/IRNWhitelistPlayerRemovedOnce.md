---
title: IRNWhitelistPlayerRemovedOnce
---

```lua
🟦 hook.Add("IRNWhitelistPlayerRemovedOnce", "identifier", function(string steamid64))
```

## Description
---

Calls when once player has been removed from the whitelist.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player's SteamID64.

## Example
---

```lua
hook.Add("IRNWhitelistPlayerRemovedOnce", "UniqueIdentifier", function(steamid64)
    -- Your code here
end)
```
