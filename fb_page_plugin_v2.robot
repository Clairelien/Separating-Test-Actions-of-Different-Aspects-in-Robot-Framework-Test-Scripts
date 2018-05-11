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
    Click Actions Button Of Post
    Click Delect Post Option
    Click Delete Button

Click Actions Button Of Post
    Click Element    xpath://${actionsOfPost}

Click Delect Post Option
    Click Element    xpath://${deletePostOption}

Click Delete Button
    Click Element    xpath://${deleteButton}

Verify The New Post Is Shown On Page Plugin
    Switch Browser    ${pagePluginAlias}
    Reload Page
    New Post Should Be Visible

New Post Should Be Visible
    Page Should Contain Element    xpath://div[contains(@class, 'userContent')]//p[text()='${contentOfPost}']

Post A New Post
    [Arguments]    ${content}
    Set Test Variable    ${contentOfPost}    ${content}
    Input New Post    ${content}
    Click Post Button

Input New Post
    [Arguments]    ${text}
    Input Text    xpath://${newPostTextarea}    ${text}

Click Post Button
    Click Button    xpath://${postButton}

Open Test Page On Facebook
    Open Facebook And Login    WuLee
    Click Element    xpath://${pinnedNav}//li[1]

Open Website With Facebook Page Plugin
    Open Browser With Chrome    ${CURDIR}/${pagePluginWeb}    alias=${pagePluginAlias}
    Verify There Is No Post On Page From Page Plugin

Verify There Is No Post On Page From Page Plugin
    Page Should Not Contain Element    xpath://${containerOfPosts}//p

Open Facebook And Login
    [Arguments]    ${user}
    Open Browser With Chrome    ${facebookURL}    alias=${user}
    Input Text    id:email    &{${user}}[email]
    Input Password    id:pass    &{${user}}[password]
    Click Element    xpath://${loginButton}

*** Variables ***
${deleteButton}    button[text()='刪除貼文']
# ${deleteButton}    input[@value='刪除']
${deletePostOption}    li[contains(normalize-space(), '刪除')]
${actionsOfPost}    a[@aria-label='活動紀錄選項']
${newPostTextarea}    div[@id='PageComposerPagelet_']//textarea
${postButton}    button[normalize-space()='發佈']
${pagePluginWeb}    test.html
${pinnedNav}    div[@id='pinnedNav']
${containerOfPosts}    div[contains(@class, 'userContent')]
${loginButton}    label[@id='loginbutton']
${facebookURL}    https://www.facebook.com/
${pagePluginAlias}    plugin
${contentOfPost}    ${EMPTY}
&{WuLee}    email=teddygetbox001@gmail.com    password=qwert123456