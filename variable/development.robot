*** Variables ***
${BASE_URL}                           http://localhost:3006
${ENDPOINT_LOGIN}                     ${BASE_URL}/v1/auth/login
${ENDPOINT_LOGIN_USER_NOT_REGISTER}   ${BASE_URL}/v1/auth/login/notRegister
${ENDPOINT_INVALID_HEADER_LOGIN}      ${BASE_URL}/v1/auth/login/failedHeader
${ENDPOINT_LOGIN_REQUEST_MANDATORY}   ${BASE_URL}/v1/auth/login/requestBodyIsEmpty
${ENDPOINT_LOGIN_401}                 ${BASE_URL}/v1/auth/login/401
${ENDPOINT_LOGIN_504}                 ${BASE_URL}/v1/auth/login/504
${ENDPOINT_LIST_PRODUCT}              ${BASE_URL}/v1/products
${ENDPOINT_LIST_PRODUCT_EMPTY}        ${BASE_URL}/v1/products/emptyData
${ENDPOINT_LIST_PRODUCT_400}          ${BASE_URL}/v1/products/400
${ENDPOINT_LIST_PRODUCT_500}          ${BASE_URL}/v1/products/500
${ENDPOINT_INQUIRY}                   ${BASE_URL}/v1/transactions/inquiry
${ENDPOINT_INQURY_INVALID_HEADER}     ${BASE_URL}/v1/transactions/inquiry/invalidHeader
${ENDPOINT_INQURY_INVALID_PAYLOAD}    ${BASE_URL}/v1/transactions/inquiry/invalidPayload
${ENDPOINT_INQUIRY_422}               ${BASE_URL}/v1/transactions/inquiry/422
${ENDPOINT_INQUIRY_504}               ${BASE_URL}/v1/transactions/inquiry/504
${ENDPOINT_PAYMENT}                   ${BASE_URL}/v1/transactions/payment
${ENDPOINT_PAYMENT_INVALID_HEADER}    ${BASE_URL}/v1/transactions/payment/invalidHeader
${ENDPOINT_PAYMENT_INVALID_PAYLOAD}   ${BASE_URL}/v1/transactions/payment/invalidPayload
${ENDPOINT_PAYMENT_PENDING}           ${BASE_URL}/v1/transactions/payment/pending
${ENDPOINT_PAYMENT_400}               ${BASE_URL}/v1/transactions/payment/400
${ENDPOINT_PAYMENT_500}               ${BASE_URL}/v1/transactions/payment/500
${ENDPOINT_RECEIPT}                   ${BASE_URL}/v1/transactions/receipt
${ENDPOINT_RECEIPT_404}               ${BASE_URL}/v1/transactions/receipt/404
${ENDPOINT_RECEIPT_504}               ${BASE_URL}/v1/transactions/receipt/504



# Value Header
${APPS_ID}                            appsid
${TIMESTAMP}                          1726033478
${GEOLOCATION}                        77665544332211