---
title: IRNWhitelistKickBotsEnabled
---

```lua
🟦 hook.Add("IRNWhitelistKickBotsEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_kick_bots' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistKickBotsEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
