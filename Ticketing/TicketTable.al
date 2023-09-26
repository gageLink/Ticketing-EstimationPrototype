/// <summary>
/// Table Ticketing (ID 90550).
/// </summary>
table 90550 "Ticketing"
{
    fields
    {
        field(1; "Ticket No."; Code[20])
        {
            //A master list of all submitted tickets.
        }
        field(2; "Submitted To"; Enum "Ticketing Departments")
        {
            //This refers to the department receiving the Ticket
        }
        field(3; "Submitted By"; Text[100])
        {
            //This refers to the person submitted the ticket
            //I do not think their department matters.
        }
        field(4; "Submitted On"; Date)
        {

            //the date that {3} 
        }
        field(5; "Accepted By"; Text[100])
        {
            //not sold on the name
            //the user from {2} who has committed to working on the ticket
        }
        field(6; "Accepted On"; Date)
        {

        }
        field(7; Status; Enum "Ticket Status")
        {
            InitValue = New;
            trigger OnValidate()
            begin
                case Status of
                    Status::Complete:
                        if "Completed On" = 0D then begin
                            "Completed On" := Today;
                        end;
                    Status::Accepted:
                        if "Accepted On" = 0D then begin
                            "Accepted On" := Today;
                        end;
                    Status::New:
                        begin
                            "Completed On" := 0D;
                            "Accepted On" := 0D;
                        end;

                end;
            end;
        }
        field(8; "Completed On"; Date)
        {
            InitValue = 0D;
        }
        field(9; Subject; Text[250])
        {
            //This is a short description of the request for work
        }
        field(10; "Ticket Body"; Text[2048])
        {
            //this is space for a longer description of the request for work.
        }
        field(11; "Source No."; Code[20])
        {
            //this is the number of the document that this ticket can be connected to
        }
        field(12; "Source Type"; Integer)
        {
            //this is the number of the table that {11} is an entry in
        }
        field(13; "Source Line"; Integer)
        {

        }
        field(14; "Completed By"; text[100])
        {

        }

        //IDs
        field(50; "Submittee ID"; Guid)
        {

        }
        field(51; "Acceptee ID"; Guid)
        {

        }
        field(52; "Completee ID"; Guid)
        {

        }

    }
    keys
    {
        key("Primary"; "Ticket No.", "Submitted To")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Submitted On" := Today;
    end;
}