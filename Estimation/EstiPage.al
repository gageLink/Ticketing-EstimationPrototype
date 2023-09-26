/// <summary>
/// Page Estimator (ID 90000).
/// </summary>
page 90000 "Estimator"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Estimator Header";
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(Setup)
            {
                field("Reference Item"; Rec."Reference Item")
                {
                    trigger OnValidate()
                    begin
                        PullRef();
                    end;
                }
                field("Quantity To Make"; Rec."Quantity To Make")
                {

                }
                field("Customer No."; Rec."Customer No.")
                {

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                }
                field("Markup %"; Rec."Markup %")
                {

                }
            }
            group("Work Adders")
            {
                field(WorkQTY; WorkQTY)
                {
                    Caption = 'Work QTY';
                }
                field(WorkSize; WorkSize)
                {
                    Caption = 'Work Size';
                }
            }
            group("Go ahead. Estimate. I dare you.")
            {

                part(BOM; EstiBOM)
                {

                    Caption = 'BOM';
                    SubPageLink = "Estimation No." = field("No.");

                }
                part(Routing; EstiRouter)
                {
                    Caption = 'Router';
                    SubPageLink = "Estimation No." = field("No.");
                }
            }
            group("Price")
            {
                Editable = false;
                field("Total Price"; Rec."Total Price")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {

                }
            }
            group(Cost)
            {
                Editable = false;
                field("Total Cost"; Rec."Total Cost")
                {

                }
                field("Unit Cost"; Rec."Unit Cost")
                {

                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(Est; Estimoite)
            {

            }
            actionref(accest; "Gimme Access Pricing")
            {

            }
            actionref(Nu; New)
            {

            }
            group("Work Adding")
            {
                actionref(C; Cut)
                {

                }
                actionref(F; Fab)
                {

                }
                actionref(w; weld)
                {

                }
                actionref(P; polish)
                {


                }
            }
            group("Related Documents")
            {
                actionref(Q; Quote)
                {

                }
                actionref(T; Ticket)
                {

                }
            }

        }
        area(Processing)
        {
            action(Estimoite)
            {
                Image = ExportShipment;
                trigger OnAction()
                var
                    BOM: record "Estimator BOM";
                    Rout: record "Estimator Router";
                    EstPrice: Codeunit "Estimation Pricing";
                    EC: Codeunit "Estimation CodeUnits";
                    Cost: Decimal; //cost dependant on quantity
                    Price: Decimal; //price dependant on quantity
                    Setup: Decimal; //independant of quantity (setup time)

                    MA: Integer; //missing availability
                    MP: Integer; //missing price
                    MS: Integer; //missing setup
                    MR: Integer; //missing run
                begin

                    //Message('Action Under Construction, please be patient.');
                    if rec."Quantity To Make" <= 0 then begin
                        rec."Total Cost" := 0;
                        rec."Total Price" := 0;
                        rec."Unit Cost" := 0;
                        rec."Unit Price" := 0;
                        exit;
                    end;

                    SideGet(BOM, Rout);


                    //BOM adding
                    repeat
                        EstPrice.BOMLinePrice(BOM, Cost, Price);
                        if bom."Available Quantity" = 0 then MA += 1;
                        if bom."Unit Price" = 0 then MP += 1;
                    until bom.Next() = 0;

                    //rout adding
                    repeat
                        EstPrice.RoutLinePrice(Rout, Cost, Price, Setup);
                        if rout."Setup Time" = 0 then MS += 1;
                        if Rout."Run Time" = 0 then MR += 1;
                    until Rout.Next() = 0;

                    rec."Total Cost" := Cost * rec."Quantity To Make" + Setup;
                    rec."Unit Cost" := rec."Total Cost" / rec."Quantity To Make";
                    rec."Total Price" := Price * rec."Quantity To Make" + Setup;
                    rec."Total Price" *= (1 + (rec."Markup %" / 100));
                    rec."Unit Price" := rec."Total Price" / rec."Quantity To Make";
                    if (MA + MP + MS + MR) = 0 then
                        rec."Valid Estimation" := true else begin
                        Message('Looks like this isn''t valid. Of %1 items in the BOM, there is %2 missing Availability, and %3 missing price. Of the %4 routings, there is %5 missing setup times, and %6 missing run times.', BOM.Count, MA, MP, Rout.Count, MS, MR);
                        rec."Valid Estimation" := false;
                    end;

                end;

            }
            action("Gimme access pricing")
            {
                ToolTip = 'For all those times you''re like "Hey access would have said this costs wayyyy more".';
                Image = ExportShipment;
                trigger OnAction()
                var
                    BOM: record "Estimator BOM";
                    Rout: record "Estimator Router";
                    EstPrice: Codeunit "Estimation Pricing";
                    Cost: Decimal; //cost dependant on quantity
                    Price: Decimal; //price dependant on quantity
                    Setup: Decimal; //independant of quantity (setup time)
                    MA: Integer; //missing Availability
                    MP: Integer; //missing price
                    MS: Integer; //missing setup
                    MR: Integer; //missing run
                begin
                    //Message('Action Under Construction, please be patient.');
                    if rec."Quantity To Make" <= 0 then begin
                        rec."Total Cost" := 0;
                        rec."Total Price" := 0;
                        rec."Unit Cost" := 0;
                        rec."Unit Price" := 0;
                        exit;
                    end;

                    SideGet(BOM, Rout);

                    //BOM adding
                    repeat
                        EstPrice.BOMLinePrice(BOM, Cost, Price);
                        if bom."Available Quantity" = 0 then MA += 1;
                        if bom."Unit Price" = 0 then MP += 1;
                    until bom.Next() = 0;

                    //rout adding
                    repeat
                        EstPrice.AccessRoutPricing(Rout, Cost, Price, Setup);
                        if rout."Setup Time" = 0 then MS += 1;
                        if Rout."Run Time" = 0 then MR += 1;
                    until Rout.Next() = 0;

                    rec."Total Cost" := Cost * rec."Quantity To Make" + Setup;
                    rec."Unit Cost" := rec."Total Cost" / rec."Quantity To Make";
                    rec."Total Price" := Price * rec."Quantity To Make" + Setup;
                    rec."Total Price" *= (1 + (rec."Markup %" / 100));
                    rec."Unit Price" := rec."Total Price" / rec."Quantity To Make";

                    if (MA + MP + MS + MR) = 0 then
                        rec."Valid Estimation" := true else begin
                        Message('Looks like this isn''t valid. Of %1 items in the BOM, there is %2 missing Availability, and %3 missing price. Of the %4 routings, there is %5 missing setup times, and %6 missing run times.', BOM.Count, MA, MP, Rout.Count, MS, MR);
                        rec."Valid Estimation" := false;
                    end;

                end;
            }
            action(New)
            {
                Image = New;
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
            action(Cut)
            {
                Image = WorkTax;
                trigger OnAction()
                var
                    Rout: Record "Estimator Router";
                begin
                    //Message('Action Under Construction, please be patient.');
                    if Rout.Get(rec."No.", '') then begin
                        Message('All routing lines must be numbered.');
                        exit;
                    end;
                    if WorkQTY <= 0 then begin
                        Message('Work QTY must be greater than zero.');
                        exit;
                    end;

                    Rout.Init();
                    Rout."Estimation No." := rec."No.";
                    Rout."No." := 'CUT';
                    Rout.Description := Format(WorkQTY) + ' QTY ' + Format(WorkSize) + 'Cut';
                    if WorkQTY > 1 then
                        rout.Description += 's';
                    Rout."Setup Time" := 2;
                    Rout."Setup Time Unit of Measure" := 'MIN';
                    if (WorkSize = WorkSize::".5″-3″") or (WorkSize = WorkSize::"4″") then
                        Rout."Run Time" := 5 * WorkQTY
                    else
                        rout."Run Time" := 10 * WorkQTY;
                    Rout.Insert();


                end;
            }
            action(Fab)
            {
                Image = WorkTax;
                trigger OnAction()
                var
                    Rout: Record "Estimator Router";
                begin
                    //Message('Action Under Construction, please be patient.');
                    if Rout.Get(rec."No.", '') then begin
                        Message('All routing lines must be numbered.');
                        exit;
                    end;
                    if WorkQTY <= 0 then begin
                        Message('Work QTY must be greater than zero.');
                        exit;
                    end;

                    Rout.Init();
                    Rout."Estimation No." := rec."No.";
                    Rout."No." := 'FAB';
                    Rout.Description := Format(WorkQTY) + ' QTY ' + Format(WorkSize) + 'Fab';
                    if WorkQTY > 1 then
                        rout.Description += 's';
                    Rout."Setup Time" := 2;
                    Rout."Setup Time Unit of Measure" := 'MIN';

                    case WorkSize of
                        WorkSize::".5″-3″":
                            rout."Run Time" := 5 * WorkQTY;
                        WorkSize::"4″":
                            Rout."Run Time" := 10 * WorkQTY;
                        WorkSize::"6″":
                            Rout."Run Time" := 10 * WorkQTY;
                        WorkSize::"8″":
                            Rout."Run Time" := 15 * WorkQTY;
                    end;

                    Rout.Insert();
                end;
            }
            action(Weld)
            {
                Image = WorkTax;
                trigger OnAction()
                var
                    Rout: Record "Estimator Router";
                begin
                    //Message('Action Under Construction, please be patient.');
                    if Rout.Get(rec."No.", '') then begin
                        Message('All routing lines must be numbered.');
                        exit;
                    end;
                    if WorkQTY <= 0 then begin
                        Message('Work QTY must be greater than zero.');
                        exit;
                    end;

                    Rout.Init();
                    Rout."Estimation No." := rec."No.";
                    Rout."No." := 'WELD';
                    Rout.Description := Format(WorkQTY) + ' QTY ' + Format(WorkSize) + 'Weld';
                    if WorkQTY > 1 then
                        rout.Description += 's';
                    Rout."Setup Time" := 2;
                    Rout."Setup Time Unit of Measure" := 'MIN';

                    case WorkSize of
                        WorkSize::".5″-3″":
                            rout."Run Time" := 5 * WorkQTY;
                        WorkSize::"4″":
                            Rout."Run Time" := 10 * WorkQTY;
                        WorkSize::"6″":
                            Rout."Run Time" := 10 * WorkQTY;
                        WorkSize::"8″":
                            Rout."Run Time" := 15 * WorkQTY;
                    end;

                    Rout.Insert();
                end;
            }
            action(Polish)
            {
                Image = WorkTax;
                trigger OnAction()
                var
                    Rout: Record "Estimator Router";
                begin
                    //Message('Action Under Construction, please be patient.');
                    if Rout.Get(rec."No.", '') then begin
                        Message('All routing lines must be numbered.');
                        exit;
                    end;
                    if WorkQTY <= 0 then begin
                        Message('Work QTY must be greater than zero.');
                        exit;
                    end;

                    Rout.Init();
                    Rout."Estimation No." := rec."No.";
                    Rout."No." := 'POLISHWELD';
                    Rout.Description := Format(WorkQTY) + ' QTY ' + Format(WorkSize) + 'Polish';
                    if WorkQTY > 1 then
                        rout.Description += 'es';
                    Rout."Setup Time" := 2;
                    Rout."Setup Time Unit of Measure" := 'MIN';

                    case WorkSize of
                        WorkSize::".5″-3″":
                            rout."Run Time" := 15 * WorkQTY;
                        WorkSize::"4″":
                            Rout."Run Time" := 20 * WorkQTY;
                        WorkSize::"6″":
                            Rout."Run Time" := 25 * WorkQTY;
                        WorkSize::"8″":
                            Rout."Run Time" := 30 * WorkQTY;
                    end;

                    Rout.Insert();
                end;
            }
            /* action(clearempty)
            {
                trigger OnAction()
                var
                    ebom: record "Estimator BOM";
                    erout: Record "Estimator Router";
                begin
                    ebom.SetRange("Estimation No.", '');
                    if ebom.FindSet() then
                        ebom.DeleteAll();
                    erout.SetRange("Estimation No.", '');
                    if erout.FindSet() then
                        erout.DeleteAll();
                end;
            } */
            action("Quote")
            {
                Image = ViewDocumentLine;
                Caption = 'Quote';
                trigger OnAction()
                var
                    SQ: Record "Sales Header";
                    SP: page "Sales Quote";
                begin

                    if sq.get(sq."Document Type"::Quote, rec."Quote No.") then begin
                        sp.SetRecord(SQ);
                        sp.Run();
                    end;
                end;
            }
            action(Ticket)
            {
                Image = ViewDocumentLine;
                Caption = 'Ticket';
                trigger OnAction()
                var
                    Tick: Record Ticketing;
                    TP: page "Ticket Card";
                begin
                    if tick.Get(rec."Ticket No.", tick."Submitted To"::Engineering) then begin
                        TP.SetRecord(tick);
                        tp.run();
                    end;
                end;
            }
        }
    }
    /// <summary>
    /// PullRef.
    /// For use on adding a reference item, pulls in
    /// BOM and Routings, deleting old entries
    /// </summary>
    procedure PullRef()
    var
        itref: record Item;
        Ebom: record "Estimator BOM";
        ERout: record "Estimator Router";
        it: record Item;

        bom: record "Production BOM Line";
        rout: record "Routing Line";

        ItemAvailCU: Codeunit "Item Avail CU";
    begin
        //clear current bom & routing
        Ebom.SetRange("Estimation No.", rec."No.");
        if ebom.FindSet() then ebom.DeleteAll();
        Erout.SetRange("Estimation No.", rec."No.");
        if erout.FindSet() then ERout.DeleteAll();

        itref.get(rec."Reference Item");
        //pull in bom
        if itref."Production BOM No." <> '' then begin
            bom.setrange("Production BOM No.", itref."Production BOM No.");
            bom.Findfirst();
            repeat
                ebom.Init();
                ebom."Line No." := bom."Line No.";
                ebom."Estimation No." := rec."No.";
                ebom."Item No." := bom."No.";
                Ebom."Item Description" := bom.Description;
                Ebom."Quantity Per" := bom."Quantity per";
                Ebom."Available Quantity" := ItemAvailCU.Get_Qty_Avail(bom."No.", '', '');
                it.get(bom."No.");
                if it."Inventory Posting Group" = 'RAW MATERIAL' then ebom."Available Quantity" := ItemAvailCU.get_Qty_onhand(it."No.", 'MAINHQ', 'RAWMATL', ebom."Available Quantity");
                ebom.Insert(true);
            until bom.Next() = 0;
        end;

        //pull in router
        if itref."Routing No." <> '' then begin
            rout.setrange("Routing No.", itref."Routing No.");
            rout.FindFirst();
            repeat
                ERout.Init();
                Erout."Operation No." := rout."Operation No.";
                ERout."Estimation No." := rec."No.";
                ERout."No." := rout."No.";
                ERout.Description := rout.Description;
                ERout."Setup Time" := rout."Setup Time";
                ERout."Setup Time Unit of Measure" := rout."Setup Time Unit of Meas. Code";
                Erout."Run Time" := rout."Run Time";
                ERout.Insert();
            until rout.Next() = 0;
        end;
    end;

    /// <summary>
    /// SideGet.
    /// Gets current set of BOM and Routings
    /// </summary>
    /// <param name="BOM">VAR record "Estimator BOM".</param>
    /// <param name="Router">VAR record "Estimator Router".</param>
    procedure SideGet(var BOM: record "Estimator BOM"; var Router: record "Estimator Router")
    begin
        BOM.SetRange("Estimation No.", rec."No.");
        if BOM.FindFirst() then begin

        end;
        Router.SetRange("Estimation No.", rec."No.");
        if router.FindFirst() then begin

        end;
    end;

    var
        WorkQTY: Decimal;
        WorkSize: enum "Work Size";
}