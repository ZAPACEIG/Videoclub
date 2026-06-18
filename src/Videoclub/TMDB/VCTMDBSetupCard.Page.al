page 50124 "VC TMDB Setup Card"
{
    Caption = 'Videoclub TMDB Setup';
    PageType = Card;
    SourceTable = "VC TMDB Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Enabled; Rec.Enabled) { ApplicationArea = All; ToolTip = 'Specifies whether TMDB integration is enabled.'; }
                field("Base URL"; Rec."Base URL") { ApplicationArea = All; ToolTip = 'Specifies the TMDB base URL.'; }
                field("Language Code"; Rec."Language Code") { ApplicationArea = All; ToolTip = 'Specifies the TMDB language code.'; }
                field("API Key Reference"; Rec."API Key Reference") { ApplicationArea = All; ToolTip = 'Specifies the secret reference for TMDB credentials.'; }
            }
        }
    }
}
