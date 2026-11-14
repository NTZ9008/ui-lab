*** Settings ***
Documentation    Keywords and locators for the QuickPizza application.
Library    SeleniumLibrary    timeout=10s


*** Variables ***
${URL}    https://quickpizza.grafana.com
${BROWSER}    chrome
${HEADING}    Looking to break out of your pizza routine?


*** Keywords ***
Open QuickPizza
    [Documentation]    Open the QuickPizza home page and wait until it is ready.
    Open Browser    ${URL}    ${BROWSER}    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1000
    Wait Until Page Contains    ${HEADING}
