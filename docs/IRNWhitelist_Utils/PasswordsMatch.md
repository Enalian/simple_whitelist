---
title: IRNWhitelist.Utils.PasswordsMatch
---

```lua
🟦 boolean IRNWhitelist.Utils.PasswordsMatch(string input_password, string input_salt, string need_hash, string pepper)
```

## Description
---

Check if password match with his hash.

## Arguments
---

`1` **`string`** **input_password**  
&emsp;Input password.

`2` **`string`** **input_salt**  
&emsp;Input salt.

`3` **`string`** **need_hash**  
&emsp;Needed hash.

`4` **`string`** **pepper**  
&emsp;Unique server pepper.

## Returns
---

`1` **`boolean`**  
&emsp;Return value.

## Example
---

```lua
return IRNWhitelist.Utils.PasswordsMatch(password, salt, hash, self.GetPepper())
```
