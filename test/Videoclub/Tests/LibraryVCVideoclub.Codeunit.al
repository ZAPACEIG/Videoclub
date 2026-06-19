codeunit 50142 "Library - VC Videoclub"
{
  procedure Initialize()
  var
    RentalHeader: Record "VC Rental Header";
    RentalLine: Record "VC Rental Line";
    TMDBImportLog: Record "VC TMDB Import Log";
    Item: Record Item;
    Customer: Record Customer;
  begin
    DeleteTestCatalogData();

    TMDBImportLog.SetFilter("Movie Item No.", 'VC-TST-MOV*');
    TMDBImportLog.DeleteAll(true);

    RentalLine.SetFilter("Rental No.", 'VC-TST-*');
    RentalLine.DeleteAll(true);

    RentalHeader.SetFilter("No.", 'VC-TST-*');
    RentalHeader.DeleteAll(true);

    Item.SetFilter("No.", 'VC-TST-MOV*');
    Item.SetRange("VC Is Movie", true);
    Item.DeleteAll(true);

    Customer.SetFilter("No.", 'VC-TST-CUST*');
    Customer.DeleteAll(true);
  end;

  procedure CreateMovieWithCopies(var Item: Record Item; RentalCopies: Decimal)
  begin
    CreateMovie(Item, RentalCopies, true);
  end;

  procedure CreateMovieWithGenre(var Item: Record Item; var Genre: Record "VC Genre"; RentalCopies: Decimal)
  begin
    CreateGenre(Genre);
    CreateMovieWithCopies(Item, RentalCopies);
    Item."VC Primary Genre Code" := Genre.Code;
    Item.Modify(true);
  end;

  procedure CreateNotRentableMovie(var Item: Record Item; RentalCopies: Decimal)
  begin
    CreateMovie(Item, RentalCopies, false);
  end;

  procedure CreateGenre(var Genre: Record "VC Genre"): Code[20]
  begin
    Genre.Init();
    Genre.Code := GetNextNo('VC-TST-GEN');
    Genre.Description := CopyStr(StrSubstNo('VC Test Genre %1', Genre.Code), 1, MaxStrLen(Genre.Description));
    Genre.Insert(true);

    exit(Genre.Code);
  end;

  procedure CreateActor(var Actor: Record "VC Actor"): Code[20]
  begin
    Actor.Init();
    Actor."No." := GetNextNo('VC-TST-ACT');
    Actor.Name := CopyStr(StrSubstNo('VC Test Actor %1', Actor."No."), 1, MaxStrLen(Actor.Name));
    Actor.Insert(true);

    exit(Actor."No.");
  end;

  procedure AddMovieCast(var MovieCast: Record "VC Movie Cast"; MovieItemNo: Code[20]; ActorNo: Code[20]; CharacterName: Text[100]; CastOrder: Integer)
  begin
    MovieCast.Init();
    MovieCast."Movie Item No." := MovieItemNo;
    MovieCast."Line No." := GetNextCastLineNo(MovieItemNo);
    MovieCast."Actor No." := ActorNo;
    MovieCast."Character Name" := CharacterName;
    MovieCast."Cast Order" := CastOrder;
    MovieCast.Insert(true);
  end;

  procedure CreateCustomer(var Customer: Record Customer): Code[20]
  begin
    Customer.Init();
    Customer."No." := GetNextNo('VC-TST-CUST');
    Customer.Name := CopyStr(StrSubstNo('VC Test Customer %1', Customer."No."), 1, MaxStrLen(Customer.Name));
    Customer.Insert(true);

    exit(Customer."No.");
  end;

  procedure CreateDraftRental(var RentalHeader: Record "VC Rental Header"; CustomerNo: Code[20])
  begin
    RentalHeader.Init();
    RentalHeader."No." := GetNextNo('VC-TST-RENT');
    RentalHeader."Customer No." := CustomerNo;
    RentalHeader."Rental Date" := WorkDate();
    RentalHeader."Due Date" := WorkDate() + 7;
    RentalHeader.Status := RentalHeader.Status::Draft;
    RentalHeader.Insert(true);
  end;

  procedure CreateDraftRentalWithLine(var RentalHeader: Record "VC Rental Header"; var RentalLine: Record "VC Rental Line"; CustomerNo: Code[20]; MovieItemNo: Code[20]; Quantity: Decimal)
  begin
    CreateDraftRental(RentalHeader, CustomerNo);
    CreateRentalLine(RentalLine, RentalHeader."No.", MovieItemNo, Quantity, RentalLine.Status::Draft);
  end;

  procedure CreateRegisteredRentalWithLine(var RentalHeader: Record "VC Rental Header"; var RentalLine: Record "VC Rental Line"; CustomerNo: Code[20]; MovieItemNo: Code[20]; Quantity: Decimal)
  begin
    CreateDraftRentalWithLine(RentalHeader, RentalLine, CustomerNo, MovieItemNo, Quantity);

    RentalHeader.Status := RentalHeader.Status::Registered;
    RentalHeader.Modify(true);

    RentalLine.Status := RentalLine.Status::Outstanding;
    RentalLine."Outstanding Qty." := Quantity;
    RentalLine.Modify(true);
  end;

  procedure CreateRentalLine(var RentalLine: Record "VC Rental Line"; RentalNo: Code[20]; MovieItemNo: Code[20]; Quantity: Decimal; LineStatus: Enum "VC Rental Line Status")
  begin
    RentalLine.Init();
    RentalLine."Rental No." := RentalNo;
    RentalLine."Line No." := GetNextLineNo(RentalNo);
    RentalLine."Movie Item No." := MovieItemNo;
    RentalLine.Quantity := Quantity;
    RentalLine."Expected Return Date" := 0D;
    RentalLine."Returned Quantity" := 0;
    RentalLine."Outstanding Qty." := Quantity;
    RentalLine.Status := LineStatus;
    RentalLine.Insert(true);
  end;

  local procedure CreateMovie(var Item: Record Item; RentalCopies: Decimal; Rentable: Boolean)
  var
    MovieMgt: Codeunit "VC Movie Mgt";
  begin
    Item.Init();
    Item."No." := GetNextNo('VC-TST-MOV');
    Item.Description := CopyStr(StrSubstNo('VC Test Movie %1', Item."No."), 1, MaxStrLen(Item.Description));
    MovieMgt.EnsureMovieItem(Item);
    Item."VC Rentable" := Rentable;
    Item."VC Rental Copies" := RentalCopies;
    Item.Insert(true);
  end;

  local procedure GetNextLineNo(RentalNo: Code[20]): Integer
  var
    RentalLine: Record "VC Rental Line";
  begin
    RentalLine.SetRange("Rental No.", RentalNo);
    if RentalLine.FindLast() then
      exit(RentalLine."Line No." + 10000);

    exit(10000);
  end;

  local procedure GetNextCastLineNo(MovieItemNo: Code[20]): Integer
  var
    MovieCast: Record "VC Movie Cast";
  begin
    MovieCast.SetRange("Movie Item No.", MovieItemNo);
    if MovieCast.FindLast() then
      exit(MovieCast."Line No." + 10000);

    exit(10000);
  end;

  local procedure DeleteTestCatalogData()
  var
    MovieCast: Record "VC Movie Cast";
    Actor: Record "VC Actor";
    Genre: Record "VC Genre";
  begin
    MovieCast.SetFilter("Movie Item No.", 'VC-TST-MOV*');
    MovieCast.DeleteAll(true);

    Actor.SetFilter("No.", 'VC-TST-ACT*');
    Actor.DeleteAll(true);

    Genre.SetFilter(Code, 'VC-TST-GEN*');
    Genre.DeleteAll(true);
  end;

  local procedure GetNextNo(NoPrefix: Code[20]): Code[20]
  begin
    exit(CopyStr(StrSubstNo('%1-%2', NoPrefix, Format(CreateGuid(), 0, 4)), 1, 20));
  end;
}
