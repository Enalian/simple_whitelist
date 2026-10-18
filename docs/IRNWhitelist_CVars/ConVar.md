---
title: IRNWhitelist.CVars:ConVar
---

```lua
🟦 ConVar|nil IRNWhitelist.CVars:ConVar(string name)
```

## Description
---

Get raw ConVar type

## Arguments
---

`1` **`string`** **name**  
&emsp;The ConVar name

## Returns
---

`1` **`ConVar|nil`**  
&emsp;Return value.

## Example
---

```lua
self.CVar = self.CVar or (SERVER and IRNWhitelist.CVars:ConVar("language") or GetConVar("gmod_language"))
```
