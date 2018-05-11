*** Settings ***
Library    fbSeleniumLibrary
Resource    keywords.txt
Test Teardown    Delete The Post And Close Browsers

*** Test Cases ***
New Post On Page plugin
    Open Website With Facebook Page Plugin
    Open Test Page On Facebook
    Post A New Post    hello
    Verify The New Post Is Shown On Page Plugin

*** Keywords ***
Delete The Post And Close Browsers
    Switch Browser    WuLee
    Delete The Post
    Close All Browsers

Delete The Post
    Wait Until Page Contains Element    xpath://${actionsOfPost}
    Click Element    xpath://${actionsOfPost}
    Wait Until Page Contains Element    xpath://${deletePostOption}
    Click Element    xpath://${deletePostOption}
    Wait Until Element Is Visible    xpath://${deleteButton}
    Click Element    xpath://${deleteButton}
    Wait Until Page Does Not Contain    xpath:(//${containerOfPosts}//p)[1][text()='${contentOfPost}']

Verify The New Post Is Shown On Page Plugin
    Switch Browser    ${pagePluginAlias}
    Execute Javascript    window.focus()
    Reload Page
    Wait Until Page Contains Element    id:fb_plugin
    Select Frame    id:fb_plugin
    Wait Until Page Contains Element    xpath://div[contains(@class, 'userContentWrapper')]
    Page Should Contain Element    xpath://div[contains(@class, 'userContent')]//p[text()='${contentOfPost}']
    Unselect Frame

Post A New Post
    [Arguments]    ${content}
    Set Test Variable    ${contentOfPost}    ${content}
    Wait Until Page Contains Element    xpath://${newPostTextarea}    15s
    Input Text    xpath://${newPostTextarea}    ${content}
    Wait Until Page Contains Element    xpath://${postButton}[not(@disabled)]    15s
    Click Button    xpath://${postButton}
    Wait Until Page Contains Element    xpath:(//${containerOfPosts}//p)[1][text()='${content}']    20s

Open Test Page On Facebook
    Open Facebook And Login    WuLee
    Click Element    xpath://${pinnedNav}//li[1]
    Wait Until Page Contains Element    xpath://${sidebarOfPage}//*[text()='Test']    15s
    Wait Until Page Contains Element    xpath://${mainColumnOfPage}    15s

Open Website With Facebook Page Plugin
    Open Browser With Chrome    ${CURDIR}/${pagePluginWeb}    alias=${pagePluginAlias}
    Verify There Is No Post On Page From Page Plugin

Verify There Is No Post On Page From Page Plugin
    Wait Until Page Contains Element    id:fb_plugin    10s
    Select Frame    id:fb_plugin
    Page Should Not Contain Element    xpath://${containerOfPosts}//p
    Unselect Frame

Open Facebook And Login
    [Arguments]    ${user}
    Open Browser With Chrome    ${facebookURL}    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}
    Wait Until Page Contains Element    xpath://${topbarOfMainPage}
    Wait Until Page Contains Element    xpath://${contentOfMainPage}

*** Variables ***
${contentOfMainPage}    div[@id='content']
${topbarOfMainPage}    div[@id='pagelet_bluebar']
${deleteButton}    button[text()='刪除貼文']
# ${deleteButton}    input[@value='刪除']
${deletePostOption}    li[contains(normalize-space(), '刪除')]
${actionsOfPost}    a[@aria-label='活動紀錄選項']
${newPostTextarea}    div[@id='PageComposerPagelet_']//textarea
${postButton}    button[normalize-space()='發佈']
${pagePluginWeb}    test.html
${sidebarOfPage}    div[@id='entity_sidebar']
${pinnedNav}    div[@id='pinnedNav']
${mainColumnOfPage}    div[@id='pagelet_timeline_main_column']
${containerOfPosts}    div[contains(@class, 'userContent')]
${loginButton}    label[@id='loginbutton']
${facebookURL}    https://www.facebook.com/
${pagePluginAlias}    plugin
${contentOfPost}    ${EMPTY}
&{WuLee}    email=teddygetbox001@gmail.com    password=qwert123456