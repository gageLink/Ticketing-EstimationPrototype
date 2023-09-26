/// <summary>
/// PageExtension SalQuoTix (ID 90550) extends Record Sales Quote Subform.
/// </summary>
pageextension 90550 "SalQuoTix" extends "Sales Quote Subform"
{
    actions
    {
        addafter("EMA Download Geometry")
        {
            action(ReqQuo)
            {
                Image = SendTo;
                Caption = 'Request Quote';
                ApplicationArea = all;
                trigger OnAction()
                var
                    Ticket: record Ticketing;
                    Tickard: page "Ticket Card";
                    tCode: Codeunit "Ticketing Codes";
                    ECU: Codeunit "Estimation CodeUnits";
                begin
                    ticket := tCode.ReqQuo(Rec);
                    ecu.NewEstfromQuote(Rec, Ticket."Ticket No.");
                    Tickard.SetRecord(Ticket);
                    Tickard.Run();

                end;
            }
            action("Apply Estimation")
            {
                Image = Apply;
                ApplicationArea = all;
                trigger OnAction()
                var
                    Est: Record "Estimator Header";
                begin
                    Est.SetRange("Quote No.", rec."Document No.");
                    Est.SetRange("Quote Line", rec."Line No.");
                    if Est.FindSet() then begin
                        if Est."Unit Price" = 0 then begin
                            Message('This estimation has a price of 0. Please Redo.');
                            exit;
                        end else begin
                            rec.Validate("Unit Price", Est."Unit Price");
                        end;
                    end else
                        Message('No estimation found.');
                end;
            }
        }
    }
}