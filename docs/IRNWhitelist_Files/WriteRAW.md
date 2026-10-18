---
title: IRNWhitelist.Files:WriteRAW
---

```lua
🟦 boolean IRNWhitelist.Files:WriteRAW(string name, string ctx)
```

## Description
---

Write RAW data to file

## Arguments
---

`1` **`string`** **name**  
&emsp;File name

`2` **`string`** **ctx**  
&emsp;File data

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:WriteRAW(name, util.TableToJSON(ctx, true) or "{}")
```
