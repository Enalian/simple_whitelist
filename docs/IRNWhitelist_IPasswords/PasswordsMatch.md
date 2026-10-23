---
title: IRNWhitelist.IPasswords:PasswordsMatch
---

```lua
🟦 boolean IRNWhitelist.IPasswords:PasswordsMatch(string password, string salt, string hash)
```

## Description
---

Check if password and his hash matches.

## Arguments
---

`1` **`string`** **password**  
&emsp;Input password.

`2` **`string`** **salt**  
&emsp;Input password salt.

`3` **`string`** **hash**  
&emsp;Needed hash.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.IPasswords:PasswordsMatch(password, salt, hash)
```
