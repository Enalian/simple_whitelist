---
title: IRNWhitelist.IPasswords
---

List of all available functions and methods in the `IRNWhitelist.IPasswords` module.

## Methods
---

`boolean IRNWhitelist.IPasswords:`[**`Check`**](Check.md)`(string steamid64, string password)`  
&emsp;Check function for whitelist hook.

`string, string IRNWhitelist.IPasswords:`[**`GenPasswordHash`**](GenPasswordHash.md)`(string password, string? salt)`  
&emsp;Generate password hash and/or salt.

`string or nil IRNWhitelist.IPasswords:`[**`GetPasswordHash`**](GetPasswordHash.md)`(string steamid64)`  
&emsp;Get player password hash.

`string or nil, string or nil IRNWhitelist.IPasswords:`[**`GetPasswordHashSalt`**](GetPasswordHashSalt.md)`(string steamid64)`  
&emsp;Get player password hash and salt.

`string or nil IRNWhitelist.IPasswords:`[**`GetPasswordSalt`**](GetPasswordSalt.md)`(string steamid64)`  
&emsp;Get player password salt.

`boolean IRNWhitelist.IPasswords:`[**`HasPassword`**](HasPassword.md)`(string steamid64)`  
&emsp;Check if player has individual password.

`IRNWhitelist.IPasswords:`[**`Load`**](Load.md)`()`  
&emsp;Main module load function.

`boolean IRNWhitelist.IPasswords:`[**`PasswordsMatch`**](PasswordsMatch.md)`(string password, string salt, string hash)`  
&emsp;Check if password and his hash matches.

`IRNWhitelist.IPasswords:`[**`RemoveAllPasswords`**](RemoveAllPasswords.md)`()`  
&emsp;Remove all player individual passwords.

`boolean IRNWhitelist.IPasswords:`[**`RemovePassword`**](RemovePassword.md)`(string steamid64)`  
&emsp;Remove player individual password.

`boolean, string? IRNWhitelist.IPasswords:`[**`SetPassword`**](SetPassword.md)`(string steamid64, string? password)`  
&emsp;Set new player password.

## Functions
---

`boolean IRNWhitelist.IPasswords.`[**`Disable`**](Disable.md)`()`  
&emsp;Disable individual passwords module.

`boolean IRNWhitelist.IPasswords.`[**`Enable`**](Enable.md)`()`  
&emsp;Enable individual passwords module.

`string IRNWhitelist.IPasswords.`[**`GetPepper`**](GetPepper.md)`()`  
&emsp;Get password pepper.

`boolean IRNWhitelist.IPasswords.`[**`IsEnabled`**](IsEnabled.md)`()`  
&emsp;Check if individual passwords module enabled or not.

`boolean IRNWhitelist.IPasswords.`[**`SetPepper`**](SetPepper.md)`(string? new_pepper)`  
&emsp;Set new password pepper.

`boolean IRNWhitelist.IPasswords.`[**`Toggle`**](Toggle.md)`()`  
&emsp;Toggle (on/off) individual passwords module.
