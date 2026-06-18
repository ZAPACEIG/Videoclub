page 50119 "VC Rental List"
{
    Caption = 'Videoclub Rentals';
    PageType = List;
    SourceTable = "VC Rental Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "VC Rental Document";

    layout
    {
        area(Content)
        {
            repeater(General)
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
