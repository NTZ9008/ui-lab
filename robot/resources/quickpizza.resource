*** Settings ***
Documentation    Keywords and locators for the QuickPizza application.
Library    SeleniumLibrary    timeout=10s


*** Variables ***
${URL}    https://quickpizza.grafana.com
${BROWSER}    chrome
${HEADING}    Looking to break out of your pizza routine?
${MAX CALORIES}    xpath://label[contains(.,'Max Calories')]/../input


*** Keywords ***
Open QuickPizza
    [Documentation]    Open the QuickPizza home page and wait until it is ready.
    Open Browser    ${URL}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1000
    Wait Until Page Contains    ${HEADING}
    Wait Until Page Contains Element    id:svelte-announcer

Turn On Advanced
    [Documentation]    Reveal the advanced pizza restriction fields.
    Wait Until Element Is Visible    xpath://label[.//span[normalize-space()='Advanced']]
    Click Element    xpath://label[.//span[normalize-space()='Advanced']]
    Wait Until Element Is Visible    ${MAX CALORIES}
    Wait Until Element Is Visible    css:select
    Wait Until Element Is Visible    id:default-checkbox
    Wait Until Element Is Visible    css:input#pizza-name

Fill In The Pizza Request
    [Documentation]    Enter calorie limit, excluded tool, vegetarian option, and custom pizza name.
    [Arguments]    ${calories}    ${tool}    ${name}
    Input Text    ${MAX CALORIES}    ${calories}
    Wait Until Page Contains Element    xpath://select/option[normalize-space()='${tool}']
    Select From List By Label    css:select    ${tool}
    Select Checkbox    id:default-checkbox
    Input Text    css:input#pizza-name    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${calories}
    List Selection Should Be    css:select    ${tool}
    Checkbox Should Be Selected    id:default-checkbox
    Textfield Value Should Be    css:input#pizza-name    ${name}
