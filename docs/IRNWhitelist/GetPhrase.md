---
title: IRNWhitelist:GetPhrase
---

```lua
🟦🟨 string IRNWhitelist:GetPhrase(string phrase, any ...)
```

## Description
---

Get language phrase.

## Arguments
---

`1` **`string`** **phrase**  
&emsp;Phrase.

`2` **`any`** **...**  
&emsp;Format strings.

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
local parsed_phrase = IRNWhitelist:GetPhrase(phrase, params.lang, params.no_warn)
```
