table 50107 "VC TMDB Import Log"
{
    Caption = 'Videoclub TMDB Import Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(2; Operation; Enum "VC TMDB Operation") { Caption = 'Operation'; }
        field(3; Status; Enum "VC Integration Status") { Caption = 'Status'; }
        field(4; "Movie Item No."; Code[20]) { Caption = 'Movie Item No.'; TableRelation = Item."No."; }
        field(5; "TMDB ID"; Integer) { Caption = 'TMDB ID'; }
        field(6; Message; Text[250]) { Caption = 'Message'; }
        field(7; Details; Text[2048]) { Caption = 'Details'; }
        field(8; "Created At"; DateTime) { Caption = 'Created At'; }
    }

    keys { key(PK; "Entry No.") { Clustered = true; } }
}
