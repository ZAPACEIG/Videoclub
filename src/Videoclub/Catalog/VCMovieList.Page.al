page 50116 "VC Movie List"
{
    Caption = 'Videoclub Movies';
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("VC Is Movie" = const(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the item number.'; }
                field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the movie title.'; }
                field("VC Release Year"; Rec."VC Release Year") { ApplicationArea = All; ToolTip = 'Specifies the release year.'; }
                field("VC Director"; Rec."VC Director") { ApplicationArea = All; ToolTip = 'Specifies the director.'; }
                field("VC Rental Copies"; Rec."VC Rental Copies") { ApplicationArea = All; ToolTip = 'Specifies the number of rental copies.'; }
                field("VC Rentable"; Rec."VC Rentable") { ApplicationArea = All; ToolTip = 'Specifies whether this movie can be rented.'; }
            }
        }
    }
}
