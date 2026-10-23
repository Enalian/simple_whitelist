---
title: IRNWhitelistKickPlayersAndBotsEnabled
---

```lua
🟦 hook.Add("IRNWhitelistKickPlayersAndBotsEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_kick' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistKickPlayersAndBotsEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
