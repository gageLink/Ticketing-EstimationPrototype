/// <summary>
/// Enum Ticket Status (ID 90550).
/// </summary>
enum 90550 "Ticket Status"
{
    value(1; "New")
    {
        //freshly submitted tickets
    }
    value(2; "Accepted")
    {
        //accepted tickets
    }
    value(3; "Needs Review")
    {
        //When the accepted party has finished work, and would like the submittee to review
    }
    value(4; "Complete")
    {
        //when the submittee decides that the original need expressed by the ticket was met.
    }
    value(5; Rejected)
    {
        //This is for tickets deemed unsupportable, impossible, or not worth the teams time
    }
}