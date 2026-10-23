---
title: IRNWhitelist.Files:LineExists
---

```lua
🟦 boolean IRNWhitelist.Files:LineExists(string name, string ctx, boolean? no_patterns)
```

## Description
---

Check if line exists at file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

`2` **`string`** **ctx**  
&emsp;Line for check.

`3` **`boolean?`** **no_patterns** *(optional)*  
&emsp;Ignore patterns.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:LineExists("players", string.format("^%s", steamid64))
```
