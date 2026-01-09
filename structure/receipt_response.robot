*** Settings ***
Library     OperatingSystem
Library     Collections
Library     BuiltIn
Library     RequestsLibrary
Library     OperatingSystem

*** Keywords ***


Validate Receipt Success Response
    [Arguments]    ${response_json}
    
    Dictionary Should Contain Key    ${response_json}    responseCode
    Dictionary Should Contain Key    ${response_json}    status
    Dictionary Should Contain Key    ${response_json}    data
    Should Be Equal As Integers      ${response_json['responseCode']}    200
    Should Be Equal As Strings       ${response_json['status']}          success

    ${data}=       Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${data}    receipt_number
    Dictionary Should Contain Key    ${data}    content

    ${content}=    Set Variable    ${data['content']}
    Dictionary Should Contain Key    ${content}    header
    Dictionary Should Contain Key    ${content}    items
    Dictionary Should Contain Key    ${content}    totalPrice
    Dictionary Should Contain Key    ${content}    footer

    ${items}=      Set Variable    ${content['items']}
    Should Not Be Empty    ${items}

    FOR    ${item}    IN    @{items}
        Dictionary Should Contain Key    ${item}    name
        Dictionary Should Contain Key    ${item}    qty
        Dictionary Should Contain Key    ${item}    price
        Dictionary Should Contain Key    ${item}    total
        
        ${item_calc}=    Evaluate    ${item['qty']} * ${item['price']}
        Should Be Equal As Numbers    ${item['total']}    ${item_calc}
    END

    Should Be Equal As Strings    ${content['header']}    KOPI GEMINI JAKARTA
    Should Not Be Empty           ${content['footer']}


Validate Receipt Failed Response    
    [Arguments]    ${response}    ${responseCode}    ${status}
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status

    Should Be Equal As Integers       ${response['responseCode']}      ${responseCode}
    Should Be Equal As Strings        ${response['status']}            ${status}
