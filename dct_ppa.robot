*** Settings ***
Library    Selenium2Library

*** Variables ***
${assetsFrame}    iframe[@id='id_assets_frame']
${dashboardFrame}    iframe[@id='id_dashboard_frame']
${itemsListCell}    div[contains(@class, 'ui-grid-render-container-body')]//div[contains(@class, 'ui-grid-viewport')]//div[contains(@class, 'ui-grid-cell')]
${dashboardElement}    *[@title='Stranded Power per Location']

*** Keywords ***
Select Assets Frame
    [Tags]    pre:The Toolbar Button Should Be Display In This Order    post:Enter Items List Page:1
    Select Frame    xpath://${assetsFrame}

Wait Until Dashboard Frame Is Visible
    [Tags]    post:Open DcTrack And Login As Administrator:1
    Wait Until Element Is Visible    xpath://${dashboardFrame}    20s

Select Dashboard Frame
    [Tags]    post:Open DcTrack And Login As Administrator:2
    Select Frame    xpath://${dashboardFrame}

Wait Until Dashboard Is Shown
    [Tags]    post:Open DcTrack And Login As Administrator:3
    Wait Until Element Is Visible    xpath://${dashboardElement}    20s

Wait Until Items List Is Shown
    [Tags]    post:Enter Items List Page:2
    Wait Until Page Contains Element    xpath://${itemsListCell}    20s

Switch To Default Content
    [Tags]    post:Wait Until Items List Is Shown    post:The Toolbar Button Should Be Display In This Order    post:Open DcTrack And Login As Administrator:4    post:Enter Items List Page:3
    Unselect Frame
