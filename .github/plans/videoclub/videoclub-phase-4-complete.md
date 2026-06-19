## Phase 4 Complete: Availability and Minimal Rental Logic

Phase 4 delivers the minimum availability slice for functional movie copies. The slice keeps the availability tests focused on rental-copy calculation and adds an availability assertion that blocks over-rental without downloading symbols, publishing or connecting to Business Central.

**AL Objects Created/Modified:**
- Table 50105 `VC Rental Line`
- Codeunit 50132 `VC Availability Mgt`
- Codeunit 50143 `VC Rental Tests`
- Event subscribers added: none.

**Files created/changed:**
- `/src/Videoclub/Rental/VCAvailabilityMgt.Codeunit.al` — Implemented rented quantity calculation, available quantity calculation, availability assertions and the compatibility check wrapper.
- `/src/Videoclub/Rental/VCRentalLine.Table.al` — Added a movie/status key with `Outstanding Qty.` as `SumIndexFields` for availability `CalcSums`.
- `/test/Videoclub/Tests/VCRentalTests.Codeunit.al` — Updated availability test wording and added direct over-rental assertion coverage.
- `/.github/plans/videoclub/videoclub-phase-3-complete.md` — Corrected minor BCQuality wording to clarify that BCQuality was not run.
- `/.github/plans/videoclub/videoclub-phase-4-complete.md` — Added the Phase 4 closure checkpoint.

**Functions created/changed:**
- `GetRentedQuantity`
- `GetAvailableQuantity`
- `AssertAvailable`
- `CheckAvailability`
- `GetAvailableQuantityExcludingDocument`
- `GetRentedQuantityExcludingDocument`
- Event subscriber signature: none.

**Tests created/changed:**
- `VC Rental Tests`
- `GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies`
- `GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding`
- `GivenInsufficientCopies_WhenAssertAvailable_ThenError`

**AL Patterns Applied:**
- Availability calculation is centralized in codeunit 50132 rather than pages or table triggers.
- `CalcSums("Outstanding Qty.")` is used with filtered rental line reads for open line statuses.
- Only own `IntegrationEvent(false, false)` publishers are retained; no standard Business Central subscribers were added.
- Minimal compatibility was preserved by keeping `CheckAvailability` as a wrapper around `AssertAvailable`.

**BCQuality Evidence:**
- Submodule SHA: not available.
- Skills run: none.
- Outcome: not-applicable.
- Findings: 0 recorded by native static fallback; BCQuality was not run.
- Raw report: not generated.

**Review Status:** APPROVED with minor recommendations

**Git Commit Message:**

feat: implement phase 4 availability

## Required Closure Fields

| Field | Phase 4 Result |
|---|---|
| Objective | Calculate functional copies available for rental and prevent over-rental. |
| Tests created or modified | Updated two availability tests in codeunit 50143 and added direct `AssertAvailable` over-rental coverage. |
| Expected RED result | Before GREEN implementation, availability returned scaffolded zero quantity and availability assertions did not block over-rental. |
| GREEN implementation performed | Implemented rental copies minus outstanding open quantities, added `AssertAvailable`, and added a supporting SumIndex key for rental-line aggregation. |
| AL objects created/modified | Table 50105 `VC Rental Line`; Codeunit 50132 `VC Availability Mgt`; Codeunit 50143 `VC Rental Tests`. |
| Review executed | Static implementation self-review against plan/spec/test-plan and repository constraints. |
| Review findings | No standard subscribers invented; no symbol/publish/BC connection commands used; registration, return and status behavior remain later-phase scope. |
| BCQuality decision used | Not available in auto mode; native static fallback used. |
| Validations performed without symbols | Static file/object inventory, availability object scan, duplicate object ID scan and restricted-command scan. |
| Validations pending with symbols | AL compilation, AL test execution, enum filter verification and runtime validation of `CalcSums`/SIFT behavior. |
| No publish/BC connection confirmation | No package was published and no Business Central environment was contacted. |
| Final phase state | APPROVED with minor recommendations pending symbol-backed compiler/test validation. |
