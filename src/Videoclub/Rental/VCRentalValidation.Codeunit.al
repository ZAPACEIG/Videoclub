codeunit 50133 "VC Rental Validation"
{
    procedure ValidateCanRegister(var RentalHeader: Record "VC Rental Header")
    var
        Customer: Record Customer;
        RentalLine: Record "VC Rental Line";
        AvailabilityMgt: Codeunit "VC Availability Mgt";
        MovieMgt: Codeunit "VC Movie Mgt";
        TotalDocumentQty: Decimal;
    begin
        RentalHeader.TestField(Status, RentalHeader.Status::Draft);
        RentalHeader.TestField("Customer No.");
        if not Customer.Get(RentalHeader."Customer No.") then
            Error(CustomerDoesNotExistErr, RentalHeader."Customer No.");
        RentalHeader.TestField("Rental Date");
        RentalHeader.TestField("Due Date");
        if RentalHeader."Due Date" < RentalHeader."Rental Date" then
            Error(DueDateBeforeRentalDateErr);

        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        if not RentalLine.FindSet() then
            Error(NoRentalLinesErr, RentalHeader."No.");

        repeat
            RentalLine.TestField("Movie Item No.");
            RentalLine.TestField(Quantity);
            if RentalLine.Quantity <= 0 then
                Error(QuantityMustBePositiveErr, RentalLine."Line No.");

            MovieMgt.ValidateMovieIsRentable(RentalLine."Movie Item No.");
            TotalDocumentQty := GetDocumentQuantity(RentalHeader."No.", RentalLine."Movie Item No.");
            AvailabilityMgt.AssertAvailable(RentalLine."Movie Item No.", TotalDocumentQty, RentalHeader."No.");
        until RentalLine.Next() = 0;
    end;

    procedure ValidateCanReturn(var RentalLine: Record "VC Rental Line"; ReturnQty: Decimal; ReturnDate: Date)
    begin
        if ReturnQty <= 0 then
            Error(ReturnQuantityMustBePositiveErr);
        if ReturnQty > RentalLine."Outstanding Qty." then
            Error(ReturnQuantityExceedsOutstandingErr, ReturnQty, RentalLine."Outstanding Qty.");
        if RentalLine.Status = RentalLine.Status::Returned then
            Error(ReturnQuantityExceedsOutstandingErr, ReturnQty, RentalLine."Outstanding Qty.");
        if RentalLine.Status = RentalLine.Status::Draft then
            Error(CannotReturnDraftLineErr);
        if ReturnDate = 0D then
            Error(ReturnDateRequiredErr);
    end;

    local procedure GetDocumentQuantity(RentalNo: Code[20]; MovieItemNo: Code[20]): Decimal
    var
        RentalLine: Record "VC Rental Line";
    begin
        RentalLine.SetRange("Rental No.", RentalNo);
        RentalLine.SetRange("Movie Item No.", MovieItemNo);
        RentalLine.CalcSums(Quantity);
        exit(RentalLine.Quantity);
    end;

    var
        CustomerDoesNotExistErr: Label 'Rental customer %1 does not exist.', Comment = '%1 = customer number';
        NoRentalLinesErr: Label 'Rental %1 must have at least one line.', Comment = '%1 = rental number';
        QuantityMustBePositiveErr: Label 'Rental line %1 quantity must be greater than zero.', Comment = '%1 = line number';
        DueDateBeforeRentalDateErr: Label 'Due date cannot be before rental date.';
        ReturnQuantityMustBePositiveErr: Label 'Return quantity must be greater than zero.';
        ReturnQuantityExceedsOutstandingErr: Label 'Return quantity %1 exceeds outstanding quantity %2.', Comment = '%1 = return quantity, %2 = outstanding quantity';
        CannotReturnDraftLineErr: Label 'Draft rental lines cannot be returned.';
        ReturnDateRequiredErr: Label 'Return date is required.';
}
