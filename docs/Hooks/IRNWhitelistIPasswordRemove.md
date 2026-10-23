---
title: IRNWhitelistIPasswordRemove
---

```lua
🟦 hook.Add("IRNWhitelistIPasswordRemove", "identifier", function(string steamid64))
```

## Description
---

Calls when player individual password has been removed.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

## Example
---

```lua
hook.Add("IRNWhitelistIPasswordRemove", "UniqueIdentifier", function(steamid64)
    -- Your code here
end)
```
