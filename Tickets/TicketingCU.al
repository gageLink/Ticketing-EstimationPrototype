/// <summary>
/// Codeunit Ticketing Codes (ID 90551).
/// </summary>
codeunit 90551 "Ticketing Codes"
{
    /// <summary>
    /// ReqQuo.
    /// </summary>
    /// <param name="SL">record "Sales Line".</param>
    /// <returns>Return variable Ticket of type Record Ticketing.</returns>
    procedure ReqQuo(SL: record "Sales Line") Ticket: Record Ticketing
    begin
        Ticket.SetRange("Source No.", sl."Document No.");
        Ticket.SetRange("Source Line", sl."Line No.");
        if ticket.FindSet() then begin
            Message('Ticket already exists');
        end else begin
            TickInit(Ticket, 'ENGTIX');
            Ticket."Source No." := sl."Document No.";
            Ticket."Source Line" := sl."Line No.";

            Ticket.Subject := 'Quote request for ' + sl."Document No.";
            Ticket."Ticket Body" := 'Please quote item ' + sl."No." + ', ' + sl.Description + '. Thank you!';
            Ticket.Insert();
            Message('Ticket created. Don''t forget to attach related documents!');
        end;
    end;

    /// <summary>
    /// drawings.
    /// </summary>
    /// <param name="SL">Record "Sales Line".</param>
    /// <returns>Return variable ticket of type record Ticketing.</returns>
    procedure drawings(SL: Record "Sales Line") ticket: record Ticketing
    begin
        Ticket.SetRange("Source No.", sl."Document No.");
        Ticket.SetRange("Source Line", sl."Line No.");
        if ticket.FindSet() then begin
            Message('Ticket already exists');
        end else begin
            TickInit(Ticket, 'ENGTIX');
            Ticket."Source No." := sl."Document No.";
            Ticket."Source Line" := sl."Line No.";

            Ticket.Subject := 'Drawing request for ' + sl."Document No.";
            Ticket."Ticket Body" := 'Please create a drawing for item ' + sl."No." + ', ' + sl.Description + '. Thank you!';
            Ticket.Insert();
            Message('Ticket created. Don''t forget to attach related documents!');
        end;
    end;

    /// <summary>
    /// TickInit.
    /// </summary>
    /// <param name="Tic">VAR record Ticketing.</param>
    /// <param name="NoSerCode">code[20].</param>
    procedure TickInit(var Tic: record Ticketing; NoSerCode: code[20])
    var
        NSM: codeunit NoSeriesManagement;
        NS: record "No. Series";
    begin
        tic.Init();
        if not ns.Get('ENGTIX') then noserinit;
        tic."Ticket No." := nsm.GetNextNo(NoSerCode, Today, true);
        tic."Submitted By" := UserId;
        tic."Submittee ID" := UserSecurityId();
        tic."Submitted On" := today;
    end;

    /// <summary>
    /// NSFinder.
    /// </summary>
    /// <param name="Dept">Enum "Ticketing Departments".</param>
    /// <returns>Return variable NSC of type code[20].</returns>
    procedure NSFinder(Dept: Enum "Ticketing Departments") NSC: code[20]
    var
        ns: Record "No. Series";
    begin
        if not ns.Get('ENGTIX') then noserinit;
        case dept of
            Dept::Engineering:
                NSC := 'ENGTIX';
            Dept::"My Kaizan":
                NSC := 'MYKAI';
            Dept::IT:
                NSC := 'ITTIX';
        end
    end;

    procedure NoSerInit()
    var
        NS: record "No. Series";
        NSL: Record "No. Series Line";
        NSR: Record "No. Series Relationship";
    begin
        NS.Init();
        NS.Code := 'ENGTIX';
        ns.Description := 'Engineering Tickets';
        ns.Insert();
        nsl.Init();
        NSL."Series Code" := NS.code;
        nsl."Starting No." := 'ET000001';
        nsl."Ending No." := 'ET999999';
        nsl."Starting Date" := Today;
        NSL.Insert();
        NSR.Init();
        NSR.Code := ns.code;
        NSR."Series Code" := ns.Code;
        NSR.Insert();

        ns.Code := 'MYKAI';
        ns.Description := 'My Kaizan Tickets';
        ns.Insert();
        NSL."Series Code" := NS.code;
        nsl."Starting No." := 'MK000001';
        nsl."Ending No." := 'MK999999';
        nsl."Starting Date" := Today;
        NSL.Insert();
        NSR.Code := ns.code;
        NSR."Series Code" := ns.Code;
        NSR.Insert();

        ns.Code := 'ITTIX';
        ns.Description := 'IT Tickets';
        ns.Insert();
        NSL."Series Code" := NS.code;
        nsl."Starting No." := 'IT000001';
        nsl."Ending No." := 'IT999999';
        nsl."Starting Date" := Today;
        NSL.Insert();
        NSR.Code := ns.code;
        NSR."Series Code" := ns.Code;
        NSR.Insert();
    end;
}