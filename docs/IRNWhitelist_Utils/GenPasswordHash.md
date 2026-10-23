---
title: IRNWhitelist.Utils.GenPasswordHash
---

```lua
🟦 string, string IRNWhitelist.Utils.GenPasswordHash(string password, string? salt, string pepper)
```

## Description
---

Generate password hash.

## Arguments
---

`1` **`string`** **password**  
&emsp;Password to generate hash from.

`2` **`string?`** **salt** *(optional)*  
&emsp;Unique password salt.

`3` **`string`** **pepper**  
&emsp;Unique server pepper.

## Returns
---

`1` **`string`**  
&emsp;Return value.

`2` **`string`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Utils.GenPasswordHash(password, salt, self.GetPepper())
```
