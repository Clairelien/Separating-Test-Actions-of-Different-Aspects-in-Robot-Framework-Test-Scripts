*** Settings ***
Library    Selenium2Library
Test Setup    Open Google Search
Test Teardown    Close Browser

*** Test Cases ***
Search Robot framework On Google
    Input Text    id:lst-ib    ${searchKeyword}
    Submit Form
    Page Should Contain    ${searchKeyword}

*** Keywords ***
Open Google Search
    Open Browser    ${googleURL}    chrome
    Maximize Browser Window

*** Variables ***
${googleURL}    https://www.google.com.tw
${searchKeyword}    robot framework

