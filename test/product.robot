*** Settings ***
Library     OperatingSystem
Resource    ../resource/key_product.robot
Resource    ../structure/product_response.robot
Resource     ../variable/development.robot


*** Test Cases ***

TC07 Product List - Success [200]
    ${response}=       Product List - Success
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate List Product Response Success     ${response}  

TC08 Product List Empty - Success [200]
    ${response}=       Product List Data Empty - Success
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate List Product Empty Response      ${response}  

TC09 Product List - Failed [400]
    ${response}=      Product List 400 - Failed
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate List Product Failed Response      ${response}    400    failed  

TC10 Product List - Timeout [500]
    ${response}=    Product List 500 - Time Out
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    500
    Validate List Product Failed Response      ${response}    500    error  


