---
title: IRNWhitelist.IPasswords.GetPepper
---

```lua
🟦 string IRNWhitelist.IPasswords.GetPepper()
```

## Description
---

Get password pepper.

## Arguments
---

*This function does not take any arguments.*

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Utils.GenPasswordHash(password, salt, IRNWhitelist.IPasswords.GetPepper())
```
