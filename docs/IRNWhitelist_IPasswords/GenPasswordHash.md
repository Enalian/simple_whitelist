---
title: IRNWhitelist.IPasswords:GenPasswordHash
---

```lua
🟦 string, string IRNWhitelist.IPasswords:GenPasswordHash(string password, string? salt)
```

## Description
---

Generate password hash and/or salt.

## Arguments
---

`1` **`string`** **password**  
&emsp;Input password.

`2` **`string?`** **salt** *(optional)*  
&emsp;Input salt.

## Returns
---

`1` **`string`**  
&emsp;Return value.

`2` **`string`**  
&emsp;Return value.

## Example
---

```lua
local hash, salt = IRNWhitelist.IPasswords:GenPasswordHash(password)
```
