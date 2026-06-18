table 50103 "VC Movie Cast"
{
    Caption = 'Videoclub Movie Cast';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Movie Item No."; Code[20]) { Caption = 'Movie Item No.'; TableRelation = Item."No."; }
        field(2; "Line No."; Integer) { Caption = 'Line No.'; }
        field(3; "Actor No."; Code[20]) { Caption = 'Actor No.'; TableRelation = "VC Actor"."No."; }
        field(4; "Character Name"; Text[100]) { Caption = 'Character Name'; }
        field(5; Protagonist; Boolean) { Caption = 'Protagonist'; }
        field(6; "Cast Order"; Integer) { Caption = 'Cast Order'; }
    }

    keys { key(PK; "Movie Item No.", "Line No.") { Clustered = true; } }
}
