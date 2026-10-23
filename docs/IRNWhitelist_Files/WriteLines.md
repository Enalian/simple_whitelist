---
title: IRNWhitelist.Files:WriteLines
---

```lua
🟦 boolean IRNWhitelist.Files:WriteLines(string name, string[] ctx)
```

## Description
---

Write lines to file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

`2` **`string[]`** **ctx**  
&emsp;File data.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:WriteLines("players", {})
```
