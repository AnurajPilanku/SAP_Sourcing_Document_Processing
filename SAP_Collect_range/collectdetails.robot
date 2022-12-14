*** Settings ***
Test Teardown     Run Keyword If Test Failed    update automationcenter failure    ${TEST MESSAGE}
Library           SSHLibrary
Library           AutomationCenter
Library           WindowsAE
Library           lib\\custom_library.py
Library           SeleniumLibrary
Library           String
Library           BuiltIn
Library           Collections
Library           lib\\Distribute_sap_range.py
Library           lib\\updatedate.py
Library           OperatingSystem
Library           DateTime

*** Variables ***
#input
${aeuser}         ${EMPTY}
${aeparameters}    ${EMPTY}
${aeci}           ${EMPTY}
${aepassword}     ${EMPTY}
${aeprivatekey}    ${EMPTY}
${aedatastore}    ${EMPTY}
${timeout}        NONE
#result
${output}         ""
${error}          ""
${rc}             0
#${sapusername}    ac5qdzz
#${sppassword}    ZXCVzxcv2131
#${sapurl}        http://sapgdy101.mmm.com:50000/sourcing/fsbuyer/portal/index?allow_redirect=true&cid=3mcluster
#${browser}       edge
#${Folders_Path}    C:\\Users\\ac5qdzz\\Desktop\\output
#${distributed_txt_path}    C:\\Users\\ac5qdzz\\Desktop\\output\\distibuted_range.txt
#${Summary_txt_path}    C:\\Users\\ac5qdzz\\Desktop\\output\\Summary.txt
#${Flow_delimiter}    20
#${Day_delimiter}    5

*** Test Cases ***
SAPtask
    [Timeout]    ${timeout}
    run
    Get Credential
    Log In
    Update AutomationCenter Output

*** Keywords ***
run
    &{aeparameters}=    AutomationCenter.json_parse    ${aeparameters}
    &{aeci}=    AutomationCenter.json_parse    ${aeci}
    set global variable    ${aeparameters}
    ${browser}=    AutomationCenter.Get Value    ${aeparameters}    Browser
    Set Global Variable    ${browser}
    ${sapurl}=    AutomationCenter.Get Value    ${aeparameters}    url
    Set Global Variable    ${sapurl}
    ${distributed_txt_path}=    AutomationCenter.Get Value    ${aeparameters}    distributed_txt_path
    Set Global Variable    ${distributed_txt_path}
    ${Summary_txt_path}=    AutomationCenter.Get Value    ${aeparameters}    Summary_txt_path
    Set Global Variable    ${Summary_txt_path}
    ${Flow_delimiter}=    AutomationCenter.Get Value    ${aeparameters}    Flow_delimiter
    Set Global Variable    ${Flow_delimiter}
    ${Day_delimiter}=    AutomationCenter.Get Value    ${aeparameters}    Day_delimiter
    Set Global Variable    ${Day_delimiter}
    ${orig wait} =    Set Selenium Implicit Wait    10 seconds
    Set Global Variable    ${orig wait}

Get Credential
    &{aedatastore}=    AutomationCenter.Json Parse    ${aedatastore}
    ${app_id}=    AutomationCenter.get_value    ${aeparameters}    cred_id
    &{entity_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${app_id}
    &{vault_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${entity_details["vaultid"]}
    Set To Dictionary    ${entity_details}    vault=${vault_details}
    ${sapusername}=    AutomationCenter.Get Value    ${entity_details}    serviceAccount
    ${sppassword}=    AutomationCenter.Resolve Sdb    ${entity_details}    ${aedatastore}
    Set Global Variable    ${sapusername}
    Set Global Variable    ${sppassword}

Log In
    ####    Login into the SCAS Application
    ${sap_range}=    Create Dictionary
    ${sap_details_summary}=    Create Dictionary
    set global variable    ${sap_range}
    set global variable    ${sap_details_summary}
    ${list}=    Create List    --inprivate
    ${args}=    Create Dictionary    args=${list}
    ${desired caps}=    Create Dictionary    ms:edgeOptions=${args}
    Open Browser    ${sapurl}    ${browser}    desired_capabilities=${desired caps}    #remote_url=http://localhost:9515
    Maximize Browser Window
    ${valueList} =    Create List
    set global variable    ${valueList}
    Wait Until Page Contains Element    //*[@id="logonuidfield"]
    Input Text    //*[@id="logonuidfield"]    ${sapusername}
    Input Text    //*[@id="logonpassfield"]    ${sppassword}
    Click Element    //*[@name="uidPasswordLogon"]
    Wait Until Page Contains Element    //*[@class="TabText"][contains(text(),"Contract")]    #Contract Management
    Click Element    //*[@class="TabText"][contains(text(),"Contract")]
    Wait Until Page Contains Element    //*[@id="selected_entry"]
    Click Element    //*[@id="selected_entry"]/option[4]    #Search Master Agreement and Agreement
    Wait Until Page Contains Element    //*[contains(text(),"Displaying")]
    ${pageCount}=    Get Text    //*[@class="documentToolbarText"][contains(text(),"of")][1]
    ${pageCount}=    Replace String    ${pageCount}    of    ${EMPTY}
    ${pageCount}=    Remove String    ${pageCount}    ${SPACE}
    ${pageCount}=    ConverT To integer    ${pageCount}
    #Log To Console    ${pageCount}
    FOR    ${pagenum}    IN RANGE    1    ${pageCount}+1
        Input Text    //*[@class="pageNumber"]    ${pagenum}
        sleep    2s
        Click Element    //*[@id="paging_FCI-SearchAllMAandAgreementslinkN10645paging"]
        sleep    5s
        ${rownum}=    Get Element Count    //*[@class="queryResultTable"]/tbody/tr
        Set To Dictionary    ${sap_range}    ${pagenum}    ${rownum}
    END
    #Log To Console    ${sap_range}
    ${total_docs_list}=    Get Dictionary Values    ${sap_range}
    ${total_docs}=    Evaluate    0+0
    Set Global Variable    ${total_docs}
    FOR    ${val_}    IN    @{total_docs_list}
        ${intval}=    Convert To Integer    ${val_}
        ${total_docs}=    Evaluate    ${total_docs}+${intval}
    END
    #Log To Console    `${total_docs}
    ${Flow_delimiter}=    Convert To Integer    ${Flow_delimiter}
    ${Day_delimiter}=    Convert To Integer    ${Day_delimiter}
    ${distributed_range}=    Download_per_delimiter    ${sap_range}    ${Flow_delimiter}    ${Day_delimiter}
    #Log To Console    ${distributed_range}
    ${distributed_range_str}=    Convert To String    ${distributed_range}
    Create File    ${distributed_txt_path}
    Append To File    ${distributed_txt_path}    ${distributed_range_str}.
    Set To Dictionary    ${sap_details_summary}    Sap_range    ${sap_range}
    Set To Dictionary    ${sap_details_summary}    Total_documents    ${total_docs}
    #${todays_date}=    Get Current Date    result_format=%Y-%m-%d
    ${todays_date}=    indiantimeUpdate
    Set To Dictionary    ${sap_details_summary}    Todays_Date    ${todays_date}
    ${sap_details_summary_str}=    Convert To String    ${sap_details_summary}
    Set Global Variable    ${sap_details_summary_str}
    Create File    ${Summary_txt_path}
    Append To File    ${Summary_txt_path}    ${sap_details_summary_str}

Update AutomationCenter Output
    ${result}=    Update AutomationCenter    ${sap_details_summary_str}    ${error}    ${rc}
