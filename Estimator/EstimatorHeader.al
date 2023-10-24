/// <summary>
/// Table Estimator Header (ID 90000).
/// </summary>
table 90000 "Estimator Header"
{
    fields
    {
        field(1; "No."; code[20])
        {

        }
        field(2; "Reference Item"; code[20])
        {
            TableRelation = Item."No.";
        }
        field(3; "Quantity To Make"; Decimal)
        {
            InitValue = 1;
        }
        field(4; "Customer No."; code[20])
        {
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                cust: Record Customer;
            begin
                cust.get(rec."Customer No.");
                rec."Customer Name" := cust.Name;
            end;
        }
        field(5; "Customer Name"; text[100])
        {

        }
        field(6; "Markup %"; Decimal)
        {
            InitValue = 40;
        }
        //The "Work Adders" section of the original estimator will be page variables, as they need not be stored
        field(7; "Total Price"; Decimal)
        {

        }
        field(8; "Unit Price"; Decimal)
        {

        }
        field(9; "Total Cost"; Decimal)
        {

        }
        field(10; "Unit Cost"; Decimal)
        {

        }
        field(11; "Ticket No."; Code[20])
        {

        }
        field(12; "Quote No."; Code[20])
        {

        }
        field(13; "Quote Line"; Integer)
        {

        }
        field(14; "Quote Part"; code[20])
        {

        }
        field(15; "Valid Estimation"; Boolean)
        {
            InitValue = false;
            //This is used to determine if sales should use this estimation
            //if it can make an estimation without any empty times or prices its valid
        }
    }
    trigger OnInsert()
    var
        NSM: Codeunit NoSeriesManagement;

    begin
        "No." := nsm.GetNextNo('ESTIMATIONS', Today, true);
    end;
}