---
title: IRNWhitelist.Files:ReplaceLine
---

```lua
🟦 boolean IRNWhitelist.Files:ReplaceLine(string name, string x, string y, boolean? no_patterns)
```

## Description
---

Replace line in file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

`2` **`string`** **x**  
&emsp;Line for replacing.

`3` **`string`** **y**  
&emsp;Line to replace.

`4` **`boolean?`** **no_patterns** *(optional)*  
&emsp;Ignore patterns.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:ReplaceLine("players", string.format("^%s,%%s*once", steamid64), steamid64)
```
