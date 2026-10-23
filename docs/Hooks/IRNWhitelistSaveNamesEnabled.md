---
title: IRNWhitelistSaveNamesEnabled
---

```lua
🟦 hook.Add("IRNWhitelistSaveNamesEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_save_names' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistSaveNamesEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
