page 50121 "VC Rental Lines Part"
{
  Caption = 'Rental Lines';
  PageType = ListPart;
  SourceTable = "VC Rental Line";
  ApplicationArea = All;
  AutoSplitKey = true;

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("Movie Item No."; Rec."Movie Item No.") { ApplicationArea = All; ToolTip = 'Specifies the rented movie item number.'; }
        field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the movie description copied to the rental line.'; }
        field(Quantity; Rec.Quantity) { ApplicationArea = All; ToolTip = 'Specifies the rented quantity.'; }
        field("Returned Quantity"; Rec."Returned Quantity") { ApplicationArea = All; ToolTip = 'Specifies the quantity already returned.'; }
        field("Outstanding Qty."; Rec."Outstanding Qty.") { ApplicationArea = All; ToolTip = 'Specifies the quantity still outstanding.'; }
        field("Rental Date"; Rec."Rental Date") { ApplicationArea = All; ToolTip = 'Specifies the rental date copied to the line.'; }
        field("Expected Return Date"; Rec."Expected Return Date") { ApplicationArea = All; ToolTip = 'Specifies the expected return date for the line.'; }
        field("Last Return Date"; Rec."Last Return Date") { ApplicationArea = All; ToolTip = 'Specifies the last return date for the line.'; }
        field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the rental line status.'; }
      }
    }
  }

  actions
  {
    area(Processing)
    {
      action("VC Register Line Return")
      {
        ApplicationArea = All;
        Caption = 'Register Line Return';
        Image = Return;
        ToolTip = 'Register the return of the outstanding quantity on the selected line.';

        trigger OnAction()
        var
          RentalMgt: Codeunit "VC Rental Mgt";
        begin
          RentalMgt.RegisterLineReturn(Rec, Rec."Outstanding Qty.", WorkDate());
          CurrPage.Update(false);
        end;
      }
    }
  }
}
