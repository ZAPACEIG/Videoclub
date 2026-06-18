codeunit 50132 "VC Availability Mgt"
{
    procedure GetAvailableQuantity(MovieItemNo: Code[20]): Decimal
    var
        AvailableQty: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateAvailability(MovieItemNo, AvailableQty, IsHandled);
        if IsHandled then
            exit(AvailableQty);

        // Bootstrap scaffold only. Availability calculation is pending implementation.
        OnAfterCalculateAvailability(MovieItemNo, AvailableQty);
        exit(AvailableQty);
    end;

    procedure CheckAvailability(MovieItemNo: Code[20]; Quantity: Decimal)
    begin
        // Bootstrap scaffold only.
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateAvailability(MovieItemNo: Code[20]; var AvailableQty: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateAvailability(MovieItemNo: Code[20]; AvailableQty: Decimal)
    begin
    end;
}
