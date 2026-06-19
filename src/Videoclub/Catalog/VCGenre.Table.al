table 50101 "VC Genre"
{
  Caption = 'Videoclub Genre';
  DataClassification = CustomerContent;
  DrillDownPageId = "VC Genre List";
  LookupPageId = "VC Genre List";

  fields
  {
    field(1; Code; Code[20])
    {
      Caption = 'Code';
      DataClassification = CustomerContent;
    }
    field(2; Description; Text[100])
    {
      Caption = 'Description';
      DataClassification = CustomerContent;
    }
    field(3; Blocked; Boolean)
    {
      Caption = 'Blocked';
      DataClassification = CustomerContent;
    }
    field(4; "TMDB Genre ID"; Integer)
    {
      Caption = 'TMDB Genre ID';
      DataClassification = CustomerContent;
    }
  }

  keys
  {
    key(PK; Code)
    {
      Clustered = true;
    }
    key(TMDBGenreID; "TMDB Genre ID")
    {
    }
  }

  trigger OnInsert()
  begin
    TestField(Code);
    TestField(Description);
  end;

  trigger OnModify()
  begin
    TestField(Description);
  end;
}
