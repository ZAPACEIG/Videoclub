pageextension 50129 "VC Customer List Ext" extends "Customer List"
{
  actions
  {
    addlast(Navigation)
    {
      group("VC Videoclub")
      {
        Caption = 'Videoclub';
        Image = Video;
        action("VC Rentals")
        {
          ApplicationArea = All;
          Caption = 'Rental History';
          Image = List;
          RunObject = page "VC Rental List";
          RunPageLink = "Customer No." = field("No.");
          ToolTip = 'View videoclub rental history for the selected customer.';
        }
        action("VC Open Rentals")
        {
          ApplicationArea = All;
          Caption = 'Open Rentals';
          Image = List;
          RunObject = page "VC Open Rentals";
          RunPageLink = "Customer No." = field("No.");
          ToolTip = 'View open videoclub rentals for the selected customer.';
        }
      }
    }
  }
}
