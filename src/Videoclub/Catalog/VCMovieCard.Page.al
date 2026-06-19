page 50117 "VC Movie Card"
{
  Caption = 'Videoclub Movie';
  PageType = Card;
  SourceTable = Item;
  SourceTableView = where("VC Is Movie" = const(true));
  ApplicationArea = All;

  layout
  {
    area(Content)
    {
      group(General)
      {
        field("No."; Rec."No.") { ApplicationArea = All; ToolTip = 'Specifies the item number.'; }
        field(Description; Rec.Description) { ApplicationArea = All; ToolTip = 'Specifies the movie title.'; }
        field("VC Is Movie"; Rec."VC Is Movie") { ApplicationArea = All; ToolTip = 'Specifies that this item is a movie.'; }
        field("VC Rentable"; Rec."VC Rentable") { ApplicationArea = All; ToolTip = 'Specifies whether this movie can be rented.'; }
        field("VC Rental Copies"; Rec."VC Rental Copies") { ApplicationArea = All; ToolTip = 'Specifies the number of rental copies.'; }
        field("VC Rented Quantity"; Rec."VC Rented Quantity") { ApplicationArea = All; ToolTip = 'Specifies the quantity currently rented.'; }
      }
      group(Details)
      {
        field("VC Release Year"; Rec."VC Release Year") { ApplicationArea = All; ToolTip = 'Specifies the release year.'; }
        field("VC Director"; Rec."VC Director") { ApplicationArea = All; ToolTip = 'Specifies the director.'; }
        field("VC Duration Minutes"; Rec."VC Duration Minutes") { ApplicationArea = All; ToolTip = 'Specifies the duration in minutes.'; }
        field("VC Primary Genre Code"; Rec."VC Primary Genre Code") { ApplicationArea = All; ToolTip = 'Specifies the primary genre.'; }
        field("VC Secondary Genre Code"; Rec."VC Secondary Genre Code") { ApplicationArea = All; ToolTip = 'Specifies the secondary genre.'; }
        field("VC Age Rating"; Rec."VC Age Rating") { ApplicationArea = All; ToolTip = 'Specifies the age rating.'; }
        field("VC Original Language"; Rec."VC Original Language") { ApplicationArea = All; ToolTip = 'Specifies the original language.'; }
        field("VC TMDB ID"; Rec."VC TMDB ID") { ApplicationArea = All; ToolTip = 'Specifies the related TMDB movie identifier.'; }
        field("VC Poster URL"; Rec."VC Poster URL") { ApplicationArea = All; ToolTip = 'Specifies the poster URL.'; }
      }
      group(Synopsis)
      {
        field("VC Synopsis"; Rec."VC Synopsis") { ApplicationArea = All; MultiLine = true; ToolTip = 'Specifies the movie synopsis.'; }
      }
      part(Cast; "VC Movie Cast Part")
      {
        ApplicationArea = All;
        SubPageLink = "Movie Item No." = field("No.");
      }
    }
  }

  trigger OnNewRecord(BelowxRec: Boolean)
  var
    MovieMgt: Codeunit "VC Movie Mgt";
  begin
    MovieMgt.SetMovieDefaults(Rec);
  end;
}
