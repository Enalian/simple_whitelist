---
title: IRNWhitelist.Whitelist.IsOn
---

```lua
🟦 boolean IRNWhitelist.Whitelist.IsOn()
```

## Description
---

Check is whitelist is enabled.

## Arguments
---

*This function does not take any arguments.*

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
if IRNWhitelist.Whitelist.IsOn() and not IRNWhitelist.Whitelist.IsPlayerWhitelisted(steamid) then
```
