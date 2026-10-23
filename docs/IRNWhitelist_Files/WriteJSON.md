---
title: IRNWhitelist.Files:WriteJSON
---

```lua
🟦 boolean IRNWhitelist.Files:WriteJSON(string name, table ctx)
```

## Description
---

Write JSON data to file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

`2` **`table`** **ctx**  
&emsp;File data.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:WriteJSON("settings", settings)
```
