---
title: IRNWhitelist.Utils.GeneratePIN
---

```lua
🟦 string IRNWhitelist.Utils.GeneratePIN(number? digits)
```

## Description
---

Generate server password pin-code.

## Arguments
---

`1` **`number?`** **digits** *(optional)*  
&emsp;Digits count.

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Utils.SetServerPassword(IRNWhitelist.Utils.GeneratePIN(5))
```
