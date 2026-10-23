---
title: IRNWhitelistJoinKickReasonChanged
---

```lua
🟦 hook.Add("IRNWhitelistJoinKickReasonChanged", "identifier", function(string newValue))
```

## Description
---

Calls when ConVar 'whitelist_joinkick_reason' has been changed.

## Arguments
---

`1` **`string`** **newValue**  
&emsp;No description provided for this argument.

## Example
---

```lua
hook.Add("IRNWhitelistJoinKickReasonChanged", "UniqueIdentifier", function(newValue)
    -- Your code here
end)
```
