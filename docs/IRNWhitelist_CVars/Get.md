---
title: IRNWhitelist.CVars:Get
---

```lua
🟦 any IRNWhitelist.CVars:Get(string name, string cv_type, any? default)
```

## Description
---

Get ConVar value

## Arguments
---

`1` **`string`** **name**  
&emsp;The ConVar name

`2` **`string`** **cv_type**  
&emsp;The ConVar type

`3` **`any?`** **default** *(optional)*  
&emsp;Default value

## Returns
---

`1` **`any`**  
&emsp;Return value.

## Example
---

```lua
string.format("commands.%s", IRNWhitelist.CVars:Get("enable", "bool", false) and "enable" or "disable")
```
