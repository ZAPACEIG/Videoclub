codeunit 50140 "VC TMDB Import Mgt"
{
  Permissions = tabledata Item = rimd,
                tabledata "VC Genre" = rimd,
                tabledata "VC Actor" = rimd,
                tabledata "VC Movie Cast" = rimd,
                tabledata "VC TMDB Import Log" = rimd;

  procedure ImportMoviePayload(MovieItemNo: Code[20]; Payload: Text): Integer
  var
    Item: Record Item;
    TMDBMapper: Codeunit "VC TMDB Mapper";
    TMDBLogMgt: Codeunit "VC TMDB Log Mgt";
    PayloadObject: JsonObject;
    IsHandled: Boolean;
    LogEntryNo: Integer;
    TMDBId: Integer;
    ImportedActors: Integer;
    ImportedGenres: Integer;
  begin
    OnBeforeImportMoviePayload(MovieItemNo, Payload, LogEntryNo, IsHandled);
    if IsHandled then
      exit(LogEntryNo);

    if MovieItemNo = '' then
      Error('Movie item number is required.');

    Item.Get(MovieItemNo);
    TMDBMapper.ReadPayload(Payload, PayloadObject);
    TMDBId := TMDBMapper.GetMovieId(PayloadObject);

    IsHandled := false;
    OnBeforeApplyMoviePayload(Item, PayloadObject, IsHandled);
    if not IsHandled then begin
      ApplyMovieFields(Item, PayloadObject);
      ImportedGenres := ApplyGenres(Item, PayloadObject);
      ImportedActors := ApplyCast(Item."No.", PayloadObject);
    end;
    OnAfterApplyMoviePayload(Item, PayloadObject, ImportedGenres, ImportedActors);

    LogEntryNo := TMDBLogMgt.LogSuccess(
        Enum::"VC TMDB Operation"::Import,
        Item."No.",
        TMDBId,
        'TMDB payload imported.',
        CopyStr(StrSubstNo('Imported %1 genres and %2 cast members from local payload.', ImportedGenres, ImportedActors), 1, 2048));

    OnAfterImportMoviePayload(Item."No.", Payload, TMDBId, ImportedGenres, ImportedActors, LogEntryNo);

    exit(LogEntryNo);
  end;

  local procedure ApplyMovieFields(var Item: Record Item; var PayloadObject: JsonObject)
  var
    TMDBMapper: Codeunit "VC TMDB Mapper";
  begin
    Item.Description := CopyStr(TMDBMapper.GetTitle(PayloadObject), 1, MaxStrLen(Item.Description));
    Item."VC Is Movie" := true;
    Item."VC Rentable" := true;
    Item."VC TMDB ID" := TMDBMapper.GetMovieId(PayloadObject);
    Item."VC Release Year" := TMDBMapper.GetReleaseYear(PayloadObject);
    Item."VC Duration Minutes" := TMDBMapper.GetRuntime(PayloadObject);
    Item."VC Synopsis" := TMDBMapper.GetOverview(PayloadObject);
    Item."VC Original Language" := TMDBMapper.GetOriginalLanguage(PayloadObject);
    Item."VC Poster URL" := TMDBMapper.GetPosterUrl(PayloadObject);
    Item.Modify(true);
  end;

  local procedure ApplyGenres(var Item: Record Item; var PayloadObject: JsonObject): Integer
  var
    Genre: Record "VC Genre";
    TMDBMapper: Codeunit "VC TMDB Mapper";
    GenreArray: JsonArray;
    GenreObject: JsonObject;
    GenreToken: JsonToken;
    GenreCode: Code[20];
    Index: Integer;
  begin
    if not TMDBMapper.TryGetArray(PayloadObject, 'genres', GenreArray) then
      exit(0);

    for Index := 0 to GenreArray.Count() - 1 do begin
      GenreArray.Get(Index, GenreToken);
      if GenreToken.IsObject() then begin
        GenreObject := GenreToken.AsObject();
        GenreCode := UpsertGenre(Genre, GenreObject);
        if Index = 0 then
          Item."VC Primary Genre Code" := GenreCode;
        if Index = 1 then
          Item."VC Secondary Genre Code" := GenreCode;
      end;
    end;

    Item.Modify(true);
    exit(GenreArray.Count());
  end;

  local procedure ApplyCast(MovieItemNo: Code[20]; var PayloadObject: JsonObject): Integer
  var
    MovieCast: Record "VC Movie Cast";
    TMDBMapper: Codeunit "VC TMDB Mapper";
    CastArray: JsonArray;
    CastObject: JsonObject;
    CastToken: JsonToken;
    ActorNo: Code[20];
    Index: Integer;
    ImportedActors: Integer;
  begin
    if not TMDBMapper.TryGetNestedArray(PayloadObject, 'credits', 'cast', CastArray) then
      exit(0);

    MovieCast.SetRange("Movie Item No.", MovieItemNo);
    MovieCast.DeleteAll(true);

    for Index := 0 to CastArray.Count() - 1 do begin
      CastArray.Get(Index, CastToken);
      if CastToken.IsObject() then begin
        CastObject := CastToken.AsObject();
        ActorNo := UpsertActor(CastObject);
        InsertCastLine(MovieItemNo, ActorNo, CastObject, ImportedActors + 1);
        ImportedActors += 1;
      end;
    end;

    exit(ImportedActors);
  end;

  local procedure UpsertGenre(var Genre: Record "VC Genre"; var GenreObject: JsonObject): Code[20]
  var
    TMDBMapper: Codeunit "VC TMDB Mapper";
    GenreCode: Code[20];
    TMDBGenreId: Integer;
  begin
    TMDBGenreId := TMDBMapper.GetGenreId(GenreObject);
    Genre.SetRange("TMDB Genre ID", TMDBGenreId);
    if not Genre.FindFirst() then begin
      Genre.Init();
      GenreCode := CopyStr(StrSubstNo('TMDB%1', TMDBGenreId), 1, MaxStrLen(Genre.Code));
      Genre.Code := GenreCode;
      Genre."TMDB Genre ID" := TMDBGenreId;
      Genre.Description := TMDBMapper.GetGenreName(GenreObject);
      Genre.Insert(true);
      exit(Genre.Code);
    end;

    Genre.Description := TMDBMapper.GetGenreName(GenreObject);
    Genre.Modify(true);
    exit(Genre.Code);
  end;

  local procedure UpsertActor(var CastObject: JsonObject): Code[20]
  var
    Actor: Record "VC Actor";
    TMDBMapper: Codeunit "VC TMDB Mapper";
    ActorNo: Code[20];
    TMDBPersonId: Integer;
  begin
    TMDBPersonId := TMDBMapper.GetCastPersonId(CastObject);
    Actor.SetRange("TMDB Person ID", TMDBPersonId);
    if not Actor.FindFirst() then begin
      Actor.Init();
      ActorNo := CopyStr(StrSubstNo('TMDB%1', TMDBPersonId), 1, MaxStrLen(Actor."No."));
      Actor."No." := ActorNo;
      Actor."TMDB Person ID" := TMDBPersonId;
      Actor.Name := TMDBMapper.GetCastName(CastObject);
      Actor.Insert(true);
      exit(Actor."No.");
    end;

    Actor.Name := TMDBMapper.GetCastName(CastObject);
    Actor.Modify(true);
    exit(Actor."No.");
  end;

  local procedure InsertCastLine(MovieItemNo: Code[20]; ActorNo: Code[20]; var CastObject: JsonObject; LineIndex: Integer)
  var
    MovieCast: Record "VC Movie Cast";
    TMDBMapper: Codeunit "VC TMDB Mapper";
  begin
    MovieCast.Init();
    MovieCast."Movie Item No." := MovieItemNo;
    MovieCast."Line No." := LineIndex * 10000;
    MovieCast."Actor No." := ActorNo;
    MovieCast."Character Name" := TMDBMapper.GetCastCharacter(CastObject);
    MovieCast."Cast Order" := TMDBMapper.GetCastOrder(CastObject);
    MovieCast."TMDB Credit ID" := TMDBMapper.GetCastCreditId(CastObject);
    MovieCast.Insert(true);
  end;

  [IntegrationEvent(false, false)]
  local procedure OnBeforeImportMoviePayload(MovieItemNo: Code[20]; Payload: Text; var LogEntryNo: Integer; var IsHandled: Boolean)
  begin
  end;

  [IntegrationEvent(false, false)]
  local procedure OnAfterImportMoviePayload(MovieItemNo: Code[20]; Payload: Text; TMDBId: Integer; ImportedGenres: Integer; ImportedActors: Integer; LogEntryNo: Integer)
  begin
  end;

  [IntegrationEvent(false, false)]
  local procedure OnBeforeApplyMoviePayload(var Item: Record Item; var PayloadObject: JsonObject; var IsHandled: Boolean)
  begin
  end;

  [IntegrationEvent(false, false)]
  local procedure OnAfterApplyMoviePayload(var Item: Record Item; var PayloadObject: JsonObject; ImportedGenres: Integer; ImportedActors: Integer)
  begin
  end;
}
