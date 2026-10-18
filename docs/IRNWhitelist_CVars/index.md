---
title: IRNWhitelist.CVars
---

List of all available functions and methods in the `IRNWhitelist.CVars` module.

## Methods
---

`boolean IRNWhitelist.CVars:`[**`Apply`**](Apply.md)`(table cvrs)`  
&emsp;Apply ConVar values from table

`table IRNWhitelist.CVars:`[**`Collect`**](Collect.md)`()`  
&emsp;Collect all ConVars values

`ConVar|nil IRNWhitelist.CVars:`[**`ConVar`**](ConVar.md)`(string name)`  
&emsp;Get raw ConVar type

`any IRNWhitelist.CVars:`[**`Get`**](Get.md)`(string name, string cv_type, any? default)`  
&emsp;Get ConVar value

`boolean IRNWhitelist.CVars:`[**`Has`**](Has.md)`(string name)`  
&emsp;Check if ConVar exists

`IRNWhitelist.CVars:`[**`Load`**](Load.md)`()`  
&emsp;Main module load function

`ConVar|nil IRNWhitelist.CVars:`[**`New`**](New.md)`(string name, string or number default, number or table? flags, string? helptext, number? min, number? max, function? on_change)`  
&emsp;Register new ConVar

`boolean IRNWhitelist.CVars:`[**`Set`**](Set.md)`(string name, string or number or boolean cv_type, string or number or boolean? value)`  
&emsp;Set ConVar value

`boolean IRNWhitelist.CVars:`[**`Toggle`**](Toggle.md)`(string name)`  
&emsp;Toggle boolean ConVar value
