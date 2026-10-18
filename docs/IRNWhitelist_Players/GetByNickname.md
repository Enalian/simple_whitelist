---
title: IRNWhitelist.Players.GetByNickname
---

```lua
🟦 Player|nil IRNWhitelist.Players.GetByNickname(string name)
```

## Description
---

Get player by nickname

## Arguments
---

`1` **`string`** **name**  
&emsp;Input name

## Returns
---

`1` **`Player|nil`**  
&emsp;Return value.

## Example
---

```lua
if IsValid(IRNWhitelist.Players.GetByNickname(input)) and self.GetByNickname(input):IsPlayer() then
```
