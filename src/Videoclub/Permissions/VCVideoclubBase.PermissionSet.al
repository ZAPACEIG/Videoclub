permissionset 50145 "VC VIDEOCLUB BASE"
{
    Assignable = false;
    Caption = 'Videoclub Base';
    Permissions =
        tabledata "VC Genre" = R,
        tabledata "VC Actor" = R,
        tabledata "VC Movie Cast" = R,
        tabledata "VC Rental Header" = R,
        tabledata "VC Rental Line" = R,
        tabledata "VC TMDB Import Log" = R;
}
