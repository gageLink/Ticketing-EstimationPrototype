/// <summary>
/// Table Estimator BOM (ID 90001).
/// </summary>
table 90001 "Estimator BOM"
{
    fields
    {
        field(1; "Estimation No."; code[20])
        {

        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
        }
        field(3; "Item No."; code[20])
        {
            TableRelation = Item;
        }
        field(4; "Item Description"; text[100])
        {

        }
        field(5; "Quantity Per"; Decimal)
        {

        }
        field(6; "Unit Price"; Decimal)
        {

        }
        field(7; "Unit Cost"; Decimal)
        {

        }
        field(8; "Available Quantity"; Decimal)
        {

        }
    }
    keys
    {
        key(Primary; "Estimation No.", "Line No.")
        {

        }
    }
    trigger OnInsert()
    var
        BOM: record "Estimator BOM";
        it: record Item;
        BT: record "Estimator BOM" temporary;
        EstPric: Codeunit "Estimation Pricing";
    begin
        if rec."Line No." = 0 then begin
            bom.SetRange("Estimation No.", rec."Estimation No.");
            bom.SetAscending("Line No.", false);
            if bom.FindSet() then begin
                rec."Line No." := bom."Line No." + 10000;
            end else
                rec."Line No." := 10000;
        end;
        if rec."Unit Cost" = 0 then begin
            it.get(rec."Item No.");
            rec."Unit Cost" := it."Unit Cost";
        end;
        BT.Copy(Rec);
        BT.Insert();
        rec."Unit Price" := EstPric.WhatPriceIsRight(BT);
    end;


    trigger OnModify()
    begin
        //update price and cost
    end;
}