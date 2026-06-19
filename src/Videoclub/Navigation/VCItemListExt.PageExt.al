pageextension 50127 "VC Item List Ext" extends "Item List"
{
  layout
  {
    addlast(Control1)
    {
      field("VC Is Movie"; Rec."VC Is Movie") { ApplicationArea = All; ToolTip = 'Specifies that the item is managed as a movie.'; }
      field("VC Rentable"; Rec."VC Rentable") { ApplicationArea = All; ToolTip = 'Specifies whether the movie can be rented.'; }
      field("VC Rental Copies"; Rec."VC Rental Copies") { ApplicationArea = All; ToolTip = 'Specifies the number of physical rental copies.'; }
      field("VC Rented Quantity"; Rec."VC Rented Quantity") { ApplicationArea = All; ToolTip = 'Specifies the quantity currently rented.'; }
    }
  }

  actions
  {
    addlast(Processing)
    {
      action("VC Movie List")
      {
        ApplicationArea = All;
        Caption = 'Videoclub Movies';
        Image = List;
        RunObject = page "VC Movie List";
        ToolTip = 'Open the filtered list of videoclub movies.';
      }
      action("VC Open Movie Card")
      {
        ApplicationArea = All;
        Caption = 'Open Movie Card';
        Image = Video;
        ToolTip = 'Open the selected item in the videoclub movie card.';

        trigger OnAction()
        begin
          Page.Run(Page::"VC Movie Card", Rec);
        end;
      }
    }
  }
}
