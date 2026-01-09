*** Settings ***
Resource        ../variable/development.robot
Library         RequestsLibrary
Library         Collections
Library         BuiltIn
Library         String
Library         String
Library         OperatingSystem
Library         BuiltIn
Library         json



*** Keywords ***

Set headers Product
    [Arguments] 
    ${headers}=    Create Dictionary
    ...    timestamp=${TIMESTAMP}
    ...    geolocation=${GEOLOCATION}
    ...    appsId=${APPS_ID}

    RETURN    ${headers}

Product List - Success
    ${header}=     Set headers Product
    Create Session      ProductListSuccess   ${ENDPOINT_LIST_PRODUCT}    verify=${True}
    ${response}=    GET On Session    ProductListSuccess    ${ENDPOINT_LIST_PRODUCT}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Product List Data Empty - Success
    ${header}=     Set headers Product
    Create Session      ProductListEmptySuccess   ${ENDPOINT_LIST_PRODUCT_EMPTY}    verify=${True}
    ${response}=    GET On Session    ProductListEmptySuccess    ${ENDPOINT_LIST_PRODUCT_EMPTY}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Product List 400 - Failed
    ${header}=     Set headers Product
    Create Session      ProductList400   ${ENDPOINT_LIST_PRODUCT_400}    verify=${True}
    ${response}=    GET On Session    ProductList400    ${ENDPOINT_LIST_PRODUCT_400}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}

Product List 500 - Time Out
    ${header}=     Set headers Product
    Create Session      ProductListTimeOut   ${ENDPOINT_LIST_PRODUCT_500}    verify=${True}
    ${response}=    GET On Session    ProductListTimeOut    ${ENDPOINT_LIST_PRODUCT_500}        headers=${header}      
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response}
    RETURN    ${response.json()}