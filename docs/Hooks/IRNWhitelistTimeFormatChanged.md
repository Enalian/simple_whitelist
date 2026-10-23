---
title: IRNWhitelistTimeFormatChanged
---

```lua
🟦 hook.Add("IRNWhitelistTimeFormatChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_time_format' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistTimeFormatChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
