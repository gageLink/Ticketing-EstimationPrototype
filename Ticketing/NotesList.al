/// <summary>
/// Page Ticketing Notes (ID 90552).
/// </summary>
page 90552 "Ticketing Notes"
{

    PageType = ListPart;
    ApplicationArea = all;
    SourceTable = "Ticketing Notes";

    layout
    {
        area(Content)
        {

            repeater(Notes)
            {
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    Width = 4;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                    Width = 6;
                }
                field(Note; Rec.Note)
                {
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Message(rec.Note);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            /* separator(Name)
            {

            } */
            group(Notify)
            {
                Caption = 'Notify';
                Image = Note;
                action("Notify Submittee")
                {

                    Caption = 'Notify Submittee';
                    Ellipsis = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = basic, suite;
                    trigger OnAction()
                    var
                        user: Record User;
                        TE: Record "Email Item" temporary;
                        Tic: record Ticketing;
                        es: enum "Email Scenario";
                    begin
                        tic.get(rec."Ticket No.");
                        user.get(tic."Submittee ID");
                        te.Subject := StrSubstNo('New Message from %1 for Ticket %2', UserId, tic."Ticket No.");
                        te.SetBodyText(rec.Note);
                        te."Send to" := user."Contact Email";
                        te.send(true, es::Default);
                    end;
                }
                action("Notify Acceptee")
                {
                    Caption = 'Notify Acceptee';
                    Ellipsis = true;
                    Image = SendApprovalRequest;
                    ApplicationArea = basic, suite;
                    trigger OnAction()
                    var
                        user: Record User;
                        TE: Record "Email Item" temporary;
                        Tic: record Ticketing;
                        es: enum "Email Scenario";
                    begin
                        tic.get(rec."Ticket No.");
                        user.get(tic."Acceptee ID");
                        te.Subject := StrSubstNo('New Message from %1 for Ticket %2', UserId, tic."Ticket No.");
                        te.SetBodyText(rec.Note);
                        te."Send to" := user."Contact Email";
                        te.send(true, es::Default);
                    end;
                }
            }

        }
    }
}