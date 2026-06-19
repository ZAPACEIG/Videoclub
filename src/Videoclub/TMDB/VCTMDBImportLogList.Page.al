page 50125 "VC TMDB Import Log"
{
  Caption = 'Videoclub TMDB Import Log';
  PageType = List;
  SourceTable = "VC TMDB Import Log";
  UsageCategory = History;
  ApplicationArea = All;
  Editable = false;
  InsertAllowed = false;
  ModifyAllowed = false;
  DeleteAllowed = false;

  layout
  {
    area(Content)
    {
      repeater(General)
      {
        field("Entry No."; Rec."Entry No.") { ApplicationArea = All; ToolTip = 'Specifies the sequential import log entry number.'; }
        field("Created At"; Rec."Created At") { ApplicationArea = All; ToolTip = 'Specifies when the import log entry was created.'; }
        field(Operation; Rec.Operation) { ApplicationArea = All; ToolTip = 'Specifies the TMDB operation that wrote the log entry.'; }
        field(Status; Rec.Status) { ApplicationArea = All; ToolTip = 'Specifies the result status for the TMDB operation.'; }
        field("Movie Item No."; Rec."Movie Item No.") { ApplicationArea = All; ToolTip = 'Specifies the movie item related to the TMDB operation.'; }
        field("TMDB ID"; Rec."TMDB ID") { ApplicationArea = All; ToolTip = 'Specifies the TMDB movie identifier related to the operation.'; }
        field(Message; Rec.Message) { ApplicationArea = All; ToolTip = 'Specifies the short log message.'; }
        field(Details; Rec.Details) { ApplicationArea = All; ToolTip = 'Specifies additional local processing details for the log entry.'; }
      }
    }
  }
}
