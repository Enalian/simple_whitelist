---
title: IRNWhitelistPlayersSetted
---

```lua
🟦 hook.Add("IRNWhitelistPlayersSetted", "identifier", function(table players))
```

## Description
---

Calls when list of whitelisted players has been set.

## Arguments
---

`1` **`table`** **players**  
&emsp;Players table (key = Player SteamID64, value = once? or SteamID64[]).

## Example
---

```lua
hook.Add("IRNWhitelistPlayersSetted", "UniqueIdentifier", function(players)
    -- Your code here
end)
```
