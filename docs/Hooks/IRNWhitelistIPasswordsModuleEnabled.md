---
title: IRNWhitelistIPasswordsModuleEnabled
---

```lua
🟦 hook.Add("IRNWhitelistIPasswordsModuleEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_ipasswords_enable' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistIPasswordsModuleEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
