---
title: IRNWhitelist.CVars:New
---

```lua
🟦 ConVar or nil IRNWhitelist.CVars:New(string name, string or number default, number or table? flags, string? helptext, number? min, number? max, function(oldValue: string, newValue: string)? on_change)
```

## Description
---

Register new ConVar.

## Arguments
---

`1` **`string`** **name**  
&emsp;Name of new ConVar.

`2` **`string or number`** **default**  
&emsp;Default value of new ConVar.

`3` **`number or table?`** **flags** *(optional)*  
&emsp;ConVar flags.

`4` **`string?`** **helptext** *(optional)*  
&emsp;Help text of new ConVar.

`5` **`number?`** **min** *(optional)*  
&emsp;Minimum value of new ConVar.

`6` **`number?`** **max** *(optional)*  
&emsp;Maximum value of new ConVar.

`7` **`function(oldValue: string, newValue: string)?`** **on_change** *(optional)*  
&emsp;OnChange function.

## Returns
---

`1` **`ConVar or nil`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.CVars.New("on", function()
	IRNWhitelist.CVars:Set("enable", true)
	IRNWhitelist.Console:Success("commands.enable")
end, "Enable whitelist")
```
