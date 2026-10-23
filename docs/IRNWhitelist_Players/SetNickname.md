---
title: IRNWhitelist.Players:SetNickname
---

```lua
🟦 boolean IRNWhitelist.Players:SetNickname(string steamid64, string name)
```

## Description
---

Set player nickname (for database).

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string`** **name**  
&emsp;Player nickname.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
IRNWhitelist.Players:SetNickname(util.SteamIDTo64(data.networkid), data.name)
```
