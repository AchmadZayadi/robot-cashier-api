*** Settings ***
Library     OperatingSystem
Resource    ../resource/key_inquiry.robot
Resource    ../structure/inquiry_response.robot
Resource     ../variable/development.robot


*** Keywords ***
Request Body Inquiry Success
    [Arguments]    ${cust_id}=CUST-007
    
    ${item1}=      Create Dictionary    product_id=P01    quantity=${2}
    ${item2}=      Create Dictionary    product_id=P02    quantity=${1}
    ${items}=      Create List          ${item1}          ${item2}
    
    ${body}=       Create Dictionary    
    ...            items=${items}    
    ...            customer_id=${cust_id}
    
    RETURN       ${body}

Request Body Inquiry Empty
    [Arguments]    ${cust_id}=${EMPTY}
    
    ${item1}=      Create Dictionary    product_id=P01    quantity=${2}
    ${item2}=      Create Dictionary    product_id=P02    quantity=${1}
    ${items}=      Create List          ${item1}          ${item2}
    
    ${body}=       Create Dictionary    
    ...            items=${items}    
    ...            customer_id=${cust_id}
    
    RETURN       ${body}


*** Test Cases ***
TC11 Inquiry - Success [200]
    ${payload}=        Request Body Inquiry Success
    ${response}=       Inquiry - Success    ${payload}    
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate Inquiry Response Success   ${response}  


TC12 Inquiry Invalid Header - Invalid [400]
    ${payload}=        Request Body Inquiry Success
    ${response}=       Inquiry Invalid Header    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate Inquiry Failed Response    ${response}    400    failed


TC13 Inquiry Invalid Payload - Invalid [400]
    ${payload}=        Request Body Inquiry Empty
    ${response}=       Inquiry Invalid Payload     ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate Inquiry Failed Response    ${response}    400    failed

TC14 Inquiry Invalid Error Stock - Invalid [422]
    ${payload}=        Request Body Inquiry Success
    ${response}=       Inquiry Invalid Error Stock    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    422
    Validate Inquiry Failed Response    ${response}    422    failed

TC15 Inquiry Invalid Error Timeout - Invalid [504]
    ${payload}=        Request Body Inquiry Success
    ${response}=       Inquiry Invalid Timeout     ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    504
    Validate Inquiry Failed Response    ${response}    504    error