#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
EmmyLua / LuaLS & GLua to MkDocs Markdown Generator (GMod Wiki Style)
- Строгое игнорирование папок и всех их подпапок через .docignore
- Раздельные папки для подмодулей
- Отдельный .md файл на каждую функцию
- Автоматический сбор хуков (hook.Run / hook.Call) в категорию Hooks
- Авто-определение типов переменных в хуках из родительской функции и локальных переменных
- Корректный парсинг аргументов-функций в хуках (например, self.Read() -> table data1)
- Безотказный сбор комментариев над/рядом с хуками
- Вывод источника функции в консоль
- Автоматическое добавление точки в конце всех описаний
- Автоматическое обновление секции nav: в mkdocs.yml через флаг --update-nav
"""

import argparse
import fnmatch
import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple


@dataclass
class ParamDoc:
    name: str
    type_name: str = "any"
    description: str = ""
    optional: bool = False


@dataclass
class ReturnDoc:
    type_name: str
    name: str = ""
    description: str = ""


@dataclass
class FieldDoc:
    name: str
    type_name: str
    description: str = ""
    access: str = "public"


@dataclass
class ClassDoc:
    name: str
    parent: str = ""
    description: str = ""
    fields: Dict[str, FieldDoc] = field(default_factory=dict)


@dataclass
class FuncDoc:
    name: str
    short_name: str
    owner_prefix: str
    sep: str
    args: List[str] = field(default_factory=list)
    description: str = ""
    params: List[ParamDoc] = field(default_factory=list)
    returns: List[ReturnDoc] = field(default_factory=list)
    examples: List[str] = field(default_factory=list)
    deprecated: bool = False
    deprecated_msg: str = ""
    realm: str = "SHARED"
    is_method: bool = False
    is_hook: bool = False
    source_file: str = ""


@dataclass
class ModuleDoc:
    name: str
    rel_dir: Path
    description: str = ""
    classes: Dict[str, ClassDoc] = field(default_factory=dict)
    functions: Dict[str, FuncDoc] = field(default_factory=dict)


class DocIgnoreChecker:
    def __init__(self, root_dir: Path):
        self.raw_patterns: List[str] = []
        self.base_dir = root_dir.resolve()
        
        ignore_file = root_dir / ".docignore"
        if not ignore_file.exists():
            ignore_file = Path(__file__).resolve().parent / ".docignore"

        if ignore_file.exists():
            self.base_dir = ignore_file.resolve().parent
            try:
                content = ignore_file.read_text(encoding="utf-8", errors="replace")
                for line in content.splitlines():
                    line = line.strip()
                    if not line or line.startswith("#"):
                        continue
                    clean = line.replace("\\", "/").strip("/")
                    if clean:
                        self.raw_patterns.append(clean)
                print(f"[*] Загружен файл правил исключений: {ignore_file} ({len(self.raw_patterns)} правил)")
            except Exception as e:
                print(f"[!] Не удалось прочитать .docignore: {e}")

    def should_ignore(self, file_path: Path, root_dir: Path) -> bool:
        if not self.raw_patterns:
            return False

        try:
            rel_path = file_path.resolve().relative_to(self.base_dir).as_posix()
        except ValueError:
            rel_path = file_path.as_posix()

        path_obj = Path(rel_path)
        all_segments = path_obj.parts

        file_variants = {rel_path, file_path.name}
        for i in range(len(path_obj.parts)):
            sub_path = Path(*path_obj.parts[i:]).as_posix()
            file_variants.add(sub_path)

        for pat in self.raw_patterns:
            pat_clean = pat.strip("/")
            
            for variant in file_variants:
                if fnmatch.fnmatch(variant, pat_clean) or fnmatch.fnmatch(file_path.name, pat_clean):
                    return True

            pat_parts = Path(pat_clean).parts
            if len(all_segments) >= len(pat_parts):
                if all_segments[:len(pat_parts)] == pat_parts:
                    return True

        return False


class UsageExampleHelper:
    TYPE_DEFAULTS = {
        "player": "Entity(1)",
        "entity": "ents.Create('prop_physics')",
        "weapon": "ply:GetActiveWeapon()",
        "vehicle": "ply:GetVehicle()",
        "panel": "vgui.Create('DFrame')",
        "vector": "Vector(0, 0, 0)",
        "angle": "Angle(0, 0, 0)",
        "color": "Color(255, 255, 255, 255)",
        "matrix": "Matrix()",
        "convar": "GetConVar('sv_cheats')",
        "imaterial": "Material('models/debug/debugwhite')",
        "itexture": "surface.GetTextureID('vgui/white')",
        "ctakedamageinfo": "DamageInfo()",
        "ceffectdata": "EffectData()",
        "cmovedata": "mv",
        "cusercmd": "cmd",
        "string": '"example"',
        "number": "1",
        "integer": "1",
        "int": "1",
        "float": "1.0",
        "boolean": "true",
        "bool": "true",
        "table": "{}",
        "function": "function() end",
        "fun": "function() end",
        "thread": "coroutine.create(function() end)",
        "userdata": "nil",
        "any": "value",
    }

    @classmethod
    def guess_value_for_param(cls, param: ParamDoc) -> str:
        if param.name == "...":
            return "..."

        base_type = re.split(r'[|?]', param.type_name)[0].strip()
        base_type_lower = base_type.lower()
        pname_lower = param.name.lower()

        if base_type_lower == "any":
            if pname_lower in ("ply", "player", "client", "attacker", "victim", "target"):
                return "Entity(1)"
            if pname_lower in ("ent", "entity"):
                return "Entity(1)"
            if pname_lower in ("pos", "position", "origin", "vec"):
                return "Vector(0, 0, 0)"
            if pname_lower in ("ang", "angle", "angles"):
                return "Angle(0, 0, 0)"
            if pname_lower in ("col", "color", "clr"):
                return "Color(255, 255, 255)"
            if pname_lower in ("name", "id", "str", "text", "msg", "title", "path", "class", "desc", "description"):
                return f'"{param.name}"'
            if pname_lower in ("amount", "count", "num", "index", "idx", "playerindex", "teamid", "time", "delay", "price", "weight", "slot"):
                return "1"
            if pname_lower.startswith(("is", "has", "can", "should", "b_")):
                return "true"
            if pname_lower in ("tbl", "data", "list", "items", "options", "cfg", "args"):
                return "{}"
            if pname_lower in ("cb", "callback", "fn", "func", "do_func"):
                return "function() end"
            return param.name

        if base_type_lower == "string":
            if pname_lower in ("id", "itemid", "uid", "uniqueid"):
                return '"item_id"'
            if pname_lower in ("name", "username", "title"):
                return '"name"'
            if pname_lower in ("desc", "description"):
                return '"Description text"'
            if pname_lower in ("path", "file", "filepath"):
                return '"path/to/file.lua"'
            return f'"{param.name}"'

        if base_type_lower.startswith("fun(") or base_type_lower in ("function", "fun"):
            return "function() end"
        if base_type_lower.endswith("[]"):
            return "{}"
        if base_type_lower in cls.TYPE_DEFAULTS:
            return cls.TYPE_DEFAULTS[base_type_lower]

        return f"<{base_type}>"

    @staticmethod
    def _extract_balanced_call(lines: List[str], start_idx: int, max_lines: int = 12) -> Optional[str]:
        collected = []
        paren_depth = 0
        started = False

        for i in range(start_idx, min(len(lines), start_idx + max_lines)):
            line = lines[i]
            collected.append(line)
            clean = re.sub(r'(--|//).*$', '', line)
            clean = re.sub(r'(["\'])(?:(?=(\\?))\2.)*?\1', '""', clean)
            for ch in clean:
                if ch == '(':
                    paren_depth += 1
                    started = True
                elif ch == ')':
                    paren_depth -= 1

            if started and paren_depth <= 0:
                break

        if not started or paren_depth > 0:
            return None

        non_empty = [l for l in collected if l.strip()]
        if not non_empty:
            return None
        min_indent = min(len(l) - len(l.lstrip()) for l in non_empty)
        dedented = [l[min_indent:] if len(l) >= min_indent else l.lstrip() for l in collected]
        return "\n".join(dedented).strip()

    @classmethod
    def find_call_in_codebase(cls, fn: FuncDoc, all_files_lines: List[List[str]]) -> Optional[str]:
        if fn.is_hook:
            return None

        direct_pat = re.compile(rf'(?<!function\s)\b{re.escape(fn.name)}\s*\(')
        self_pat = None
        if fn.owner_prefix:
            self_pat = re.compile(rf'(?<!function\s)\bself\s*([.:])\s*{re.escape(fn.short_name)}\s*\(')

        for lines in all_files_lines:
            for idx, line in enumerate(lines):
                stripped = line.strip()
                if not stripped or stripped.startswith(("--", "//", "function ")):
                    continue
                if re.match(rf'^{re.escape(fn.name)}\s*=\s*function', stripped):
                    continue
                if direct_pat.search(stripped):
                    extracted = cls._extract_balanced_call(lines, idx)
                    if extracted:
                        return extracted

        if self_pat:
            for lines in all_files_lines:
                file_text = "\n".join(lines)
                if fn.owner_prefix not in file_text:
                    continue
                for idx, line in enumerate(lines):
                    stripped = line.strip()
                    if not stripped or stripped.startswith(("--", "//", "function ")):
                        continue
                    m = self_pat.search(stripped)
                    if m:
                        extracted = cls._extract_balanced_call(lines, idx)
                        if extracted:
                            sep = m.group(1)
                            extracted = re.sub(
                                rf'\bself\s*[.:]\s*{re.escape(fn.short_name)}\b',
                                f"{fn.owner_prefix}{sep}{fn.short_name}",
                                extracted,
                                count=1
                            )
                            return extracted

        return None

    @classmethod
    def synthesize_example(cls, fn: FuncDoc) -> str:
        if fn.is_hook:
            args_str = ", ".join([p.name for p in fn.params])
            return f"hook.Add(\"{fn.name}\", \"UniqueIdentifier\", function({args_str})\n    -- Your code here\nend)"

        call_args = [cls.guess_value_for_param(p) for p in fn.params]
        args_str = ", ".join(call_args)

        lhs = ""
        ret_vars = []
        if fn.returns:
            for idx, r in enumerate(fn.returns, start=1):
                if r.name and r.name not in ("nil", "void"):
                    ret_vars.append(r.name)
                else:
                    base_ret = re.split(r'[|?]', r.type_name)[0].strip().lower()
                    if base_ret in ("boolean", "bool"):
                        ret_vars.append("ok" if idx == 1 else f"ok{idx}")
                    elif base_ret == "string":
                        ret_vars.append("str" if idx == 1 else f"str{idx}")
                    elif base_ret in ("number", "integer", "int", "float"):
                        ret_vars.append("num" if idx == 1 else f"num{idx}")
                    elif base_ret == "table":
                        ret_vars.append("data" if idx == 1 else f"data{idx}")
                    elif base_ret == "player":
                        ret_vars.append("ply" if idx == 1 else f"ply{idx}")
                    elif base_ret == "entity":
                        ret_vars.append("ent" if idx == 1 else f"ent{idx}")
                    elif base_ret in ("nil", "void"):
                        continue
                    else:
                        ret_vars.append("result" if idx == 1 else f"result{idx}")
            if ret_vars:
                lhs = f"local {', '.join(ret_vars)} = "

        call_line = f"{lhs}{fn.name}({args_str})"
        if fn.returns and ret_vars:
            return f"{call_line}\nprint({ret_vars[0]})"
        return call_line


class LuaDocParser:
    RE_MODULE_TAG = re.compile(r'^@module\s+[\'"]?([a-zA-Z0-9_.\-]+)[\'"]?(?:\s+(.*))?$')
    RE_CLASS_TAG = re.compile(r'^@class\s+([a-zA-Z0-9_.]+)(?:\s*:\s*([a-zA-Z0-9_.]+))?(?:\s+(.*))?$')
    RE_DEPRECATED_TAG = re.compile(r'^@deprecated(?:\s+(.*))?$')
    RE_USAGE_TAG = re.compile(r'^@(?:usage|example)\b(?:\s+(.*))?$', re.IGNORECASE)
    RE_REALM_TAG = re.compile(r'^@(server|client|shared|realm)\b(?:\s+(.*))?$', re.IGNORECASE)

    RE_MODULE_CALL = re.compile(r'^\s*module\s*\(\s*[\'"]([a-zA-Z0-9_.\-]+)[\'"]')
    RE_GLOBAL_TABLE = re.compile(
        r'^\s*([a-zA-Z_][a-zA-Z0-9_.]*)\s*=\s*(?:\1\s+or\s+)?\{\s*\}|'
        r'^\s*([a-zA-Z_][a-zA-Z0-9_.]*)\s*=\s*table\.Copy\b'
    )
    RE_LOCAL_FUNC = re.compile(
        r'^\s*local\s+function\s+[a-zA-Z0-9_]+\s*\(|'
        r'^\s*local\s+[a-zA-Z0-9_]+\s*=\s*function\s*\('
    )
    RE_GLOBAL_FUNC = re.compile(
        r'^\s*function\s+([a-zA-Z_][a-zA-Z0-9_.:]*)\s*\(([^)]*)\)|'
        r'^\s*([a-zA-Z_][a-zA-Z0-9_.]*)\s*=\s*function\s*\(([^)]*)\)'
    )
    RE_HOOK = re.compile(r'hook\.(Run|Call)\s*\(\s*[\'"]([a-zA-Z0-9_.:\-]+)[\'"](.*)')
    RE_ANY_FUNC_SIG = re.compile(r'\b(?:function\s*[a-zA-Z0-9_.:]*|[a-zA-Z0-9_.:]+\s*=\s*function)\s*\(([^)]*)\)')

    RE_IF_REALM = re.compile(r'^\s*(?:else)?if\s+(SERVER|CLIENT)\s+then\b')
    RE_BLOCK_START = re.compile(r'\b(function|if|for|while|repeat)\b')
    RE_BLOCK_END = re.compile(r'\b(end|until)\b')

    def __init__(self, include_undocumented: bool = True):
        self.include_undocumented = include_undocumented

    @staticmethod
    def extract_emmylua_type_and_rest(text: str) -> Tuple[str, str]:
        if not text:
            return "", ""
        paren_c = 0
        angle_c = 0
        for i, char in enumerate(text):
            if char == '(': paren_c += 1
            elif char == ')': paren_c -= 1
            elif char == '<': angle_c += 1
            elif char == '>': angle_c -= 1
            
            if char == ' ' and paren_c == 0 and angle_c == 0:
                if text[i:i+3] in (" | ", " : "):
                    continue
                if i > 0 and text[i-1] in ("|", ":"):
                    continue
                if i+1 < len(text) and text[i+1] in ("|", ":"):
                    continue
                return text[:i].strip(), text[i+1:].strip()
        return text.strip(), ""

    @staticmethod
    def guess_type_by_name(name: str) -> str:
        name_lower = name.lower()
        if name_lower in ("ply", "player", "client", "attacker", "victim", "caller", "activator"):
            return "Player"
        if name_lower in ("ent", "entity", "target", "weapon", "vehicle"):
            return "Entity"
        if name_lower in ("oldvalue", "newvalue", "str", "text", "reason", "name", "id", "uid", "title", "path", "msg", "cmd"):
            return "string"
        if name_lower in ("amount", "count", "num", "index", "idx", "time", "delay", "price", "weight", "slot", "health", "damage", "len"):
            return "number"
        if name_lower in ("tbl", "data", "list", "items", "options", "args", "cfg") or name_lower.startswith("data"):
            return "table"
        if name_lower.startswith(("is", "has", "can", "should", "b_")):
            return "boolean"
        if name_lower in ("pos", "position", "origin", "vec"):
            return "Vector"
        if name_lower in ("ang", "angle", "angles"):
            return "Angle"
        if name_lower in ("col", "color", "clr"):
            return "Color"
        if name_lower in ("func", "cb", "callback", "on_change"):
            return "function"
        return "any"

    @staticmethod
    def preprocess_lines(content: str) -> List[str]:
        def replace_keeping_newlines(match):
            return "\n" * match.group(0).count("\n")

        content = re.sub(r'/\*[\s\S]*?\*/', replace_keeping_newlines, content)
        content = re.sub(r'--\[\[[\s\S]*?\]\]', replace_keeping_newlines, content)
        return content.splitlines()

    @staticmethod
    def detect_file_realm(file_path: Path) -> str:
        fname = file_path.stem.lower()
        parts = [p.lower() for p in file_path.parts]

        if fname.startswith(("sv_", "server_")) or fname in ("init", "sv_init") or "server" in parts:
            return "SERVER"
        if fname.startswith(("cl_", "client_")) or fname in ("cl_init",) or "client" in parts:
            return "CLIENT"
        if fname.startswith(("sh_", "shared_")) or fname in ("shared", "sh_init") or "shared" in parts:
            return "SHARED"
        return "SHARED"

    def detect_module_name(self, lines: List[str], file_path: Path) -> Tuple[str, str]:
        for line in lines:
            stripped = line.strip()
            if stripped.startswith(("---", "///")):
                doc_body = stripped[3:].strip()
                m = self.RE_MODULE_TAG.match(doc_body)
                if m:
                    return m.group(1), (m.group(2) or "").strip()

        for line in lines:
            clean_line = re.sub(r'(--|//).*$', '', line).strip()
            m_fn = self.RE_GLOBAL_FUNC.match(clean_line)
            if m_fn:
                fn_name = m_fn.group(1) or m_fn.group(3)
                if "." in fn_name or ":" in fn_name:
                    full_prefix = re.split(r'[.:](?=[^.:]*$)', fn_name)[0]
                    if full_prefix and full_prefix not in ("_", "M", "self"):
                        return full_prefix, ""

        for line in lines:
            clean_line = re.sub(r'(--|//).*$', '', line).strip()
            if not clean_line or clean_line.startswith("local "):
                continue
            m_tbl = self.RE_GLOBAL_TABLE.match(clean_line)
            if m_tbl:
                tbl_name = m_tbl.group(1) or m_tbl.group(2)
                if tbl_name not in ("_", "M", "GAMEMODE", "GM", "ENT", "SWEP", "EFFECT", "TOOL"):
                    return tbl_name, ""

        stem = file_path.stem
        if stem.lower() in ("init", "cl_init", "shared", "sh_init", "sv_init") and file_path.parent.name:
            return file_path.parent.name, ""
        clean_stem = re.sub(r'^(sv|cl|sh|server|client|shared)_', '', stem, flags=re.IGNORECASE)
        return clean_stem or stem, ""

    def find_local_tables(self, lines: List[str]) -> set:
        locals_set = set()
        re_local_tbl = re.compile(r'^\s*local\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=')
        for line in lines:
            m = re_local_tbl.match(line)
            if m:
                locals_set.add(m.group(1))
        return locals_set

    def parse_file(self, file_path: Path, root_dir: Path, lines: List[str]) -> Tuple[str, Path, str, List[ClassDoc], List[FuncDoc], List[FuncDoc]]:
        rel_dir = file_path.relative_to(root_dir).parent
        mod_name, mod_desc = self.detect_module_name(lines, file_path)
        local_vars = self.find_local_tables(lines)
        file_realm = self.detect_file_realm(file_path)

        classes: List[ClassDoc] = []
        functions: List[FuncDoc] = []
        hooks: List[FuncDoc] = []
        doc_buffer: List[str] = []

        realm_stack: List[Tuple[int, str]] = []
        block_depth = 0
        active_params: Dict[str, ParamDoc] = {}
        active_locals: Dict[str, str] = {}

        for idx, raw_line in enumerate(lines, start=1):
            stripped = raw_line.strip()

            if stripped.startswith("---") and not stripped.startswith("----"):
                doc_buffer.append(stripped[3:].strip())
                continue
            elif stripped.startswith("///") and not stripped.startswith("////"):
                doc_buffer.append(stripped[3:].strip())
                continue

            if stripped.startswith("--") or stripped.startswith("//"):
                continue

            if not stripped:
                if doc_buffer and any(l.startswith("@class") for l in doc_buffer):
                    cls_doc = self._build_class_from_buffer(doc_buffer)
                    if cls_doc:
                        classes.append(cls_doc)
                doc_buffer.clear()
                continue

            code_line = re.sub(r'(--|//).*$', '', stripped).strip()

            m_realm_if = self.RE_IF_REALM.match(code_line)
            if m_realm_if:
                r_type = m_realm_if.group(1).upper()
                if code_line.startswith("elseif") and realm_stack and realm_stack[-1][0] == block_depth:
                    realm_stack[-1] = (block_depth, r_type)
                else:
                    realm_stack.append((block_depth + 1, r_type))
            elif code_line == "else" and realm_stack and realm_stack[-1][0] == block_depth:
                prev_depth, prev_r = realm_stack[-1]
                opposite = "CLIENT" if prev_r == "SERVER" else ("SERVER" if prev_r == "CLIENT" else "SHARED")
                realm_stack[-1] = (prev_depth, opposite)

            clean_for_depth = re.sub(r'(["\'])(?:(?=(\\?))\2.)*?\1', '""', code_line)
            starts = len(self.RE_BLOCK_START.findall(clean_for_depth))
            ends = len(self.RE_BLOCK_END.findall(clean_for_depth))
            block_depth += starts - ends
            while realm_stack and block_depth < realm_stack[-1][0]:
                realm_stack.pop()

            current_realm = realm_stack[-1][1] if realm_stack else file_realm

            m_any_func = self.RE_ANY_FUNC_SIG.search(code_line)
            if m_any_func:
                raw_args = m_any_func.group(1)
                func_args_list = [a.strip() for a in raw_args.split(",") if a.strip()]
                active_params.clear()
                active_locals.clear()
                params_map = {}
                for item in doc_buffer:
                    if item.startswith("@param"):
                        parts = item.split(maxsplit=2)
                        if len(parts) >= 2:
                            raw_pname = parts[1]
                            rest = parts[2] if len(parts) > 2 else ""
                            ptype, pdesc = self.extract_emmylua_type_and_rest(rest)
                            if not ptype: ptype = "any"
                            pname = raw_pname[:-1] if raw_pname.endswith("?") else raw_pname
                            clean_ptype = ptype[:-1] if ptype.endswith("?") else ptype
                            params_map[pname] = ParamDoc(name=pname, type_name=clean_ptype, description=pdesc)

                for arg in func_args_list:
                    if arg in params_map:
                        active_params[arg] = params_map[arg]
                    else:
                        guessed_type = self.guess_type_by_name(arg)
                        active_params[arg] = ParamDoc(name=arg, type_name=guessed_type)

            m_loc = re.match(r'^local\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*(.*)', code_line)
            if m_loc:
                var_name = m_loc.group(1)
                expr = m_loc.group(2).lower()
                if any(kw in expr for kw in ["int2bool", "tobool", "==", "~=", "true", "false", "is", "has"]):
                    active_locals[var_name] = "boolean"
                elif "tonumber" in expr:
                    active_locals[var_name] = "number"
                elif "tostring" in expr or '\"' in expr or '\'' in expr:
                    active_locals[var_name] = "string"
                elif "{}" in expr or "table." in expr:
                    active_locals[var_name] = "table"
                else:
                    active_locals[var_name] = "any"

            if self.RE_LOCAL_FUNC.match(code_line):
                doc_buffer.clear()
                continue

            m_hook = self.RE_HOOK.search(code_line)
            if m_hook:
                hook_type = m_hook.group(1)
                hook_name = m_hook.group(2)
                raw_rest = m_hook.group(3)
                
                args_list = []
                if "," in raw_rest:
                    parts = raw_rest.split(",", 1)[1]
                    parts = parts.rsplit(")", 1)[0]
                    
                    paren_level = 0
                    current_arg = ""
                    arg_chunks = []
                    for char in parts:
                        if char == '(': paren_level += 1
                        elif char == ')': paren_level -= 1
                        elif char == ',' and paren_level == 0:
                            arg_chunks.append(current_arg)
                            current_arg = ""
                            continue
                        current_arg += char
                    if current_arg:
                        arg_chunks.append(current_arg)
                    
                    if hook_type == "Call" and arg_chunks:
                        arg_chunks = arg_chunks[1:]
                        
                    for i, chunk in enumerate(arg_chunks):
                        chunk_clean = chunk.strip()
                        if not chunk_clean:
                            continue
                        
                        simplified = re.sub(r'["\'].*?["\']', '""', chunk_clean)
                        
                        if "(" in simplified:
                            args_list.append(f"data{i+1}")
                        elif simplified in ("true", "false"):
                            args_list.append(f"b{i+1}")
                        elif simplified.isdigit():
                            args_list.append(f"num{i+1}")
                        elif simplified.startswith('""'):
                            args_list.append(f"str{i+1}")
                        else:
                            if "." in chunk_clean or ":" in chunk_clean:
                                last_part = re.split(r'[.:]', chunk_clean)[-1]
                                last_part = re.sub(r'[^a-zA-Z0-9_]', '', last_part)
                                if last_part:
                                    args_list.append(last_part)
                                else:
                                    args_list.append(f"arg{i+1}")
                            else:
                                matches = re.findall(r'[a-zA-Z_][a-zA-Z0-9_]*', chunk_clean)
                                if matches:
                                    args_list.append(matches[-1])
                                else:
                                    args_list.append(f"arg{i+1}")

                if doc_buffer or self.include_undocumented:
                    inline_m = re.search(r'(?:--|//)\s*(.*)$', raw_line)
                    inline_comment = inline_m.group(1).strip() if inline_m else ""
                    
                    prev_line = lines[idx - 2].strip() if idx >= 2 else ""
                    prev_comment = ""
                    if prev_line.startswith("--") and not prev_line.startswith("---") and not prev_line.startswith("--[["):
                        prev_comment = prev_line[2:].strip()
                        
                    temp_buffer = list(doc_buffer)
                    if not temp_buffer:
                        if inline_comment:
                            temp_buffer.append(inline_comment)
                        elif prev_comment:
                            temp_buffer.append(prev_comment)

                    try:
                        rel_src = file_path.relative_to(root_dir).as_posix()
                    except ValueError:
                        rel_src = file_path.as_posix()
                        
                    func_doc = self._build_func_from_buffer(hook_name, args_list, temp_buffer, current_realm)
                    
                    for p in func_doc.params:
                        if p.type_name == "any":
                            if p.name in active_params:
                                p.type_name = active_params[p.name].type_name
                                if not p.description and active_params[p.name].description:
                                    p.description = active_params[p.name].description
                            elif p.name in active_locals:
                                p.type_name = active_locals[p.name]
                            else:
                                p.type_name = self.guess_type_by_name(p.name)
                                
                    func_doc.source_file = rel_src
                    func_doc.is_hook = True
                    func_doc.name = hook_name
                    func_doc.short_name = hook_name
                    func_doc.owner_prefix = ""
                    func_doc.sep = ""
                    hooks.append(func_doc)

                doc_buffer.clear()
                continue

            m_func = self.RE_GLOBAL_FUNC.match(code_line)
            if m_func:
                func_name = m_func.group(1) or m_func.group(3)
                
                if func_name.startswith("self.") or func_name.startswith("self:") or func_name == "self":
                    doc_buffer.clear()
                    continue

                raw_args = m_func.group(2) if m_func.group(1) else m_func.group(4)
                args_list = [a.strip() for a in raw_args.split(",") if a.strip()]

                base_table = re.split(r'[.:]', func_name)[0]
                if base_table in local_vars and not doc_buffer:
                    doc_buffer.clear()
                    continue

                if doc_buffer and any(l.startswith("@class") for l in doc_buffer):
                    cls_doc = self._build_class_from_buffer(doc_buffer)
                    if cls_doc:
                        classes.append(cls_doc)

                if doc_buffer or self.include_undocumented:
                    try:
                        rel_src = file_path.relative_to(root_dir).as_posix()
                    except ValueError:
                        rel_src = file_path.as_posix()
                        
                    func_doc = self._build_func_from_buffer(func_name, args_list, doc_buffer, current_realm)
                    func_doc.source_file = rel_src
                    functions.append(func_doc)

                doc_buffer.clear()
                continue

            if doc_buffer and any(l.startswith("@class") for l in doc_buffer):
                cls_doc = self._build_class_from_buffer(doc_buffer)
                if cls_doc:
                    classes.append(cls_doc)
                doc_buffer.clear()
            else:
                doc_buffer.clear()

        if doc_buffer and any(l.startswith("@class") for l in doc_buffer):
            cls_doc = self._build_class_from_buffer(doc_buffer)
            if cls_doc:
                classes.append(cls_doc)

        return mod_name, rel_dir, mod_desc, classes, functions, hooks

    def _build_class_from_buffer(self, buffer: List[str]) -> Optional[ClassDoc]:
        cls_doc = None
        desc_lines = []

        for item in buffer:
            if item.startswith("@class"):
                m = self.RE_CLASS_TAG.match(item)
                if m:
                    cls_doc = ClassDoc(
                        name=m.group(1),
                        parent=m.group(2) or "",
                        description=(m.group(3) or "").strip()
                    )
            elif item.startswith("@field") and cls_doc:
                parts = item.split(maxsplit=1)
                if len(parts) > 1:
                    rest = parts[1]
                    access = "public"
                    if rest.startswith(("public ", "protected ", "private ")):
                        access_parts = rest.split(maxsplit=1)
                        access = access_parts[0]
                        rest = access_parts[1] if len(access_parts) > 1 else ""
                    
                    if rest:
                        name_parts = rest.split(maxsplit=1)
                        fname = name_parts[0]
                        rest2 = name_parts[1] if len(name_parts) > 1 else ""
                        ftype, fdesc = self.extract_emmylua_type_and_rest(rest2)
                        if not ftype: ftype = "any"
                        cls_doc.fields[fname] = FieldDoc(name=fname, type_name=ftype, description=fdesc, access=access)
            elif not item.startswith("@"):
                desc_lines.append(item)

        if cls_doc and desc_lines:
            extra_desc = "\n".join(desc_lines).strip()
            cls_doc.description = f"{cls_doc.description}\n\n{extra_desc}".strip() if cls_doc.description else extra_desc

        return cls_doc

    def _build_func_from_buffer(
        self,
        func_name: str,
        args_list: List[str],
        buffer: List[str],
        default_realm: str
    ) -> FuncDoc:
        desc_lines = []
        params_map: Dict[str, ParamDoc] = {}
        returns: List[ReturnDoc] = []
        examples: List[str] = []
        deprecated = False
        deprecated_msg = ""
        realm = default_realm

        for item in buffer:
            if item.startswith("@param"):
                parts = item.split(maxsplit=2)
                if len(parts) >= 2:
                    raw_pname = parts[1]
                    rest = parts[2] if len(parts) > 2 else ""
                    ptype, pdesc = self.extract_emmylua_type_and_rest(rest)
                    if not ptype: ptype = "any"
                    
                    is_opt = raw_pname.endswith("?") or ptype.endswith("?")
                    pname = raw_pname[:-1] if raw_pname.endswith("?") else raw_pname
                    clean_ptype = ptype[:-1] if ptype.endswith("?") else ptype
                    params_map[pname] = ParamDoc(name=pname, type_name=clean_ptype, description=pdesc, optional=is_opt)
                    
            elif item.startswith("@return"):
                parts = item.split(maxsplit=1)
                if len(parts) > 1:
                    rest = parts[1]
                    rtype, rdesc_full = self.extract_emmylua_type_and_rest(rest)
                    rname = ""
                    rdesc = rdesc_full
                    if rdesc_full:
                        desc_parts = rdesc_full.split(maxsplit=1)
                        if re.match(r'^[a-zA-Z0-9_]+$', desc_parts[0]):
                            rname = desc_parts[0]
                            rdesc = desc_parts[1] if len(desc_parts) > 1 else ""
                    returns.append(ReturnDoc(type_name=rtype, name=rname, description=rdesc))
                    
            elif item.startswith("@deprecated"):
                m = self.RE_DEPRECATED_TAG.match(item)
                deprecated = True
                if m and m.group(1):
                    deprecated_msg = m.group(1).strip()
            elif self.RE_USAGE_TAG.match(item):
                m = self.RE_USAGE_TAG.match(item)
                if m and m.group(1):
                    examples.append(m.group(1).strip())
            elif self.RE_REALM_TAG.match(item):
                m = self.RE_REALM_TAG.match(item)
                tag_type = m.group(1).upper()
                if tag_type == "REALM" and m.group(2):
                    realm = m.group(2).strip().upper()
                else:
                    realm = tag_type
            elif item.startswith("@"):
                continue
            else:
                desc_lines.append(item)

        final_params: List[ParamDoc] = []
        seen_params = set()
        for arg in args_list:
            if arg in params_map:
                final_params.append(params_map[arg])
                seen_params.add(arg)
            else:
                final_params.append(ParamDoc(name=arg, type_name="any", description=""))
                seen_params.add(arg)

        for pname, pdoc in params_map.items():
            if pname not in seen_params:
                final_params.append(pdoc)

        parts = re.split(r'([.:])', func_name)
        short_name = parts[-1]
        sep = parts[-2] if len(parts) >= 3 else ""
        owner_prefix = "".join(parts[:-2]) if len(parts) >= 3 else ""

        return FuncDoc(
            name=func_name,
            short_name=short_name,
            owner_prefix=owner_prefix,
            sep=sep,
            args=args_list,
            description="\n".join(desc_lines).strip(),
            params=final_params,
            returns=returns,
            examples=examples,
            deprecated=deprecated,
            deprecated_msg=deprecated_msg,
            realm=realm,
            is_method=(sep == ":")
        )


def merge_function_docs(existing: FuncDoc, new_fn: FuncDoc) -> FuncDoc:
    if not existing.description and new_fn.description:
        existing.description = new_fn.description

    if existing.realm and new_fn.realm and existing.realm != new_fn.realm:
        existing.realm = "SHARED"

    existing_params_by_name = {p.name: p for p in existing.params}
    for np in new_fn.params:
        if np.name in existing_params_by_name:
            ep = existing_params_by_name[np.name]
            if ep.type_name == "any" and np.type_name != "any":
                ep.type_name = np.type_name
            if not ep.description and np.description:
                ep.description = np.description
            ep.optional = ep.optional or np.optional
        else:
            existing.params.append(np)

    if not existing.returns and new_fn.returns:
        existing.returns = new_fn.returns

    for ex in new_fn.examples:
        if ex not in existing.examples:
            existing.examples.append(ex)

    if new_fn.deprecated:
        existing.deprecated = True
        if not existing.deprecated_msg and new_fn.deprecated_msg:
            existing.deprecated_msg = new_fn.deprecated_msg

    return existing


def _format_type_string(type_name: str) -> str:
    res = re.sub(r'\bfun\(', 'function(', type_name)
    res = res.replace("|", " or ")
    return res


def _ensure_period(text: str) -> str:
    if not text:
        return ""
    text = text.strip()
    if not text:
        return ""
    if text[-1] not in ('.', '!', '?'):
        return text + '.'
    return text


def _format_param_type_gmod(p: ParamDoc) -> str:
    raw_type = _format_type_string(p.type_name)
    if p.optional and not raw_type.endswith("?"):
        return f"{raw_type}?"
    return raw_type


def format_gmod_signature_box(fn: FuncDoc) -> str:
    realm_icons = {
        "SERVER": "🟦",
        "CLIENT": "🟨",
        "SHARED": "🟦🟨",
    }
    icon = realm_icons.get(fn.realm, "🟦🟨")

    if fn.is_hook:
        args_formatted = []
        for p in fn.params:
            args_formatted.append(f"{_format_param_type_gmod(p)} {p.name}")
        inner_args = ", ".join(args_formatted)
        return f"{icon} hook.Add(\"{fn.name}\", \"identifier\", function({inner_args}))"

    ret_prefix = ""
    if fn.returns:
        ret_types = ", ".join(_format_type_string(r.type_name) for r in fn.returns)
        ret_prefix = f"{ret_types} "

    if fn.params:
        args_formatted = []
        for p in fn.params:
            t_str = _format_param_type_gmod(p)
            if p.name == "...":
                args_formatted.append(f"{t_str} ...")
            else:
                args_formatted.append(f"{t_str} {p.name}")
        inner_args = f"{', '.join(args_formatted)}"
    else:
        inner_args = ""

    return f"{icon} {ret_prefix}{fn.name}({inner_args})"


def format_gmod_index_signature_line(fn: FuncDoc, md_filename: str) -> str:
    if fn.is_hook:
        if fn.params:
            args_formatted = [f"{_format_param_type_gmod(p)} {p.name}" for p in fn.params]
            right_code = f"`({', '.join(args_formatted)})`"
        else:
            right_code = "`()`"
        return f"[**`{fn.name}`**]({md_filename}){right_code}"

    ret_prefix = ""
    if fn.returns:
        ret_types = ", ".join(_format_type_string(r.type_name) for r in fn.returns)
        ret_prefix = f"{ret_types} "

    owner_part = f"{fn.owner_prefix}{fn.sep}" if fn.owner_prefix else ""
    left_code = f"`{ret_prefix}{owner_part}`" if (ret_prefix or owner_part) else ""

    if fn.params:
        args_formatted = []
        for p in fn.params:
            t_str = _format_param_type_gmod(p)
            if p.name == "...":
                args_formatted.append(f"{t_str} ...")
            else:
                args_formatted.append(f"{t_str} {p.name}")
        right_code = f"`({', '.join(args_formatted)})`"
    else:
        right_code = "`()`"

    return f"{left_code}[**`{fn.short_name}`**]({md_filename}){right_code}"


def render_function_markdown(fn: FuncDoc, all_files_lines: List[List[str]]) -> str:
    out = [
        "---",
        f"title: {fn.name}",
        "---",
        "",
        "```lua",
        format_gmod_signature_box(fn),
        "```",
        ""
    ]

    if fn.deprecated:
        msg = _ensure_period(fn.deprecated_msg) if fn.deprecated_msg else "This function is deprecated and is not recommended for use."
        out.append(f"> ⚠️ **Deprecated:** {msg}")
        out.append("")

    out.append("## Description")
    out.append("---")
    out.append("")
    out.append(_ensure_period(fn.description) if fn.description else "No description provided.")
    out.append("")

    out.append("## Arguments")
    out.append("---")
    out.append("")
    if fn.params:
        for idx, p in enumerate(fn.params, start=1):
            opt_label = " *(optional)*" if p.optional else ""
            out.append(f"`{idx}` **`{_format_param_type_gmod(p)}`** **{p.name}**{opt_label}  ")
            desc = _ensure_period(p.description) if p.description else "No description provided for this argument."
            out.append(f"&emsp;{desc}")
            out.append("")
    else:
        out.append("*This function does not take any arguments.*")
        out.append("")

    if fn.returns:
        out.append("## Returns")
        out.append("---")
        out.append("")
        for idx, r in enumerate(fn.returns, start=1):
            rname = f" **{r.name}**" if r.name else ""
            out.append(f"`{idx}` **`{_format_type_string(r.type_name)}`**{rname}  ")
            rdesc = _ensure_period(r.description) if r.description else "Return value."
            out.append(f"&emsp;{rdesc}")
            out.append("")

    out.append("## Example")
    out.append("---")
    out.append("")

    if fn.examples:
        example_code = "\n".join(fn.examples)
    else:
        found_call = UsageExampleHelper.find_call_in_codebase(fn, all_files_lines)
        example_code = found_call if found_call else UsageExampleHelper.synthesize_example(fn)

    out.append("```lua")
    out.append(example_code)
    out.append("```")
    out.append("")

    return "\n".join(out)


def render_module_index_markdown(mod: ModuleDoc, func_links: List[Tuple[FuncDoc, str]]) -> str:
    out = [
        "---",
        f"title: {mod.name}",
        "---",
        "",
    ]

    if mod.description:
        out.append(_ensure_period(mod.description))
    else:
        out.append(f"List of all available functions and methods in the `{mod.name}` module.")
    out.append("")

    if mod.classes:
        out.append("## Classes and Structures")
        out.append("---")
        out.append("")
        for cls_name, cls in sorted(mod.classes.items()):
            inh = f" : `{cls.parent}`" if cls.parent else ""
            out.append(f"### `{cls.name}`{inh}")
            out.append("")
            if cls.description:
                out.append(_ensure_period(cls.description))
                out.append("")
            for idx, (_, f) in enumerate(sorted(cls.fields.items()), start=1):
                out.append(f"`{idx}` **`{_format_type_string(f.type_name)}`** **{f.name}** *({f.access})*  ")
                if f.description:
                    out.append(f"&emsp;{_ensure_period(f.description)}")
                out.append("")

    methods = [(fn, fname) for fn, fname in func_links if fn.is_method and not fn.is_hook]
    functions = [(fn, fname) for fn, fname in func_links if not fn.is_method and not fn.is_hook]
    hooks = [(fn, fname) for fn, fname in func_links if fn.is_hook]

    if hooks:
        out.append("## Events & Hooks")
        out.append("---")
        out.append("")
        for fn, fname_md in hooks:
            sig_line = format_gmod_index_signature_line(fn, fname_md)
            short_desc = fn.description.splitlines()[0] if fn.description else "No description provided."
            out.append(f"{sig_line}  ")
            out.append(f"&emsp;{_ensure_period(short_desc)}")
            out.append("")

    if methods:
        out.append("## Methods")
        out.append("---")
        out.append("")
        for fn, fname_md in methods:
            sig_line = format_gmod_index_signature_line(fn, fname_md)
            short_desc = fn.description.splitlines()[0] if fn.description else "No description provided."
            out.append(f"{sig_line}  ")
            out.append(f"&emsp;{_ensure_period(short_desc)}")
            out.append("")

    if functions:
        out.append("## Functions")
        out.append("---")
        out.append("")
        for fn, fname_md in functions:
            sig_line = format_gmod_index_signature_line(fn, fname_md)
            short_desc = fn.description.splitlines()[0] if fn.description else "No description provided."
            out.append(f"{sig_line}  ")
            out.append(f"&emsp;{_ensure_period(short_desc)}")
            out.append("")

    return "\n".join(out)


def generate_docs(src_dir: Path, out_dir: Path, include_undoc: bool = True, gen_nav: bool = False, update_nav: bool = False):
    src_dir = src_dir.resolve()
    ignore_checker = DocIgnoreChecker(src_dir)
    parser = LuaDocParser(include_undocumented=include_undoc)
    modules: Dict[str, ModuleDoc] = {}
    global_hooks: Dict[str, FuncDoc] = {}

    all_lua_files = sorted(src_dir.rglob("*.lua"))
    if not all_lua_files:
        print(f"[!] В папке '{src_dir}' не найдено ни одного .lua файла.")
        return

    lua_files = []
    for f in all_lua_files:
        if out_dir.resolve() in f.resolve().parents:
            continue
        if ignore_checker.should_ignore(f, src_dir):
            print(f"[-] Пропущено по правилам .docignore: {f.relative_to(src_dir)}")
            continue
        lua_files.append(f)

    if not lua_files:
        print(f"[!] Все файлы были отфильтрованы через .docignore.")
        return

    all_files_lines: List[List[str]] = []
    valid_lua_files: List[Tuple[Path, List[str]]] = []
    seen_file_hashes = set()

    for lua_file in lua_files:
        content = lua_file.read_text(encoding="utf-8", errors="replace")
        file_hash = hash(content)
        if file_hash in seen_file_hashes:
            continue
        seen_file_hashes.add(file_hash)

        lines = parser.preprocess_lines(content)
        all_files_lines.append(lines)
        valid_lua_files.append((lua_file, lines))

    for lua_file, lines in valid_lua_files:
        mod_name, rel_dir, mod_desc, classes, functions, file_hooks = parser.parse_file(lua_file, src_dir, lines)

        for hk in file_hooks:
            if hk.name in global_hooks:
                merge_function_docs(global_hooks[hk.name], hk)
            else:
                global_hooks[hk.name] = hk

        if not classes and not functions and not mod_desc:
            continue

        if mod_name not in modules:
            modules[mod_name] = ModuleDoc(name=mod_name, rel_dir=rel_dir, description=mod_desc)
        elif mod_desc and not modules[mod_name].description:
            modules[mod_name].description = mod_desc

        mod_obj = modules[mod_name]

        for cls in classes:
            if cls.name in mod_obj.classes:
                existing_cls = mod_obj.classes[cls.name]
                if cls.description and not existing_cls.description:
                    existing_cls.description = cls.description
                existing_cls.fields.update(cls.fields)
            else:
                mod_obj.classes[cls.name] = cls

        for fn in functions:
            if fn.name in mod_obj.functions:
                merge_function_docs(mod_obj.functions[fn.name], fn)
            else:
                mod_obj.functions[fn.name] = fn

    if global_hooks:
        hooks_mod = ModuleDoc(name="Hooks", rel_dir=Path("Hooks"), description="List of all available custom hooks and events.")
        hooks_mod.functions = global_hooks
        modules["Hooks"] = hooks_mod

    out_dir.mkdir(parents=True, exist_ok=True)
    nav_tree: List[Tuple[str, Path, List[Tuple[str, Path]]]] = []

    for mod_name, mod_obj in sorted(modules.items(), key=lambda x: x[0].lower()):
        safe_mod_folder = mod_name.replace(".", "_").replace("/", "_")
        mod_folder = out_dir / safe_mod_folder
        mod_folder.mkdir(parents=True, exist_ok=True)

        func_links_for_index: List[Tuple[FuncDoc, str]] = []
        mod_nav_items: List[Tuple[str, Path]] = []
        used_filenames: set = set()

        for fn_name, fn in sorted(mod_obj.functions.items(), key=lambda item: item[0].lower()):
            base_fname = re.sub(r'[^a-zA-Z0-9_\-]', '_', fn.short_name)
            if not base_fname or base_fname.lower() == "index":
                base_fname = re.sub(r'[^a-zA-Z0-9_\-]', '_', fn.name)

            candidate = f"{base_fname}.md"
            if candidate.lower() in used_filenames:
                full_safe = re.sub(r'[^a-zA-Z0-9_\-]', '_', fn.name)
                candidate = f"{full_safe}.md"
            used_filenames.add(candidate.lower())

            fn_md_path = mod_folder / candidate
            fn_md_content = render_function_markdown(fn, all_files_lines)
            fn_md_path.write_text(fn_md_content, encoding="utf-8")

            func_links_for_index.append((fn, candidate))
            mod_nav_items.append((fn.short_name, fn_md_path.relative_to(out_dir)))
            
            src_display = f" (из {fn.source_file})" if fn.source_file else ""
            h_mark = "[HOOK] " if fn.is_hook else ""
            print(f"[+] Сгенерирована {h_mark}'{fn.name}' [{fn.realm}]{src_display} -> {fn_md_path}")

        mod_index_path = mod_folder / "index.md"
        mod_index_content = render_module_index_markdown(mod_obj, func_links_for_index)
        mod_index_path.write_text(mod_index_content, encoding="utf-8")
        nav_tree.append((mod_name, mod_index_path.relative_to(out_dir), mod_nav_items))

    root_index_path = out_dir / "index.md"
    if not root_index_path.exists() and nav_tree:
        index_lines = [
            "---",
            "title: Home",
            "---",
            "",
            "# API Documentation",
            ""
        ]
        for mod_name, mod_index_rel, mod_items in nav_tree:
            index_lines.append(f"## [{mod_name}]({mod_index_rel.as_posix()})")
            for fn_title, fn_rel in mod_items:
                index_lines.append(f"- [{fn_title}]({fn_rel.as_posix()})")
            index_lines.append("")
        root_index_path.write_text("\n".join(index_lines), encoding="utf-8")
        print(f"[+] Создана главная страница -> {root_index_path}")

    if nav_tree and (gen_nav or update_nav):
        nav_str_lines = ["nav:", "  - Home: index.md"]
        for mod_name, mod_index_rel, mod_items in nav_tree:
            nav_str_lines.append(f"  - {mod_name}:")
            nav_str_lines.append(f"    - {mod_index_rel.as_posix()}")
            for fn_title, fn_rel in mod_items:
                nav_str_lines.append(f"    - {fn_title}: {fn_rel.as_posix()}")
        
        nav_string = "\n".join(nav_str_lines)

        if gen_nav:
            print("\n--- Скопируйте это в ваш mkdocs.yml ---")
            print(nav_string)
            print("------------------------------------------")

        if update_nav:
            mkdocs_file = Path("mkdocs.yml")
            if not mkdocs_file.exists():
                mkdocs_file = Path(__file__).resolve().parent / "mkdocs.yml"
            
            if mkdocs_file.exists():
                content = mkdocs_file.read_text(encoding="utf-8")
                pattern = re.compile(r'^nav:[ \t]*(?:\n[ \t]+.*)*', re.MULTILINE)
                
                if pattern.search(content):
                    new_content = pattern.sub(nav_string, content)
                    print(f"\n[*] Секция 'nav:' в {mkdocs_file} успешно обновлена!")
                else:
                    new_content = content.rstrip() + "\n\n" + nav_string + "\n"
                    print(f"\n[*] Секция 'nav:' успешно добавлена в конец {mkdocs_file}!")
                
                mkdocs_file.write_text(new_content, encoding="utf-8")
            else:
                print("\n[!] mkdocs.yml не найден. Автоматическое обновление nav невозможно.")


def main():
    arg_parser = argparse.ArgumentParser(
        description="Генератор документации EmmyLua / GLua в стиле Garry's Mod Wiki (пофайлово для MkDocs)."
    )
    arg_parser.add_argument(
        "-s", "--src",
        type=Path,
        default=Path("."),
        help="Папка для поиска .lua файлов (по умолчанию: '.')"
    )
    arg_parser.add_argument(
        "-o", "--out",
        type=Path,
        default=Path("docs"),
        help="Папка для сохранения .md документации (по умолчанию: 'docs/')"
    )
    arg_parser.add_argument(
        "--only-annotated",
        action="store_true",
        help="Игнорировать функции без аннотаций ---"
    )
    arg_parser.add_argument(
        "--print-nav",
        action="store_true",
        help="Вывести в консоль готовую секцию 'nav:' для mkdocs.yml"
    )
    arg_parser.add_argument(
        "--update-nav",
        action="store_true",
        help="Автоматически найти mkdocs.yml и обновить в нём секцию nav:"
    )

    args = arg_parser.parse_args()
    generate_docs(
        src_dir=args.src,
        out_dir=args.out,
        include_undoc=not args.only_annotated,
        gen_nav=args.print_nav,
        update_nav=args.update_nav
    )


if __name__ == "__main__":
    main()
