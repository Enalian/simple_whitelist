---
title: IRNWhitelist.Whitelist.NeedPassword
---

```lua
🟦 boolean IRNWhitelist.Whitelist.NeedPassword()
```

## Description
---

Check if player need to provide password to join (on enabled whitelist)

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
if IRNWhitelist.Whitelist.NeedPassword() and svPassword ~= clPassword then
```
