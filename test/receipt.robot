*** Settings ***
Library     OperatingSystem
Resource    ../resource/key_receipt.robot
Resource    ../structure/receipt_response.robot
Resource     ../variable/development.robot
Suite Teardown    Generate PDF Report After Test


*** Test Cases ***

TC22 Receipt - Success [200]
    ${response}=       Receipt - Success
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate Receipt Success Response    ${response}  
TC23 Receipt - Transaction Not Found [404]
    ${response}=       Receipt 404 - Success
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    404
    Validate Receipt Failed Response     ${response}     404    failed

TC24 Receipt - Failed Generate Receipt [504]
    ${response}=       Receipt 504 - Success
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    504
    Validate Receipt Failed Response     ${response}     504    error