---
title: IRNWhitelist.Files:ReadLines
---

```lua
🟦 string[] IRNWhitelist.Files:ReadLines(string name)
```

## Description
---

Read lines from file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

## Returns
---

`1` **`string[]`**  
&emsp;Return value.

## Example
---

```lua
for _, line in ipairs(IRNWhitelist.Files:ReadLines("players") or {}) do
```
