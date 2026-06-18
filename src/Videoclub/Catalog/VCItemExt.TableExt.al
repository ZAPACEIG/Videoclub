tableextension 50100 "VC Item Ext" extends Item
{
    fields
    {
        field(50100; "VC Is Movie"; Boolean) { Caption = 'Is Movie'; DataClassification = CustomerContent; }
        field(50101; "VC Release Year"; Integer) { Caption = 'Release Year'; DataClassification = CustomerContent; MinValue = 1888; }
        field(50102; "VC Director"; Text[100]) { Caption = 'Director'; DataClassification = CustomerContent; }
        field(50103; "VC Duration Minutes"; Integer) { Caption = 'Duration Minutes'; DataClassification = CustomerContent; MinValue = 0; }
        field(50104; "VC Primary Genre Code"; Code[20]) { Caption = 'Primary Genre Code'; TableRelation = "VC Genre".Code; DataClassification = CustomerContent; }
        field(50105; "VC Secondary Genre Code"; Code[20]) { Caption = 'Secondary Genre Code'; TableRelation = "VC Genre".Code; DataClassification = CustomerContent; }
        field(50106; "VC Synopsis"; Text[2048]) { Caption = 'Synopsis'; DataClassification = CustomerContent; }
        field(50107; "VC Age Rating"; Code[20]) { Caption = 'Age Rating'; DataClassification = CustomerContent; }
        field(50108; "VC Original Language"; Code[10]) { Caption = 'Original Language'; DataClassification = CustomerContent; }
        field(50109; "VC Poster URL"; Text[250]) { Caption = 'Poster URL'; ExtendedDatatype = URL; DataClassification = CustomerContent; }
        field(50110; "VC TMDB ID"; Integer) { Caption = 'TMDB ID'; DataClassification = CustomerContent; }
        field(50111; "VC Rental Copies"; Decimal) { Caption = 'Rental Copies'; DecimalPlaces = 0 : 0; MinValue = 0; DataClassification = CustomerContent; }
        field(50112; "VC Rented Quantity"; Decimal) { Caption = 'Rented Quantity'; FieldClass = FlowField; CalcFormula = sum("VC Rental Line"."Outstanding Qty." where("Movie Item No." = field("No."))); }
        field(50114; "VC Rentable"; Boolean) { Caption = 'Rentable'; InitValue = true; DataClassification = CustomerContent; }
    }
}
