---
title: IRNWhitelist.CVars:Set
---

```lua
🟦 boolean IRNWhitelist.CVars:Set(string name, string or number or boolean cv_type, string or number or boolean? value)
```

## Description
---

Set ConVar value.

## Arguments
---

`1` **`string`** **name**  
&emsp;The ConVar name.

`2` **`string or number or boolean`** **cv_type**  
&emsp;The ConVar type.

`3` **`string or number or boolean?`** **value** *(optional)*  
&emsp;New ConVar value.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.CVars:Set("language", "string", new_lang)
```
