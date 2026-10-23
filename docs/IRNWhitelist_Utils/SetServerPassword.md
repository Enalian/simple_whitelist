---
title: IRNWhitelist.Utils.SetServerPassword
---

```lua
🟦 IRNWhitelist.Utils.SetServerPassword(string? password)
```

## Description
---

Set or reset server password (for reset - 'password' = nil or 'password' = "").

## Arguments
---

`1` **`string?`** **password** *(optional)*  
&emsp;The new server password.

## Example
---

```lua
IRNWhitelist.Utils.SetServerPassword(IRNWhitelist.Utils.GeneratePIN(5))
```
