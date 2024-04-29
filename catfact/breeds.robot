*** Settings ***
Library    Collections
Library    String
#Library    HttpLibrary.HTTP
Library    RequestsLibrary
Resource    keywords.resource

*** Variables ***
${path}    /breeds

*** Test Cases ***
Get Breeds without Limit Param and Verify Response Keys and Default per_page
    ${response}=           Get Request API      ${path}
    Should Not Be Empty    ${response}
    ${expected_response_keys}    Create List    current_page    data    first_page_url    from    last_page    last_page_url
    ...    links    next_page_url    path    per_page    prev_page_url    to    total
    Response Should Contain Keys     ${response}    ${expected_response_keys}

    ${response_per_page}    Get From Dictionary    ${response}    per_page    ${None}
    ${expected_default_per_page}    Set Variable    25
    ${expected_default_per_page}    Convert To Integer     ${expected_default_per_page}
    Should Be Equal    ${response_per_page}     ${expected_default_per_page}

Get Breeds with Limit Param Should equal to per_page in Response
    ${param_limit}         Set Variable    50
    ${params}=             Create Dictionary    limit=${param_limit}
    ${response}=           Get Request API      ${path}    ${params}
    Should Not Be Empty    ${response}
    ${response_per_page}    Get From Dictionary    ${response}    per_page    ${None}
    Should Be Equal         ${response_per_page}     ${param_limit}

    ${response_data}    Get From Dictionary    ${response}    data    ${None}
    ${length_response_data}=    Get Length        ${response_data}
    ${int_param_limit}    Convert To Integer     ${param_limit}
    Should Be Equal         ${length_response_data}     ${int_param_limit}

Get Breeds and Verify Breeds Keys in Data and Links
    ${param_limit}         Set Variable    1
    ${params}=             Create Dictionary    limit=${param_limit}
    ${response}=           Get Request API      ${path}    ${params}
    Should Not Be Empty    ${response}

    ${response_data}    Get From Dictionary    ${response}    data    ${None}
    ${data}             Get From List    ${response_data}     0
    ${expected_data_keys}    Create List    breed    country    origin    coat    pattern
    Response Should Contain Keys     ${data}    ${expected_data_keys}

    

