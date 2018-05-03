*** Settings ***
Library    fbSeleniumLibrary    run_on_failure=None
Resource    keywords.txt
Test Teardown    Take Screenshot If Fail And Close Browser

*** Test Cases ***
User profile
    Open Facebook And Login    Dave
    Go To Profile Page
    Verify The User Name Of Profile Is Correct

*** Keywords ***
Take Screenshot If Fail And Close Browser
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

Verify The User Name Of Profile Is Correct
    ${userName} =    Get Text    xpath://span[@id='fb-timeline-cover-name']
    Should Be Equal    ${userName}    &{Dave}[name]

Go To Profile Page
    Click Element    xpath://${topBar}//div[@data-click='profile_icon']
    Wait Until Page Contains Element    xpath://${contentOfProfilePage}

Open Facebook And Login
    [Arguments]    ${user}
    Open Browser With Chrome    ${facebookURL}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}

*** Variables ***
${contentOfProfilePage}    div[@id='pagelet_main_column_personal']
${topBar}    div[@id='pagelet_bluebar']
${loginButton}    label[@id='loginbutton']
${facebookURL}    https://www.facebook.com/
&{Dave}    name=Dave Albecgjdfggca Bushakescu    email=ztiikid_bushakescu_1523290582@tfbnw.net    password=d0mefe8fu8w