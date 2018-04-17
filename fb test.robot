*** Settings ***
Library    Selenium2Library
# Test Teardown    Close All Browsers

*** Test Cases ***
chat
    Open Facebook And Login    user1
    Click Element    xpath://*[text()='Messenger']
    Wait Until Page Contains Element    id:js_d
    Click Element    xpath://div[@id='js_d']//li
    Capture Page Screenshot
    Open Facebook And Login    user2
    Click Element    xpath://*[text()='Messenger']
    Wait Until Page Contains Element    id:js_d
    Click Element    xpath://div[@id='js_d']//li
    Capture Page Screenshot

*** Keywords ***
Open Facebook And Login
    [Arguments]    ${user}
    Chrome With Preferences    https://www.facebook.com/    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://label[@id='loginbutton']
    Wait Until Page Contains Element    xpath://div[@id='pagelet_bluebar']//*[text()='&{${user}}[name]']    timeout=3s
    
Chrome With Preferences
    [Arguments]    ${url}    ${alias}=${EMPTY}
    ${chrome_options} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-notifications 
    Create WebDriver    Chrome    chrome_options=${chrome_options}    alias=${alias}
    Maximize Browser Window
    Go To    ${url}

*** Variables ***
&{user1}    name=Dave Albecgjdfggca Bushakescu    email=ztiikid_bushakescu_1523290582@tfbnw.net    password=d0mefe8fu8w
&{user2}    name=Rick Albebehacbejg Warmanson    email=edwywar_warmanson_1523290486@tfbnw.net    password=coz4upprct4