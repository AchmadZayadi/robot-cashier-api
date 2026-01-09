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

Set headers inquiry
    [Arguments] 
    ${headers}=    Create Dictionary
    ...    timestamp=${TIMESTAMP}
    ...    geolocation=${GEOLOCATION}
    ...    appsId=${APPS_ID}
    ...    auth=Authhorization

    RETURN    ${headers}

Inquiry - Success
    [Arguments]         ${payload}
    ${header}=     Set headers inquiry
    Create Session      InquirySuccess   ${ENDPOINT_INQUIRY}    verify=${True}
    ${response}=    POST On Session    InquirySuccess    ${ENDPOINT_INQUIRY}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Inquiry Invalid Header
    [Arguments]         ${payload}
    ${header}=     Set headers inquiry
    Create Session      InquiryInvalidHeader   ${ENDPOINT_INQURY_INVALID_HEADER}    verify=${True}
    ${response}=    POST On Session    InquiryInvalidHeader    ${ENDPOINT_INQURY_INVALID_HEADER}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Inquiry Invalid Payload 
    [Arguments]         ${payload}
    ${header}=     Set headers inquiry
    Create Session      InquiryInvalidPayload  ${ENDPOINT_INQURY_INVALID_PAYLOAD}    verify=${True}
    ${response}=    POST On Session    InquiryInvalidPayload    ${ENDPOINT_INQURY_INVALID_PAYLOAD}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Inquiry Invalid Error Stock 
    [Arguments]         ${payload}
    ${header}=     Set headers inquiry
    Create Session      InquiryInvalidErrorStock  ${ENDPOINT_INQUIRY_422}    verify=${True}
    ${response}=    POST On Session    InquiryInvalidErrorStock    ${ENDPOINT_INQUIRY_422}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Inquiry Invalid Timeout 
    [Arguments]         ${payload}       
    ${header}=     Set headers inquiry
    Create Session      InquiryInvalidTimeout  ${ENDPOINT_INQUIRY_504}    verify=${True}
    ${response}=    POST On Session    InquiryInvalidTimeout    ${ENDPOINT_INQUIRY_504}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}
