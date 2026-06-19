table 50102 "VC Actor"
{
  Caption = 'Videoclub Actor';
  DataClassification = CustomerContent;
  DrillDownPageId = "VC Actor List";
  LookupPageId = "VC Actor List";

  fields
  {
    field(1; "No."; Code[20])
    {
      Caption = 'No.';
      DataClassification = CustomerContent;
    }
    field(2; Name; Text[100])
    {
      Caption = 'Name';
      DataClassification = CustomerContent;
    }
    field(3; "Birth Date"; Date)
    {
      Caption = 'Birth Date';
      DataClassification = CustomerContent;
    }
    field(4; Nationality; Text[50])
    {
      Caption = 'Nationality';
      DataClassification = CustomerContent;
    }
    field(5; Biography; Text[2048])
    {
      Caption = 'Biography';
      DataClassification = CustomerContent;
    }
    field(6; "TMDB Person ID"; Integer)
    {
      Caption = 'TMDB Person ID';
      DataClassification = CustomerContent;
    }
    field(7; Blocked; Boolean)
    {
      Caption = 'Blocked';
      DataClassification = CustomerContent;
    }
  }

  keys
  {
    key(PK; "No.")
    {
      Clustered = true;
    }
    key(Name; Name)
    {
    }
    key(TMDBPersonID; "TMDB Person ID")
    {
    }
  }

  trigger OnInsert()
  begin
    TestField("No.");
    TestField(Name);
  end;

  trigger OnModify()
  begin
    TestField(Name);
  end;
}
