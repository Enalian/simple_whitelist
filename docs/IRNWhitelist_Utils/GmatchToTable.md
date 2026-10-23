---
title: IRNWhitelist.Utils.GmatchToTable
---

```lua
🟦🟨 table IRNWhitelist.Utils.GmatchToTable(string str, string pattern)
```

## Description
---

Insert all string.gmatch values into table.

## Arguments
---

`1` **`string`** **str**  
&emsp;The string to search in.

`2` **`string`** **pattern**  
&emsp;The pattern to search for.

## Returns
---

`1` **`table`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(parsed_phrase, "%%([%w_%.]+)%%"))
```
