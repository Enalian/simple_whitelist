---
title: IRNWhitelistSettingsSaved
---

```lua
🟦 hook.Add("IRNWhitelistSettingsSaved", "identifier", function(table settings))
```

## Description
---

Calls when settings has been saved.

## Arguments
---

`1` **`table`** **settings**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistSettingsSaved", "UniqueIdentifier", function(settings)
    -- Your code here
end)
```
