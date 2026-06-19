codeunit 50138 "VC TMDB Setup Mgt"
{
  Permissions = tabledata "VC TMDB Setup" = rimd;

  procedure EnsureDefaultSetup(var TMDBSetup: Record "VC TMDB Setup")
  begin
    if TMDBSetup.Get(GetPrimaryKey()) then
      exit;

    TMDBSetup.Init();
    TMDBSetup."Primary Key" := GetPrimaryKey();
    // Configuration default only; this slice never uses the URL for live HTTP.
    TMDBSetup."Base URL" := 'https://api.themoviedb.org/3';
    TMDBSetup."Language Code" := 'en-US';
    TMDBSetup.Enabled := false;
    TMDBSetup.Insert(true);
  end;

  procedure GetPrimaryKey(): Code[10]
  begin
    exit('TMDB');
  end;

  procedure ValidateSetup(var TMDBSetup: Record "VC TMDB Setup")
  begin
    TMDBSetup.TestField("Primary Key");
    TMDBSetup.TestField("Base URL");
    TMDBSetup.TestField("Language Code");

    if TMDBSetup.Enabled then
      TMDBSetup.TestField("API Key Reference");
  end;

  procedure EnsureCanUseLive()
  var
    TMDBSetup: Record "VC TMDB Setup";
  begin
    EnsureDefaultSetup(TMDBSetup);
    ValidateSetup(TMDBSetup);

    if not TMDBSetup.Enabled then
      Error('TMDB live integration is disabled. Enable setup only after a safe credential reference is configured.');
  end;
}
