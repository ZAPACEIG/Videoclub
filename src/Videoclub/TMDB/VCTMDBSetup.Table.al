table 50106 "VC TMDB Setup"
{
    Caption = 'Videoclub TMDB Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { Caption = 'Primary Key'; }
        field(2; Enabled; Boolean) { Caption = 'Enabled'; }
        field(3; "Base URL"; Text[250]) { Caption = 'Base URL'; ExtendedDatatype = URL; }
        field(4; "Language Code"; Code[10]) { Caption = 'Language Code'; }
        field(5; "API Key Reference"; Text[250]) { Caption = 'API Key Reference'; DataClassification = EndUserIdentifiableInformation; }
    }

    keys { key(PK; "Primary Key") { Clustered = true; } }
}
