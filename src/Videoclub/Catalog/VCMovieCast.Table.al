table 50103 "VC Movie Cast"
{
  Caption = 'Videoclub Movie Cast';
  DataClassification = CustomerContent;

  fields
  {
    field(1; "Movie Item No."; Code[20])
    {
      Caption = 'Movie Item No.';
      TableRelation = Item."No." where("VC Is Movie" = const(true));
      DataClassification = CustomerContent;
    }
    field(2; "Line No."; Integer)
    {
      Caption = 'Line No.';
      DataClassification = CustomerContent;
    }
    field(3; "Actor No."; Code[20])
    {
      Caption = 'Actor No.';
      TableRelation = "VC Actor"."No." where(Blocked = const(false));
      DataClassification = CustomerContent;
    }
    field(4; "Character Name"; Text[100])
    {
      Caption = 'Character Name';
      DataClassification = CustomerContent;
    }
    field(5; "Cast Order"; Integer)
    {
      Caption = 'Cast Order';
      DataClassification = CustomerContent;
      MinValue = 0;
    }
    field(6; "TMDB Credit ID"; Text[50])
    {
      Caption = 'TMDB Credit ID';
      DataClassification = CustomerContent;
    }
  }

  keys
  {
    key(PK; "Movie Item No.", "Line No.")
    {
      Clustered = true;
    }
    key(ActorMovie; "Actor No.", "Movie Item No.")
    {
    }
    key(CastOrder; "Movie Item No.", "Cast Order")
    {
    }
  }

  trigger OnInsert()
  begin
    TestField("Movie Item No.");
    TestField("Line No.");
    TestField("Actor No.");
    ValidateMovieItem();
    ValidateActor();
  end;

  trigger OnModify()
  begin
    ValidateMovieItem();
    ValidateActor();
  end;

  local procedure ValidateMovieItem()
  var
    Item: Record Item;
  begin
    Item.Get("Movie Item No.");
    Item.TestField("VC Is Movie", true);
  end;

  local procedure ValidateActor()
  var
    Actor: Record "VC Actor";
  begin
    Actor.Get("Actor No.");
    Actor.TestField(Blocked, false);
  end;
}
