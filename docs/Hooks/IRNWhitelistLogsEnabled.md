---
title: IRNWhitelistLogsEnabled
---

```lua
🟦 hook.Add("IRNWhitelistLogsEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_logs' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistLogsEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
