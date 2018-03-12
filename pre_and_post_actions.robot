*** Settings ***
Library    Selenium2Library

*** Variables ***
${assetsFrame}    iframe[@id='id_assets_frame']
${dashboardFrame}    iframe[@id='id_dashboard_frame']
${itemsListCell}    div[contains(@class, 'ui-grid-render-container-body')]//div[contains(@class, 'ui-grid-viewport')]//div[contains(@class, 'ui-grid-cell')]
${dashboardElement}    *[@title='Stranded Power per Location']

*** Keywords ***
Select Assets Frame
    [Tags]    pre:Wait Until Items List Is Shown    pre:The Toolbar Button Should Be Display In This Order
    Select Frame    xpath://${assetsFrame}

Select Dashboard Frame
    [Tags]    pre:Wait Until Dashboard Is Shown
    Select Frame    xpath://${dashboardFrame}

Wait Until Dashboard Is Shown
    [Tags]    post:Open DcTrack And Login As Administrator
    Wait Until Element Is Visible    xpath://${dashboardElement}    20s

Wait Until Dashboard Frame Is Visible
    [Tags]    pre:Select Dashboard Frame
    Wait Until Element Is Visible    xpath://${dashboardFrame}    20s

Wait Until Items List Is Shown
    [Tags]    post:Enter Items List Page
    Wait Until Page Contains Element    xpath://${itemsListCell}    20s
