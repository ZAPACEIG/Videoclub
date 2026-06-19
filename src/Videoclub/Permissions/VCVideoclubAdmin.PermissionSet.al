permissionset 50148 "VC VIDEOCLUB ADMIN"
{
    Assignable = true;
    Caption = 'Videoclub Admin';
    IncludedPermissionSets = "VC VIDEOCLUB USER";
    Permissions =
        tabledata Item = RIMD,
        tabledata "VC Genre" = RIMD,
        tabledata "VC Actor" = RIMD,
        tabledata "VC Movie Cast" = RIMD,
        tabledata "VC Rental Header" = RIMD,
        tabledata "VC Rental Line" = RIMD,
        tabledata "VC TMDB Setup" = RIMD,
        tabledata "VC TMDB Import Log" = RIMD,
        page "VC TMDB Setup Card" = X,
        page "VC TMDB Import Log" = X,
        codeunit "VC TMDB Log Mgt" = X,
        codeunit "VC TMDB Setup Mgt" = X,
        codeunit "VC TMDB Mapper" = X,
        codeunit "VC TMDB Import Mgt" = X,
        codeunit "VC TMDB Client" = X;
}
