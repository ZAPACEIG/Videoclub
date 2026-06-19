codeunit 50134 "VC Rental Status Mgt"
{
    procedure UpdateLineStatus(var RentalLine: Record "VC Rental Line")
    begin
        if RentalLine."Outstanding Qty." <= 0 then
            RentalLine.Status := RentalLine.Status::Returned
        else
            if RentalLine."Returned Quantity" > 0 then
                RentalLine.Status := RentalLine.Status::"Partially Returned"
            else
                RentalLine.Status := RentalLine.Status::Outstanding;

        RentalLine.Modify(true);
    end;

    procedure UpdateHeaderStatus(var RentalHeader: Record "VC Rental Header")
    var
        RentalLine: Record "VC Rental Line";
        HasOutstanding: Boolean;
        HasReturned: Boolean;
        HasLines: Boolean;
    begin
        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        if RentalLine.FindSet() then
            repeat
                HasLines := true;
                if RentalLine."Outstanding Qty." > 0 then
                    HasOutstanding := true;
                if RentalLine."Returned Quantity" > 0 then
                    HasReturned := true;
            until RentalLine.Next() = 0;

        if not HasLines then
            exit;

        if HasOutstanding and HasReturned then
            RentalHeader.Status := RentalHeader.Status::"Partially Returned"
        else
            if HasOutstanding then
                RentalHeader.Status := RentalHeader.Status::Registered
            else
                RentalHeader.Status := RentalHeader.Status::Returned;

        RentalHeader.Modify(true);
    end;

    procedure IsHeaderOverdue(var RentalHeader: Record "VC Rental Header"; ReferenceDate: Date): Boolean
    var
        RentalLine: Record "VC Rental Line";
    begin
        if ReferenceDate = 0D then
            ReferenceDate := WorkDate();
        if (RentalHeader.Status <> RentalHeader.Status::Registered) and (RentalHeader.Status <> RentalHeader.Status::"Partially Returned") then
            exit(false);
        if (RentalHeader."Due Date" <> 0D) and (RentalHeader."Due Date" < ReferenceDate) then
            exit(HeaderHasOutstandingLines(RentalHeader."No."));

        RentalLine.SetRange("Rental No.", RentalHeader."No.");
        RentalLine.SetFilter("Outstanding Qty.", '>0');
        RentalLine.SetFilter("Expected Return Date", '<%1&<>%2', ReferenceDate, 0D);
        exit(not RentalLine.IsEmpty());
    end;

    procedure IsLineOverdue(var RentalLine: Record "VC Rental Line"; ReferenceDate: Date): Boolean
    begin
        if ReferenceDate = 0D then
            ReferenceDate := WorkDate();
        if (RentalLine.Status <> RentalLine.Status::Outstanding) and (RentalLine.Status <> RentalLine.Status::"Partially Returned") then
            exit(false);
        if RentalLine."Outstanding Qty." <= 0 then
            exit(false);
        if RentalLine."Expected Return Date" = 0D then
            exit(false);

        exit(RentalLine."Expected Return Date" < ReferenceDate);
    end;

    local procedure HeaderHasOutstandingLines(RentalNo: Code[20]): Boolean
    var
        RentalLine: Record "VC Rental Line";
    begin
        RentalLine.SetRange("Rental No.", RentalNo);
        RentalLine.SetFilter("Outstanding Qty.", '>0');
        exit(not RentalLine.IsEmpty());
    end;
}
