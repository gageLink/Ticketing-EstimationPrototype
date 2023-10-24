/// <summary>
/// Table Ticketing Notes (ID 90551).
/// </summary>
table 90551 "Ticketing Notes"
{
    TableType = Normal;
    fields
    {
        field(1; "Ticket No."; Code[20])
        {
            TableRelation = Ticketing."Ticket No.";
        }
        field(2; "Line"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Note; Text[2048])
        {

        }
        field(4; "Created On"; DateTime)
        {

        }
        field(5; "Created By"; Text[100])
        {

        }
    }
    keys
    {
        key(Primary; "Ticket No.", Line)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created On" := CurrentDateTime;
        "Created By" := UserId;
    end;
}