---
title: IRNWhitelistPlayerAdded
---

```lua
🟦 hook.Add("IRNWhitelistPlayerAdded", "identifier", function(string steamid64, boolean once))
```

## Description
---

Calls when player has been added to the whitelist.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player's SteamID64.

`2` **`boolean`** **once**  
&emsp;Add player once?

## Example
---

```lua
hook.Add("IRNWhitelistPlayerAdded", "UniqueIdentifier", function(steamid64, once)
    -- Your code here
end)
```
