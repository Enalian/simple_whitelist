---
title: IRNWhitelist.Lang:GetName
---

```lua
🟦🟨 string IRNWhitelist.Lang:GetName(string lang, number? mode)
```

## Description
---

Get language name.

## Arguments
---

`1` **`string`** **lang**  
&emsp;Input language.

`2` **`number?`** **mode** *(optional)*  
&emsp;Print mode.

## Returns
---

`1` **`string`**  
&emsp;Return value.

## Example
---

```lua
self.Settings.LanguageSelect.ComboBox:AddChoice(IRNWhitelist.Lang:GetName(v), v)
```
