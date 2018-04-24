*** Settings ***
Library    fbSeleniumLibrary
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
    Page Should Contain Element    xpath://div[@aria-label='訊息']//h5[@aria-label='&{${sender}}[name]'][last()]/following-sibling::*[normalize-space()='${message}']

${sender} Sends A Message '${message}' To ${receiver}
    Switch Browser    ${sender}
    Open Friend's Conversation Record    ${receiver}
    Wait Until Page Contains Element    xpath://${typingArea}
    Click Element    xpath://${typingArea}
    Type Text And Send    ${message}
    Wait Until Page Contains Element    xpath://div[@aria-label='訊息']//h5[@aria-label='&{${sender}}[name]'][last()]/following-sibling::*[normalize-space()='${message}']/span[@title='已傳送']

Open Friend's Conversation Record
    [Arguments]    ${friend}
    Wait Until Page Contains Element    xpath://${conversationList}//*[text()='&{${friend}}[name]']
    Click Element    xpath://${conversationList}//*[text()='&{${friend}}[name]']
    Wait Until Page Contains Element    xpath://${friendsInfoPanel}

${user} Open Facebook Messenger
    Open Facebook And Login As ${user}
    Click Element    xpath://${messengerButton}
    Wait Until Page Contains Element    xpath://${messengerSideBar}

Open Facebook And Login As ${user}
    Chrome With Preferences    ${facebookURL}    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}
    Wait Until Page Contains Element    xpath://${topBar}//*[text()='&{${user}}[name]']

Chrome With Preferences
    [Arguments]    ${url}    ${alias}=${EMPTY}
    ${chrome_options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-notifications
    Create WebDriver    Chrome    chrome_options=${chrome_options}    alias=${alias}
    Maximize Browser Window
    Go To    ${url}
    Set Throughput Regular 2G

Set Throughput Regular 2G
    Set Throughput    300    256000    51200

Set Throughput Good 2G
    Set Throughput    150    460800    153600

Set Throughput Good 3G
    Set Throughput    40    1536000    768000

*** Variables ***
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