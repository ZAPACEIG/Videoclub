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
    }

    keys { key(PK; "No.") { Clustered = true; } }
}
