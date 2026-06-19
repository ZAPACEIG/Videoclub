codeunit 50132 "VC Availability Mgt"
{
    procedure GetRentedQuantity(MovieItemNo: Code[20]): Decimal
    var
        RentalLine: Record "VC Rental Line";
        RentedQty: Decimal;
    begin
        RentalLine.SetRange("Movie Item No.", MovieItemNo);
        RentalLine.SetFilter(Status, '%1|%2', RentalLine.Status::Outstanding, RentalLine.Status::"Partially Returned");
        RentalLine.CalcSums("Outstanding Qty.");
        RentedQty := RentalLine."Outstanding Qty.";
        exit(RentedQty);
    end;

    procedure GetAvailableQuantity(MovieItemNo: Code[20]): Decimal
    var
        Item: Record Item;
        AvailableQty: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateAvailability(MovieItemNo, AvailableQty, IsHandled);
        if IsHandled then
            exit(AvailableQty);

        Item.Get(MovieItemNo);
        AvailableQty := Item."VC Rental Copies" - GetRentedQuantity(MovieItemNo);

        OnAfterCalculateAvailability(MovieItemNo, AvailableQty);
        exit(AvailableQty);
    end;

    procedure AssertAvailable(MovieItemNo: Code[20]; Quantity: Decimal; ExcludeDocumentNo: Code[20])
    var
        AvailableQty: Decimal;
    begin
        AvailableQty := GetAvailableQuantityExcludingDocument(MovieItemNo, ExcludeDocumentNo);
        if Quantity > AvailableQty then
            Error(InsufficientAvailabilityErr, MovieItemNo, Quantity, AvailableQty);
    end;

    procedure CheckAvailability(MovieItemNo: Code[20]; Quantity: Decimal)
    begin
        AssertAvailable(MovieItemNo, Quantity, '');
    end;

    local procedure GetAvailableQuantityExcludingDocument(MovieItemNo: Code[20]; ExcludeDocumentNo: Code[20]): Decimal
    var
        Item: Record Item;
    begin
        Item.Get(MovieItemNo);
        exit(Item."VC Rental Copies" - GetRentedQuantityExcludingDocument(MovieItemNo, ExcludeDocumentNo));
    end;

    local procedure GetRentedQuantityExcludingDocument(MovieItemNo: Code[20]; ExcludeDocumentNo: Code[20]): Decimal
    var
        RentalLine: Record "VC Rental Line";
    begin
        RentalLine.SetRange("Movie Item No.", MovieItemNo);
        RentalLine.SetFilter(Status, '%1|%2', RentalLine.Status::Outstanding, RentalLine.Status::"Partially Returned");
        if ExcludeDocumentNo <> '' then
            RentalLine.SetFilter("Rental No.", '<>%1', ExcludeDocumentNo);
        RentalLine.CalcSums("Outstanding Qty.");
        exit(RentalLine."Outstanding Qty.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateAvailability(MovieItemNo: Code[20]; var AvailableQty: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateAvailability(MovieItemNo: Code[20]; AvailableQty: Decimal)
    begin
    end;

    var
        InsufficientAvailabilityErr: Label 'Movie %1 does not have enough available copies. Requested: %2. Available: %3.', Comment = '%1 = movie item number, %2 = requested quantity, %3 = available quantity';
}
