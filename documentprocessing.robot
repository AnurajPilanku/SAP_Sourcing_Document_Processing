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
Library           OperatingSystem
Library           DateTime
Library           lib\\traversetoExcel.py
Library           lib\\support.py
Library           lib\\MainFileTransfer.py
Library           lib\\SubFileTransfer.py
Library           lib\\CollectDocumentDetails.py
Library           lib\\SharepointSignIn.py
Library           lib\\GetFilePathToUpload.py
Library           lib\\GetNumber_of_Files.py
Library           lib\\fileUploadWindow.py
Library           lib\\DeleteDirectory.py
Library           lib\\Get_first_range.py
Library           lib\\retriveCurrentDate.py
Library           lib\\Check_Match.py
Library           lib\\Next_run_Data_preparetion.py
Library           lib\\updatedate.py
Library           lib\\SentSapMail.py
Library           lib\\Directory_segragation.py
Library           lib\\Collect_Download_details_in_Excel.py
Library           lib\\Collect_All_Download_details_in_Excel.py

*** Variables ***
${aeuser}         ${EMPTY}
${aeparameters}    ${EMPTY}
${aeci}           ${EMPTY}
${aepassword}     ${EMPTY}
${aeprivatekey}    ${EMPTY}
${aedatastore}    ${EMPTY}
${timeout}        NONE
${output}         ""
${error}          ""
${rc}             0

*** Test Cases ***
SAPtask
    [Timeout]    ${timeout}
    run
    Get Credential
    Read_txt
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
    ${downloads}=    AutomationCenter.Get Value    ${aeparameters}    downloads
    Set Global Variable    ${downloads}
    ${targetfolder}=    AutomationCenter.Get Value    ${aeparameters}    targetfolder
    Set Global Variable    ${targetfolder}
    ${DocumentCollectionFolderName}=    AutomationCenter.Get Value    ${aeparameters}    DocumentCollectionFolderName
    Set Global Variable    ${DocumentCollectionFolderName}
    ${SAP_sharepoint}=    AutomationCenter.Get Value    ${aeparameters}    SAP_sharepoint
    Set Global Variable    ${SAP_sharepoint}
    ${usermailid}=    AutomationCenter.Get Value    ${aeparameters}    usermailid
    Set Global Variable    ${usermailid}
    ${Folders_Path}=    AutomationCenter.Get Value    ${aeparameters}    Folders_Path
    Set Global Variable    ${Folders_Path}
    ${summary_FilePath}=    AutomationCenter.Get Value    ${aeparameters}    summary_FilePath
    Set Global Variable    ${summary_FilePath}
    ${distributed_range_path}=    AutomationCenter.Get Value    ${aeparameters}    distributed_range_path
    Set Global Variable    ${distributed_range_path}
    ${logpath}=    AutomationCenter.Get Value    ${aeparameters}    logpath
    Set Global Variable    ${logpath}
    ${Downloaded_Files_Details}=    AutomationCenter.Get Value    ${aeparameters}    Downloaded_Files_Details
    Set Global Variable    ${Downloaded_Files_Details}
    ${From}=    AutomationCenter.Get Value    ${aeparameters}    From
    Set Global Variable    ${From}
    ${To}=    AutomationCenter.Get Value    ${aeparameters}    To
    Set Global Variable    ${To}
    ${Cc}=    AutomationCenter.Get Value    ${aeparameters}    Cc
    Set Global Variable    ${Cc}
    ${Bcc}=    AutomationCenter.Get Value    ${aeparameters}    Bcc
    Set Global Variable    ${Bcc}
    ${Subject}=    AutomationCenter.Get Value    ${aeparameters}    Subject
    Set Global Variable    ${Subject}
    ${Greetings}=    AutomationCenter.Get Value    ${aeparameters}    Greetings
    Set Global Variable    ${Greetings}
    ${Body}=    AutomationCenter.Get Value    ${aeparameters}    Body
    Set Global Variable    ${Body}
    ${Sign}=    AutomationCenter.Get Value    ${aeparameters}    Sign
    Set Global Variable    ${Sign}
    ${fontStyle}=    AutomationCenter.Get Value    ${aeparameters}    fontStyle
    Set Global Variable    ${fontStyle}
    ${attachments}=    AutomationCenter.Get Value    ${aeparameters}    attachments
    Set Global Variable    ${attachments}
    ${header}=    AutomationCenter.Get Value    ${aeparameters}    header
    Set Global Variable    ${header}
    ${footer}=    AutomationCenter.Get Value    ${aeparameters}    footer
    Set Global Variable    ${footer}
    ${Folder_for_sharepoint}=    AutomationCenter.Get Value    ${aeparameters}    Folder_for_sharepoint
    Set Global Variable    ${Folder_for_sharepoint}
    ${orig wait} =    Set Selenium Implicit Wait    10 seconds
    Set Global Variable    ${orig wait}
    ${output_run_}=    Catenate    Func_run :    {Success}
    Set Global Variable    ${output_run_}

Get Credential
    ####    Fetching Credential from Entity
    &{aedatastore}=    AutomationCenter.Json Parse    ${aedatastore}
    ${app_id}=    AutomationCenter.get_value    ${aeparameters}    cred_id
    &{entity_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${app_id}
    &{vault_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${entity_details["vaultid"]}
    Set To Dictionary    ${entity_details}    vault=${vault_details}
    ${sapusername}=    AutomationCenter.Get Value    ${entity_details}    serviceAccount
    ${pwd}=    AutomationCenter.Get Value    ${entity_details}    password
    Set Global Variable    ${pwd}
    ${contains}=    Evaluate    "sdb://" in """${pwd}"""
    Run Keyword If    ${contains} == True    Passwordsbd
    ...    ELSE    HardCode
    Set Global Variable    ${sapusername}
    ${output_Get_Credential_}=    Catenate    Func_Get_Credential :    {Success}
    Set Global Variable    ${output_Get_Credential_}

Passwordsbd
    &{aedatastore}=    AutomationCenter.Json Parse    ${aedatastore}
    ${app_id}=    AutomationCenter.get_value    ${aeparameters}    cred_id
    &{entity_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${app_id}
    &{vault_details}=    AutomationCenter.Get Entity    ${aedatastore}    ${entity_details["vaultid"]}
    Set To Dictionary    ${entity_details}    vault=${vault_details}
    ${sapusername}=    AutomationCenter.Get Value    ${entity_details}    serviceAccount
    ${sppassword}=    AutomationCenter.Resolve Sdb    ${entity_details}    ${aedatastore}
    Set Global Variable    ${sppassword}
    Set Global Variable    ${sapusername}

HardCode
    ${sppassword}=    Set Variable    ${pwd}
    Set Global Variable    ${sppassword}

Read_txt
    #________Read Text File___________
    #_______Get First data____________
    Create File    ${Downloaded_Files_Details}
    #${todays_date}=    Get Current Date    result_format=%Y-%m-%d
    ${todays_date}=    indiantimeUpdate
    Set Global Variable    ${todays_date}
    ${input}=    validate_str_rep    ${distributed_range_path}
    Set Global Variable    ${input}
    ${flow_str_msg}=    Catenate    Flow    Completed
    ${analyze_match}=    inspectMatch    ${input}    ${flow_str_msg}
    Run Keyword If    '${analyze_match}'=='matched'    Sent Mail Flow Completed
    Run Keyword If    '${analyze_match}'!= 'matched'    Check Date
    ${output_Read_txt_}=    Catenate    Func_Read_txt :    {Success}
    Set Global Variable    ${output_Read_txt_}

Check Date
    ${currentDate_in_file}=    retrieveTodaydate    ${summary_FilePath}
    Set Global Variable    ${currentDate_in_file}
    Run Keyword If    '${currentDate_in_file}'== '${todays_date}'    Start Required Flow
    Run Keyword If    '${currentDate_in_file}'!= '${todays_date}'    Sent mail to dev team todays flow completed

Start Required Flow
    ${first_item}=    Get From List    ${input}    0
    ${req_item}=    Get From List    ${first_item}    0
    ${cur_page_num_list}=    Get Dictionary Keys    ${req_item}
    ${cur_page_num}=    Get From List    ${cur_page_num_list}    0
    ${req_range}=    Get From Dictionary    ${req_item}    ${cur_page_num}
    set global variable    ${cur_page_num}
    set global variable    ${req_range}
    Log In

Sent Mail Flow Completed
    UploadDirectories
    ${Mail Update}=    sentmail    ${From}    ${To}    ${Cc}    ${Bcc}    ${Subject}    ${Greetings}    ${Body}    ${Sign}    ${fontStyle}    ${attachments}    ${header}    ${footer}

Sent mail to dev team todays flow completed
    ${todays_flow_compl}=    Catenate    todays_flow compl :    completed

Log In
    ${CompleteDetails}=    Create List
    Set Global Variable    ${CompleteDetails}
    ####    Login into the SAP Application
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
    IndividualValue
    ${Nextrun}=    next_run_preparation    ${input}    ${summary_FilePath}    ${distributed_range_path}

IndividualValue
    Input Text    //*[@class="pageNumber"]    ${cur_page_num}    #Enter Page Num
    sleep    1s
    Click Element    //*[@id="paging_FCI-SearchAllMAandAgreementslinkN10645paging"]    #Click Go
    sleep    5s
    ${Entire_File_Details}=    Create List    #-------------------------------------------->New
    Set Global Variable    ${Entire_File_Details}    #-------------------------------------------->New
    FOR    ${document}    IN    @{req_range}
        Set Global Variable    ${document}
        ${File_Details_for_Each_Agreement_ID}=    Create Dictionary    #-------------------------------------------->New
        Set Global Variable    ${File_Details_for_Each_Agreement_ID}    #-------------------------------------------->New
        ${MasterAgreementID}=    Get Text    //*[@class="queryResultTable"]/tbody/tr[${document}]/td[1]
        Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Master_Agreement_ID    ${MasterAgreementID}    #---------->New
        Set Global Variable    ${MasterAgreementID}
        #Click Element    //*[@class="queryResultTable"]/tbody/tr[${document}]/td[1]    #Click on the master Agreement ID
        ${nolink}=    Run Keyword And Return Status    Click Element    //*[@class="queryResultTable"]/tbody/tr[${document}]/td[1]/a
        Run Keyword If    '${nolink}'!='True'    Click Element    //*[@class="queryResultTable"]/tbody/tr[${document}]/td[1]
        sleep    2s
        ${present}=    Run Keyword And Return Status    Element Should Be Visible    //*[@class="queryResultTable"]/tbody/tr[${document}]/td[1]
        Run Keyword If    (${present} == False)    Clickeachdoc
        Run Keyword If    (${present} == True)    ContinueFlow
        Append To List    ${valueList}    ${MasterAgreementID}
        Wait Until Page Contains Element    //*[@class="queryResultTable"]/tbody
        Append To List    ${Entire_File_Details}    ${File_Details_for_Each_Agreement_ID}
    END
    ${Entire_File_Details_str}=    Convert To String    ${Entire_File_Details}
    Append To File    ${Downloaded_Files_Details}    ${Entire_File_Details_str}
    ${Excel_download_details}=    Downloadfiles_Excel    ${Entire_File_Details}    ${summary_FilePath}
    ${Excel_Alldownload_details}=    AllDownloadfiles_Excel    ${Entire_File_Details}    ${summary_FilePath}

Clickeachdoc
    ${datacollection}=    Create List
    Append To List    ${datacollection}    ${MasterAgreementID}
    #Click Element    //*[@class="queryResultTable"]/tbody/tr[${${document}+1}]/td[1]
    sleep    6s
    Click Element    //*[@class="lsTbsLabelSelText"]    #Header
    sleep    3s
    ${effective_date_check}=    Run Keyword And Return Status    Effective_date
    Run Keyword If    '${effective_date_check}'=='False'    Effective_date_Replace
    ${expiration_date_check}=    Run Keyword And Return Status    Expiration_date
    Run Keyword If    '${expiration_date_check}'=='False'    Expiration_date_Replace
    Append To List    ${datacollection}    ${Effective_date}
    Append To List    ${datacollection}    ${Expiration_date}
    Click Element    //*[@class="lsTbsLabel lsTbsLabelUp"][@title="This tab contains supplier information"]    #supplierinformation
    sleep    3s
    ${SupplierName}=    Get Text    //*[@id="fieldLabel||vendor"][contains(text(),"Supplier")]/../following-sibling::div/a    #suppliername
    Set Global Variable    ${SupplierName}
    Append To List    ${datacollection}    ${SupplierName}
    sleep    2s
    Click Element    //*[@id="fieldLabel||vendor"][contains(text(),"Supplier")]/../following-sibling::div/a
    sleep    3s
    ${ExternalID}=    Get Text    //*[@class="standardField field"][@tooltipref="fieldPrompt||external_id"]/span    #externalid
    Set Global Variable    ${ExternalID}
    Append To List    ${datacollection}    ${ExternalID}
    ${Store_DocumentDetails}=    collect_Document_Details    ${DocumentCollectionFolderName}    ${targetfolder}    ${datacollection}
    Append To List    ${CompleteDetails}    ${datacollection}
    ${FolderName}=    Catenate    ${masterAgreementID}    _    ${SupplierName}    _    ${ExternalID}
    Set Global Variable    ${FolderName}
    Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Folder_Name    ${FolderName}    #---------->New
    Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Master_Agreements    EMPTY
    Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Sub_Document Details    EMPTY
    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]    #Go back
    sleep    5s
    Click Element    //*[text()="Contract Documents"]    #//*[@id="contracts.toolbar.contractslinkN100FEText"]    #contract documents
    sleep    5s
    #__________Get number of contract document tables(MasterDocument)__________________
    sleep    3s
    ${con_present}=    Run Keyword And Return Status    Element Should Be Visible    //*[@class="documentToolbarText"][2]
    Run Keyword If    (${con_present} == False)    Commence Sub Agreement Download    #Click    //*[@class="queryButton queryButtonImage"][@alt="Back"]
    Run Keyword If    (${con_present} == True)    Jumping To Contract Document Download Part

Effective_date
    ${Effective_date}=    Get Text    //*[@tooltipref="fieldPrompt||effective_date"]/span    #Effective date
    Set Global Variable    ${Effective_date}

Expiration_date
    ${Expiration_date}=    Get Text    //*[@tooltipref="fieldPrompt||expiration_date"]/span    #Expiration date
    Set Global Variable    ${Expiration_date}

Effective_date_Replace
    ${Effective_date}=    Catenate    Date    Absent
    Set Global Variable    ${Effective_date}

Expiration_date_Replace
    ${Expiration_date}=    Catenate    Date    Absent
    Set Global Variable    ${Expiration_date}

Jumping To Contract Document Download Part
    sleep    2s
    ${tablenum_unordered}=    Get Text    //*[@class="documentToolbarText"][2]
    ${tablenum_ordered}=    Remove String    ${tablenum_unordered}    &nbsp;    of    #removing chareters from a string
    ${tablenum}=    Replace String    ${tablenum_ordered}    ${SPACE}    ${EMPTY}    #replacing in string ,note:${SPACE} and ${EMPTY} are buildin
    ${tablenum_int}=    Convert To Integer    ${tablenum}
    Set Global Variable    ${tablenum_int}
    #_________Entering Page number and iterate through table in each page(MasterDocument)_________
    ${enrnge}=    Evaluate    ${tablenum_int}+1
    FOR    ${f}    IN RANGE    1    ${enrnge}
        Input Text    //*[@class="pageNumber"]    ${f}
        Click Element    //*[@class="queryButtonText"][contains(text(),"Go")]    #Click Go Button
        DownloadMasterDocuments
    END
    #_____Main File Transfer(MasterDocument)__________
    sleep    12s
    ${MasterDocDownloaded}=    mainDocFileTransfer    ${MaindocNames}    ${FolderName}    ${targetfolder}    ${downloads}
    #**************************_____Downloading Sub Agreements______*****************************
    sleep    3s
    Commence Sub Agreement Download

Commence Sub Agreement Download
    ${Agg_present}=    Run Keyword And Return Status    Element Should Be Visible    //*[@class="lsTbsLabelText"][contains(text(),"Agreements")]
    Run Keyword If    (${Agg_present} == False)    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]
    Run Keyword If    (${Agg_present} == True)    Check Agreements Presence

Check Agreements Presence
    Click Element    //*[@class="lsTbsLabelText"][contains(text(),"Agreements")]
    sleep    5s
    #__________Get number of Sub document tables(SubDocument)__________________
    ${sub_present}=    Run Keyword And Return Status    Element Should Be Visible    //*[@class="documentToolbarText"][2]
    Run Keyword If    (${sub_present} == False)    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]
    Run Keyword If    (${sub_present} == True)    Move To Sub Documents download part

Move To Sub Documents download part
    sleep    3s
    ${subtablenum_UO}=    Get Text    //*[@class="documentToolbarText"][2]
    ${subtablenum_O}=    Remove String    ${subtablenum_UO}    &nbsp;    of    #removing chareters from a string
    ${subtablenum}=    Replace String    ${subtablenum_O}    ${SPACE}    ${EMPTY}    #replacing in string ,note:${SPACE} and ${EMPTY} are buildin
    ${subtablenum_int}=    Convert To Integer    ${subtablenum}
    Set Global Variable    ${subtablenum_int}
    ${Subofsub_docNames}=    Create List    #List of All sub documents
    Set Global Variable    ${Subofsub_docNames}
    #_________Entering Page number and iterate through table in each page(SubDocument)_________
    ${subendrange}=    Evaluate    ${subtablenum_int}+1
    FOR    ${f}    IN RANGE    1    ${subendrange}
        Input Text    //*[@class="pageNumber"]    ${f}
        Click Element    //*[@class="queryButtonText"][contains(text(),"Go")]    #Click Go Button
        IterateSubDocuments
    END
    #_____Sub File Transfer(SubDocument)__________
    sleep    12s
    ${SubDocDownloaded}=    SubDocFileTransfer    ${Subofsub_docNames}    ${FolderName}    ${targetfolder}    ${downloads}
    sleep    2s
    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]

DownloadMasterDocuments
    #______Get number of rows in a table(MasterDocument)_____
    ${rowcount_div}=    Get Element Count    //*[@class="genericCollectionTable"]/table/tbody/tr    #Get count of rows in a table
    Set Global Variable    ${rowcount_div}
    ${MaindocNames}=    Create List
    Set Global variable    ${MaindocNames}
    FOR    ${contdoc}    IN RANGE    1    ${rowcount_div}+1
        Set Global Variable    ${contdoc}
        ${get_name_contr_doc}=    Run Keyword And Return Status    Contract_Document_Downloading
        Run Keyword If    '${get_name_contr_doc}'=='True'    Append To List    ${MaindocNames}    ${MainFile}
        ${downloadcontr_doc}=    Run Keyword And Return Status    Click Element    //*[@class="genericCollectionTable"]/table/tbody/tr[${contdoc}]/td[5]
    END
    Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Master_Agreements    ${MaindocNames}

Contract_Document_Downloading
    ${MainFile}=    Get Text    //*[@class="genericCollectionTable"]/table/tbody/tr[${contdoc}]/td[5]
    Set Global Variable    ${MainFile}

IterateSubDocuments
    #______Get number of rows in a table(MasterDocument)_____
    ${sub_rowcount}=    Get Element Count    //*[@class="genericCollectionTable"]/table/tbody/tr    #Get count of rows in a table
    Set Global Variable    ${sub_rowcount}
    ${SubdocNames}=    Create List
    ${Entire_Subdocuments_Names}=    Create List
    Set Global Variable    ${Entire_Subdocuments_Names}
    Set Global Variable    ${SubdocNames}
    FOR    ${subcontdoc}    IN RANGE    1    ${sub_rowcount}+1
        Set Global Variable    ${subcontdoc}
        ${Sub_Title_Presence}=    Run Keyword And Return Status    Sub_Doc_Title_Presence
        Run Keyword If    '${Sub_Title_Presence}'=='True'    Work On SubDoc Title
    END
    Set To Dictionary    ${File_Details_for_Each_Agreement_ID}    Sub_Document Details    ${Entire_Subdocuments_Names}

Sub_Doc_Title_Presence
    ${subAgreement_Title}=    Get Text    //*[@class="genericCollectionTable"]/table/tbody/tr[${subcontdoc}]/td[2]
    Set Global Variable    ${subAgreement_Title}

Work On SubDoc Title
    ${Files_in_each_sub_agreement}=    Create List
    Set Global Variable    ${Files_in_each_sub_agreement}
    ${Each_Sub_Agreement}=    Create Dictionary
    Set Global variable    ${Each_Sub_Agreement}
    Set To Dictionary    ${Each_Sub_Agreement}    ${subAgreement_Title}    Empty
    ${Click_Sub_Doc_Title}=    Run Keyword and Return Status    Click Element    //*[@class="genericCollectionTable"]/table/tbody/tr[${subcontdoc}]/td[2]
    sleep    5s
    Click Element    //*[@class="lsTbsLabelText"][contains(text(),"Contract Documents")]    #contract documents
    GetSubDocuments_in_SubAgreements
    sleep    2s
    Append To List    ${Entire_Subdocuments_Names}    ${Each_Sub_Agreement}

GetSubDocuments_in_SubAgreements
    #__________Get number of contract document tables(Subof_SubDocument)__________________
    sleep    3s
    ${present}=    Run Keyword And Return Status    Element Should Be Visible    //*[@class="documentToolbarText"][2]
    Run Keyword If    (${present} == False)    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]
    Run Keyword If    (${present} == True)    Inspecting Element and click element

Inspecting Element and click element
    sleep    2s
    ${subofsub_getPages_no}=    Get Text    //*[@class="documentToolbarText"][2]
    ${subofsub_getPages_o}=    Remove String    ${subofsub_getPages_no}    &nbsp;    of    #removing chareters from a string
    ${subofsub_getPages_re}=    Replace String    ${subofsub_getPages_o}    ${SPACE}    ${EMPTY}    #replacing in string ,note:${SPACE} and ${EMPTY} are buildin
    ${subofsub_getPages_int}=    Convert To Integer    ${subofsub_getPages_re}
    Set Global Variable    ${subofsub_getPages_int}
    #_________Entering Page number and iterate through table in each page(Subof_SubDocument)_________
    sleep    3s
    ${subofsub_endrange}=    Evaluate    ${subofsub_getPages_int}+1
    FOR    ${f}    IN RANGE    1    ${subofsub_endrange}
        Input Text    //*[@class="pageNumber"]    ${f}
        sleep    2s
        Click Element    //*[@class="queryButtonText"][contains(text(),"Go")]    #Click Go Button
        DownloadSubDocuments_of_SubAgreements
    END

DownloadSubDocuments_of_SubAgreements
    #______Get number of rows in a table(MasterDocument)_____
    ${subofsub_rowcount}=    Get Element Count    //*[@class="genericCollectionTable"]/table/tbody/tr    #Get count of rows in a table
    Set Global Variable    ${subofsub_rowcount}
    ${subof_subEvenlist}=    Create List
    FOR    ${subof_subcontdoc}    IN RANGE    1    ${subofsub_rowcount}+1
        Set Global Variable    ${subof_subcontdoc}
        ${Check_File_In_Sub_Agg}=    Run Keyword And Return Status    Look For Sub Agg File
        Run Keyword If    '${Check_File_In_Sub_Agg}'=='True'    Click and Download Sub File
    END
    Set To Dictionary    ${Each_Sub_Agreement}    ${subAgreement_Title}    ${Files_in_each_sub_agreement}
    sleep    3s
    Click Element    //*[@class="queryButton queryButtonImage"][@alt="Back"]
    sleep    4s

Look For Sub Agg File
    ${subof_subFile}=    Get Text    //*[@class="genericCollectionTable"]/table/tbody/tr[${subof_subcontdoc}]/td[5]
    Set Global Variable    ${subof_subFile}

Click and Download Sub File
    Append To List    ${Subofsub_docNames}    ${subof_subFile}
    Append To List    ${Files_in_each_sub_agreement}    ${subof_subFile}
    sleep    4s
    ${Clicking_sub_file}=    Run Keyword And Return Status    Click Element    //*[@class="genericCollectionTable"]/table/tbody/tr[${subof_subcontdoc}]/td[5]

ContinueFlow
    Continue For Loop

UploadDirectories
    #_____________Get FolderPath_________________________#
    sleep    3s
    Close All Browsers
    sleep    3s
    ${Folders_list_}=    Create List
    Set Global Variable    ${Folders_list_}
    ${FolderPath}=    sap_directory_segregation    ${Folder_for_sharepoint}    ${Folders_Path}
    Append To List    ${Folders_list_}    ${FolderPath}
    Set Global Variable    ${FolderPath}
    #${Folder_Num}    Get Length    ${FolderPath}
    ${list}=    Create List    --inprivate
    ${args}=    Create Dictionary    args=${list}
    ${desired caps}=    Create Dictionary    ms:edgeOptions=${args}
    Open Browser    ${SAP_sharepoint}    ${browser}    desired_capabilities=${desired caps}    #remote_url=http://localhost:9515
    Maximize Browser Window
    Sleep    5s
    Input Text    //*[@class="form-control ltr_override input ext-input text-box ext-text-box"]    ${usermailid}
    sleep    2s
    Click Element    //*[@class="win-button button_primary button ext-button primary ext-primary"]
    sleep    5s
    sharepointAuth    ${sapusername}    ${sppassword}
    Sleep    28s
    FOR    ${path}    IN    @{Folders_list_}
        ${filecount}=    CollectFileCount    ${path}
        Set Global Variable    ${filecount}
        Set Global Variable    ${path}
        UploadEachFolder
    END
    ${deletesubdirectory}=    deleteFolders    ${Folders_Path}
    ${currentDate_in_file}=    Catenate    Upload_Update    ${deletesubdirectory}
    Set Global Variable    ${currentDate_in_file}

UploadEachFolder
    sleep    5s    #Upload Button
    Click Element    //*[@class="ms-Button-label label-130"][contains(text(),"Upload")]
    sleep    4s    #Folder Button
    Click Element    //*[starts-with(@class,"ms-ContextualMenu-itemText label")][contains(text(),"Folder")]
    sleep    2s
    ${FileUploadresult}=    sharepointfileupload    ${path}    ${filecount}
    sleep    2s
    ${output}=    Set Variable    ${FolderPath}
    Set Global Variable    ${output}

Update AutomationCenter Output
    ${output}=    Catenate    Current_execution_range :    ${input}    Date_in_file :    ${currentDate_in_file}    ${output_run_}    ${output_Get_Credential_}    ${output_Read_txt_}
    ${result}=    Update AutomationCenter    ${output}    ${error}    ${rc}
