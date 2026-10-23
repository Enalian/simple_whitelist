---
title: IRNWhitelist.Utils
---

List of all available functions and methods in the `IRNWhitelist.Utils` module.

## Functions
---

`string IRNWhitelist.Utils.`[**`FormatString`**](FormatString.md)`(string str, string? fmt, string[] tbl)`  
&emsp;Format string with table (Relace all 'fmt' strings from key-values into 'tbl').

`string IRNWhitelist.Utils.`[**`GeneratePIN`**](GeneratePIN.md)`(number? digits)`  
&emsp;Generate server password pin-code.

`string, string IRNWhitelist.Utils.`[**`GenPasswordHash`**](GenPasswordHash.md)`(string password, string? salt, string pepper)`  
&emsp;Generate password hash.

`string IRNWhitelist.Utils.`[**`GenPasswordSaltPepper`**](GenPasswordSaltPepper.md)`(number? length)`  
&emsp;Generate password salt or server pepper.

`table IRNWhitelist.Utils.`[**`GmatchToTable`**](GmatchToTable.md)`(string str, string pattern)`  
&emsp;Insert all string.gmatch values into table.

`boolean IRNWhitelist.Utils.`[**`Int2Bool`**](Int2Bool.md)`(number int, boolean? rev)`  
&emsp;Translate number (integer) to bool value.

`boolean IRNWhitelist.Utils.`[**`Log`**](Log.md)`(string str)`  
&emsp;Write string into a log file.

`any IRNWhitelist.Utils.`[**`Module`**](Module.md)`(string name)`  
&emsp;Load whitelist module.

`string IRNWhitelist.Utils.`[**`ParseIP`**](ParseIP.md)`(string ipa)`  
&emsp;Get IP from IP:Port.

`boolean IRNWhitelist.Utils.`[**`PasswordsMatch`**](PasswordsMatch.md)`(string input_password, string input_salt, string need_hash, string pepper)`  
&emsp;Check if password match with his hash.

`string IRNWhitelist.Utils.`[**`PrintPlayerName`**](PrintPlayerName.md)`(Player or string plyOrName, string? sid64, boolean? logs_print)`  
&emsp;Generate printable player name.

`IRNWhitelist.Utils.`[**`SetServerPassword`**](SetServerPassword.md)`(string? password)`  
&emsp;Set or reset server password (for reset - 'password' = nil or 'password' = "").

`table IRNWhitelist.Utils.`[**`TableClearDoubles`**](TableClearDoubles.md)`(any[] tbl)`  
&emsp;Clear sequential table from double values.
