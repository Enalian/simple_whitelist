---
title: IRNWhitelistSettingsWrited
---

```lua
🟦 hook.Add("IRNWhitelistSettingsWrited", "identifier", function(table settings))
```

## Description
---

Calls when settings has been writed to file.

## Arguments
---

`1` **`table`** **settings**  
&emsp;New settings.

## Example
---

```lua
hook.Add("IRNWhitelistSettingsWrited", "UniqueIdentifier", function(settings)
    -- Your code here
end)
```
