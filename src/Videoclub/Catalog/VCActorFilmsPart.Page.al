page 50118 "VC Actor Films Part"
{
  Caption = 'Actor Films';
  PageType = ListPart;
  SourceTable = "VC Movie Cast";
  ApplicationArea = All;
  Editable = false;

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("Movie Item No."; Rec."Movie Item No.") { ApplicationArea = All; ToolTip = 'Specifies the movie item number.'; }
        field("Character Name"; Rec."Character Name") { ApplicationArea = All; ToolTip = 'Specifies the character name.'; }
        field("Cast Order"; Rec."Cast Order") { ApplicationArea = All; ToolTip = 'Specifies the cast order.'; }
        field("TMDB Credit ID"; Rec."TMDB Credit ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB credit identifier.'; }
      }
    }
  }
}
