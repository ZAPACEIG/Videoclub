# videoclub — TDD Implementation Plan

## 1. Phase 1 Status

Phase 1 is planning-only. No functional AL implementation is authorized in this phase.

## 2. Context Read

The conductor reviewed these inputs before planning:

- `.github/plans/memory.md`
- `.github/plans/functional.md`
- `.github/plans/architecture.md`
- `.github/plans/videoclub/videoclub.spec.md`
- `.github/agents/al-conductor.agent.md`
- `aldc.yaml`
- `app.json`
- Current initialized AL project structure

## 3. BCQuality Decision

`aldc.yaml` sets `external.bcquality.enabled` to `auto` and points to `../bcquality/skills/entry.md`. The entry point is not present in this workspace, so BCQuality is treated as not available for this run. Per the configured fallback, review phases must use native skills-mode review with residual checklist A-G, record BCQuality as not-applicable, and must not block solely because the external BCQuality knowledge base is absent.

## 4. Project Structure Observation

The repository currently contains the AL manifest `app.json` and ALDC planning/tooling files. No `.al` source objects were found in the project at Phase 1 planning time. The manifest defines app name `Videoclub`, publisher `ZAPACEIG`, runtime `15.0`, target `Cloud`, application/platform `26.0.0.0`, and ID range `50100..50149`.

## 5. Global Gates

- Do not download symbols.
- Do not run `AL: Download Symbols`.
- Do not publish.
- Do not connect to any Business Central environment.
- Do not claim compilation unless compilation has actually been run.
- Do not invent standard Business Central event subscribers or signatures.
- If a subscriber/signature requires symbols, keep it as pending/open question.
- Do not modify ALDC templates.
- Treat `.github/plans/memory.md` as append-only.
- Stop after Phase 1 until explicit human approval.

## 6. Phase Plan

### Phase 1 — Planning, Test Strategy and Structure Baseline

| Item | Detail |
|---|---|
| Functional objective | Establish the implementation contract, test strategy, phase gates and project baseline without writing functional AL code. |
| AL objects to create/modify | None. Documentation only: `videoclub-plan.md`, `videoclub.test-plan.md`, `videoclub-phase-1-complete.md`. |
| RED tests expected | Artifact checks fail before this phase because `videoclub.test-plan.md` and `videoclub-plan.md` do not exist. |
| GREEN implementation minimum | Create planning/test-plan/phase-complete documents and record BCQuality decision. |
| Technical risks | Existing scaffold appears manifest-only from static file scan; spec lists many objects but no AL objects currently exist. |
| Dependencies | Existing functional, architecture and spec documents. |
| Validations possible without symbols | File existence, ID range in `app.json`, no `.al` object conflicts detected, no symbol/publish commands run. |
| Validations pending with symbols | None for documentation; future compile/test validation requires symbols. |

### Phase 2 — Foundation / Setup / App Structure Validation

| Item | Detail |
|---|---|
| Functional objective | Create the minimum AL project structure and test foundation needed for subsequent TDD slices. |
| AL objects to create/modify | Test helper codeunit 50142 `Library - VC Videoclub`; initial test codeunit shell 50143 `VC Rental Tests`; folder structure for app/test objects; no TMDB live HTTP. |
| RED tests expected | Helper/test procedures reference catalog/rental objects not yet implemented and therefore are expected to fail static/compile validation once compilation is available. |
| GREEN implementation minimum | Establish minimal test object skeletons and any required common labels/helpers without business logic beyond fixture intent. |
| Technical risks | AL test framework dependencies and exact test library availability require symbols. |
| Dependencies | Phase 1 approval and `app.json` ID range. |
| Validations possible without symbols | File naming, object IDs, object names, no standard subscriber signatures. |
| Validations pending with symbols | Compile test objects and verify test framework references. |

### Phase 3 — Catalog: Genres, Actors, Movies and Item Extension

| Item | Detail |
|---|---|
| Functional objective | Enable maintaining movie metadata, genres, actors and cast relationships. |
| AL objects to create/modify | TableExtension 50100 `VC Item Ext`; tables 50101 `VC Genre`, 50102 `VC Actor`, 50103 `VC Movie Cast`; pages 50112-50118 as needed by slice; codeunit 50131 `VC Movie Mgt`; catalog fixture tests in 50142/50143. |
| RED tests expected | Creating a rentable movie fixture, assigning genres and adding cast fail until fields/tables exist. |
| GREEN implementation minimum | Required fields/PKs/table relations, basic validations for title/rentable movie, minimal list/card/listpart pages. |
| Technical risks | TableRelation filters to extended Item fields require compiler verification; title maps to Item Description unless otherwise approved. |
| Dependencies | Phase 2 test structure. |
| Validations possible without symbols | Object ID/name consistency; field inventory against spec; no base-object modifications. |
| Validations pending with symbols | Compile table extension relations/pages and run catalog tests. |

### Phase 4 — Availability and Minimal Rental Logic

| Item | Detail |
|---|---|
| Functional objective | Calculate functional copies available for rental and prevent over-rental. |
| AL objects to create/modify | Codeunit 50132 `VC Availability Mgt`; supporting parts of tables 50104/50105 if not already present; availability tests in 50143. |
| RED tests expected | `GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies` and `GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding` fail before code exists. |
| GREEN implementation minimum | `GetRentedQuantity`, `GetAvailableQuantity`, `AssertAvailable` using rental copies minus outstanding registered lines; publish only own IntegrationEvents from spec. |
| Technical risks | Concurrency/locking strategy cannot be fully validated without runtime; FlowField vs calculated field decision must match spec. |
| Dependencies | Catalog movie fields and initial rental line structure. |
| Validations possible without symbols | Static review of formulas and event declarations. |
| Validations pending with symbols | Compile CalcSums/filters, execute availability tests, validate locking behavior if added. |

### Phase 5 — Rental Header/Lines and Registration

| Item | Detail |
|---|---|
| Functional objective | Register rentals with customer, line, rentable and availability validations. |
| AL objects to create/modify | Enums 50108/50109; tables 50104/50105; codeunits 50133 `VC Rental Validation`, 50134 `VC Rental Status Mgt`, 50135 `VC Rental Mgt`, optional 50136 `VC No Series Mgt`; tests in 50143. |
| RED tests expected | Missing customer, no lines, non-rentable movie, insufficient copies and valid draft registration tests fail until logic exists. |
| GREEN implementation minimum | Draft-to-Registered flow, line Outstanding status, controlled errors, copied customer/movie descriptions, date validations. |
| Technical risks | No. Series API signatures and test setup may require symbols; if unavailable, defer exact integration and use explicit test numbers temporarily only if approved. |
| Dependencies | Phases 3-4. |
| Validations possible without symbols | Static review of status transitions and no invented base subscribers. |
| Validations pending with symbols | Compile No. Series usage and execute registration tests. |

### Phase 6 — Returns, Partial Returns and Overdue Handling

| Item | Detail |
|---|---|
| Functional objective | Register partial/full returns and expose overdue rentals according to approved overdue strategy. |
| AL objects to create/modify | Extend codeunits 50133-50135 and 50134; tables 50104/50105 fields for returned/outstanding/date status; tests in 50143. |
| RED tests expected | Partial return, full return, excess quantity, duplicate return and overdue tests fail until return logic exists. |
| GREEN implementation minimum | `RegisterLineReturn` and `RegisterReturn` update returned quantities, last return dates and header/line statuses; overdue is persisted only if approved, otherwise calculated dynamically in pages/queries. |
| Technical risks | Open question: persisted vs dynamic overdue. Date behavior depends on WorkDate/runtime. |
| Dependencies | Phase 5 registration. |
| Validations possible without symbols | Static status transition matrix review. |
| Validations pending with symbols | Execute return/overdue tests and validate page filters. |

### Phase 7 — Pages and Navigation

| Item | Detail |
|---|---|
| Functional objective | Provide user access to catalog, rentals, open/overdue rentals and customer/item navigation. |
| AL objects to create/modify | Pages 50116-50123; pageextensions 50126-50129; Role Center extension 50130 remains pending until target page is approved; actions call codeunits only. |
| RED tests expected | Page/action review fails because user workflows are not exposed. |
| GREEN implementation minimum | Minimal list/card/document/listpart pages with fields/actions from spec; customer/item navigation actions; no Role Center extension unless base page decision is closed. |
| Technical risks | Page extension anchors/action areas and Role Center target require symbols and user decision. |
| Dependencies | Catalog and rental objects. |
| Validations possible without symbols | Static page/action source review and no environment connection. |
| Validations pending with symbols | Compile page layouts/actions and manual UI validation. |

### Phase 8 — Permissions

| Item | Detail |
|---|---|
| Functional objective | Enforce functional roles for read, operator and admin profiles. |
| AL objects to create/modify | PermissionSets 50145 `VC VIDEOCLUB BASE`, 50146 `VC VIDEOCLUB READ`, 50147 `VC VIDEOCLUB USER`, 50148 `VC VIDEOCLUB ADMIN`; permission review checklist/tests. |
| RED tests expected | Permission matrix review fails before permission sets exist. |
| GREEN implementation minimum | Permission sets matching spec matrix, with setup restricted to admin and rental operations available to user/admin. |
| Technical risks | Exact indirect/codeunit permissions and permission test automation require environment. |
| Dependencies | All data/code/page objects needing permissions. |
| Validations possible without symbols | Static permission matrix comparison. |
| Validations pending with symbols | Compile permissions and execute/perform role-based checks. |

### Phase 9 — TMDB Integration as Separate Gated Slice

| Item | Detail |
|---|---|
| Functional objective | Add TMDB setup, logging and fakeable import/mapping boundaries without requiring a live TMDB connection during tests. |
| AL objects to create/modify | Tables 50106/50107; enums 50110/50111; pages 50124/50125; codeunits 50137-50141; tests 50144. |
| RED tests expected | TMDB disabled/search/map/apply tests fail until setup/log/mapper/import shells exist. |
| GREEN implementation minimum | Setup validation, local/fake payload mapping, import application rules, log/error handling, own IntegrationEvents. Live HTTP remains behind setup and explicit future validation. |
| Technical risks | Secret storage mechanism, overwrite confirmation policy and possible buffer table remain open. No real HTTP tests without approved environment/credentials. |
| Dependencies | Catalog objects and human decisions for secrets/overwrite/buffer. |
| Validations possible without symbols | Static review of no secret exposure, no live calls in tests, event publisher declarations. |
| Validations pending with symbols | Compile HttpClient code, execute fake mapper/import tests, validate setup page masking. |

## 7. Open Questions Blocking or Constraining Later Phases

1. Confirm final Business Central runtime/application target from `app.json`.
2. Confirm whether `50100..50149` remains the final object range.
3. Decide secure TMDB credential mechanism.
4. Decide persisted vs dynamic overdue status.
5. Decide poster storage: URL, Media or Blob.
6. Confirm Decimal with `DecimalPlaces = 0:0` vs Integer for rental copies/quantities.
7. Confirm Role Center page to extend.
8. Confirm delete policy for registered rental documents.
9. Decide whether a temporary TMDB result/buffer table is required.
10. Keep all standard BC event subscribers pending until symbols are available.

## 8. Phase 1 Stop

The conductor must stop here and wait for explicit human approval before starting Phase 2. No functional AL code should be written until that approval is received.
