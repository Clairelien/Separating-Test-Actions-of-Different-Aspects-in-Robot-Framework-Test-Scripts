*** Settings ***
Library    fbSeleniumLibrary

*** Keywords ***
Wait Until Facebook Main Page Is Shown
    [Tags]    post:Open Facebook And Login
    Wait Until Page Contains Element    xpath://${topbarOfMainPage}
    Wait Until Page Contains Element    xpath://${contentOfMainPage}
    
Wait Until Friend's Conversation Record Is Opened
    [Tags]    post:
    Wait Until Page Contains Element    xpath://${friendsInfoPanel}

Wait Until Typing Area Is Clickable
    [Tags]    pre:Send A Message
    Wait Until Page Contains Element    xpath://${typingArea}

*** Variables ***
${typingArea}    div[@aria-label='輸入訊息⋯⋯']
${friendsInfoPanel}    div[@data-testid='info_panel']
${contentOfMainPage}    div[@id='content']
${topbarOfMainPage}    div[@id='pagelet_bluebar']