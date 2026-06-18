codeunit 50131 "VC Movie Mgt"
{
    procedure IsMovie(Item: Record Item): Boolean
    begin
        exit(Item."VC Is Movie");
    end;

    procedure IsRentable(Item: Record Item): Boolean
    begin
        exit(Item."VC Is Movie" and Item."VC Rentable");
    end;

    procedure ValidateMovieForRental(Item: Record Item)
    begin
        // Bootstrap scaffold only. Full validation is pending implementation.
    end;
}
