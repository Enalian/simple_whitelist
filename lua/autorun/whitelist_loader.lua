local MAIN_FOLDER = "irn_whitelist"
local LOADING_PRINT = false

local EXCLUDE_FILES = {
	"/post_load.lua",
}
local EXCLUDE_FOLDERS = {}

local run_sv = SERVER and include or function() end
local run_cl = SERVER and AddCSLuaFile or include
local run_cs = SERVER and AddCSLuaFile or function() end
local function run_sh(path)
	if SERVER then
		include(path)
		AddCSLuaFile(path)
	else
		include(path)
	end
end

local function Loader(fld, do_print, ignore_exclude, force_side)
	fld = fld or "*"

	if do_print == nil then
		do_print = LOADING_PRINT
	end
	if isstring(force_side) and not table.HasValue({ "sv", "cl", "sh", "cs" }, force_side:lower()) then
		ErrorNoHalt(
			string.format(
				"[%s] Параметр 'force_side' указан неверно. Допустимые значения: sv, cl, cs, sh",
				MAIN_FOLDER:upper()
			)
		)
		return
	end

	local files, dirs = file.Find(MAIN_FOLDER .. "/" .. (string.EndsWith(fld, "*") and fld or fld .. "/*"), "LUA")
	local iFiles, iDirs = {}, {}
	if not isstring(force_side) then
		for _, v in ipairs(files) do
			local ifld = string.Replace(string.Replace(fld, "/*", ""), "*", "")
			local ipath = string.format("%s/%s%s", MAIN_FOLDER, #ifld > 0 and ifld .. "/" or "", v)

			if
				table.HasValue(EXCLUDE_FILES, string.format("/%s%s", #ifld > 0 and ifld .. "/" or "", v))
				and not ignore_exclude
			then
				iFiles[v] = true
			elseif string.EndsWith(v, ".lua") then
				if v == "init.lua" then
					if SERVER and do_print then
						MsgC(
							Color(0, 255, 0),
							string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
							Color(0, 255, 255),
							"(SERVER)\n"
						)
					end

					run_sv(ipath)
					iFiles[v] = true
				elseif v == "cl_init.lua" then
					if SERVER and do_print then
						MsgC(
							Color(0, 255, 0),
							string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
							Color(255, 255, 0),
							"(CLIENT)\n"
						)
					end

					run_cl(ipath)
					iFiles[v] = true
				elseif v == "shared.lua" or v == "main.lua" then
					if SERVER and do_print then
						MsgC(
							Color(0, 255, 0),
							string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
							Color(255, 255, 255),
							"(SHARED)\n"
						)
					end

					run_sh(ipath)
					iFiles[v] = true
				end
			end
		end
	end

	for _, v in ipairs(files) do
		if iFiles[v] then
			continue
		end

		if string.EndsWith(v, ".lua") then
			local ifld = string.Replace(string.Replace(fld, "/*", ""), "*", "")
			local ipath = string.format("%s/%s%s", MAIN_FOLDER, #ifld > 0 and ifld .. "/" or "", v)

			if string.StartsWith(v, "sv_") or force_side == "sv" then
				run_sv(ipath)
				if SERVER and do_print then
					MsgC(
						Color(0, 255, 0),
						string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
						Color(0, 255, 255),
						"(SERVER)\n"
					)
				end
			elseif string.StartsWith(v, "cl_") or force_side == "cl" then
				run_cl(ipath)
				if SERVER and do_print then
					MsgC(
						Color(0, 255, 0),
						string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
						Color(255, 255, 0),
						"(CLIENT)\n"
					)
				end
			elseif string.StartsWith(v, "cs_") or force_side == "cs" then
				run_cs(ipath)
				if SERVER and do_print then
					MsgC(
						Color(0, 255, 0),
						string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
						Color(128, 128, 0),
						"(CLIENTSIDE)\n"
					)
				end
			elseif string.StartsWith(v, "sh_") or force_side == "sh" then
				run_sh(ipath)
				if SERVER and do_print then
					MsgC(
						Color(0, 255, 0),
						string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
						Color(255, 255, 255),
						"(SHARED)\n"
					)
				end
			else
				run_sh(ipath)
				if SERVER and do_print then
					MsgC(
						Color(0, 255, 0),
						string.format('[%s] Файл "%s" загружен. ', MAIN_FOLDER:upper(), ipath),
						Color(255, 0, 0),
						"(SHARED DEFAULT)\n"
					)
				end
			end
		end
	end

	for _, v in ipairs(dirs) do
		if
			table.HasValue(
				EXCLUDE_FOLDERS,
				string.format(
					"/%s/%s",
					(fld == "*" or fld == "/*") and v or string.Replace(string.Replace(fld, "/*", ""), "*", ""),
					v
				)
			) and not ignore_exclude
		then
			iDirs[v] = true
		end
	end

	for _, v in ipairs(dirs) do
		if iDirs[v] then
			continue
		end

		Loader(
			(fld == "*" or fld == "/*") and v or string.Replace(string.Replace(fld, "/*", ""), "*", "") .. "/" .. v,
			LOADING_PRINT
		)
	end
end

Loader()
run_sv(MAIN_FOLDER .. "/post_load.lua")
