table 50105 "VC Rental Line"
{
    Caption = 'Videoclub Rental Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Rental No."; Code[20]) { Caption = 'Rental No.'; TableRelation = "VC Rental Header"."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; }
        field(3; "Movie Item No."; Code[20]) { Caption = 'Movie Item No.'; TableRelation = Item."No."; }
        field(4; Quantity; Decimal) { Caption = 'Quantity'; DecimalPlaces = 0 : 0; MinValue = 0; }
        field(5; "Expected Return Date"; Date) { Caption = 'Expected Return Date'; }
        field(6; "Last Return Date"; Date) { Caption = 'Last Return Date'; }
        field(7; "Returned Quantity"; Decimal) { Caption = 'Returned Quantity'; DecimalPlaces = 0 : 0; MinValue = 0; }
        field(8; "Outstanding Qty."; Decimal) { Caption = 'Outstanding Qty.'; DecimalPlaces = 0 : 0; MinValue = 0; }
        field(9; Status; Enum "VC Rental Line Status") { Caption = 'Status'; }
        field(10; Description; Text[100]) { Caption = 'Description'; DataClassification = CustomerContent; }
        field(11; "Rental Date"; Date) { Caption = 'Rental Date'; DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Rental No.", "Line No.") { Clustered = true; }
        key(MovieStatus; "Movie Item No.", Status) { SumIndexFields = "Outstanding Qty."; }
    }
}
