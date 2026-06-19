codeunit 50143 "VC Rental Tests"
{
  Subtype = Test;
  TestPermissions = Disabled;

  var
    Assert: Codeunit "Library Assert";
    LibraryVC: Codeunit "Library - VC Videoclub";


  [Test]
  procedure GivenMovieFixture_WhenEnsureMovieItem_ThenMovieDefaultsAreSet()
  var
    Item: Record Item;
    MovieMgt: Codeunit "VC Movie Mgt";
  begin
    // [GIVEN] A catalog fixture can create a movie item.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithCopies(Item, 3);

    // [WHEN] The movie management contract reads the created item.
    Item.Get(Item."No.");

    // [THEN] The item is marked as a rentable movie with the configured copies.
    Assert.IsTrue(MovieMgt.IsMovie(Item."No."), 'The catalog fixture should create an item marked as movie.');
    Assert.AreEqual(3, Item."VC Rental Copies", 'The movie should keep the requested rental copies.');
    Assert.IsTrue(Item."VC Rentable", 'The movie should be rentable by default.');
  end;

  [Test]
  procedure GivenMovieWithGenre_WhenValidateRentable_ThenCatalogMetadataPersists()
  var
    Genre: Record "VC Genre";
    Item: Record Item;
    MovieMgt: Codeunit "VC Movie Mgt";
  begin
    // [GIVEN] A movie is linked to a catalog genre.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithGenre(Item, Genre, 2);

    // [WHEN] The movie is validated for rental.
    MovieMgt.ValidateMovieIsRentable(Item."No.");

    // [THEN] The title and genre metadata remain available through the catalog model.
    Item.Get(Item."No.");
    Assert.AreEqual(Genre.Code, Item."VC Primary Genre Code", 'The primary genre should be assigned to the movie.');
    Assert.AreEqual(Item.Description, MovieMgt.GetMovieTitle(Item."No."), 'The movie title should come from the item description.');
  end;

  [Test]
  procedure GivenActorAndMovie_WhenAddCast_ThenCastLinksActorToMovie()
  var
    Actor: Record "VC Actor";
    Item: Record Item;
    MovieCast: Record "VC Movie Cast";
  begin
    // [GIVEN] A movie and an actor exist in the catalog.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateActor(Actor);

    // [WHEN] The actor is added to the movie cast.
    LibraryVC.AddMovieCast(MovieCast, Item."No.", Actor."No.", 'Lead Character', 1);

    // [THEN] The cast row links the movie and actor with the character metadata.
    MovieCast.Get(Item."No.", MovieCast."Line No.");
    Assert.AreEqual(Actor."No.", MovieCast."Actor No.", 'The cast line should reference the actor.');
    Assert.AreEqual('Lead Character', MovieCast."Character Name", 'The cast line should keep the character name.');
    Assert.AreEqual(1, MovieCast."Cast Order", 'The cast line should keep the cast order.');
  end;

  [Test]
  procedure GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies()
  var
    Item: Record Item;
    AvailabilityMgt: Codeunit "VC Availability Mgt";
    AvailableQty: Decimal;
  begin
    // [GIVEN] A rentable movie with three rental copies and no open rental lines.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithCopies(Item, 3);

    // [WHEN] Availability is calculated through the rental availability contract.
    AvailableQty := AvailabilityMgt.GetAvailableQuantity(Item."No.");

    // [THEN] The available quantity should equal the configured copies.
    Assert.AreEqual(3, AvailableQty, 'Available quantity should match rental copies when there are no open rentals.');
  end;

  [Test]
  procedure GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    AvailabilityMgt: Codeunit "VC Availability Mgt";
    AvailableQty: Decimal;
  begin
    // [GIVEN] A rentable movie with three copies and a registered rental with two outstanding copies.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithCopies(Item, 3);
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 2);

    // [WHEN] Availability is calculated through the rental availability contract.
    AvailableQty := AvailabilityMgt.GetAvailableQuantity(Item."No.");

    // [THEN] The outstanding quantity should be subtracted from the rental copies.
    Assert.AreEqual(1, AvailableQty, 'Available quantity should subtract registered outstanding rentals.');
  end;

  [Test]
  procedure GivenInsufficientCopies_WhenAssertAvailable_ThenError()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    AvailabilityMgt: Codeunit "VC Availability Mgt";
  begin
    // [GIVEN] A rentable movie with one remaining available copy.
    LibraryVC.Initialize();
    LibraryVC.CreateMovieWithCopies(Item, 2);
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);

    // [WHEN] Availability is asserted for more copies than remain available.
    asserterror AvailabilityMgt.AssertAvailable(Item."No.", 2, '');

    // [THEN] A controlled availability error should block over-rental.
    Assert.ExpectedError('available');
  end;

  [Test]
  procedure GivenNoCustomer_WhenRegisterRental_ThenError()
  var
    RentalHeader: Record "VC Rental Header";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A draft rental header without a customer.
    LibraryVC.Initialize();
    LibraryVC.CreateDraftRental(RentalHeader, '');

    // [WHEN] Registration is requested through the rental management codeunit.
    asserterror RentalMgt.RegisterRental(RentalHeader);

    // [THEN] A controlled customer-required error should be raised.
    Assert.ExpectedError('customer');
  end;

  [Test]
  procedure GivenNoLines_WhenRegisterRental_ThenError()
  var
    Customer: Record Customer;
    RentalHeader: Record "VC Rental Header";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A draft rental header with a customer and no lines.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateDraftRental(RentalHeader, Customer."No.");

    // [WHEN] Registration is requested through the rental management codeunit.
    asserterror RentalMgt.RegisterRental(RentalHeader);

    // [THEN] A controlled lines-required error should be raised.
    Assert.ExpectedError('line');
  end;

  [Test]
  procedure GivenNotRentableMovie_WhenRegisterRental_ThenError()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A draft rental with a line for a movie that is not rentable.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateNotRentableMovie(Item, 1);
    LibraryVC.CreateDraftRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);

    // [WHEN] Registration is requested through the rental management codeunit.
    asserterror RentalMgt.RegisterRental(RentalHeader);

    // [THEN] A controlled not-rentable error should be raised.
    Assert.ExpectedError('rentable');
  end;

  [Test]
  procedure GivenInsufficientCopies_WhenRegisterRental_ThenError()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A draft rental line requests more copies than the movie has available.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateDraftRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 2);

    // [WHEN] Registration is requested through the rental management codeunit.
    asserterror RentalMgt.RegisterRental(RentalHeader);

    // [THEN] A controlled availability error should be raised.
    Assert.ExpectedError('avail');
  end;

  [Test]
  procedure GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A valid draft rental exists for a rentable movie with enough copies.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 2);
    LibraryVC.CreateDraftRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);

    // [WHEN] The rental is registered through the rental management codeunit.
    RentalMgt.RegisterRental(RentalHeader);

    // [THEN] Header and line statuses should reflect an outstanding registered rental.
    RentalHeader.Get(RentalHeader."No.");
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");
    Assert.AreEqual(RentalHeader.Status::Registered, RentalHeader.Status, 'Rental header should be registered.');
    Assert.AreEqual(WorkDate(), RentalHeader."Registered Date", 'Rental header should capture the registration date.');
    Assert.AreEqual(Customer.Name, RentalHeader."Customer Name", 'Rental header should copy the customer name at registration.');
    Assert.AreEqual(RentalLine.Status::Outstanding, RentalLine.Status, 'Rental line should be outstanding.');
    Assert.AreEqual(Item.Description, RentalLine.Description, 'Rental line should copy the movie description at registration.');
    Assert.AreEqual(RentalHeader."Rental Date", RentalLine."Rental Date", 'Rental line should copy the rental date at registration.');
    Assert.AreEqual(RentalHeader."Due Date", RentalLine."Expected Return Date", 'Rental line should copy the due date as expected return date at registration.');
    Assert.AreEqual(1, RentalLine."Outstanding Qty.", 'Rental line should initialize outstanding quantity from quantity.');

    // [THEN] The copied customer name should remain historical even if the customer master data changes later.
    Customer.Name := CopyStr('VC Renamed Customer', 1, MaxStrLen(Customer.Name));
    Customer.Modify(true);
    RentalHeader.Get(RentalHeader."No.");
    Assert.IsTrue(Customer.Name <> RentalHeader."Customer Name", 'Rental header customer name should be a persisted historical copy.');
  end;

  [Test]
  procedure GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
    ReturnDate: Date;
  begin
    // [GIVEN] A registered rental line has two outstanding copies.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 2);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 2);
    ReturnDate := WorkDate();

    // [WHEN] One copy is returned through the rental management codeunit.
    RentalMgt.RegisterLineReturn(RentalLine, 1, ReturnDate);

    // [THEN] The return quantities, last return date, and line/header statuses are updated immediately.
    RentalHeader.Get(RentalHeader."No.");
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");
    Assert.AreEqual(1, RentalLine."Returned Quantity", 'Rental line should track the returned quantity.');
    Assert.AreEqual(1, RentalLine."Outstanding Qty.", 'Rental line should leave only the unreturned copy outstanding.');
    Assert.AreEqual(ReturnDate, RentalLine."Last Return Date", 'Rental line should store the last return date.');
    Assert.AreEqual(RentalLine.Status::"Partially Returned", RentalLine.Status, 'Rental line should be partially returned.');
    Assert.AreEqual(RentalHeader.Status::"Partially Returned", RentalHeader.Status, 'Rental header should be partially returned.');
  end;

  [Test]
  procedure GivenOutstandingLine_WhenFullReturn_ThenReturned()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
    ReturnDate: Date;
  begin
    // [GIVEN] A registered rental line has one outstanding copy.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);
    ReturnDate := WorkDate();

    // [WHEN] The outstanding copy is returned through the rental management codeunit.
    RentalMgt.RegisterLineReturn(RentalLine, 1, ReturnDate);

    // [THEN] The line has no outstanding quantity and both line and header are returned.
    RentalHeader.Get(RentalHeader."No.");
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");
    Assert.AreEqual(1, RentalLine."Returned Quantity", 'Rental line should track the full returned quantity.');
    Assert.AreEqual(0, RentalLine."Outstanding Qty.", 'Rental line should have no outstanding quantity after full return.');
    Assert.AreEqual(ReturnDate, RentalLine."Last Return Date", 'Rental line should store the full return date.');
    Assert.AreEqual(RentalLine.Status::Returned, RentalLine.Status, 'Rental line should be returned.');
    Assert.AreEqual(RentalHeader.Status::Returned, RentalHeader.Status, 'Rental header should be returned.');
  end;

  [Test]
  procedure GivenRegisteredRental_WhenRegisterReturn_ThenAllOutstandingLinesReturned()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
    ReturnDate: Date;
  begin
    // [GIVEN] A registered rental line has multiple outstanding copies.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 2);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 2);
    ReturnDate := WorkDate();

    // [WHEN] The whole rental is returned through the document-level return flow.
    RentalMgt.RegisterReturn(RentalHeader, ReturnDate);

    // [THEN] RegisterReturn returns the full outstanding quantity on the line and closes the header.
    RentalHeader.Get(RentalHeader."No.");
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");
    Assert.AreEqual(2, RentalLine."Returned Quantity", 'Document return should return all outstanding copies.');
    Assert.AreEqual(0, RentalLine."Outstanding Qty.", 'Document return should leave no outstanding quantity.');
    Assert.AreEqual(ReturnDate, RentalLine."Last Return Date", 'Document return should stamp the return date on the line.');
    Assert.AreEqual(RentalLine.Status::Returned, RentalLine.Status, 'Document return should mark the line returned.');
    Assert.AreEqual(RentalHeader.Status::Returned, RentalHeader.Status, 'Document return should mark the header returned.');
  end;

  [Test]
  procedure GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A registered rental line has one outstanding copy.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);

    // [WHEN] Two copies are returned through the rental management codeunit.
    asserterror RentalMgt.RegisterLineReturn(RentalLine, 2, WorkDate());

    // [THEN] A controlled excess-return error should be raised.
    Assert.ExpectedError('outstanding');
  end;

  [Test]
  procedure GivenReturnedLine_WhenDuplicateReturn_ThenError()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    RentalMgt: Codeunit "VC Rental Mgt";
  begin
    // [GIVEN] A registered rental line has already returned all copies and has no outstanding quantity.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);
    RentalMgt.RegisterLineReturn(RentalLine, 1, WorkDate());
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");

    // [WHEN] A second return is requested for the same already-returned copy.
    asserterror RentalMgt.RegisterLineReturn(RentalLine, 1, WorkDate());

    // [THEN] A controlled duplicate/excess-return error should be raised.
    Assert.ExpectedError('outstanding');
  end;

  [Test]
  procedure GivenDueDatePast_WhenEvaluateOverdue_ThenDynamicContractWithoutPersistedStatus()
  var
    Customer: Record Customer;
    Item: Record Item;
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    HeaderOverdue: Boolean;
    LineOverdue: Boolean;
  begin
    // [GIVEN] A registered rental has a due date before the reference date and still has outstanding quantity.
    LibraryVC.Initialize();
    LibraryVC.CreateCustomer(Customer);
    LibraryVC.CreateMovieWithCopies(Item, 1);
    LibraryVC.CreateRegisteredRentalWithLine(RentalHeader, RentalLine, Customer."No.", Item."No.", 1);
    RentalHeader."Due Date" := WorkDate() - 1;
    RentalHeader.Modify(true);
    RentalLine."Expected Return Date" := WorkDate() - 1;
    RentalLine.Modify(true);

    // [WHEN] The conservative overdue contract is evaluated dynamically.
    HeaderOverdue := IsHeaderOverdue(RentalHeader, WorkDate());
    LineOverdue := IsLineOverdue(RentalLine, WorkDate());
    RentalHeader.Get(RentalHeader."No.");
    RentalLine.Get(RentalLine."Rental No.", RentalLine."Line No.");

    // [THEN] The rental is exposed as overdue without forcing persisted Overdue status while the decision remains open.
    Assert.IsTrue(HeaderOverdue, 'Rental header should be reported overdue by the dynamic overdue contract.');
    Assert.IsTrue(LineOverdue, 'Rental line should be reported overdue by the dynamic overdue contract.');
    Assert.AreEqual(RentalHeader.Status::Registered, RentalHeader.Status, 'Rental header status should remain registered until persisted overdue is explicitly approved.');
    Assert.AreEqual(RentalLine.Status::Outstanding, RentalLine.Status, 'Rental line status should remain outstanding until persisted overdue is explicitly approved.');
  end;


  local procedure IsHeaderOverdue(var RentalHeader: Record "VC Rental Header"; ReferenceDate: Date): Boolean
  var
    RentalStatusMgt: Codeunit "VC Rental Status Mgt";
  begin
    exit(RentalStatusMgt.IsHeaderOverdue(RentalHeader, ReferenceDate));
  end;

  local procedure IsLineOverdue(var RentalLine: Record "VC Rental Line"; ReferenceDate: Date): Boolean
  var
    RentalStatusMgt: Codeunit "VC Rental Status Mgt";
  begin
    exit(RentalStatusMgt.IsLineOverdue(RentalLine, ReferenceDate));
  end;
}
