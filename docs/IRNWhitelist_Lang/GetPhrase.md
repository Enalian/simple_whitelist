---
title: IRNWhitelist.Lang:GetPhrase
---

```lua
🟦🟨 string IRNWhitelist.Lang:GetPhrase(string phrase, string? lang, boolean? no_warn)
```

## Description
---

Get language phrase

## Arguments
---

`1` **`string`** **phrase**  
&emsp;Input phrase

`2` **`string?`** **lang** *(optional)*  
&emsp;Phrase language

`3` **`boolean?`** **no_warn** *(optional)*  
&emsp;Ignore warnings

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
local parsed_phrase = IRNWhitelist.Lang:GetPhrase(phrase, params.lang, params.no_warn)
```
