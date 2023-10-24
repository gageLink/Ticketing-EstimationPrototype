/// <summary>
/// Page Ticket Card (ID 90551).
/// </summary>
page 90551 "Ticket Card"
{
    ApplicationArea = all;
    //UsageCategory = Tasks;
    PageType = Card;
    SourceTable = Ticketing;
    layout
    {
        area(Content)
        {

            field(Subject; Rec.Subject)
            {
                MultiLine = true;
            }
            group("Ticket Info")
            {
                Editable = false;
                field("Ticket No."; Rec."Ticket No.")
                {

                }
                field("Submitted To"; Rec."Submitted To")
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
                field("Accepted On"; Rec."Accepted On")
                {

                }
                field("Completed On"; Rec."Completed On")
                {

                }
            }
            group(Request)
            {
                field("Ticket Body"; Rec."Ticket Body")
                {
                    ApplicationArea = suite;
                    MultiLine = false;
                    ShowCaption = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    begin
                        Message(rec."Ticket Body");
                    end;
                }
            }
            part(Notes; "Ticketing Notes")
            {
                Editable = true;
                Caption = 'Notes';
                SubPagelink = "Ticket No." = field("Ticket No.");
                ApplicationArea = all;

            }

        }
        area(FactBoxes)
        {
            part(Attach; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(Database::Ticketing), "No." = field("Ticket No.");

            }
            systempart(Link; Links)
            {
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(Staii)
            {
                actionref(Acc; accept)
                {

                }
                actionref(Drp; Drop)
                {

                }
                actionref(TO; "Take Over")
                {

                }
                actionref(RA; "Request Approval")
                {

                }
                actionref(C; Complete)
                {

                }
            }
            group("Related Documents")
            {
                actionref(Est; Estimation)
                {

                }
                actionref(SQ; Quote)
                {

                }
            }
        }
        area(Processing)
        {
            group(Stati)
            {
                Caption = 'Status';
                action(Accept)
                {
                    Image = Signature;
                    trigger OnAction()
                    begin
                        if rec.Status = rec.Status::Complete then exit;
                        if rec."Accepted By" <> '' then begin
                            Message('This ticket was already accepted by %1.', rec."Accepted By");
                            exit;
                        end;
                        rec.Validate(Status, rec.Status::Accepted);
                        rec."Accepted By" := UserId;
                        rec."Acceptee ID" := UserSecurityId();
                    end;
                }
                action(Drop)
                {
                    Image = DeleteAllBreakpoints;
                    trigger OnAction()
                    begin
                        if rec.Status = rec.Status::Complete then exit;
                        rec.Validate(Status, rec.Status::New);
                        Clear(rec."Accepted By");
                        Clear(rec."Acceptee ID");
                    end;
                }
                action("Take Over")
                {
                    Image = Refresh;
                    trigger OnAction()
                    begin
                        if rec.Status <> rec.Status::Accepted then exit;
                        if rec.Status = rec.Status::Complete then exit;
                        if rec."Accepted By" = UserId then begin
                            Message('It''s already your ticket, ya goober');
                        end else begin
                            rec."Accepted By" := UserId;
                            rec."Acceptee ID" := UserSecurityId();
                        end;
                    end;
                }
                action("Request Approval")
                {
                    Image = SendConfirmation;
                    trigger OnAction()
                    begin
                        if rec.Status = rec.Status::Complete then exit;
                        if rec.Status = rec.Status::"Needs Review" then exit;
                        rec.Validate(Status, rec.Status::"Needs Review");
                    end;
                }
                action(Complete)
                {
                    Image = ServiceTasks;
                    trigger OnAction()
                    begin
                        rec."Completed On" := Today;
                        rec."Completed By" := UserId;
                        rec."Completee ID" := UserSecurityId();
                        rec.Validate(Status, rec.Status::Complete);
                    end;

                }

            }
            action(Estimation)
            {
                Image = PostedTimeSheet;
                ToolTip = 'Opens Related Estimation';
                trigger OnAction()
                var
                    Est: Record "Estimator Header";
                    EstiPage: page Estimator;
                    Noti: Notification;
                begin
                    est.SetRange("Ticket No.", rec."Ticket No.");
                    if est.FindSet() then begin
                        estipage.SetTableView(Est);
                        EstiPage.Run();
                    end else begin
                        Noti.Message('There is no estimation for this ticket.');
                        Noti.Send();
                    end;

                end;
            }
            action("Quote")
            {
                Image = Quote;
                ToolTip = 'Opens sales quote.';
                trigger OnAction()
                var
                    SH: Record "Sales Header";
                    SQP: page "Sales Quote";
                    Noti: Notification;
                begin

                    if sh.get(SH."Document Type"::Quote, rec."Source No.") then begin
                        SQP.SetRecord(SH);
                        SQP.Run();
                    end else begin
                        Noti.Message('There is no quote for this ticket.');
                        Noti.Send();
                    end;


                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Editable(true);
    end;
}