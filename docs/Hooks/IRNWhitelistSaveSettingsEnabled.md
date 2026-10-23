---
title: IRNWhitelistSaveSettingsEnabled
---

```lua
🟦 hook.Add("IRNWhitelistSaveSettingsEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_save_settings' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistSaveSettingsEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
