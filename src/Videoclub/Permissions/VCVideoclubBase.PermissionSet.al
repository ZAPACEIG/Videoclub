permissionset 50145 "VC VIDEOCLUB BASE"
{
    Assignable = false;
    Caption = 'Videoclub Base';
    Permissions =
        tabledata Item = R,
        tabledata "VC Genre" = R,
        tabledata "VC Actor" = R,
        tabledata "VC Movie Cast" = R,
        tabledata "VC Rental Header" = R,
        tabledata "VC Rental Line" = R,
        tabledata "VC TMDB Import Log" = R,
        page "VC Genre List" = X,
        page "VC Actor List" = X,
        page "VC Actor Card" = X,
        page "VC Movie Cast Part" = X,
        page "VC Movie List" = X,
        page "VC Movie Card" = X,
        page "VC Actor Films Part" = X,
        page "VC Rental List" = X,
        page "VC Rental Document" = X,
        page "VC Rental Lines Part" = X,
        page "VC Open Rentals" = X,
        page "VC Overdue Rentals" = X;
}
