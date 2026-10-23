---
title: IRNWhitelistDateFormatChanged
---

```lua
🟦 hook.Add("IRNWhitelistDateFormatChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_date_format' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistDateFormatChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
