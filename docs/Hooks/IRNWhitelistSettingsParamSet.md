---
title: IRNWhitelistSettingsParamSet
---

```lua
🟦 hook.Add("IRNWhitelistSettingsParamSet", "identifier", function(string param, string or number or boolean value))
```

## Description
---

Calls when settings parameter has been set.

## Arguments
---

`1` **`string`** **param**  
&emsp;Parameter name.

`2` **`string or number or boolean`** **value**  
&emsp;Parameter value.

## Example
---

```lua
hook.Add("IRNWhitelistSettingsParamSet", "UniqueIdentifier", function(param, value)
    -- Your code here
end)
```
