enum 50108 "VC Rental Status"
{
    Extensible = true;
    value(0; Draft) { Caption = 'Draft'; }
    value(1; Registered) { Caption = 'Registered'; }
    value(2; "Partially Returned") { Caption = 'Partially Returned'; }
    value(3; Returned) { Caption = 'Returned'; }
    value(4; Overdue) { Caption = 'Overdue'; }
}

enum 50109 "VC Rental Line Status"
{
    Extensible = true;
    value(0; Draft) { Caption = 'Draft'; }
    value(1; Outstanding) { Caption = 'Outstanding'; }
    value(2; "Partially Returned") { Caption = 'Partially Returned'; }
    value(3; Returned) { Caption = 'Returned'; }
    value(4; Overdue) { Caption = 'Overdue'; }
}
