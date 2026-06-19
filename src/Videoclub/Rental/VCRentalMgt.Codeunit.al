codeunit 50135 "VC Rental Mgt"
{
    procedure RegisterRental(var RentalHeader: Record "VC Rental Header")
    var
        Customer: Record Customer;
        RentalLine: Record "VC Rental Line";
        RentalValidation: Codeunit "VC Rental Validation";
        IsHandled: Boolean;
    begin
        OnBeforeRegisterRental(RentalHeader, IsHandled);
        if IsHandled then
            exit;

        RentalValidation.ValidateCanRegister(RentalHeader);
        Customer.Get(RentalHeader."Customer No.");

        RentalHeader."Customer Name" := Customer.Name;
        RentalHeader.Status := RentalHeader.Status::Registered;
        RentalHeader."Registered Date" := WorkDate();
        RentalHeader.Modify(true);

        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        if RentalLine.FindSet(true) then
            repeat
                PrepareRegisteredLine(RentalHeader, RentalLine);
                RentalLine.Modify(true);
            until RentalLine.Next() = 0;

        OnAfterRegisterRental(RentalHeader);
    end;

    procedure RegisterReturn(var RentalHeader: Record "VC Rental Header"; ReturnDate: Date)
    var
        RentalLine: Record "VC Rental Line";
    begin
        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        RentalLine.SetFilter("Outstanding Qty.", '>0');
        if RentalLine.FindSet(true) then
            repeat
                RegisterLineReturn(RentalLine, RentalLine."Outstanding Qty.", ReturnDate);
            until RentalLine.Next() = 0;
    end;

    procedure RegisterLineReturn(var RentalLine: Record "VC Rental Line"; ReturnQty: Decimal; ReturnDate: Date)
    var
        RentalHeader: Record "VC Rental Header";
        RentalValidation: Codeunit "VC Rental Validation";
        RentalStatusMgt: Codeunit "VC Rental Status Mgt";
        IsHandled: Boolean;
    begin
        OnBeforeRegisterReturn(RentalLine, ReturnQty, ReturnDate, IsHandled);
        if IsHandled then
            exit;

        RentalValidation.ValidateCanReturn(RentalLine, ReturnQty, ReturnDate);

        RentalLine."Returned Quantity" += ReturnQty;
        RentalLine."Outstanding Qty." := RentalLine.Quantity - RentalLine."Returned Quantity";
        RentalLine."Last Return Date" := ReturnDate;
        RentalStatusMgt.UpdateLineStatus(RentalLine);

        if RentalHeader.Get(RentalLine."Rental No.") then
            RentalStatusMgt.UpdateHeaderStatus(RentalHeader);

        OnAfterRegisterReturn(RentalLine);
    end;

    procedure ReopenDraft(var RentalHeader: Record "VC Rental Header")
    var
        RentalLine: Record "VC Rental Line";
    begin
        RentalHeader.TestField(Status, RentalHeader.Status::Registered);
        RentalHeader.Status := RentalHeader.Status::Draft;
        RentalHeader."Registered Date" := 0D;
        RentalHeader.Modify(true);

        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        if RentalLine.FindSet(true) then
            repeat
                RentalLine.Status := RentalLine.Status::Draft;
                RentalLine."Outstanding Qty." := 0;
                RentalLine."Returned Quantity" := 0;
                RentalLine."Last Return Date" := 0D;
                RentalLine.Modify(true);
            until RentalLine.Next() = 0;
    end;

    local procedure PrepareRegisteredLine(RentalHeader: Record "VC Rental Header"; var RentalLine: Record "VC Rental Line")
    var
        Item: Record Item;
    begin
        Item.Get(RentalLine."Movie Item No.");
        RentalLine.Description := Item.Description;
        RentalLine."Rental Date" := RentalHeader."Rental Date";
        if RentalLine."Expected Return Date" = 0D then
            RentalLine."Expected Return Date" := RentalHeader."Due Date";
        RentalLine."Returned Quantity" := 0;
        RentalLine."Outstanding Qty." := RentalLine.Quantity;
        RentalLine.Status := RentalLine.Status::Outstanding;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRegisterRental(var RentalHeader: Record "VC Rental Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRegisterRental(RentalHeader: Record "VC Rental Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRegisterReturn(var RentalLine: Record "VC Rental Line"; ReturnQty: Decimal; ReturnDate: Date; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRegisterReturn(RentalLine: Record "VC Rental Line")
    begin
    end;
}
