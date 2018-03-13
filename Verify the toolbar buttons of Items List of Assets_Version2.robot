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

*** Keywords ***
Open DcTrack And Login As Administrator
    Open Browser    ${dcTrackUrl}    ${browser}
    Maximize Browser Window
    Login As Administrator

Enter Items List Page
    Mouse Over    xpath://${assetsTab}
    Click Element    xpath://${itemsListOption}

The Toolbar Button Should Be Display In This Order
    [Arguments]    @{expectedButtonsName}
    @{actualButtonsName} =    Get Elements Text    xpath://${toolbarButtonsLabel}
    Should Be Equal    ${actualButtonsName}    ${expectedButtonsName}
