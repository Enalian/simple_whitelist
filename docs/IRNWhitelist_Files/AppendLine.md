---
title: IRNWhitelist.Files:AppendLine
---

```lua
🟦 boolean IRNWhitelist.Files:AppendLine(string name, string ctx)
```

## Description
---

Append line to file.

## Arguments
---

`1` **`string`** **name**  
&emsp;File name.

`2` **`string`** **ctx**  
&emsp;Appending line.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Files:AppendLine("players", string.format("%s%s", steamid64, once and ", once" or ""))
```
