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

| Phase | RED Tests | GREEN Target | Execution Status in Phase 1 |
|---|---|---|---|
| 1 — Planning and foundation validation | Document-only validation: missing plan/test-plan artifacts must be resolved. | `videoclub-plan.md`, `videoclub.test-plan.md`, and phase-1 completion file exist. | Static only. |
| 2 — App structure and catalog foundation | Tests for creating a movie item, genres, actors and cast fixtures fail because objects/fields are absent or placeholders are incomplete. | Minimal catalog tables, item extension fields and helper procedures exist. | Pending approval. |
| 3 — Availability logic | Availability tests fail because calculation codeunit and open-rental data model are not complete. | Available quantity equals rental copies minus outstanding registered quantities. | Pending approval. |
| 4 — Rental document registration | Registration validation tests fail for missing customer, no lines, non-rentable movie and insufficient copies. | Minimal header/line tables, status enums and registration codeunit enforce validations. | Pending approval. |
| 5 — Returns and overdue behavior | Return tests fail for partial, full, excess and duplicate return cases. | Return code updates quantities, dates and statuses; overdue behavior follows approved decision. | Pending approval. |
| 6 — Pages and navigation | Page-focused review/tests fail because pages/actions are absent. | Minimal list/card/document pages and safe actions call codeunits. | Pending approval. |
| 7 — Permissions | Permission review/tests fail because permission sets are absent. | READ/USER/ADMIN/BASE permission sets match matrix. | Pending approval. |
| 8 — TMDB integration shell | TMDB tests fail because setup, log and integration codeunits are absent/incomplete. | Setup/log/mapper facade are introduced with fakeable boundaries; live HTTP remains gated by decisions. | Pending approval. |

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
| `GivenDueDatePast_WhenUpdateStatus_ThenOverdue` | A registered rental has due date before work date. | Status is recalculated. | Status is Overdue if persisted overdue is approved; otherwise page/query exposes it dynamically. |
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
