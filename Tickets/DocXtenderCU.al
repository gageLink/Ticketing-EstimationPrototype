/// <summary>
/// Codeunit Docxtension (ID 90550).
/// </summary>
codeunit 90550 "Docxtension"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IWX DocXtender", 'OnGetCustomRecRefFromDocAttachment'
    , '', false, false)]
    local procedure OnGetCustomRecRefFromDocAttachmentDocXtender(precDocumentAttachment: Record "Document Attachment"; var prrRecordRef: RecordRef; var lbRecordRefHandled: Boolean);
    var
        lrecTicketing: Record "Ticketing";
    begin
        // Set the table for the custom record, when attached documents using drag-and-drop with DocXtender
        if not lbRecordRefHandled then begin
            case precDocumentAttachment."Table ID" of
                Database::Ticketing:
                    begin
                        prrRecordRef.Open(Database::"ticketing");
                        if lrecTicketing.Get(precDocumentAttachment."No.") then begin
                            prrRecordRef.GetTable(lrecTicketing);
                            lbRecordRefHandled := true;
                        end;
                    end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IWX DocXtender", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRefDocXtender(var precDocumentAttachment: Record "Document Attachment"; var prrRecordRef: RecordRef);

    var

        lfrFieldRef: FieldRef;
        lcodRecNo: Code[20];

    begin

        // Set filter for custom record when opening document attachment details

        case prrRecordRef.Number of

            Database::Ticketing:

                begin

                    lfrFieldRef := prrRecordRef.Field(2);

                    lcodRecNo := lfrFieldRef.Value;

                    precDocumentAttachment.SetRange("No.", lcodRecNo);

                end;

        end;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);

    var

        lfrFieldRef: FieldRef;

        lcodRecNo: Code[20];

    begin

        // Set filter for custom record when opening document attachment details

        case RecRef.Number of

            Database::Ticketing:

                begin

                    lfrFieldRef := RecRef.Field(2);

                    lcodRecNo := lfrFieldRef.Value;

                    DocumentAttachment.SetRange("No.", lcodRecNo);

                end;

        end;

    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);

    var

        lrecProductionOrder: Record Ticketing;

    begin

        // Set the table for the custom record, when attaching documents manually

        case DocumentAttachment."Table ID" of

            Database::Ticketing:

                begin

                    RecRef.Open(Database::ticketing);

                    if lrecProductionOrder.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(lrecProductionOrder);

                end;

        end;

    end;
}