## Phase 9 Complete: TMDB Integration as Separate Gated Slice (Review Correction)

Phase 9 delivers a source-only TMDB integration slice that is safe by default. It adds setup validation, structured import logging, local JSON mapping/import into movie items, genres, actors and cast, plus fakeable AL tests; live TMDB HTTP remains gated behind a placeholder and is not executed by tests.

**Review executed:** Static source review and local repository checks were executed without compiling, downloading symbols, publishing, connecting to Business Central, or calling TMDB.

**Review findings:** Initial Phase 9 review returned NEEDS_REVISION. The correction adds read-only page 50125 `VC TMDB Import Log`, grants ADMIN execute permission for that page, adds minimal TMDB IntegrationEvent publishers around import/apply/log processing, and documents URL literals as configuration/mapping constants rather than live calls. Runtime AL compilation and test execution remain pending for a Business Central environment with symbols.

**BCQuality decision used:** BCQuality auto was not invoked; native source-only validation was used because this slice explicitly prohibits symbol downloads, publishing, BC connections and live TMDB calls.

**Final Phase Status:** APPROVED after AL Code Review Subagent re-review; compile/runtime validation with symbols remains pending.

## Scope Boundaries Observed

- No symbols were downloaded.
- No package was published.
- No Business Central environment was contacted.
- No live HTTP call against TMDB was implemented or executed.
- No real secrets were stored; setup stores only an API key reference field.
- Changes are limited to the Phase 9 TMDB setup/log/import/client slice, read-only import log page, fakeable tests, permissions for the new codeunits/page, event publishers, and this completion checkpoint.

## TMDB Slice Implemented

| Area | Delivered behavior |
|---|---|
| Setup | Default setup bootstrap with disabled live integration, base URL, language code and validation that requires a credential reference only when enabled. |
| Logging | Centralized success/warning/error log writer for `VC TMDB Import Log`, with read-only list page 50125 for review and operations visibility. |
| Mapper | Local JSON payload parser for movie fields, genres and nested credits/cast arrays; poster URL literal is documented as a mapping constant only, not a fetch/live call. |
| Import | Applies local fake payloads to Item movie metadata, upserts genres/actors, replaces cast for the imported movie and writes an import log. |
| Live client | Safe placeholder validates the gate and then errors; no HTTP client or TMDB request is executed. The setup base URL literal is a configuration default only. |
| Tests | Test codeunit 50144 now covers setup defaults, setup secret validation, local payload import, controlled empty payload errors and live gate blocking. |

## AL Objects Created/Modified

- Table 50106 `VC TMDB Setup` — added insert/modify validation triggers.
- Table 50107 `VC TMDB Import Log` — added created-at stamping.
- Enum 50110 `VC TMDB Operation` — reused for import logging.
- Enum 50111 `VC Integration Status` — reused for success/error logging.
- Page 50124 `VC TMDB Setup Card` — added safe validation action and default setup bootstrap.
- Page 50125 `VC TMDB Import Log` — added read-only list page over the TMDB import log table.
- Codeunit 50137 `VC TMDB Log Mgt` — new structured log writer with `OnBeforeInsertLog` and `OnAfterInsertLog` IntegrationEvent publishers.
- Codeunit 50138 `VC TMDB Setup Mgt` — new setup bootstrap and live-gate validation.
- Codeunit 50139 `VC TMDB Mapper` — new local JSON mapper; poster URL literal documented as mapping-only.
- Codeunit 50140 `VC TMDB Import Mgt` — new local payload import/apply service with `OnBeforeImportMoviePayload`, `OnAfterImportMoviePayload`, `OnBeforeApplyMoviePayload` and `OnAfterApplyMoviePayload` IntegrationEvent publishers.
- Codeunit 50141 `VC TMDB Client` — new gated live placeholder.
- Codeunit 50142 `Library - VC Videoclub` — added TMDB import log cleanup for test fixtures.
- Codeunit 50144 `VC TMDB Tests` — replaced placeholder with fakeable TMDB tests.
- PermissionSet 50148 `VC VIDEOCLUB ADMIN` — added execute permissions for TMDB codeunits and page 50125.

## Files Created/Changed

- `/src/Videoclub/TMDB/VCTMDBLogMgt.Codeunit.al` — Structured TMDB import logging helper with before/after log publishers.
- `/src/Videoclub/TMDB/VCTMDBSetupMgt.Codeunit.al` — Setup defaults and validation gate; base URL literal documented as configuration-only.
- `/src/Videoclub/TMDB/VCTMDBMapper.Codeunit.al` — Local/fake JSON mapping helpers; poster URL literal documented as mapping-only.
- `/src/Videoclub/TMDB/VCTMDBImportMgt.Codeunit.al` — Local payload import/apply service with before/after import/apply publishers.
- `/src/Videoclub/TMDB/VCTMDBClient.Codeunit.al` — Safe live placeholder.
- `/src/Videoclub/TMDB/VCTMDBSetup.Table.al` — Setup validation triggers.
- `/src/Videoclub/TMDB/VCTMDBImportLog.Table.al` — Log timestamp trigger.
- `/src/Videoclub/TMDB/VCTMDBSetupCard.Page.al` — Safe setup validation UI action.
- `/src/Videoclub/TMDB/VCTMDBImportLogList.Page.al` — Read-only TMDB import log list page 50125.
- `/src/Videoclub/Permissions/VCVideoclubAdmin.PermissionSet.al` — Execute permissions for Phase 9 codeunits and page 50125.
- `/test/Videoclub/Tests/LibraryVCVideoclub.Codeunit.al` — Test fixture cleanup for TMDB import logs.
- `/test/Videoclub/Tests/VCTMDBTests.Codeunit.al` — Fakeable local payload tests.
- `/.github/plans/videoclub/videoclub-phase-9-complete.md` — Phase 9 completion checkpoint.

## Functions Created/Changed

- `LogSuccess`, `LogWarning`, `LogError`, `OnBeforeInsertLog`, `OnAfterInsertLog` in `VC TMDB Log Mgt`.
- `EnsureDefaultSetup`, `ValidateSetup`, `EnsureCanUseLive` in `VC TMDB Setup Mgt`.
- `ReadPayload`, `GetMovieId`, `GetTitle`, `GetReleaseYear`, `TryGetArray`, `TryGetNestedArray` and mapping accessors in `VC TMDB Mapper`.
- `ImportMoviePayload`, `ApplyMovieFields`, `ApplyGenres`, `ApplyCast`, `UpsertGenre`, `UpsertActor`, `InsertCastLine`, `OnBeforeImportMoviePayload`, `OnAfterImportMoviePayload`, `OnBeforeApplyMoviePayload`, `OnAfterApplyMoviePayload` in `VC TMDB Import Mgt`.
- `GetMovieDetails` in `VC TMDB Client`.
- `ValidateSetup` action on `VC TMDB Setup Card`.
- `Initialize` in `Library - VC Videoclub`.

## Tests Created/Changed

- Codeunit 50144 `VC TMDB Tests`.
- `GivenDefaultSetup_WhenValidate_ThenSafeDefaultsAreAccepted`.
- `GivenEnabledSetupWithoutSecret_WhenValidate_ThenError`.
- `GivenLocalPayload_WhenImport_ThenMovieGenresActorsCastAndLogAreApplied`.
- `GivenEmptyPayload_WhenImport_ThenControlledError`.
- `GivenLiveClient_WhenCalled_ThenSafeGateBlocksBeforeHttp`.

## Static Review

The local review verified that Phase 9 adds codeunits 50137-50141, page 50125, IntegrationEvent publishers in TMDB import/log management, retains the live client as a gated placeholder, keeps tests on local fake JSON payloads, documents URL literals as configuration/mapping constants, and does not introduce `HttpClient`, TMDB network calls, symbol download commands, publish commands or real secrets.

## Validation Notes

- Static source validation was performed only.
- AL compilation was intentionally not run because this slice must not download symbols or connect to Business Central.
- Runtime tests remain pending for an approved Business Central test environment with symbols.

## Suggested Commit Message

```text
fix: address tmdb phase 9 review findings
```

## Required Closure Fields

| Field | Phase 9 Result |
|---|---|
| Objective | Implement TMDB setup/log/local mapper/import/client scaffolding as a separate gated slice with fakeable tests. |
| Tests created or modified | `test/Videoclub/Tests/VCTMDBTests.Codeunit.al` and fixture cleanup in `test/Videoclub/Tests/LibraryVCVideoclub.Codeunit.al`. |
| Expected RED result | Before this phase, `VC TMDB Tests` only contained a placeholder and no local payload import, setup validation, logging or live-gate behavior existed. |
| GREEN implementation performed | Added codeunits 50137-50141, setup validation triggers/UI action, log timestamping, page 50125, ADMIN page permission, local JSON mapper/import into Item/genres/actors/cast, IntegrationEvent publishers, URL-literal documentation and fakeable tests. |
| AL objects created/modified | Tables 50106/50107, enums 50110/50111, pages 50124/50125, codeunits 50137-50142/50144, permission set 50148. |
| Review executed | Static source review plus AL Code Review Subagent re-review using repository commands only. |
| Review findings | Initial NEEDS_REVISION findings corrected; re-review findings: no blockers, no majors, no minors. Page 50125 exists, ADMIN can execute it, TMDB IntegrationEvent publishers exist, URL literals are documented as non-live constants, and no live HTTP/real secrets/publish/BC connection/symbol download were introduced. |
| BCQuality decision used | Not invoked; native source-only validation used for this no-symbol/no-BC/no-live-HTTP slice. |
| Validations performed without symbols | Object inventory, local fake payload tests by source inspection, live-gate inspection and forbidden live HTTP command/source scan. |
| Validations pending with symbols | AL compilation, Business Central test runner execution, permission metadata validation and runtime UI validation. |
| No publish/BC connection confirmation | No package was published and no Business Central environment was contacted. |
| Final phase state | APPROVED. |
