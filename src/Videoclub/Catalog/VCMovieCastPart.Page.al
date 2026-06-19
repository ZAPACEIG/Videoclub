page 50115 "VC Movie Cast Part"
{
  Caption = 'Movie Cast';
  PageType = ListPart;
  SourceTable = "VC Movie Cast";
  ApplicationArea = All;
  AutoSplitKey = true;

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("Actor No."; Rec."Actor No.") { ApplicationArea = All; ToolTip = 'Specifies the actor number.'; }
        field("Character Name"; Rec."Character Name") { ApplicationArea = All; ToolTip = 'Specifies the character name.'; }
        field("Cast Order"; Rec."Cast Order") { ApplicationArea = All; ToolTip = 'Specifies the cast order.'; }
        field("TMDB Credit ID"; Rec."TMDB Credit ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB credit identifier.'; }
      }
    }
  }
}
