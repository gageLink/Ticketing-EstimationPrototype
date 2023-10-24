/// <summary>
/// Page Estimations (ID 90003).
/// </summary>
page 90003 "Estimations"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    CardPageId = 90000;
    SourceTable = "Estimator Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(List)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {

                }
                field("Customer Name"; Rec."Customer Name")
                {

                }
                field("Total Cost"; Rec."Total Cost")
                {

                }
                field("Total Price"; Rec."Total Price")
                {

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(New)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    esti: record "Estimator Header";
                    esticard: page Estimator;
                begin
                    esti.Init();
                    esti.Insert(true);
                    esticard.SetRecord(esti);
                    esticard.Run();
                end;
            }
        }
    }
}