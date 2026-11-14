*** Settings ***
Documentation    QP-01: Custom pizza recommendation scenario on QuickPizza.
Resource    resources/quickpizza.resource
Test Teardown    Close Browser


*** Test Cases ***
Customer Requests A Custom Pizza And Admin Sees It
    [Documentation]    Open QuickPizza and run the customer-to-admin custom pizza check.
    Open QuickPizza
