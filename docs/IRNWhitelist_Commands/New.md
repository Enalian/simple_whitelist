---
title: IRNWhitelist.Commands.New
---

```lua
🟦 IRNWhitelist.Commands.New(string name, function do_func, string? desc)
```

## Description
---

Register new command

## Arguments
---

`1` **`string`** **name**  
&emsp;New command name

`2` **`function`** **do_func**  
&emsp;OnExecute function

`3` **`string?`** **desc** *(optional)*  
&emsp;Command description

## Example
---

```lua
IRNWhitelist.Commands.New("on", function()
	IRNWhitelist.CVars:Set("enable", true)
	IRNWhitelist.Console:Success("commands.enable")
end, "Enable whitelist")
```
