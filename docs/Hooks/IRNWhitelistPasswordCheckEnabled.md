---
title: IRNWhitelistPasswordCheckEnabled
---

```lua
🟦 hook.Add("IRNWhitelistPasswordCheckEnabled", "identifier", function(boolean nv))
```

## Description
---

Calls when ConVar 'whitelist_password_check' has been changed.

## Arguments
---

`1` **`boolean`** **nv**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistPasswordCheckEnabled", "UniqueIdentifier", function(nv)
    -- Your code here
end)
```
