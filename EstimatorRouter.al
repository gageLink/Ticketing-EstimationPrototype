/// <summary>
/// Table Estimator Router (ID 90002).
/// </summary>
table 90002 "Estimator Router"
{
    fields
    {
        field(1; "Estimation No."; code[20])
        {

        }
        field(2; "Operation No."; code[10])
        {

        }
        field(3; Type; Enum "Capacity Type Routing")
        {

        }
        field(4; "No."; code[20])
        {

            TableRelation = "Work Center";
        }
        field(5; Description; text[100])
        {

        }
        field(6; "Setup Time"; Decimal)
        {

        }
        field(7; "Setup Time Unit of Measure"; code[10])
        {

        }
        field(8; "Run Time"; Decimal)
        {

        }
    }
    keys
    {
        key(Primary; "Estimation No.", "Operation No.")
        {

        }
    }
}