table 50102 "VC Actor"
{
    Caption = 'Videoclub Actor';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; }
        field(2; Name; Text[100]) { Caption = 'Name'; }
        field(3; "Birth Date"; Date) { Caption = 'Birth Date'; }
        field(4; Nationality; Text[50]) { Caption = 'Nationality'; }
        field(5; Blocked; Boolean) { Caption = 'Blocked'; }
        field(6; "TMDB Person ID"; Integer) { Caption = 'TMDB Person ID'; }
    }

    keys { key(PK; "No.") { Clustered = true; } }
}
