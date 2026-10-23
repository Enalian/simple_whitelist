---
title: IRNWhitelistIPasswordSet
---

```lua
🟦 hook.Add("IRNWhitelistIPasswordSet", "identifier", function(string steamid64, string password))
```

## Description
---

Calls when player individual password has been set.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string`** **password**  
&emsp;New password.

## Example
---

```lua
hook.Add("IRNWhitelistIPasswordSet", "UniqueIdentifier", function(steamid64, password)
    -- Your code here
end)
```
