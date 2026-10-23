---
title: IRNWhitelist.Files
---

List of all available functions and methods in the `IRNWhitelist.Files` module.

## Methods
---

`boolean IRNWhitelist.Files:`[**`AppendLine`**](AppendLine.md)`(string name, string ctx)`  
&emsp;Append line to file.

`boolean IRNWhitelist.Files:`[**`Create`**](Create.md)`(string name, string ctx)`  
&emsp;Create new file.

`boolean IRNWhitelist.Files:`[**`Exists`**](Exists.md)`(string name)`  
&emsp;Check if file exists.

`boolean IRNWhitelist.Files:`[**`LineExists`**](LineExists.md)`(string name, string ctx, boolean? no_patterns)`  
&emsp;Check if line exists at file.

`IRNWhitelist.Files:`[**`Load`**](Load.md)`()`  
&emsp;Main module load function.

`table IRNWhitelist.Files:`[**`ReadJSON`**](ReadJSON.md)`(string name)`  
&emsp;Read file content as JSON.

`string[] IRNWhitelist.Files:`[**`ReadLines`**](ReadLines.md)`(string name)`  
&emsp;Read lines from file.

`string IRNWhitelist.Files:`[**`ReadRAW`**](ReadRAW.md)`(string name)`  
&emsp;Read RAW file content.

`boolean IRNWhitelist.Files:`[**`RemoveDuplicateLines`**](RemoveDuplicateLines.md)`(string name)`  
&emsp;Remove duplicate lines from file.

`boolean IRNWhitelist.Files:`[**`RemoveLine`**](RemoveLine.md)`(string name, string ctx, boolean? no_patterns)`  
&emsp;Remove line from file.

`boolean IRNWhitelist.Files:`[**`ReplaceLine`**](ReplaceLine.md)`(string name, string x, string y, boolean? no_patterns)`  
&emsp;Replace line in file.

`boolean IRNWhitelist.Files:`[**`WriteJSON`**](WriteJSON.md)`(string name, table ctx)`  
&emsp;Write JSON data to file.

`boolean IRNWhitelist.Files:`[**`WriteLines`**](WriteLines.md)`(string name, string[] ctx)`  
&emsp;Write lines to file.

`boolean IRNWhitelist.Files:`[**`WriteRAW`**](WriteRAW.md)`(string name, string ctx)`  
&emsp;Write RAW data to file.
