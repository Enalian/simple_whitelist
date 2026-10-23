---
title: IRNWhitelist.Lang:FormatString
---

```lua
🟦🟨 string IRNWhitelist.Lang:FormatString(string str, any ...)
```

## Description
---

Format string with vararg inputs.

## Arguments
---

`1` **`string`** **str**  
&emsp;Input string.

`2` **`any`** **...**  
&emsp;Format strings.

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Utils.Log(IRNWhitelist.Lang:FormatString(string.format("%%log.%s%% %s", log_type, str)))
```
