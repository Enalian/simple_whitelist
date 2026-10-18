---
title: IRNWhitelist.Console:Critical
---

```lua
🟦🟨 IRNWhitelist.Console:Critical(string phrase, string ...)
```

## Description
---

Print critical error into client console

## Arguments
---

`1` **`string`** **phrase**  
&emsp;Phrase (or text) to print

`2` **`string`** **...**  
&emsp;Format strings

## Example
---

```lua
IRNWhitelist.Console:Critical("Default language '{{1}}' not found! Reinstall the addon.", self.Default)
```
