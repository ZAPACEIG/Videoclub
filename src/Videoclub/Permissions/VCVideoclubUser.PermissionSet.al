permissionset 50147 "VC VIDEOCLUB USER"
{
    Assignable = true;
    Caption = 'Videoclub User';
    IncludedPermissionSets = "VC VIDEOCLUB READ";
    Permissions =
        tabledata Item = IM,
        tabledata "VC Actor" = IM,
        tabledata "VC Movie Cast" = IM,
        tabledata "VC Rental Header" = IM,
        tabledata "VC Rental Line" = IM,
        codeunit "VC Movie Mgt" = X,
        codeunit "VC Availability Mgt" = X,
        codeunit "VC Rental Validation" = X,
        codeunit "VC Rental Status Mgt" = X,
        codeunit "VC Rental Mgt" = X;
}
