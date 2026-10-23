---
title: IRNWhitelistEnabled
---

```lua
🟦 hook.Add("IRNWhitelistEnabled", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_enable' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistEnabled", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
