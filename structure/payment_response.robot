*** Settings ***
Library     OperatingSystem
Library     Collections
Library     BuiltIn
Library     RequestsLibrary
Library     OperatingSystem

*** Keywords ***
Validate Payment Response Success
    [Arguments]    ${response_json}
    
    Dictionary Should Contain Key    ${response_json}    responseCode
    Dictionary Should Contain Key    ${response_json}    status
    Dictionary Should Contain Key    ${response_json}    data
    
    Should Be Equal As Integers      ${response_json['responseCode']}    200
    Should Be Equal As Strings       ${response_json['status']}          success    ignore_case=True

    ${data}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${data}    transaction_id
    Dictionary Should Contain Key    ${data}    payment_status
    Dictionary Should Contain Key    ${data}    paid_at

    Should Be Equal As Strings       ${data['payment_status']}           PAID
    Should Start With                ${data['transaction_id']}           TRX-

    Should Contain                   ${data['paid_at']}                  T
    Should End With                  ${data['paid_at']}                  Z
Validate payment Failed Response    
    [Arguments]    ${response}    ${responseCode}    ${status}
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status

    Should Be Equal As Integers       ${response['responseCode']}      ${responseCode}
    Should Be Equal As Strings        ${response['status']}            ${status}
