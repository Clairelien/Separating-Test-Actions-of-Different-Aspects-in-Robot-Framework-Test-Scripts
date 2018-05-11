*** Settings ***
Library    fbSeleniumLibrary
Resource    keywords.txt
Test Teardown    Close Browser

*** Test Cases ***
User Name In Profile Page
    Open Facebook And Login    Dave
    Go To Profile Page
    Verify The User Name In Profile Page And On Topbar Are Identical

*** Keywords ***
Verify The User Name In Profile Page And On Topbar Are Identical
    ${userNameOnTopbar} =    Get Text    xpath://${topBar}//div[@data-click='profile_icon']
    ${userNameInProfile} =    Get Text    xpath://span[@id='fb-timeline-cover-name']
    Should Be Equal    ${userNameInProfile}    ${userNameOnTopbar}

Go To Profile Page
    Click Element    xpath://${topBar}//div[@data-click='profile_icon']

Open Facebook And Login
    [Arguments]    ${user}
    Open Browser With Chrome    ${facebookURL}
    Maximize Browser Window
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}

*** Variables ***
${topBar}    div[@id='pagelet_bluebar']
${loginButton}    label[@id='loginbutton']
${facebookURL}    https://www.facebook.com/
&{Dave}    email=ztiikid_bushakescu_1523290582@tfbnw.net    password=d0mefe8fu8w