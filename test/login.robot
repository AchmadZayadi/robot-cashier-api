*** Settings ***
Library     OperatingSystem
Resource    ../resource/key_login.robot
Resource    ../structure/login_response.robot
Resource     ../variable/development.robot
Library      Process

# Suite Teardown    Run Python PDF Generator




*** Keywords ***
Run Python PDF Generator
    # Pastikan path ke script python sudah benar
    Run Process    python    library/generate_pdf_report.py
    Log To Console    \nPDF Report has been generated automatically!
Request Body Login Success
    ${JSON_BODY} =    Create Dictionary
    ...    idEmployee=admin
    ...    password=admin123
    
    RETURN   ${JSON_BODY}

Request Body Login Empty
    ${JSON_BODY} =    Create Dictionary
    ...    idEmployee=${EMPTY}
    ...    password=${EMPTY}
    
    RETURN   ${JSON_BODY}

*** Test Cases ***

TC01 Login - Success [200]
    ${payload} =       Request Body Login Success
    ${response}=       Login - Success    ${payload}
    Log    Request Body: ${payload}
    Log    Response: ${response}
    
    Should Be Equal As Integers    ${response['responseCode']}    200
    Should Be Equal As Strings     ${response['status']}          Success
    Validate Login Response Success    ${response}  

TC02 Login - Success Not Register [200]
    ${payload} =       Request Body Login Success
    ${response}=       Login - Success Not Register    ${payload}
    Log    Request Body: ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    200
    Validate Login Account Not Registered Response     ${response}  


TC03 Login - Invalid Header [400]
    ${payload} =       Request Body Login Success
    ${response}=       Login - Failed Header    ${payload}
    Log    Request Body: ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate Login Account Not Registered Response     ${response}  

TC04 Login - Empty Request Body [400]
    ${payload} =       Request Body Login Empty
    ${response}=       Login - RequestBody Is Empty    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    400
    Validate Login Error 401 Response     ${response}  

TC05 Login - Failed Password or User Name [401]
    ${payload} =       Request Body Login Success
    ${response}=       Login - Failed 401    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    401
    Validate Login Error 401 Response     ${response}  

TC06 Login - Timeout [504]
    ${payload} =       Request Body Login Success
    ${response}=    Login - Timeout 504    ${payload}
    Log    Response: ${response}
    Should Be Equal As Integers    ${response['responseCode']}    504
    Validate Login Error 504 Response    ${response}
