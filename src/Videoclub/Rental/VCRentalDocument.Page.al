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
        Caption = 'General';
        field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the rental number.'; }
        field("Customer No."; Rec."Customer No.") { ApplicationArea = All; ToolTip = 'Specifies the customer number.'; }
        field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; ToolTip = 'Specifies the customer name copied to the rental.'; }
        field("Rental Date"; Rec."Rental Date") { ApplicationArea = All; ToolTip = 'Specifies the rental date.'; }
        field("Due Date"; Rec."Due Date") { ApplicationArea = All; ToolTip = 'Specifies the due date.'; }
        field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the rental status.'; }
        field("Registered Date"; Rec."Registered Date") { ApplicationArea = All; ToolTip = 'Specifies the date when the rental was registered.'; }
      }
      part(Lines; "VC Rental Lines Part")
      {
        ApplicationArea = All;
        SubPageLink = "Rental No." = field("No.");
        UpdatePropagation = Both;
      }
    }
  }

  actions
  {
    area(Processing)
    {
      action("VC Register Rental")
      {
        ApplicationArea = All;
        Caption = 'Register Rental';
        Image = Register;
        Promoted = true;
        PromotedCategory = Process;
        PromotedIsBig = true;
        ToolTip = 'Register the rental document and mark its lines as outstanding.';

        trigger OnAction()
        var
          RentalMgt: Codeunit "VC Rental Mgt";
        begin
          RentalMgt.RegisterRental(Rec);
          CurrPage.Update(false);
        end;
      }
      action("VC Register Return")
      {
        ApplicationArea = All;
        Caption = 'Register Return';
        Image = Return;
        Promoted = true;
        PromotedCategory = Process;
        ToolTip = 'Register the return of all outstanding quantities on this rental document.';

        trigger OnAction()
        var
          RentalMgt: Codeunit "VC Rental Mgt";
        begin
          RentalMgt.RegisterReturn(Rec, WorkDate());
          CurrPage.Update(false);
        end;
      }
    }
    area(Navigation)
    {
      action("VC Customer Rentals")
      {
        ApplicationArea = All;
        Caption = 'Customer Rentals';
        Image = Customer;
        RunObject = page "VC Rental List";
        RunPageLink = "Customer No." = field("Customer No.");
        ToolTip = 'View rentals for the selected customer.';
      }
    }
  }
}
