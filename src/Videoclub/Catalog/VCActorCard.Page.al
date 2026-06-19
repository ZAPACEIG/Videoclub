page 50114 "VC Actor Card"
{
  Caption = 'Videoclub Actor';
  PageType = Card;
  SourceTable = "VC Actor";
  ApplicationArea = All;

  layout
  {
    area(Content)
    {
      group(General)
      {
        field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the actor number.'; }
        field(Name; Rec.Name) { ApplicationArea = All; ToolTip = 'Specifies the actor name.'; }
        field("Birth Date"; Rec."Birth Date") { ApplicationArea = All; ToolTip = 'Specifies the actor birth date.'; }
        field(Nationality; Rec.Nationality) { ApplicationArea = All; ToolTip = 'Specifies the actor nationality.'; }
        field(Blocked; Rec.Blocked) { ApplicationArea = All; ToolTip = 'Specifies whether the actor is blocked.'; }
        field("TMDB Person ID"; Rec."TMDB Person ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB person identifier.'; }
      }
      group(Biography)
      {
        field(BiographyText; Rec.Biography) { ApplicationArea = All; MultiLine = true; ToolTip = 'Specifies the actor biography.'; }
      }
      part(Films; "VC Actor Films Part")
      {
        ApplicationArea = All;
        SubPageLink = "Actor No." = field("No.");
      }
    }
  }
}
