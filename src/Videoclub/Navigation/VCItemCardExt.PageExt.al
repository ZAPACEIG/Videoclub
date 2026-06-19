pageextension 50126 "VC Item Card Ext" extends "Item Card"
{
  layout
  {
    addlast(Content)
    {
      group("VC Videoclub")
      {
        Caption = 'Videoclub';
        field("VC Is Movie"; Rec."VC Is Movie") { ApplicationArea = All; ToolTip = 'Specifies that the item is managed as a movie.'; }
        field("VC Rentable"; Rec."VC Rentable") { ApplicationArea = All; ToolTip = 'Specifies whether the movie can be rented.'; }
        field("VC Rental Copies"; Rec."VC Rental Copies") { ApplicationArea = All; ToolTip = 'Specifies the number of physical rental copies.'; }
        field("VC Rented Quantity"; Rec."VC Rented Quantity") { ApplicationArea = All; ToolTip = 'Specifies the quantity currently rented.'; }
        field("VC Release Year"; Rec."VC Release Year") { ApplicationArea = All; ToolTip = 'Specifies the movie release year.'; }
        field("VC Director"; Rec."VC Director") { ApplicationArea = All; ToolTip = 'Specifies the movie director.'; }
        field("VC Primary Genre Code"; Rec."VC Primary Genre Code") { ApplicationArea = All; ToolTip = 'Specifies the primary genre.'; }
        field("VC Secondary Genre Code"; Rec."VC Secondary Genre Code") { ApplicationArea = All; ToolTip = 'Specifies the secondary genre.'; }
      }
    }
  }

  actions
  {
    addlast(Processing)
    {
      action("VC Mark as Movie")
      {
        ApplicationArea = All;
        Caption = 'Mark as Movie';
        Image = Video;
        ToolTip = 'Set videoclub defaults on this item.';

        trigger OnAction()
        var
          MovieMgt: Codeunit "VC Movie Mgt";
        begin
          MovieMgt.SetMovieDefaults(Rec);
          Rec.Modify(true);
        end;
      }
      action("VC Open Movie Card")
      {
        ApplicationArea = All;
        Caption = 'Open Movie Card';
        Image = Video;
        ToolTip = 'Open this item in the videoclub movie card.';

        trigger OnAction()
        begin
          Page.Run(Page::"VC Movie Card", Rec);
        end;
      }
    }
  }
}
