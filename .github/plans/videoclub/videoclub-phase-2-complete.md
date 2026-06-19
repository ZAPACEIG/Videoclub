## Phase 2 Complete: Foundation / Setup / App Structure Validation

Phase 2 established the Videoclub AL test foundation and RED rental slice shell. It adds reusable fixture intent and Given/When/Then tests that document the future catalog, availability, validation, rental, return and overdue contracts without implementing business logic.

**Review executed:** Initial Phase 2 review returned NEEDS_REVISION; re-review was executed after corrections.

**Review findings:** Initial majors were overdue persistence ambiguity and missing duplicate-return coverage. Corrections were applied. Re-review returned no blockers, no majors and no minors.

**BCQuality decision used:** BCQuality auto was not available; native skills-mode fallback with residual checklist A-G was used, outcome not-applicable.

**Final Phase Status:** APPROVED.

## Scope Boundaries Observed

- No symbols were downloaded.
- No package was published.
- No Business Central environment was contacted.
- No Phase 3+ business implementation was added.
- Changes are limited to Phase 2 RED test contracts, fixture hygiene and documentation alignment.

## AL Objects Created/Modified

- Codeunit 50142 `Library - VC Videoclub`
- Codeunit 50143 `VC Rental Tests`

## Files Created/Changed

- `/test/Videoclub/Tests/LibraryVCVideoclub.Codeunit.al` — Shared test helper for movie, customer, rental header and rental line fixture intent; `Initialize()` now only removes `VC-TST-*` fixtures where viable.
- `/test/Videoclub/Tests/VCRentalTests.Codeunit.al` — RED Given/When/Then rental, availability, validation, return, duplicate-return and dynamic-overdue shell tests.
- `/.github/plans/videoclub/videoclub.test-plan.md` — Phase test matrix heading generalized and core scenario matrix aligned with duplicate-return and dynamic-overdue contracts.
- `/.github/plans/videoclub/videoclub-phase-2-complete.md` — Phase 2 checkpoint updated to reflect review result and corrections.
- `/.github/plans/memory.md` — Append-only handoff entries for Phase 2 and review correction.

## Functions Created/Changed

- `Initialize`
- `CreateMovieWithCopies`
- `CreateNotRentableMovie`
- `CreateCustomer`
- `CreateDraftRental`
- `CreateDraftRentalWithLine`
- `CreateRegisteredRentalWithLine`
- `CreateRentalLine`
- `GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies`
- `GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding`
- `GivenNoCustomer_WhenRegisterRental_ThenError`
- `GivenNoLines_WhenRegisterRental_ThenError`
- `GivenNotRentableMovie_WhenRegisterRental_ThenError`
- `GivenInsufficientCopies_WhenRegisterRental_ThenError`
- `GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding`
- `GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned`
- `GivenOutstandingLine_WhenFullReturn_ThenReturned`
- `GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError`
- `GivenReturnedLine_WhenDuplicateReturn_ThenError`
- `GivenDueDatePast_WhenEvaluateOverdue_ThenDynamicContractWithoutPersistedStatus`
- `ValidateCanRegister`
- `ValidateCanReturn`
- `UpdateRentalStatuses`
- `IsHeaderOverdue`

## Tests Created/Changed

- `VC Rental Tests`
- `GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies`
- `GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding`
- `GivenNoCustomer_WhenRegisterRental_ThenError`
- `GivenNoLines_WhenRegisterRental_ThenError`
- `GivenNotRentableMovie_WhenRegisterRental_ThenError`
- `GivenInsufficientCopies_WhenRegisterRental_ThenError`
- `GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding`
- `GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned`
- `GivenOutstandingLine_WhenFullReturn_ThenReturned`
- `GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError`
- `GivenReturnedLine_WhenDuplicateReturn_ThenError`
- `GivenDueDatePast_WhenEvaluateOverdue_ThenDynamicContractWithoutPersistedStatus`

## Phase 2 Review Findings and Corrections

1. **Overdue contract corrected.** The previous overdue test implied persisted `Overdue` status. It now documents the conservative dynamic contract through `IsHeaderOverdue(...)` and asserts that persisted status remains `Registered` until a persistence decision is approved.
2. **Duplicate-return RED coverage added.** A dedicated test now covers the case where all copies are already returned and a second return is requested.
3. **Fixture cleanup narrowed.** `Initialize()` now filters rentals, movies and customers to `VC-TST-*` fixture numbers where viable instead of deleting all rental headers/lines.
4. **Test-plan wording generalized.** The phase matrix column was renamed from `Execution Status in Phase 1` to `Execution Status`.
5. **Checkpoint status corrected.** This completion checkpoint now reflects the received `NEEDS_REVISION` review and the applied corrections, with final state ready for re-review rather than auto-approved.

## AL Patterns Applied

- Feature-based test placement under `test/Videoclub/Tests`.
- Given/When/Then test procedure names and comments.
- Shared fixture helper codeunit for repeatable test data setup.
- RED contract references to future `VC Rental Validation` and `VC Rental Status Mgt` objects remain intentional for later phases.
- Dynamic/conservative overdue behavior is documented without forcing a persisted status decision.

## Validation Notes

- Static file inspection was performed only.
- AL compile/test execution was intentionally not run because this slice must not download symbols or connect to Business Central, and the RED tests intentionally reference later-phase objects.

## Suggested Commit Message

```text
test: address phase 2 review corrections
```


## Required Closure Fields

| Field | Phase 2 Result |
|---|---|
| Objective | Establish minimum AL project/test foundation for later TDD slices. |
| Tests created or modified | `VC Rental Tests` in codeunit 50143 plus helper fixtures in codeunit 50142. |
| Expected RED result | Tests reference later-phase catalog/rental/validation/status behavior and remain expected RED until symbols and later objects are available. |
| GREEN implementation performed | Test helper/test shell foundation, fixture hygiene, aligned test-plan matrix and documented gate closure. |
| AL objects created/modified | Codeunit 50142 `Library - VC Videoclub`; Codeunit 50143 `VC Rental Tests`. |
| Review executed | AL Code Review Subagent initial review plus re-review. |
| Review findings | Initial majors corrected; re-review findings: no blockers, no majors, no minors. |
| BCQuality decision used | Not available in auto mode; native A-G fallback. |
| Validations performed without symbols | Static file/object inventory, ID range check, no subscriber/HTTP/publish/symbol command scan, test-plan matrix review. |
| Validations pending with symbols | AL compilation, AL test execution and runtime validation of test framework references. |
| No publish/BC connection confirmation | No package was published and no Business Central environment was contacted. |
| Final phase state | APPROVED. |
