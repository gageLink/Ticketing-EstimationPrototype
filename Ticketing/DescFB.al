/// <summary>
/// Page Ticket Description (ID 90553).
/// </summary>
page 90553 "Ticket Description"
{
    SourceTable = Ticketing;
    PageType = CardPart;
    ApplicationArea = all;
    layout
    {
        area(Content)
        {
            field("Ticket Body"; Rec."Ticket Body")
            {
                //MultiLine = true;
                DrillDown = true;
                trigger OnDrillDown()
                begin
                    Message(rec."Ticket Body");
                end;
            }
        }
    }
}