/// <summary>
/// Codeunit Estimation Pricing (ID 90000).
/// </summary>
codeunit 90000 "Estimation Pricing"
{
    /// <summary>
    /// BOMLinePrice.
    /// Takes an Estimator BOM line and Cost and Price variables
    /// and returns updated values of the latter two.
    /// </summary>
    /// <param name="BOM">record "Estimator BOM".</param>
    /// <param name="Cost">Decimal.</param>
    /// <param name="Price">Decimal.</param>
    procedure BOMLinePrice(BOM: record "Estimator BOM"; var Cost: Decimal; var Price: Decimal)
    begin
        Cost += BOM."Unit Cost" * bom."Quantity Per";
        Price += BOM."Unit Price" * bom."Quantity Per";
    end;

    /// <summary>
    /// RoutLinePrice.
    /// Takes an Estimator Router line and Cost, Price and Setup variables
    /// and returns updated values of the latter Three.
    /// </summary>
    /// <param name="Rout">record "Estimator Router".</param>
    /// <param name="Cost">Decimal.</param>
    /// <param name="Price">Decimal.</param>
    /// <param name="Setup">Decimal.</param>
    procedure RoutLinePrice(Rout: record "Estimator Router"; var Cost: Decimal; var Price: Decimal; var Setup: Decimal)
    var
        WorkCenter: Record "Work Center";
    begin
        WorkCenter.get(Rout."No.");
        Cost += WorkCenter."Unit Cost" * Rout."Run Time";
        Price += WorkCenter."Unit Cost" * Rout."Run Time";
        Setup += WorkCenter."Unit Cost" * Rout."Setup Time";
    end;

    /// <summary>
    /// AccessRoutPricing.
    /// </summary>
    /// <param name="Rout">record "Estimator Router".</param>
    /// <param name="Cost">VAR Decimal.</param>
    /// <param name="Price">VAR Decimal.</param>
    /// <param name="Setup">VAR Decimal.</param>
    procedure AccessRoutPricing(Rout: record "Estimator Router"; var Cost: Decimal; var Price: Decimal; var Setup: Decimal)
    begin
        Cost += 1.58 * Rout."Run Time";
        Price += 1.58 * Rout."Run Time";
        Setup += 1.58 * Rout."Setup Time";
    end;

    /// <summary>
    /// WhatPriceIsRight.
    /// Goes through the heirarchy of pricing:
    /// Customer Specific > Customer Price Group > Unit Price > Unit Cost * 1.2 > No cost, alert user.
    /// Returns best price.
    /// 
    /// NOTE: this must be updated along with the ranked pricing mod.
    /// I'll be gluing it into the ticketing system first though
    /// </summary>
    /// <param name="BOM">Record "Estimator BOM".</param>
    /// <returns>Return variable RightPrice of type Decimal.</returns>
    procedure WhatPriceIsRight(BOM: Record "Estimator BOM") RightPrice: Decimal
    var
        Est: Record "Estimator Header";
        Cust: Record Customer;
        SP: Record "Price List Line";
        Item: Record Item;
        NSP: Codeunit "SOB Price Calculation";
        CSP: Boolean;
    begin
        Est.Get(BOM."Estimation No.");
        if cust.get(est."Customer No.") then
            exit(nsp.SOBPricing(est."Customer No.", bom."Item No.", cust."Customer Price Group", CSP));


        //Unit Price
        Item.get(BOM."Item No.");
        if Item."Unit Price" <> 0 then
            exit(Item."Unit Price");


        //Unit Cost * 1.2
        if Item."Unit Cost" <> 0 then
            exit(Item."Unit Cost" * 1.2);
        //Nil
        RightPrice := 0;
    end;
}