codeunit 50141 "VC TMDB Client"
{
  procedure GetMovieDetails(TMDBId: Integer): Text
  var
    TMDBSetupMgt: Codeunit "VC TMDB Setup Mgt";
  begin
    if TMDBId <= 0 then
      Error('TMDB ID must be greater than zero.');

    TMDBSetupMgt.EnsureCanUseLive();
    Error('Live TMDB HTTP calls are intentionally gated for this slice. Use local fake payloads in tests.');
  end;
}
