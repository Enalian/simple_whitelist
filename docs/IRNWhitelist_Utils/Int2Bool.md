---
title: IRNWhitelist.Utils.Int2Bool
---

```lua
🟦 boolean IRNWhitelist.Utils.Int2Bool(number int, boolean? rev)
```

## Description
---

Translate number (integer) to bool value

## Arguments
---

`1` **`number`** **int**  
&emsp;The number to convert

`2` **`boolean?`** **rev** *(optional)*  
&emsp;Reverse output (1 = false, 0 = true)

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
local once = IRNWhitelist.Utils.Int2Bool(tonumber(args[2]) or 0)
```
