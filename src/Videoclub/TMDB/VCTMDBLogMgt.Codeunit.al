codeunit 50137 "VC TMDB Log Mgt"
{
  Permissions = tabledata "VC TMDB Import Log" = rimd;

  procedure LogSuccess(Operation: Enum "VC TMDB Operation"; MovieItemNo: Code[20]; TMDBId: Integer; Message: Text[250]; Details: Text[2048]): Integer
  begin
    exit(InsertLog(Operation, Enum::"VC Integration Status"::Success, MovieItemNo, TMDBId, Message, Details));
  end;

  procedure LogWarning(Operation: Enum "VC TMDB Operation"; MovieItemNo: Code[20]; TMDBId: Integer; Message: Text[250]; Details: Text[2048]): Integer
  begin
    exit(InsertLog(Operation, Enum::"VC Integration Status"::Warning, MovieItemNo, TMDBId, Message, Details));
  end;

  procedure LogError(Operation: Enum "VC TMDB Operation"; MovieItemNo: Code[20]; TMDBId: Integer; Message: Text[250]; Details: Text[2048]): Integer
  begin
    exit(InsertLog(Operation, Enum::"VC Integration Status"::Error, MovieItemNo, TMDBId, Message, Details));
  end;

  local procedure InsertLog(Operation: Enum "VC TMDB Operation"; Status: Enum "VC Integration Status"; MovieItemNo: Code[20]; TMDBId: Integer; Message: Text[250]; Details: Text[2048]): Integer
  var
    TMDBImportLog: Record "VC TMDB Import Log";
    EntryNo: Integer;
    IsHandled: Boolean;
  begin
    OnBeforeInsertLog(Operation, Status, MovieItemNo, TMDBId, Message, Details, EntryNo, IsHandled);
    if IsHandled then
      exit(EntryNo);

    TMDBImportLog.Init();
    TMDBImportLog."Entry No." := GetNextEntryNo();
    TMDBImportLog.Operation := Operation;
    TMDBImportLog.Status := Status;
    TMDBImportLog."Movie Item No." := MovieItemNo;
    TMDBImportLog."TMDB ID" := TMDBId;
    TMDBImportLog.Message := CopyStr(Message, 1, MaxStrLen(TMDBImportLog.Message));
    TMDBImportLog.Details := CopyStr(Details, 1, MaxStrLen(TMDBImportLog.Details));
    TMDBImportLog."Created At" := CurrentDateTime();
    TMDBImportLog.Insert(true);

    OnAfterInsertLog(TMDBImportLog);

    exit(TMDBImportLog."Entry No.");
  end;

  local procedure GetNextEntryNo(): Integer
  var
    TMDBImportLog: Record "VC TMDB Import Log";
  begin
    if TMDBImportLog.FindLast() then
      exit(TMDBImportLog."Entry No." + 1);

    exit(1);
  end;

  [IntegrationEvent(false, false)]
  local procedure OnBeforeInsertLog(var Operation: Enum "VC TMDB Operation"; var Status: Enum "VC Integration Status"; var MovieItemNo: Code[20]; var TMDBId: Integer; var Message: Text[250]; var Details: Text[2048]; var EntryNo: Integer; var IsHandled: Boolean)
  begin
  end;

  [IntegrationEvent(false, false)]
  local procedure OnAfterInsertLog(TMDBImportLog: Record "VC TMDB Import Log")
  begin
  end;
}
