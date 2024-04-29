*** Settings ***
Resource    settings.resource
Resource    variables.resource
Library    DateTime

*** Keywords ***
Get Object Name
    ${object_name}=    FakerLibrary.Word
    Return From Keyword    ${object_name}

Create Object
    ${dob}=    FakerLibrary.Date Of Birth
    ${dob}=    Convert Date    ${dob}    result_format=%d.%m.%Y

    ${salary}=    FakerLibrary.Pydecimal    5    2    True    1000.00    9999.99
    ${salary}=    Convert To Number    ${salary}
    
    # &{object}=    Create Dictionary    date_of_birth=${dob}    salary=${salary}
    @{profile_fields}=    Create List    username    name    sex    addess    mail
    &{object}=    FakerLibrary.Profile    fields=@{profile_fields}
    &{object}=    Create Dictionary    &{object}    dob=${dob}    salary=${salary}
    Return From Keyword    ${object}

GET Request API
    [Arguments]    ${_path}    ${_param}=${None}    ${_expected_status}=200
    Create Session      session    ${base_url}
    ${response}=        GET On Session    session    url=${_path}    params=${_param}    expected_status=${_expected_status}
    Return From Keyword    ${response.json()}

POST Request API
    [Arguments]    ${_path}    ${_body}=${None}    ${_expected_status}=200
    Create Session      session    ${base_url}
    ${response}=    POST On Session    session    url=${_path}    json=${_body}    expected_status=${_expected_status}
    Return From Keyword    ${response.json()}

PUT Request API
    [Arguments]    ${_path}    ${_body}=${None}    ${_expected_status}=200
    Create Session      session    ${base_url}
    ${response}=    PUT On Session    session    url=${_path}    json=${_body}    expected_status=${_expected_status}
    Return From Keyword    ${response.json()}

Delete Request API
    [Arguments]    ${_path}    ${_body}=${None}    ${_expected_status}=200
    Create Session      session    ${base_url}
    ${response}=    DELETE On Session    session    url=${_path}    expected_status=${_expected_status}
    Return From Keyword    ${response.json()}

Response Should Contain Keys
    [Arguments]    ${object}    ${expected_keys}
    ${object_keys}    Get Dictionary Keys    ${object}
    Sort List        ${object_keys}
    Sort List        ${expected_keys}
    Log List         ${object_keys}
    Log List         ${expected_keys}
    Lists Should Be Equal    ${object_keys}    ${expected_keys}