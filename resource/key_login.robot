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

Set headers Login
    [Arguments] 
    ${headers}=    Create Dictionary
    ...    timestamp=${TIMESTAMP}
    ...    geolocation=${GEOLOCATION}
    ...    appsId=${APPS_ID}

    RETURN    ${headers}

Login - Success
    [Arguments]         ${payload}
    ${header}=     Set headers Login
    Create Session      LoginSuccess   ${ENDPOINT_LOGIN}    verify=${True}
    ${response}=    POST On Session    LoginSuccess    ${ENDPOINT_LOGIN}       json=${payload}     headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Login - Success Not Register
    [Arguments]         ${payload}
    ${header}=     Set headers Login
    Create Session      LoginSuccessNotRegister   ${ENDPOINT_LOGIN_USER_NOT_REGISTER}    verify=${True}
    ${response}=    POST On Session    LoginSuccessNotRegister    ${ENDPOINT_LOGIN_USER_NOT_REGISTER}    json=${payload}     headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Login - Failed Header
    [Arguments]         ${payload}
    ${header}=     Set headers Login
    Create Session      LoginInvalidHeader   ${ENDPOINT_INVALID_HEADER_LOGIN}    verify=${True}
    ${response}=    POST On Session    LoginInvalidHeader    ${ENDPOINT_INVALID_HEADER_LOGIN}     json=${payload}   headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}


Login - RequestBody Is Empty
    [Arguments]         ${payload}
    ${header}=     Set headers Login
    Create Session      LoginSuccessRequestBodyIsEmpty   ${ENDPOINT_LOGIN_REQUEST_MANDATORY}    verify=${True}
    ${response}=    POST On Session    LoginSuccessRequestBodyIsEmpty    ${ENDPOINT_LOGIN_REQUEST_MANDATORY}       json=${payload}     headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Login - Failed 401
    [Arguments]         ${payload}
    ${header}=     Set headers Login
    Create Session      LoginSuccess401   ${ENDPOINT_LOGIN_401}    verify=${True}
    ${response}=    POST On Session    LoginSuccess401    ${ENDPOINT_LOGIN_401}    json=${payload}    headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Login - Timeout 504
    [Arguments]         ${payload}
    ${header}=        Set headers Login
    Create Session    LoginTimeout    ${ENDPOINT_LOGIN_504}    verify=${True}
    ${response}=    POST On Session    LoginTimeout     ${ENDPOINT_LOGIN_504}     json=${payload}   headers=${header}     
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}