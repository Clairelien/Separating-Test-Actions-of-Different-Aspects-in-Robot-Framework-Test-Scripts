*** Settings ***
Library    fbSeleniumLibrary

*** Keywords ***
# Wait Until Facebook Main Page Is Shown
#     [Tags]    post:Open Facebook And Login
#     Wait Until Page Contains Element    xpath://${topbarOfMainPage}
#     Wait Until Page Contains Element    xpath://${contentOfMainPage}

# Wait Until Friend's Conversation Record Is Opened
#     [Tags]    post:Open Friend's Conversation Record
#     Wait Until Page Contains Element    xpath://${friendsInfoPanel}
#     Wait Until Page Contains Element    xpath://${messageContainer}

# Wait Until Typing Area Is Clickable
#     [Tags]    pre:Send A Message
#     Wait Until Page Contains Element    xpath://${typingArea}

# Wait Until Messenger Is Opened
#     [Tags]    post:* Open Facebook Messenger
#     Wait Until Page Contains Element    xpath://${messengerSideBar}

# Wait Until Message Is Sent
#     [Tags]    post:Send A Message
#     Wait Until Page Contains Element    xpath://${messageContainer}//${latestUnreadMessage}

# Wait Until Friends List Is Shown
#     [Tags]    pre:Open Friend's Conversation Record
#     Wait Until Page Contains Element    xpath://${conversationList}/li

Capture Screenshot On Failure
    [Tags]    post:*:status=fail
    # [Tags]    post:!fbSeleniumLibrary.*:status=fail
    Capture Page Screenshot

Capture Screenshot On Failure3
    [Tags]    post:*:status=fail:priority=2
    # [Tags]    post:!fbSeleniumLibrary.*:status=fail
    Capture Page Screenshot

Capture Screenshot On Failure2
    [Tags]    post:*:status=fail:priority=2
    # [Tags]    post:!fbSeleniumLibrary.*:status=fail
    Capture Page Screenshot

*** Variables ***
${conversationList}    ul[@aria-label='對話清單']
${latestUnreadMessage}    h5[contains(@class, 'accessible_elem')]/following-sibling::*/span[@title='已傳送']
${messageContainer}    div[@aria-label='訊息']
${messengerSideBar}    a[@title='新訊息']
${typingArea}    div[@aria-label='輸入訊息⋯⋯']
${friendsInfoPanel}    div[@data-testid='info_panel']
${contentOfMainPage}    div[@id='content']
${topbarOfMainPage}    div[@id='pagelet_bluebar']