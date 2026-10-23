---
title: IRNWhitelistKickReasonChanged
---

```lua
🟦 hook.Add("IRNWhitelistKickReasonChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_kick_reason' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistKickReasonChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
