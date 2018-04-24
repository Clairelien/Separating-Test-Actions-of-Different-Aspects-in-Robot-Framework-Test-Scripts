*** Setting ***
Library    Selenium2Library
Library    Collections
Resource    Keyword.txt
Test Setup    Open DcTrack And Login As Administrator
Test Teardown    Close Browser

*** Test Cases ***
Verify the toolbar buttons of Items List
    Enter Items List Page
    The Toolbar Button Should Be Display In This Order    Add an Item    View    Edit    Clone    Delete    Refresh    Actions   Print    Export    Floor Maps    Permissions

*** Variables ***
${assetsFrame}    iframe[@id='id_assets_frame']
${dashboardFrame}    iframe[@id='id_dashboard_frame']
${itemsListCell}    div[contains(@class, 'ui-grid-render-container-body')]//div[contains(@class, 'ui-grid-viewport')]//div[contains(@class, 'ui-grid-cell')]
${dashboardElement}    *[@title='Stranded Power per Location']

*** Keywords ***
Open DcTrack And Login As Administrator
    Open Browser    ${dcTrackUrl}    ${browser}
    Maximize Browser Window
    Login As Administrator
    Wait Until Dashboard Is Shown

Enter Items List Page
    Mouse Over    xpath://${assetsTab}
    Click Element    xpath://${itemsListOption}
    Wait Until Items List Is Shown

Wait Until Dashboard Is Shown
    Wait Until Element Is Visible    xpath://${dashboardFrame}    20s
    Select Frame    xpath://${dashboardFrame}
    Wait Until Element Is Visible    xpath://${dashboardElement}    20s
    Unselect Frame

Wait Until Items List Is Shown
    Select Frame    xpath://${assetsFrame}
    Wait Until Page Contains Element    xpath://${itemsListCell}    20s
    Unselect Frame

The Toolbar Button Should Be Display In This Order
    [Arguments]    @{expectedButtonsName}
    Select Frame    xpath://${assetsFrame}
    @{actualButtonsName} =    Get Elements Text    xpath://${toolbarButtonsLabel}
    Should Be Equal    ${actualButtonsName}    ${expectedButtonsName}
    Unselect Frame