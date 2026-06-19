page 50123 "VC Overdue Rentals"
{
  Caption = 'Overdue Videoclub Rentals';
  PageType = List;
  SourceTable = "VC Rental Header";
  SourceTableView = where(Status = filter(Registered | "Partially Returned"));
  UsageCategory = Lists;
  ApplicationArea = All;
  CardPageId = "VC Rental Document";
  Editable = false;

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the rental number.'; }
        field("Customer No."; Rec."Customer No.") { ApplicationArea = All; ToolTip = 'Specifies the customer number.'; }
        field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; ToolTip = 'Specifies the customer name copied to the rental.'; }
        field("Rental Date"; Rec."Rental Date") { ApplicationArea = All; ToolTip = 'Specifies the rental date.'; }
        field("Due Date"; Rec."Due Date") { ApplicationArea = All; ToolTip = 'Specifies the due date.'; }
        field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the rental status.'; }
      }
    }
  }

  trigger OnOpenPage()
  begin
    Rec.SetFilter("Due Date", '<%1&<>%2', WorkDate(), 0D);
  end;
}
