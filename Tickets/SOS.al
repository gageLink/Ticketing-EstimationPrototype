/// <summary>
/// PageExtension SalOrdTix (ID 90551) extends Record Sales Order Subform.
/// </summary>
pageextension 90551 "SalOrdTix" extends "Sales Order Subform"
{
    actions
    {
        addafter("EMA Download Geometry")
        {
            action("Request Drawing")
            {
                Caption = 'Request Drawing';
                ApplicationArea = all;
                trigger OnAction()
                var
                    Ticket: record Ticketing;
                    Tickard: page "Ticket Card";
                    tCode: Codeunit "Ticketing Codes";
                begin
                    ticket := tCode.drawings(rec);
                    Tickard.SetRecord(Ticket);
                    Tickard.Run();
                end;
            }
        }
    }
}