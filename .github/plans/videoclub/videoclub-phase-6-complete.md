## Phase 6 Complete: Returns, Partial Returns and Overdue Handling

Phase 6 delivers the minimum return-processing slice for registered rentals. The slice keeps overdue behavior conservative and dynamic: overdue can be evaluated without persisting `Overdue` onto rental headers or lines unless a later approved decision introduces that persistence.

**AL Objects Created/Modified:**
- Codeunit 50133 `VC Rental Validation`
- Codeunit 50134 `VC Rental Status Mgt`
- Codeunit 50135 `VC Rental Mgt`
- Codeunit 50143 `VC Rental Tests`
- Event subscribers added: none.

**Files created/changed:**
- `/src/Videoclub/Rental/VCRentalMgt.Codeunit.al` — Implements `RegisterLineReturn` and `RegisterReturn` return flows that update returned/outstanding quantities, last return dates, and line/header statuses.
- `/src/Videoclub/Rental/VCRentalValidation.Codeunit.al` — Validates positive return quantity, required return date, draft-line rejection, and excess/duplicate return attempts against outstanding quantity.
- `/src/Videoclub/Rental/VCRentalStatusMgt.Codeunit.al` — Maintains returned/partially returned status calculation and exposes dynamic header/line overdue evaluation without persisted overdue status.
- `/test/Videoclub/Tests/VCRentalTests.Codeunit.al` — Updates return tests to exercise the production return flows directly and adds document-level `RegisterReturn` plus dynamic line overdue assertions.
- `/.github/plans/videoclub/videoclub-phase-6-complete.md` — Adds the Phase 6 closure checkpoint.

**Functions created/changed:**
- `RegisterReturn`
- `RegisterLineReturn`
- `ValidateCanReturn`
- `UpdateLineStatus`
- `UpdateHeaderStatus`
- `IsHeaderOverdue`
- `IsLineOverdue`
- Tests: `GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned`, `GivenOutstandingLine_WhenFullReturn_ThenReturned`, `GivenRegisteredRental_WhenRegisterReturn_ThenAllOutstandingLinesReturned`, `GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError`, `GivenReturnedLine_WhenDuplicateReturn_ThenError`, `GivenDueDatePast_WhenEvaluateOverdue_ThenDynamicContractWithoutPersistedStatus`
- Event subscriber signature: none.

**Tests created/changed:**
- `VC Rental Tests`
- Updated partial-return coverage to assert `Returned Quantity`, `Outstanding Qty.`, `Last Return Date`, line status and header status immediately after `RegisterLineReturn`.
- Updated full-return coverage to assert closed quantities/dates/statuses immediately after `RegisterLineReturn`.
- Added document-level `RegisterReturn` coverage for returning all outstanding quantities on a rental.
- Updated excess-return and duplicate-return coverage to call `RegisterLineReturn` directly.
- Updated overdue coverage to assert both header and line dynamic overdue checks while persisted statuses remain non-overdue.

**AL Patterns Applied:**
- Return orchestration remains centralized in codeunit 50135 rather than table triggers or pages.
- Validation remains centralized in codeunit 50133 before quantity mutation.
- Status derivation remains centralized in codeunit 50134.
- Conservative overdue behavior is exposed as dynamic predicates and does not persist `Overdue` status.
- Own `IntegrationEvent(false, false)` publishers are retained; no standard Business Central subscribers were added.

**BCQuality Evidence:**
- Submodule SHA: not available.
- Skills run: none.
- Outcome: not-applicable.
- Findings: 0 recorded by native static fallback; BCQuality was not run.
- Raw report: not generated.

**Review Status:** APPROVED_WITH_RECOMMENDATIONS after AL Code Review Subagent review.

**Git Commit Message:**

feat: implement phase 6 returns and overdue handling

## Required Closure Fields

| Field | Phase 6 Result |
|---|---|
| Objective | Implement minimum returns, partial returns and conservative dynamic overdue handling for registered rentals. |
| Tests created or modified | Updated return/overdue tests in codeunit 50143 and added document-level `RegisterReturn` coverage. |
| Expected RED result | Before GREEN implementation, production return flows did not satisfy direct quantity/date/status assertions, document-level returns, duplicate/excess return blocking through `RegisterLineReturn`, or dynamic line overdue checks. |
| GREEN implementation performed | Implemented/verified `RegisterLineReturn` and `RegisterReturn`, returned/outstanding quantities, last return dates, partial/returned statuses, excess/duplicate return errors, and dynamic conservative header/line overdue evaluation. |
| AL objects created/modified | Codeunit 50133 `VC Rental Validation`; Codeunit 50134 `VC Rental Status Mgt`; Codeunit 50135 `VC Rental Mgt`; Codeunit 50143 `VC Rental Tests`. |
| Review executed | Static implementation self-review plus AL Code Review Subagent review against Phase 6 scope, plan/spec/test-plan and repository constraints. |
| Review findings | No blockers or majors. One non-blocking recommendation remains to decide/document duplicate no-op behavior for document-level `RegisterReturn` before exposing broader UI flows. |
| BCQuality decision used | Not available in auto mode; native static fallback used. |
| Validations performed without symbols | Static file/object inventory, return/overdue object scan, duplicate object ID scan and restricted-command scan. |
| Validations pending with symbols | AL compilation, AL test execution and runtime validation in a Business Central test environment. |
| No publish/BC connection confirmation | No package was published and no Business Central environment was contacted. |
| Final phase state | APPROVED_WITH_RECOMMENDATIONS. |
