*** Settings ***
Library    fbSeleniumLibrary
Test Teardown    Close All Browsers

*** Test Cases ***
chat
    Open Facebook And Login    user1
    Open Messenger Page
    Open Facebook And Login    user2
    Open Messenger Page
    Send A Message To The Friend   user1    user2    hello
    Verify The Frined Has Received The Message  user2   user1    hello

*** Keywords ***
Verify The Frined Has Received The Message
    Switch Browser    user2
    Open Friend's The Conversation Record    user1
    Element Should Be Visible    xpath://div[@aria-label='訊息']//h5[@aria-label='&{user2}[name]']/following-sibling::*[normalize-space()='hello']

Send A Message To The Friend
    [Arguments]    ${sender}    ${receiver}    ${message}
    Switch Browser    ${sender}
    Open Friend's The Conversation Record    ${receiver}
    Wait Until Page Contains Element    xpath://div[@aria-label='輸入訊息⋯⋯']
    Click Element    xpath://div[@aria-label='輸入訊息⋯⋯']
    Type Text And Send    ${message}
    # ensure the message is sent

Open Friend's The Conversation Record
    [Arguments]    ${friend}
    Wait Until Page Contains Element    xpath://${conversationList}//*[text()='&{${friend}}[name]']
    Click Element    xpath://${conversationList}//*[text()='&{${friend}}[name]']
    Wait Until Page Contains Element    xpath://${friendsInfoPanel}

Open Messenger Page
    Click Element    xpath://${messengerButton}
    Wait Until Page Contains Element    xpath://${messengerSideBar}

Open Facebook And Login
    [Arguments]    ${user}
    Chrome With Preferences    https://www.facebook.com/    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://label[@id='loginbutton']
    Wait Until Page Contains Element    xpath://div[@id='pagelet_bluebar']//*[text()='&{${user}}[name]']
    
Chrome With Preferences
    [Arguments]    ${url}    ${alias}=${EMPTY}
    ${chrome_options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-notifications
    Create WebDriver    Chrome    chrome_options=${chrome_options}    alias=${alias}
    Maximize Browser Window
    Go To    ${url}

*** Variables ***
${conversationList}    ul[@aria-label='對話清單']
${friendsInfoPanel}    div[@data-testid='info_panel']
${messengerSideBar}    a[@title='新訊息']
${messengerButton}    *[text()='Messenger']
&{user1}    name=Dave Albecgjdfggca Bushakescu    email=ztiikid_bushakescu_1523290582@tfbnw.net    password=d0mefe8fu8w
&{user2}    name=Rick Albebehacbejg Warmanson    email=edwywar_warmanson_1523290486@tfbnw.net    password=coz4upprct4