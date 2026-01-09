*** Settings ***
Resource        ../variable/development.robot
Library         RequestsLibrary
Library         Collections
Library         BuiltIn
Library         String
Library         String
Library         OperatingSystem
Library         BuiltIn
Library         json
Library         Process



*** Keywords ***

Set headers Receipt
    [Arguments] 
    ${headers}=    Create Dictionary
    ...    timestamp=${TIMESTAMP}
    ...    geolocation=${GEOLOCATION}
    ...    appsId=${APPS_ID}

    RETURN    ${headers}

Receipt - Success
    ${header}=     Set headers Receipt
    Create Session      ReceiptSuccess   ${ENDPOINT_RECEIPT}    verify=${True}
    ${response}=    GET On Session    ReceiptSuccess    ${ENDPOINT_RECEIPT}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Receipt 404 - Success
    ${header}=     Set headers Receipt
    Create Session      Receipt404   ${ENDPOINT_RECEIPT_404}    verify=${True}
    ${response}=    GET On Session    Receipt404    ${ENDPOINT_RECEIPT_404}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Receipt 504 - Success
    ${header}=     Set headers Receipt
    Create Session      Receipt504   ${ENDPOINT_RECEIPT_504}    verify=${True}
    ${response}=    GET On Session    Receipt504    ${ENDPOINT_RECEIPT_504}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}


Generate PDF Report After Test
    Run Process    python3    library/generate_pdf_report.py
