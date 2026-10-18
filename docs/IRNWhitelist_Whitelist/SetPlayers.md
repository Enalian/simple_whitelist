---
title: IRNWhitelist.Whitelist:SetPlayers
---

```lua
🟦 IRNWhitelist.Whitelist:SetPlayers(table players)
```

## Description
---

Replace all whitelisted players to provided players

## Arguments
---

`1` **`table`** **players**  
&emsp;Players table (key = Player SteamID64, value = once? or SteamID64[])

## Example
---

```lua
IRNWhitelist.Whitelist:SetPlayers({ [steamid] = once })
```
