enum 50110 "VC TMDB Operation"
{
    Extensible = true;
    value(0; Search) { Caption = 'Search'; }
    value(1; Import) { Caption = 'Import'; }
    value(2; Refresh) { Caption = 'Refresh'; }
}

enum 50111 "VC Integration Status"
{
    Extensible = true;
    value(0; Success) { Caption = 'Success'; }
    value(1; Warning) { Caption = 'Warning'; }
    value(2; Error) { Caption = 'Error'; }
}
