## Phase 8 Complete: Permissions

Phase 8 implements the Videoclub least-privilege permission model for the currently delivered AL objects. The slice creates the READ, USER and ADMIN role layers on top of the existing non-assignable BASE layer, restricts TMDB setup access to administrators, grants rental operations to USER/ADMIN, and keeps READ limited to consultation.

**Review executed:** Static AL permission matrix review was executed locally without compiling, downloading symbols, publishing, or connecting to Business Central.

**Review findings:** No blockers were found by the static matrix check. Runtime permission behavior remains pending for a Business Central test environment with symbols.

**BCQuality decision used:** BCQuality auto was not invoked for this slice; native static validation was used because Phase 8 can be checked by source inspection and must not connect to Business Central.

**Final Phase Status:** APPROVED for source-level Phase 8 closure; pending compile/runtime validation with symbols.

## Scope Boundaries Observed

- No symbols were downloaded.
- No package was published.
- No Business Central environment was contacted.
- No TMDB HTTP implementation, live TMDB call, or TMDB codeunit implementation was added.
- No Phase 9 integration logic was implemented.
- Changes are limited to Phase 8 permission sets, a static permission matrix validator, and this completion checkpoint.

## Permission Model Implemented

| Permission set | ID | Assignable | Functional role |
|---|---:|---|---|
| `VC VIDEOCLUB BASE` | 50145 | No | Shared consultation layer included by all assignable roles. |
| `VC VIDEOCLUB READ` | 50146 | Yes | Read-only consultation for catalog, actors, genres, rental documents and TMDB import log. |
| `VC VIDEOCLUB USER` | 50147 | Yes | Daily operator role for maintaining movie metadata, actors/cast and rental/return operations without delete or setup permissions. |
| `VC VIDEOCLUB ADMIN` | 50148 | Yes | Administrator role with controlled delete/full maintenance, TMDB setup access and setup page execution. |

## Effective Permission Matrix

| Object/Data | READ | USER | ADMIN | Notes |
|---|---|---|---|---|
| `Item` / VC movie fields | R | RIM | RIMD | Movie catalog maintenance is available to USER; delete is ADMIN-only. |
| `VC Genre` | R | R | RIMD | Genre maintenance is ADMIN-only. |
| `VC Actor` | R | RIM | RIMD | USER can maintain actor data; delete is ADMIN-only. |
| `VC Movie Cast` | R | RIM | RIMD | USER can maintain cast data; delete is ADMIN-only. |
| `VC Rental Header` | R | RIM | RIMD | USER can create/update rental documents; delete is ADMIN-only and still subject to business logic. |
| `VC Rental Line` | R | RIM | RIMD | USER can create/update rental lines; delete is ADMIN-only and still subject to business logic. |
| `VC TMDB Setup` | — | — | RIMD | Setup/secrets are ADMIN-only for this Phase 8 slice. |
| `VC TMDB Import Log` | R | R | RIMD | Existing Phase 8 objects do not include TMDB logging codeunits, so USER remains read-only until Phase 9 adds indirect log writers. |
| Rental/catalog codeunits | — | X | X | USER and ADMIN can execute rental/catalog workflows. |
| Consultation pages | X | X | X | Page execution is inherited from BASE for catalog and rental consultation pages. |
| `VC TMDB Setup Card` | — | — | X | ADMIN-only setup UI. |

## AL Objects Created/Modified

- PermissionSet 50145 `VC VIDEOCLUB BASE`
- PermissionSet 50146 `VC VIDEOCLUB READ`
- PermissionSet 50147 `VC VIDEOCLUB USER`
- PermissionSet 50148 `VC VIDEOCLUB ADMIN`

## Files Created/Changed

- `/src/Videoclub/Permissions/VCVideoclubBase.PermissionSet.al` — Updated non-assignable base permission layer to read delivered domain data and execute delivered consultation pages.
- `/src/Videoclub/Permissions/VCVideoclubRead.PermissionSet.al` — Added assignable READ role that includes BASE and grants no write permissions.
- `/src/Videoclub/Permissions/VCVideoclubUser.PermissionSet.al` — Added assignable USER role for movie metadata, actor/cast and rental operations without delete/setup permissions.
- `/src/Videoclub/Permissions/VCVideoclubAdmin.PermissionSet.al` — Added assignable ADMIN role for full functional maintenance plus TMDB setup page/data access.
- `/tools/videoclub/validate_permissions.py` — Added static source-only permission matrix validation for effective READ/USER/ADMIN permissions.
- `/.github/plans/videoclub/videoclub-phase-8-complete.md` — Added Phase 8 completion checkpoint.

## Static Matrix Review

The validator parses `*.PermissionSet.al` files, follows `IncludedPermissionSets`, computes effective permissions and validates:

1. `VC VIDEOCLUB BASE` is not assignable.
2. `VC VIDEOCLUB READ`, `VC VIDEOCLUB USER` and `VC VIDEOCLUB ADMIN` are assignable.
3. READ effective table data permissions are read-only.
4. USER effective permissions exclude delete and TMDB setup access.
5. ADMIN effective permissions include full functional maintenance and TMDB setup page/data access.

## Validation Notes

- Static source validation was performed only.
- AL compilation was intentionally not run because this slice must not download symbols or connect to Business Central.
- Runtime restrictive permission tests remain pending for an environment with symbols and the Business Central test framework.

## Suggested Commit Message

```text
feat: implement phase 8 videoclub permissions
```

## Required Closure Fields

| Field | Phase 8 Result |
|---|---|
| Objective | Enforce functional roles for read, operator and admin profiles. |
| Tests created or modified | No AL tests were added; a static permission matrix validator was added at `tools/videoclub/validate_permissions.py`. |
| Expected RED result | Before this phase, the matrix review failed because only the BASE permission set existed and assignable READ/USER/ADMIN roles were missing. |
| GREEN implementation performed | Implemented PermissionSets 50145-50148, role hierarchy, setup/TMDB admin restriction, rental operations for USER/ADMIN and static matrix validation. |
| AL objects created/modified | PermissionSets 50145 `VC VIDEOCLUB BASE`, 50146 `VC VIDEOCLUB READ`, 50147 `VC VIDEOCLUB USER`, 50148 `VC VIDEOCLUB ADMIN`. |
| Review executed | Static permission matrix review using `python3 tools/videoclub/validate_permissions.py`. |
| Review findings | Static matrix check passed; no blockers found in source-level permission model. |
| BCQuality decision used | Not invoked; native source-only validation used for this no-symbol/no-BC slice. |
| Validations performed without symbols | Permission set inventory, assignable flag check, included-permission hierarchy check and effective permission matrix comparison. |
| Validations pending with symbols | AL compilation, permission set metadata validation in BC, and restrictive role-based runtime tests. |
| No publish/BC connection confirmation | No package was published and no Business Central environment was contacted. |
| Final phase state | APPROVED for Phase 8 source completion. |
