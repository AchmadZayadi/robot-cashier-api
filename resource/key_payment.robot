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



*** Keywords ***

Set headers payment
    [Arguments] 
    ${headers}=    Create Dictionary
    ...    timestamp=${TIMESTAMP}
    ...    geolocation=${GEOLOCATION}
    ...    appsId=${APPS_ID}
    ...    auth=Authhorization

    RETURN    ${headers}

Payment - Success
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      PaymentSuccess   ${ENDPOINT_PAYMENT}    verify=${True}
    ${response}=    POST On Session    PaymentSuccess    ${ENDPOINT_PAYMENT}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Payment Invalid Header
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      PaymentInvalidHeader   ${ENDPOINT_PAYMENT_INVALID_HEADER}    verify=${True}
    ${response}=    POST On Session    PaymentInvalidHeader    ${ENDPOINT_PAYMENT_INVALID_HEADER}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}
Payment Invalid Payload
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      PaymentInvalidPayload   ${ENDPOINT_PAYMENT_INVALID_PAYLOAD}    verify=${True}
    ${response}=    POST On Session    PaymentInvalidPayload    ${ENDPOINT_PAYMENT_INVALID_PAYLOAD}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Payment Pending
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      PaymentPending   ${ENDPOINT_PAYMENT_PENDING}    verify=${True}
    ${response}=    POST On Session    PaymentPending    ${ENDPOINT_PAYMENT_PENDING}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Payment Saldo Kurang
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      PaymentSaldoKurang   ${ENDPOINT_PAYMENT_400}    verify=${True}
    ${response}=    POST On Session    PaymentSaldoKurang    ${ENDPOINT_PAYMENT_400}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Payment Timeout
    [Arguments]    ${payload}
    ${header}=     Set headers payment
    Create Session      paymentTimeout   ${ENDPOINT_PAYMENT_500}    verify=${True}
    ${response}=    POST On Session    paymentTimeout    ${ENDPOINT_PAYMENT_500}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

