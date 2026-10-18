---
title: IRNWhitelist.Utils.TableClearDoubles
---

```lua
🟦🟨 table IRNWhitelist.Utils.TableClearDoubles(any[] tbl)
```

## Description
---

Clear sequential table from double values

## Arguments
---

`1` **`any[]`** **tbl**  
&emsp;Table to clear doubles in

## Returns
---

`1` **`table`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Utils.TableClearDoubles(IRNWhitelist.Utils.GmatchToTable(parsed_phrase, "%%([%w_%.]+)%%"))
```
