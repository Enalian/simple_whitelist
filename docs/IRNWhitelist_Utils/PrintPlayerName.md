---
title: IRNWhitelist.Utils.PrintPlayerName
---

```lua
🟦 string IRNWhitelist.Utils.PrintPlayerName(Player or string plyOrName, string? sid64, boolean? logs_print)
```

## Description
---

Generate printable player name.

## Arguments
---

`1` **`Player or string`** **plyOrName**  
&emsp;Player or player name.

`2` **`string?`** **sid64** *(optional)*  
&emsp;Player SteamID64.

`3` **`boolean?`** **logs_print** *(optional)*  
&emsp;For logs?

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
local print_name = IRNWhitelist.Utils.PrintPlayerName(name, steamid)
```
