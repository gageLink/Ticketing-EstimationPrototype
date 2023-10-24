/// <summary>
/// Page EstiRouter (ID 90002).
/// </summary>
page 90002 "EstiRouter"
{
    ApplicationArea = all;
    SourceTable = "Estimator Router";
    PageType = ListPart;
    layout
    {
        area(Content)
        {
            repeater(Routing)
            {
                field("Operation No."; Rec."Operation No.")
                {

                }
                field("No."; Rec."No.")
                {
                    trigger OnValidate()
                    begin
                        RoutPop();
                    end;
                }
                field(Description; Rec.Description)
                {

                }
                field("Setup Time"; Rec."Setup Time")
                {

                }
                field("Setup Time Unit of Measure"; Rec."Setup Time Unit of Measure")
                {

                }
                field("Run Time"; Rec."Run Time")
                {

                }
            }
        }
    }
    /// <summary>
    /// RoutPop.
    /// </summary>
    procedure RoutPop()
    var
        WC: Record "Work Center";
        i: Integer;
        j: Integer;
        ER: record "Estimator Router";
    begin
        if WC.Get(rec."No.") then begin
            rec.Description := wc.Name;
            rec."Setup Time Unit of Measure" := wc."Unit of Measure Code";
        end;
        for i := 0 to 9 do begin
            for j := 0 to 9 do begin
                if not (ER.get(rec."Estimation No.", format(i) + Format(j))) then begin
                    rec."Operation No." := format(i) + Format(j);
                    exit;
                end;
            end;


        end;
    end;
}