---
title: IRNWhitelist.Utils.FormatString
---

```lua
🟦🟨 string IRNWhitelist.Utils.FormatString(string str, string? fmt, string[] tbl)
```

## Description
---

Format string with table (Relace all 'fmt' strings from key-values into 'tbl')

## Arguments
---

`1` **`string`** **str**  
&emsp;String to format

`2` **`string?`** **fmt** *(optional)*  
&emsp;Format string

`3` **`string[]`** **tbl**  
&emsp;String formats

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Utils.FormatString(parsed_phrase, nil, tbl)
```
