page 90550 "Tickets"
{
    ApplicationArea = all;
    PageType = List;
    UsageCategory = Tasks;
    SourceTable = Ticketing;
    CardPageId = "Ticket Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Tickets)
            {
                field("Ticket No."; Rec."Ticket No.")
                {
                }
                field(Subject; Rec.Subject)
                {

                }
                field("Submitted By"; Rec."Submitted By")
                {

                }
                field("Submitted On"; Rec."Submitted On")
                {

                }
                field(Status; Rec.Status)
                {

                }
                field("Accepted By"; Rec."Accepted By")
                {

                }
            }
        }
        area(FactBoxes)
        {
            part(Description; "Ticket Description")
            {
                SubPageLink = "Ticket No." = field("Ticket No.");
            }
            part(Notes; "Ticketing Notes")
            {
                SubPageLink = "Ticket No." = field("Ticket No.");
            }
            part(Attach; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(Database::Ticketing), "No." = field("Ticket No.");

            }
            systempart(Link; Links)
            {
            }

        }
    }
}