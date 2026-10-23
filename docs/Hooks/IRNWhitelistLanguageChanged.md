---
title: IRNWhitelistLanguageChanged
---

```lua
🟦 hook.Add("IRNWhitelistLanguageChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_language' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistLanguageChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
