*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL}    https://www.selenium.dev/selenium/web/web-form.html
${BROWSER}    chrome


*** Test Cases ***
The Web Form Opens
    [Documentation]    Verify that the practice web form opens with the expected title.
    Open Browser    ${URL}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Title Should Be    Web form
    [Teardown]    Close Browser
