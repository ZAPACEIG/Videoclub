page 50112 "VC Genre List"
{
    Caption = 'Videoclub Genres';
    PageType = List;
    SourceTable = "VC Genre";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { ApplicationArea = All; ToolTip = 'Specifies the genre code.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the genre description.'; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; ToolTip = 'Specifies whether the genre is blocked.'; }
                field("TMDB Genre ID"; Rec."TMDB Genre ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB genre identifier.'; }
            }
        }
    }
}
