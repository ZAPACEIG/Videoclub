codeunit 50131 "VC Movie Mgt"
{
  procedure EnsureMovieItem(var Item: Record Item)
  begin
    SetMovieDefaults(Item);
    Item.TestField(Description);
  end;

  procedure ValidateMovieIsRentable(MovieItemNo: Code[20])
  var
    Item: Record Item;
  begin
    Item.Get(MovieItemNo);
    Item.TestField("VC Is Movie", true);
    Item.TestField("VC Rentable", true);
    Item.TestField(Description);
  end;

  procedure SetMovieDefaults(var Item: Record Item)
  begin
    Item."VC Is Movie" := true;
    Item."VC Rentable" := true;
  end;

  procedure IsMovie(MovieItemNo: Code[20]): Boolean
  var
    Item: Record Item;
  begin
    if not Item.Get(MovieItemNo) then
      exit(false);

    exit(Item."VC Is Movie");
  end;

  procedure GetMovieTitle(MovieItemNo: Code[20]): Text[100]
  var
    Item: Record Item;
  begin
    Item.Get(MovieItemNo);
    exit(Item.Description);
  end;

  procedure IsRentable(MovieItemNo: Code[20]): Boolean
  var
    Item: Record Item;
  begin
    if not Item.Get(MovieItemNo) then
      exit(false);

    exit(Item."VC Is Movie" and Item."VC Rentable");
  end;
}
