*** Settings ***
Documentation    QP-01: Custom pizza recommendation scenario on QuickPizza.
Library    DateTime
Resource    resources/quickpizza.resource
Test Teardown    Close Browser


*** Test Cases ***
Customer Requests A Custom Pizza And Admin Sees It
    [Documentation]    Request a custom pizza with restrictions and verify it appears in the admin list.
    Open QuickPizza
    Turn On Advanced
    ${stamp}=    Get Current Date    result_format=%Y%m%d-%H%M%S
    ${name}=    Set Variable    Lab Pizza ${stamp}
    Log    ${name}
    Fill In The Pizza Request    600    Knife    ${name}
    Capture Page Screenshot    qp01-step3-fields.png
