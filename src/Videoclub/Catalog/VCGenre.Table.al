table 50101 "VC Genre"
{
    Caption = 'Videoclub Genre';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20]) { Caption = 'Code'; }
        field(2; Description; Text[100]) { Caption = 'Description'; }
        field(3; Blocked; Boolean) { Caption = 'Blocked'; }
        field(4; "TMDB Genre ID"; Integer) { Caption = 'TMDB Genre ID'; }
    }

    keys { key(PK; Code) { Clustered = true; } }
}
