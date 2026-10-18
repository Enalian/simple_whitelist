---
title: IRNWhitelist.Files:RemoveLine
---

```lua
🟦 boolean IRNWhitelist.Files:RemoveLine(string name, string ctx, boolean? no_patterns)
```

## Description
---

Remove line from file

## Arguments
---

`1` **`string`** **name**  
&emsp;File name

`2` **`string`** **ctx**  
&emsp;Removing line

`3` **`boolean?`** **no_patterns** *(optional)*  
&emsp;Ignore patterns

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:RemoveLine("players", string.format("^%s", steamid64))
```
