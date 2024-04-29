*** Settings ***
Library    Collections
Library    String
#Library    HttpLibrary.HTTP
Library    RequestsLibrary
Resource   variables.resource

*** Keywords ***
Get Request API
    [Arguments]    ${_path}    ${_param}=${None}    ${_expected_status}=200
    Create Session      session    ${base_url}
    ${response}=        GET On Session    session    url=${_path}    params=${_param}    expected_status=${_expected_status}
    Return From Keyword    ${response.json()}

Response Should Contain Keys
    [Arguments]    ${object}    ${expected_keys}
    ${object_keys}    Get Dictionary Keys    ${object}
    Sort List        ${object_keys}
    Sort List        ${expected_keys}
    Log List         ${object_keys}
    Log List         ${expected_keys}
    Lists Should Be Equal    ${object_keys}    ${expected_keys}