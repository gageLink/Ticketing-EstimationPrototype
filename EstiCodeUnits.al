/// <summary>
/// Codeunit Estimation CodeUnits (ID 90001).
/// </summary>
codeunit 90001 "Estimation CodeUnits"
{
    /// <summary>
    /// NewEstfromQuote.
    /// </summary>
    /// <param name="SL">record "Sales Line".</param>
    /// <param name="Ticket">code[20].</param>
    /// <returns>Return variable Estimation of type Record "Estimator Header".</returns>
    procedure NewEstfromQuote(SL: record "Sales Line"; Ticket: code[20]) Estimation: Record "Estimator Header"
    var
    begin
        Estimation.SetRange("Quote No.", sl."Document No.");
        Estimation.SetRange("Quote Line", sl."Line No.");
        if Estimation.FindSet() then begin
            exit(Estimation);
        end else begin
            Estimation.Init();
            Estimation.Validate("Customer No.", SL."Sell-to Customer No.");
            Estimation."Ticket No." := Ticket;
            Estimation."Quote No." := SL."Document No.";
            Estimation."Quote Line" := SL."Line No.";
            Estimation."Quantity To Make" := SL.Quantity;
            estimation."Quote Part" := sl."No.";
            Estimation.Insert(true);
        end;
    end;

}