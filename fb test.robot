*** Settings ***
Library    fbSeleniumLibrary
Resource    keywords.txt
Test Teardown    Close All Browsers

*** Test Cases ***
Sending Message To Friend
    Dave Open Facebook Messenger
    Rick Open Facebook Messenger
    Dave Sends A Message 'hello' To Rick
    Verify Rick Has Received The Message 'hello' From Dave

*** Keywords ***
Verify ${receiver} Has Received The Message '${message}' From ${sender}
    Switch Browser    ${receiver}
    Open Friend's Conversation Record    ${sender}
    Page Should Contain Element    xpath://${messageContainer}//h5[@aria-label='&{${sender}}[name]'][last()]/following-sibling::*[normalize-space()='${message}']

${sender} Sends A Message '${message}' To ${receiver}
    Switch Browser    ${sender}
    Open Friend's Conversation Record    ${receiver}
    Send A Message    ${message}

Send A Message
    [Arguments]    ${message}
    Wait Until Page Contains Element    xpath://${typingArea}
    Click Element    xpath://${typingArea}
    Type Text And Send    ${message}
    Wait Until Page Contains Element    xpath://${messageContainer}//${latestUnreadMessage}

Open Friend's Conversation Record
    [Arguments]    ${friend}
    Wait Until Page Contains Element    xpath://${conversationList}/li
    Click Element    xpath://${conversationList}//*[text()='&{${friend}}[name]']
    Wait Until Page Contains Element    xpath://${friendsInfoPanel}

${user} Open Facebook Messenger
    Open Facebook And Login    ${user}
    Click Element    xpath://${messengerButton}
    Wait Until Page Contains Element    xpath://${messengerSideBar}

Open Facebook And Login
    [Arguments]    ${user}
    Open Browser With Chrome    ${facebookURL}    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}
    Wait Until Page Contains Element    xpath://${topBar}//*[text()='&{${user}}[name]']

*** Variables ***
${latestUnreadMessage}    h5[contains(@class, 'accessible_elem')]/following-sibling::*/span[@title='已傳送']
${messageContainer}    div[@aria-label='訊息']
${typingArea}    div[@aria-label='輸入訊息⋯⋯']
${topBar}    div[@id='pagelet_bluebar']
${loginButton}    label[@id='loginbutton']
${facebookURL}    https://www.facebook.com/
${conversationList}    ul[@aria-label='對話清單']
${friendsInfoPanel}    div[@data-testid='info_panel']
${messengerSideBar}    a[@title='新訊息']
${messengerButton}    *[text()='Messenger']
&{Dave}    name=Dave Albecgjdfggca Bushakescu    email=ztiikid_bushakescu_1523290582@tfbnw.net    password=d0mefe8fu8w
&{Rick}    name=Rick Albebehacbejg Warmanson    email=edwywar_warmanson_1523290486@tfbnw.net    password=coz4upprct4