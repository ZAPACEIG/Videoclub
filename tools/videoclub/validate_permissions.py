#!/usr/bin/env python3
"""Static permission matrix validation for Videoclub Phase 8.

This check intentionally avoids AL compilation, symbol download, publishing, and
Business Central connections. It parses the AL PermissionSet files and validates
that the effective READ/USER/ADMIN matrix matches the approved Phase 8 slice.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PERMISSIONS_DIR = ROOT / "src" / "Videoclub" / "Permissions"

EXPECTED = {
    "VC VIDEOCLUB READ": {
        "tabledata Item": "R",
        'tabledata "VC Genre"': "R",
        'tabledata "VC Actor"': "R",
        'tabledata "VC Movie Cast"': "R",
        'tabledata "VC Rental Header"': "R",
        'tabledata "VC Rental Line"': "R",
        'tabledata "VC TMDB Import Log"': "R",
    },
    "VC VIDEOCLUB USER": {
        "tabledata Item": "RIM",
        'tabledata "VC Genre"': "R",
        'tabledata "VC Actor"': "RIM",
        'tabledata "VC Movie Cast"': "RIM",
        'tabledata "VC Rental Header"': "RIM",
        'tabledata "VC Rental Line"': "RIM",
        'tabledata "VC TMDB Import Log"': "R",
        'codeunit "VC Movie Mgt"': "X",
        'codeunit "VC Availability Mgt"': "X",
        'codeunit "VC Rental Validation"': "X",
        'codeunit "VC Rental Status Mgt"': "X",
        'codeunit "VC Rental Mgt"': "X",
    },
    "VC VIDEOCLUB ADMIN": {
        "tabledata Item": "RIMD",
        'tabledata "VC Genre"': "RIMD",
        'tabledata "VC Actor"': "RIMD",
        'tabledata "VC Movie Cast"': "RIMD",
        'tabledata "VC Rental Header"': "RIMD",
        'tabledata "VC Rental Line"': "RIMD",
        'tabledata "VC TMDB Setup"': "RIMD",
        'tabledata "VC TMDB Import Log"': "RIMD",
        'codeunit "VC Movie Mgt"': "X",
        'codeunit "VC Availability Mgt"': "X",
        'codeunit "VC Rental Validation"': "X",
        'codeunit "VC Rental Status Mgt"': "X",
        'codeunit "VC Rental Mgt"': "X",
        'page "VC TMDB Setup Card"': "X",
    },
}

FORBIDDEN = {
    "VC VIDEOCLUB READ": {
        'tabledata "VC TMDB Setup"',
        'page "VC TMDB Setup Card"',
        'codeunit "VC Movie Mgt"',
        'codeunit "VC Availability Mgt"',
        'codeunit "VC Rental Validation"',
        'codeunit "VC Rental Status Mgt"',
        'codeunit "VC Rental Mgt"',
    },
    "VC VIDEOCLUB USER": {
        'tabledata "VC TMDB Setup"',
        'page "VC TMDB Setup Card"',
    },
}

NO_DELETE_ROLES = {"VC VIDEOCLUB READ", "VC VIDEOCLUB USER"}

ASSIGNABLE = {
    "VC VIDEOCLUB BASE": "false",
    "VC VIDEOCLUB READ": "true",
    "VC VIDEOCLUB USER": "true",
    "VC VIDEOCLUB ADMIN": "true",
}

PERMISSION_RE = re.compile(r'^\s*((?:tabledata|codeunit|page)\s+(?:"[^"]+"|\w+))\s*=\s*([RIMDX]+)\s*[,;]', re.MULTILINE)
INCLUDED_RE = re.compile(r'IncludedPermissionSets\s*=\s*"([^"]+)"\s*;', re.MULTILINE)
ASSIGNABLE_RE = re.compile(r'Assignable\s*=\s*(true|false)\s*;', re.IGNORECASE)
OBJECT_RE = re.compile(r'permissionset\s+\d+\s+"([^"]+)"', re.IGNORECASE)


def permission_union(left: str, right: str) -> str:
    if "X" in left or "X" in right:
        return "X"
    order = "RIMD"
    return "".join(letter for letter in order if letter in set(left + right))


def parse_permission_sets() -> dict[str, dict[str, object]]:
    permission_sets: dict[str, dict[str, object]] = {}
    for path in sorted(PERMISSIONS_DIR.glob("*.PermissionSet.al")):
        text = path.read_text(encoding="utf-8")
        object_match = OBJECT_RE.search(text)
        if not object_match:
            continue
        name = object_match.group(1)
        assignable_match = ASSIGNABLE_RE.search(text)
        permission_sets[name] = {
            "path": path,
            "assignable": assignable_match.group(1).lower() if assignable_match else None,
            "included": INCLUDED_RE.findall(text),
            "permissions": {object_name: level for object_name, level in PERMISSION_RE.findall(text)},
        }
    return permission_sets


def effective_permissions(name: str, permission_sets: dict[str, dict[str, object]], stack: tuple[str, ...] = ()) -> dict[str, str]:
    if name in stack:
        raise ValueError(f"Cyclic IncludedPermissionSets chain: {' -> '.join(stack + (name,))}")
    if name not in permission_sets:
        raise ValueError(f"Missing permission set: {name}")

    result: dict[str, str] = {}
    for included in permission_sets[name]["included"]:  # type: ignore[index]
        for object_name, level in effective_permissions(included, permission_sets, stack + (name,)).items():
            result[object_name] = permission_union(result.get(object_name, ""), level)

    for object_name, level in permission_sets[name]["permissions"].items():  # type: ignore[index]
        result[object_name] = permission_union(result.get(object_name, ""), level)
    return result


def main() -> int:
    permission_sets = parse_permission_sets()
    errors: list[str] = []

    for name, assignable in ASSIGNABLE.items():
        if name not in permission_sets:
            errors.append(f"Missing {name}")
            continue
        if permission_sets[name]["assignable"] != assignable:
            errors.append(f"{name} Assignable expected {assignable}, got {permission_sets[name]['assignable']}")

    for name, expected_permissions in EXPECTED.items():
        try:
            effective = effective_permissions(name, permission_sets)
        except ValueError as exc:
            errors.append(str(exc))
            continue
        for object_name, expected_level in expected_permissions.items():
            actual_level = effective.get(object_name)
            if actual_level != expected_level:
                errors.append(f"{name}: {object_name} expected {expected_level}, got {actual_level or 'none'}")
        for object_name in FORBIDDEN.get(name, set()):
            if object_name in effective:
                errors.append(f"{name}: forbidden permission present for {object_name}")
        if name in NO_DELETE_ROLES:
            for object_name, actual_level in effective.items():
                if object_name.startswith("tabledata ") and "D" in actual_level:
                    errors.append(f"{name}: delete permission is not allowed for {object_name}")

    if errors:
        print("Permission matrix validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print("Permission matrix validation passed for READ, USER, and ADMIN effective permissions.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
