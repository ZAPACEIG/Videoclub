page 50113 "VC Actor List"
{
  Caption = 'Videoclub Actors';
  PageType = List;
  SourceTable = "VC Actor";
  UsageCategory = Lists;
  ApplicationArea = All;
  CardPageId = "VC Actor Card";

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the actor number.'; }
        field(Name; Rec.Name) { ApplicationArea = All; ToolTip = 'Specifies the actor name.'; }
        field("Birth Date"; Rec."Birth Date") { ApplicationArea = All; ToolTip = 'Specifies the actor birth date.'; }
        field(Nationality; Rec.Nationality) { ApplicationArea = All; ToolTip = 'Specifies the actor nationality.'; }
        field(Blocked; Rec.Blocked) { ApplicationArea = All; ToolTip = 'Specifies whether the actor is blocked.'; }
        field("TMDB Person ID"; Rec."TMDB Person ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB person identifier.'; }
      }
    }
  }
}
