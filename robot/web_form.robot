*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close Browser


*** Variables ***
${URL}    https://www.selenium.dev/selenium/web/web-form.html
${BROWSER}    chrome


*** Test Cases ***
Submitting The Web Form Shows Received
    [Documentation]    Fill in the practice web form, submit it, and assert the confirmation message.
    Open Browser    ${URL}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Input Text    id:my-text-id    Robot
    Input Password    name:my-password    Secret123
    Input Text    name:my-textarea    My first form test
    Select From List By Label    name:my-select    Two
    Select Checkbox    id:my-check-2
    Select Radio Button    my-radio    my-radio-2
    Input Text    name:my-date    11/05/2026
    Click Button    css:button[type=submit]
    Wait Until Element Is Visible    id:message
    Title Should Be    Web form - target page
    Element Text Should Be    id:message    Received!
