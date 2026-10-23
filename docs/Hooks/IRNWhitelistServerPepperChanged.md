---
title: IRNWhitelistServerPepperChanged
---

```lua
🟦 hook.Add("IRNWhitelistServerPepperChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_ipasswords_pepper' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistServerPepperChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
