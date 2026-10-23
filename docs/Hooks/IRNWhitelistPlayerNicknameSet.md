---
title: IRNWhitelistPlayerNicknameSet
---

```lua
🟦 hook.Add("IRNWhitelistPlayerNicknameSet", "identifier", function(string steamid64, string name))
```

## Description
---

Calls when player nickname has been set.

## Arguments
---

`1` **`string`** **steamid64**  
&emsp;Player SteamID64.

`2` **`string`** **name**  
&emsp;Player nickname.

## Example
---

```lua
hook.Add("IRNWhitelistPlayerNicknameSet", "UniqueIdentifier", function(steamid64, name)
    -- Your code here
end)
```
