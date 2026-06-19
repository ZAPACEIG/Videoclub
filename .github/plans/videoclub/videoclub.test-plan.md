# videoclub — Test Plan

## 1. Scope and Contract

This test plan supports the TDD implementation of the `videoclub` requirement and is governed by:

- `.github/plans/functional.md`
- `.github/plans/architecture.md`
- `.github/plans/videoclub/videoclub.spec.md`
- `app.json`

The plan is intentionally phased. It does not require downloading symbols, publishing, or connecting to a Business Central environment during Phase 1 planning.

## 2. Test Strategy

### 2.1 TDD Rule

For every implementation phase after Phase 1:

1. Create or update AL test codeunits first.
2. Confirm the expected RED state by static review and, when symbols/test runtime are available, by execution.
3. Implement the minimum GREEN production code for the slice.
4. Review against the spec, architecture, instructions, and BCQuality decision.
5. Refactor only within the approved phase scope.

### 2.2 Test Object Boundaries

| Object ID | Object Name | Responsibility |
|---:|---|---|
| 50142 | `Library - VC Videoclub` | Test helpers and fixture creation. |
| 50143 | `VC Rental Tests` | Availability, rental registration, return and status tests. |
| 50144 | `VC TMDB Tests` | TMDB setup, mapper, fake payload/import tests. |

### 2.3 Validation Without Symbols

Until symbols are available, validation is limited to:

- Object inventory and ID-range consistency with `app.json`.
- Naming and file-structure checks.
- Static AL review of object definitions and TDD intent.
- No standard Business Central event subscriber signatures unless verified from symbols.
- No claim of successful compilation.

### 2.4 Validation Pending Symbols

The following require Business Central symbols and/or a test environment:

- AL compiler validation.
- AL test execution.
- Permission behavior checks by role.
- Any subscriber signature against standard BC events.
- Runtime validation of pages, actions, FlowFields and table relations.

## 3. Phase Test Matrix

| Phase | RED Tests | GREEN Target | Execution Status |
|---|---|---|---|
| 1 — Planning, Test Strategy and Structure Baseline | Document-only validation: missing plan/test-plan artifacts must be resolved. | `videoclub-plan.md`, `videoclub.test-plan.md`, and phase-1 completion file exist. | Static only; complete. |
| 2 — Foundation / Setup / App Structure Validation | Helper/test shell procedures establish fixture intent and reference future catalog/rental capabilities; compile/runtime validation is expected to remain RED until symbols and later objects exist. | Test helper 50142, rental test shell 50143, source/test folder structure, and common test intent exist without business logic. | Approved to start after Phase 1. |
| 3 — Catalog: Genres, Actors, Movies and Item Extension | Tests for creating a movie item, genres, actors and cast fixtures fail because catalog objects/fields are absent or incomplete. | Minimal catalog tables, Item extension fields, movie management codeunit and catalog pages/helpers exist. | Pending Phase 2 gate. |
| 4 — Availability and Minimal Rental Logic | Availability tests fail because calculation codeunit and open-rental data model are not complete. | Available quantity equals rental copies minus outstanding registered quantities, with availability assertions. | Pending Phase 3 gate. |
| 5 — Rental Header/Lines and Registration | Registration validation tests fail for missing customer, no lines, non-rentable movie, insufficient copies and draft registration. | Minimal header/line tables, status enums and registration codeunits enforce validations and status transitions. | Pending Phase 4 gate. |
| 6 — Returns, Partial Returns and Overdue Handling | Return tests fail for partial, full, excess and duplicate return cases; overdue behavior is unresolved until slice implementation. | Return code updates quantities, dates and statuses; overdue behavior follows conservative dynamic calculation unless an approved decision exists. | Pending Phase 5 gate. |
| 7 — Pages and Navigation | Page-focused review/tests fail because user workflows are not exposed through pages/actions. | Minimal list/card/document/listpart pages and safe actions call codeunits; Role Center extension remains pending unless the base page is confirmed. | Pending Phase 6 gate. |
| 8 — Permissions | Permission review/tests fail because permission sets are absent. | READ/USER/ADMIN/BASE permission sets match the functional matrix and object inventory. | Pending Phase 7 gate. |
| 9 — TMDB Integration as Separate Gated Slice | TMDB disabled/search/map/apply tests fail because setup, log and fakeable integration boundaries are absent/incomplete. | Setup/log/mapper/facade are introduced with fakeable payload boundaries; live HTTP remains gated and untested. | Pending Phase 8 gate. |

## 4. Core Given/When/Then Scenarios

| Test Name | Given | When | Then |
|---|---|---|---|
| `GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies` | A rentable movie with 3 copies and no open rental lines. | Availability is calculated. | The result is 3. |
| `GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding` | A rentable movie with 3 copies and a registered rental of 2 outstanding copies. | Availability is calculated. | The result is 1. |
| `GivenNoCustomer_WhenRegisterRental_ThenError` | A draft rental header without customer. | Registration is requested. | A controlled customer-required error is raised. |
| `GivenNoLines_WhenRegisterRental_ThenError` | A draft rental header with customer and no lines. | Registration is requested. | A controlled lines-required error is raised. |
| `GivenNotRentableMovie_WhenRegisterRental_ThenError` | A line references a movie where `VC Rentable = false`. | Registration is requested. | A controlled not-rentable error is raised. |
| `GivenInsufficientCopies_WhenRegisterRental_ThenError` | One copy is available and the rental quantity is 2. | Registration is requested. | A controlled availability error is raised. |
| `GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding` | A valid draft rental exists. | Registration is requested. | Header is Registered and lines are Outstanding. |
| `GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned` | A registered line has quantity 2 outstanding. | One copy is returned. | Line/header are partially returned. |
| `GivenOutstandingLine_WhenFullReturn_ThenReturned` | A registered line has quantity 1 outstanding. | One copy is returned. | Line/header are returned if no outstanding quantity remains. |
| `GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError` | One copy is outstanding. | Two copies are returned. | A controlled excess-return error is raised. |
| `GivenReturnedLine_WhenDuplicateReturn_ThenError` | One copy was already fully returned and no outstanding quantity remains. | A second return is requested. | A controlled duplicate/excess-return error is raised. |
| `GivenDueDatePast_WhenEvaluateOverdue_ThenDynamicContractWithoutPersistedStatus` | A registered rental has due date before work date and remains outstanding. | Dynamic overdue evaluation is requested. | The rental is reported overdue without forcing persisted `Overdue` status while the decision remains open. |
| `GivenTMDBDisabled_WhenSearch_ThenError` | TMDB setup is disabled. | Search is requested. | A controlled error/log entry is produced. |
| `GivenTMDBPayload_WhenMapMovie_ThenFieldsMapped` | A local JSON payload is available. | Mapper runs. | Movie fields, genres and cast are normalized. |
| `GivenTMDBImport_WhenApply_ThenMovieUpdated` | A movie and fake normalized payload exist. | Import application runs. | Existing movie fields and cast are updated according to overwrite rules. |

## 5. Gates

A phase may not move from RED to GREEN unless:

- Tests for the slice are written first.
- Implementation stays within the slice.
- No symbols are downloaded by the agent.
- No publishing or BC environment connection is attempted.
- Standard event subscribers are not invented; unverified subscriber requirements remain open questions.
- Review confirms architecture/spec alignment.
