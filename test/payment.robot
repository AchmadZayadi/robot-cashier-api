*** Settings ***
Library     OperatingSystem
Resource    ../resource/key_payment.robot
Resource    ../structure/payment_response.robot
Resource     ../variable/development.robot


*** Keywords ***
Request Body Payment
    [Arguments]    ${inquiry_id}=INQ-7788    ${method}=CASH    ${amount}=${55000}
    
    ${body}=       Create Dictionary    
    ...            inquiry_id=${inquiry_id}    
    ...            payment_method=${method}    
    ...            amount_paid=${amount}
    ...            remark=Testing Automation
    
    RETURN       ${body}

*** Test Cases ***

TC16 Payment - Success [200]
    ${payload}=    Request Body Payment
    ${response}=      Payment - Success    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate Payment Response Success     ${response}  

TC17 Payment - Invalid Header [400]
    ${payload}=    Request Body Payment
    ${response}=      Payment Invalid Header    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate payment Failed Response      ${response}    400    failed  

TC18 Payment - Invalid Payload [400]
    ${payload}=    Request Body Payment
    ${response}=      Payment Invalid Payload    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate payment Failed Response      ${response}    400    failed  

TC19 Payment - pending [200]
    ${payload}=    Request Body Payment
    ${response}=      Payment Pending    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate payment Failed Response      ${response}    200    success  

TC20 Payment - Saldo Kurang [400]
    ${payload}=    Request Body Payment    
    ${response}=      Payment Saldo Kurang    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate payment Failed Response      ${response}    400    failed  

TC21 Payment - Timeout[500]
    ${payload}=    Request Body Payment
    ${response}=     Payment Timeout    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    500
    Validate payment Failed Response      ${response}    500    pending  
