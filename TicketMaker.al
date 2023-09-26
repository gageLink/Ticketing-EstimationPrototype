/// <summary>
/// Page Ticket Maker (ID 90554).
/// </summary>
page 90554 "Ticket Maker"
{
    PageType = Worksheet;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    layout
    {
        area(Content)
        {
            field(Department; Department)
            {

            }
            group(Sub)
            {
                Caption = 'Subject';
                field(Subject; Subject)
                {
                    ApplicationArea = suite;
                    ShowCaption = false;
                    MultiLine = true;
                }
            }

            group(Desc)
            {
                Caption = 'Description';
                field(Description; Description)
                {
                    ApplicationArea = suite;
                    MultiLine = true;
                    ShowCaption = false;
                }
            }

        }
    }
    actions
    {
        area(Creation)
        {
            action(LETTERIP)
            {
                ToolTip = 'Releases the ticket into the wild like one of those candles from tangled that got repunzel to get out of her tower. You remember tangled, right? from when your kid was really into it?';
                Image = LimitedCredit;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Ticket: record Ticketing;
                    Tickard: page "Ticket Card";
                    tCode: Codeunit "Ticketing Codes";
                begin
                    //Checking for empty fields
                    if Description = '' then begin
                        Message('You must fill out the Description');
                        exit;
                    end;
                    if Subject = '' then begin
                        Message('You must fill out the Subject');
                        exit;
                    end;
                    tcode.TickInit(Ticket, tcode.NSFinder(Department));
                    ticket.Subject := Subject;
                    ticket."Ticket Body" := Description;
                    ticket."Submitted To" := Department;
                    Ticket.Insert();
                    Tickard.SetRecord(Ticket);
                    Tickard.Run();

                end;
            }
        }
    }
    var
        Department: enum "Ticketing Departments";
        Subject: text[250];
        Description: text[2048];
}