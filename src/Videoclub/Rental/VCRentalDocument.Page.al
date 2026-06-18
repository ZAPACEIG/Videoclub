page 50120 "VC Rental Document"
{
    Caption = 'Videoclub Rental';
    PageType = Document;
    SourceTable = "VC Rental Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the rental number.'; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; ToolTip = 'Specifies the customer number.'; }
                field("Rental Date"; Rec."Rental Date") { ApplicationArea = All; ToolTip = 'Specifies the rental date.'; }
                field("Due Date"; Rec."Due Date") { ApplicationArea = All; ToolTip = 'Specifies the due date.'; }
                field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the rental status.'; }
            }
        }
    }
}
