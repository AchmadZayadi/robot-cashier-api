*** Settings ***
Library     OperatingSystem
Library     Collections
Library     BuiltIn
Library     RequestsLibrary
Library     OperatingSystem

*** Keywords ***
Validate List Product Response Success
    [Arguments]    ${response}
    # 1. Validasi Root Level
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    data

    Should Be Equal As Integers       ${response['responseCode']}      200
    Should Be Equal As Strings        ${response['status']}            success


    ${products}=    Set Variable    ${response['data']}
    Should Not Be Empty    ${products}
    

    FOR    ${product}    IN    @{products}
        Dictionary Should Contain Key    ${product}    id
        Dictionary Should Contain Key    ${product}    name
        Dictionary Should Contain Key    ${product}    price
        ${price_type}=    Evaluate    type($product['price']).__name__
        Should Be Equal As Strings    ${price_type}    int
    END

Validate List Product Empty Response    
    [Arguments]    ${response}
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status
    Dictionary Should Contain Key    ${response}    data

    Should Be Equal As Integers       ${response['responseCode']}      200
    Should Be Equal As Strings        ${response['status']}            success

    Should Be Equal    ${response['data']}    ${None}

    
Validate List Product Failed Response    
    [Arguments]    ${response}    ${responseCode}    ${status}
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status

    Should Be Equal As Integers       ${response['responseCode']}      ${responseCode}
    Should Be Equal As Strings        ${response['status']}            ${status}
