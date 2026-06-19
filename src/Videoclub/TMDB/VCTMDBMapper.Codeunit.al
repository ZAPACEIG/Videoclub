codeunit 50139 "VC TMDB Mapper"
{
  procedure ReadPayload(Payload: Text; var PayloadObject: JsonObject)
  begin
    if Payload = '' then
      Error('TMDB payload is required.');

    if not PayloadObject.ReadFrom(Payload) then
      Error('TMDB payload must be valid JSON.');
  end;

  procedure GetMovieId(var PayloadObject: JsonObject): Integer
  begin
    exit(GetRequiredInteger(PayloadObject, 'id'));
  end;

  procedure GetTitle(var PayloadObject: JsonObject): Text[100]
  var
    Title: Text;
  begin
    Title := GetOptionalText(PayloadObject, 'title');
    if Title = '' then
      Title := GetOptionalText(PayloadObject, 'name');

    if Title = '' then
      Error('TMDB payload must include a title.');

    exit(CopyStr(Title, 1, 100));
  end;

  procedure GetReleaseYear(var PayloadObject: JsonObject): Integer
  var
    ReleaseYearText: Text;
  begin
    ReleaseYearText := GetOptionalText(PayloadObject, 'release_date');
    if StrLen(ReleaseYearText) < 4 then
      exit(0);

    exit(GetIntegerFromText(CopyStr(ReleaseYearText, 1, 4)));
  end;

  procedure GetRuntime(var PayloadObject: JsonObject): Integer
  begin
    exit(GetOptionalInteger(PayloadObject, 'runtime'));
  end;

  procedure GetOverview(var PayloadObject: JsonObject): Text[2048]
  begin
    exit(CopyStr(GetOptionalText(PayloadObject, 'overview'), 1, 2048));
  end;

  procedure GetOriginalLanguage(var PayloadObject: JsonObject): Code[10]
  begin
    exit(CopyStr(UpperCase(GetOptionalText(PayloadObject, 'original_language')), 1, 10));
  end;

  procedure GetPosterUrl(var PayloadObject: JsonObject): Text[250]
  var
    PosterPath: Text;
  begin
    PosterPath := GetOptionalText(PayloadObject, 'poster_path');
    if PosterPath = '' then
      exit('');

    if CopyStr(PosterPath, 1, 4) = 'http' then
      exit(CopyStr(PosterPath, 1, 250));

    // Mapping constant only; this slice does not fetch poster images or call TMDB live.
    exit(CopyStr('https://image.tmdb.org/t/p/w500' + PosterPath, 1, 250));
  end;

  procedure TryGetArray(var PayloadObject: JsonObject; PropertyName: Text; var JsonArray: JsonArray): Boolean
  var
    JsonToken: JsonToken;
  begin
    if not PayloadObject.Get(PropertyName, JsonToken) then
      exit(false);

    if not JsonToken.IsArray() then
      exit(false);

    JsonArray := JsonToken.AsArray();
    exit(true);
  end;

  procedure TryGetNestedArray(var PayloadObject: JsonObject; ParentName: Text; PropertyName: Text; var JsonArray: JsonArray): Boolean
  var
    JsonToken: JsonToken;
    NestedObject: JsonObject;
  begin
    if not PayloadObject.Get(ParentName, JsonToken) then
      exit(false);

    if not JsonToken.IsObject() then
      exit(false);

    NestedObject := JsonToken.AsObject();
    exit(TryGetArray(NestedObject, PropertyName, JsonArray));
  end;

  procedure GetGenreId(var GenreObject: JsonObject): Integer
  begin
    exit(GetRequiredInteger(GenreObject, 'id'));
  end;

  procedure GetGenreName(var GenreObject: JsonObject): Text[100]
  begin
    exit(CopyStr(GetRequiredText(GenreObject, 'name'), 1, 100));
  end;

  procedure GetCastPersonId(var CastObject: JsonObject): Integer
  begin
    exit(GetRequiredInteger(CastObject, 'id'));
  end;

  procedure GetCastName(var CastObject: JsonObject): Text[100]
  begin
    exit(CopyStr(GetRequiredText(CastObject, 'name'), 1, 100));
  end;

  procedure GetCastCharacter(var CastObject: JsonObject): Text[100]
  begin
    exit(CopyStr(GetOptionalText(CastObject, 'character'), 1, 100));
  end;

  procedure GetCastOrder(var CastObject: JsonObject): Integer
  begin
    exit(GetOptionalInteger(CastObject, 'order'));
  end;

  procedure GetCastCreditId(var CastObject: JsonObject): Text[50]
  begin
    exit(CopyStr(GetOptionalText(CastObject, 'credit_id'), 1, 50));
  end;

  local procedure GetRequiredText(var JsonObject: JsonObject; PropertyName: Text): Text
  var
    Value: Text;
  begin
    Value := GetOptionalText(JsonObject, PropertyName);
    if Value = '' then
      Error('TMDB payload is missing required property %1.', PropertyName);

    exit(Value);
  end;

  local procedure GetOptionalText(var JsonObject: JsonObject; PropertyName: Text): Text
  var
    JsonToken: JsonToken;
  begin
    if not JsonObject.Get(PropertyName, JsonToken) then
      exit('');

    if JsonToken.AsValue().IsNull() then
      exit('');

    exit(JsonToken.AsValue().AsText());
  end;

  local procedure GetRequiredInteger(var JsonObject: JsonObject; PropertyName: Text): Integer
  var
    Value: Integer;
  begin
    Value := GetOptionalInteger(JsonObject, PropertyName);
    if Value = 0 then
      Error('TMDB payload is missing required numeric property %1.', PropertyName);

    exit(Value);
  end;

  local procedure GetOptionalInteger(var JsonObject: JsonObject; PropertyName: Text): Integer
  var
    JsonToken: JsonToken;
  begin
    if not JsonObject.Get(PropertyName, JsonToken) then
      exit(0);

    if JsonToken.AsValue().IsNull() then
      exit(0);

    exit(JsonToken.AsValue().AsInteger());
  end;

  local procedure GetIntegerFromText(Value: Text): Integer
  var
    IntegerValue: Integer;
  begin
    if not Evaluate(IntegerValue, Value) then
      exit(0);

    exit(IntegerValue);
  end;
}
