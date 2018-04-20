*** Settings ***
Library    fbSeleniumLibrary
# Test Teardown    Close All Browsers

*** Test Cases ***
chat
    Open Facebook And Login    user1
    Open Messenger Page
    Open Friend's The Conversation Record    user2
    Send A Message To Friend   hello
    Capture Page Screenshot
    # Open Facebook And Login    user2
    # Open Messenger Page
    # Open Friend's The Conversation Record    user1
    # Capture Page Screenshot

*** Keywords ***
Send A Message To Friend
    [Arguments]    ${message}
    Wait Until Page Contains Element    xpath://div[@aria-label='輸入訊息⋯⋯']/descendant::*[last()-1]
    Type Text    xpath://div[@aria-label='輸入訊息⋯⋯']/descendant::*[last()-1]    ${message}
    # Input Text    xpath://div[@aria-label='輸入訊息⋯⋯']/descendant::*[last()]    ${message}
    # Execute Javascript    $x("//div[@aria-label='輸入訊息⋯⋯']/descendant::*[last()]").innerHTML = ${message}
    Sleep    3s    

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