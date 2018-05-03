*** Settings ***
Library    fbSeleniumLibrary

*** Keywords ***
Select Page Plugin Frame
    [Tags]    pre:Verify There Is No Post On Page From Page Plugin    pre:New Post Should Be Visible:priority=1
    Wait Until Page Contains Element    id:fb_plugin    10s
    Select Frame    id:fb_plugin

Switch To Default Content
    [Tags]    post:Verify There Is No Post On Page From Page Plugin    post:New Post Should Be Visible
    Unselect Frame

Wait Until Test Page Is Shown
    [Tags]    post:Open Test Page On Facebook
    Wait Until Page Contains Element    xpath://${sidebarOfPage}//*[text()='Test']    15s
    Wait Until Page Contains Element    xpath://${mainColumnOfPage}    15s

Wait Until New Post is Posted
    [Tags]    post:Post A New Post
    Wait Until Page Contains Element    xpath://${containerOfPosts}/p    20s

Wait Until Post Container Is Shown
    [Tags]    pre:New Post Should Be Visible:priority=2
    Wait Until Page Contains Element    xpath://div[contains(@class, 'userContentWrapper')]

Wait Until Actions Button Is Shown
    [Tags]    pre:Click Actions Button Of Post
    Wait Until Page Contains Element    xpath://${actionsOfPost}

Wait Until Delete Option Is Shown
    [Tags]    pre:Click Delect Post Option
    Wait Until Page Contains Element    xpath://${deletePostOption}

Wait Until Confirm Dialog Is Shown
    [Tags]    pre:Click Delete Button
    Wait Until Page Contains Element    xpath://${deleteButton}

Wait Until The Post Is Deleted
    [Tags]    post:Delete The Post
    Wait Until Page Does Not Contain Element    xpath:(//${containerOfPosts}/p)[1][text()='hello']

Wait Until Textarea Of New Post Is Shown
    [Tags]    pre:Input New Post
    Wait Until Page Contains Element    xpath://${newPostTextarea}    15s

Wait Until Post Button Is Enabled
    [Tags]    pre:Click Post Button
    [Arguments]    ${arg}
    Wait Until Page Contains Element    xpath://${postButton}[not(@disabled)]    15s

*** Variables ***
${postButton}    button[normalize-space()='發佈']
${newPostTextarea}    div[@id='PageComposerPagelet_']//textarea
${deleteButton}    input[@value='刪除']
${deletePostOption}    li[normalize-space()='從粉絲專頁刪除']
${actionsOfPost}    a[@aria-label='活動紀錄選項']
${containerOfPosts}    div[contains(@class, 'userContent')]
${sidebarOfPage}    div[@id='entity_sidebar']
${mainColumnOfPage}    div[@id='pagelet_timeline_main_column']