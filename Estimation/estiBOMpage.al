/// <summary>
/// Page EstiBOM (ID 90001).
/// </summary>
page 90001 "EstiBOM"
{
    ApplicationArea = all;
    SourceTable = "Estimator BOM";
    PageType = ListPart;
    layout
    {
        area(Content)
        {
            repeater(BOM)
            {
                field("Item No."; Rec."Item No.")
                {
                    trigger OnValidate()
                    begin
                        BOMPop();
                    end;
                }
                field("Item Description"; Rec."Item Description")
                {

                }
                field("Quantity Per"; Rec."Quantity Per")
                {

                }
                field("Unit Price"; Rec."Unit Price")
                {

                }
                field("Unit Cost"; Rec."Unit Cost")
                {

                }
                field("Available Quantity"; Rec."Available Quantity")
                {
                    Editable = false;
                }
            }
        }
    }
    /// <summary>
    /// BOMPop.
    /// </summary>
    procedure BOMPop()
    var
        it: record item;
        ItemAvailCU: Codeunit "Item Avail CU";
    begin
        it.get(rec."Item No.");
        rec."Item Description" := it.Description;
        if it."Unit Price" <> 0 then begin
            rec."Unit Price" := it."Unit Price";
        end else
            rec."Unit Price" := it."Unit Cost" * 1.2;
        rec."Unit Cost" := it."Unit Cost";
        rec."Available Quantity" := ItemAvailCU.Get_Qty_Avail(it."No.", '', '');
        if it."Inventory Posting Group" = 'RAW MATERIAL' then rec."Available Quantity" := ItemAvailCU.get_Qty_onhand(it."No.", 'MAINHQ', 'RAWMATL', rec."Available Quantity");
    end;
}