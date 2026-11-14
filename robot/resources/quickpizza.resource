*** Settings ***
Documentation    Keywords and locators for the QuickPizza application.
Library    SeleniumLibrary    timeout=10s
Library    String


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

Ask For A Pizza
    [Documentation]    Submit the pizza request and wait for the recommendation box.
    Click Button    name:pizza-please
    Wait Until Element Is Visible    id:recommendations
    Wait Until Element Is Visible    xpath://p[starts-with(., 'Name:')]

Get Recommended Tool
    [Documentation]    Extract the tool name from the pizza recommendation.
    ${text}=    Get Text    xpath://p[starts-with(., 'Tool:')]
    ${raw}=    Fetch From Right    ${text}    :
    ${tool}=    Strip String    ${raw}
    RETURN    ${tool}

Get Calories Per Slice
    [Documentation]    Extract the calories per slice as an integer.
    ${text}=    Get Text    xpath://p[starts-with(., 'Calories per slice:')]
    ${raw}=    Fetch From Right    ${text}    :
    ${calories}=    Strip String    ${raw}
    ${calories int}=    Convert To Integer    ${calories}
    RETURN    ${calories int}

Recommendation Should Keep The Restrictions
    [Documentation]    Verify the recommended pizza matches the name, avoids the excluded tool, and respects max calories.
    [Arguments]    ${name}    ${excluded tool}    ${max calories}
    Element Text Should Be    xpath://p[starts-with(., 'Name:')]    Name: ${name}
    ${tool}=    Get Recommended Tool
    Should Not Be Equal    ${tool}    ${excluded tool}
    ${calories}=    Get Calories Per Slice
    Should Be True    ${calories} <= ${max calories}
    Log    Pizza=${name}, Tool=${tool}, Calories=${calories}
    RETURN    ${tool}

Rate The Pizza Without Logging In
    [Documentation]    Click Love it! while logged out and verify the login prompt appears.
    Click Button    name:rate-5
    Wait Until Element Is Visible    id:rate-result
    Element Text Should Be    id:rate-result    Please log in first.

Wait Until The Page Is Ready
    [Documentation]    Wait until the SvelteKit page finishes client-side mounting.
    Wait Until Page Contains Element    id:svelte-announcer

Log In As Admin
    [Documentation]    Open the admin page, log in, and wait for the latest recommendations heading.
    [Arguments]    ${user}    ${password}
    Go To    ${URL}/admin
    Wait Until The Page Is Ready
    Wait Until Element Is Visible    id:username
    Input Text    id:username    ${user}
    Input Password    id:password    ${password}
    Click Button    css:button[type=submit]
    Wait Until Page Contains    Latest pizza recommendations

Admin List Should Show The Pizza
    [Documentation]    Verify the named pizza and recommended tool appear in the admin recommendations list.
    [Arguments]    ${name}    ${tool}
    Wait Until Page Contains    ${name}
    Element Should Contain    xpath://li[contains(.,'${name}')]    ${tool}
