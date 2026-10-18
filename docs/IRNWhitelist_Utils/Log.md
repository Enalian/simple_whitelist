---
title: IRNWhitelist.Utils.Log
---

```lua
🟦 boolean IRNWhitelist.Utils.Log(string str)
```

## Description
---

Write string into a log file

## Arguments
---

`1` **`string`** **str**  
&emsp;The string to log

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Utils.Log(IRNWhitelist.Lang:FormatString(string.format("%%log.%s%% %s", log_type, str)))
```
