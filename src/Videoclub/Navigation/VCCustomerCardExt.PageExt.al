pageextension 50128 "VC Customer Card Ext" extends "Customer Card"
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
          Caption = 'Rentals';
          Image = List;
          RunObject = page "VC Rental List";
          RunPageLink = "Customer No." = field("No.");
          ToolTip = 'View all videoclub rentals for this customer.';
        }
        action("VC Open Rentals")
        {
          ApplicationArea = All;
          Caption = 'Open Rentals';
          Image = List;
          RunObject = page "VC Open Rentals";
          RunPageLink = "Customer No." = field("No.");
          ToolTip = 'View open videoclub rentals for this customer.';
        }
      }
    }
  }
}
