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
                field(Enabled; Rec.Enabled) { ApplicationArea = All; ToolTip = 'Specifies whether TMDB live integration is enabled. Tests and local imports do not require this value.'; }
                field("Base URL"; Rec."Base URL") { ApplicationArea = All; ToolTip = 'Specifies the TMDB base URL used only by the gated live placeholder.'; }
                field("Language Code"; Rec."Language Code") { ApplicationArea = All; ToolTip = 'Specifies the TMDB language code for future live calls.'; }
                field("API Key Reference"; Rec."API Key Reference") { ApplicationArea = All; ToolTip = 'Specifies the secret reference name for TMDB credentials. Do not store real secrets in source.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateSetup)
            {
                ApplicationArea = All;
                Caption = 'Validate Setup';
                Image = Check;
                ToolTip = 'Validates the TMDB setup fields without calling TMDB.';

                trigger OnAction()
                var
                    TMDBSetupMgt: Codeunit "VC TMDB Setup Mgt";
                begin
                    TMDBSetupMgt.ValidateSetup(Rec);
                    Message('TMDB setup is valid.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(ValidateSetup_Promoted; ValidateSetup) { }
        }
    }

    trigger OnOpenPage()
    var
        TMDBSetupMgt: Codeunit "VC TMDB Setup Mgt";
    begin
        TMDBSetupMgt.EnsureDefaultSetup(Rec);
    end;
}
