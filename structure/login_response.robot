*** Settings ***
Library     OperatingSystem
Library     Collections
Library     BuiltIn
Library     RequestsLibrary
Library     OperatingSystem

*** Keywords ***

Validate Login Response Success

    [Arguments]    ${response}    
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    data


    Should Be Equal As Strings       ${response['responseCode']}      200
    Should Be Equal As Strings       ${response['status']}            Success

    ${data}=    Set Variable    ${response['data']}
    
    Dictionary Should Contain Key    ${data}    token
    Dictionary Should Contain Key    ${data}    user
    Dictionary Should Contain Key    ${data}    expiresAt
    

    ${user}=    Set Variable    ${data['user']}
    Dictionary Should Contain Key    ${user}    id
    Dictionary Should Contain Key    ${user}    name
    Dictionary Should Contain Key    ${user}    role

Validate Login Account Not Registered Response    
    [Arguments]    ${response}    
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    message
    
Validate Login Error 401 Response    
    [Arguments]    ${response}    
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    message

Validate Login Error 504 Response    
    [Arguments]    ${response}    
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    message