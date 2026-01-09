*** Settings ***
Library     OperatingSystem
Library     Collections
Library     BuiltIn
Library     RequestsLibrary
Library     OperatingSystem

*** Keywords ***
Validate Inquiry Response Success
    [Arguments]    ${response_json}
    
    Dictionary Should Contain Key    ${response_json}    responseCode
    Dictionary Should Contain Key    ${response_json}    status
    Dictionary Should Contain Key    ${response_json}    data
    Should Be Equal As Integers      ${response_json['responseCode']}    200
    Should Be Equal As Strings       ${response_json['status']}          Success

    ${data}=    Set Variable    ${response_json['data']}
    Dictionary Should Contain Key    ${data}    inquiry_id
    Dictionary Should Contain Key    ${data}    subtotal
    Dictionary Should Contain Key    ${data}    PPN_percent
    Dictionary Should Contain Key    ${data}    tax_amount
    Dictionary Should Contain Key    ${data}    total_amount

    ${items}=    Set Variable    ${data['items']}
    Should Not Be Empty    ${items}
    
    FOR    ${item}    IN    @{items}
        Dictionary Should Contain Key    ${item}    product_id
        Dictionary Should Contain Key    ${item}    product_name
        Dictionary Should Contain Key    ${item}    quantity
        Dictionary Should Contain Key    ${item}    price
        Dictionary Should Contain Key    ${item}    item_subtotal
        ${calculated_item_total}=    Evaluate    ${item['price']} * ${item['quantity']}
        Should Be Equal As Numbers    ${item['item_subtotal']}    ${calculated_item_total}
    END

    ${sum_total}=    Evaluate    ${data['subtotal']} + ${data['tax_amount']}
    Should Be Equal As Numbers    ${data['total_amount']}    ${sum_total}

Validate Inquiry Failed Response    
    [Arguments]    ${response}    ${responseCode}    ${status}
    Dictionary Should Contain Key    ${response}    responseCode
    Dictionary Should Contain Key    ${response}    status

    Should Be Equal As Integers       ${response['responseCode']}      ${responseCode}
    Should Be Equal As Strings        ${response['status']}            ${status}
