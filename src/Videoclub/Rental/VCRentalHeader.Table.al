table 50104 "VC Rental Header"
{
    Caption = 'Videoclub Rental Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; }
        field(2; "Customer No."; Code[20]) { Caption = 'Customer No.'; TableRelation = Customer."No."; }
        field(3; "Rental Date"; Date) { Caption = 'Rental Date'; }
        field(4; "Due Date"; Date) { Caption = 'Due Date'; }
        field(5; Status; Enum "VC Rental Status") { Caption = 'Status'; }
        field(6; "Customer Name"; Text[100]) { Caption = 'Customer Name'; Editable = false; DataClassification = CustomerContent; }
        field(7; "Registered Date"; Date) { Caption = 'Registered Date'; Editable = false; DataClassification = CustomerContent; }
    }

    keys { key(PK; "No.") { Clustered = true; } }
}
