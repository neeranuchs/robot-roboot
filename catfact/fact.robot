*** Settings ***
Library    Collections
Library    String
#Library    HttpLibrary.HTTP
Library    RequestsLibrary
Resource    keywords.resource

*** Variables ***
${path}    /fact

*** Test Cases ***
Get Random Cat Fact Should Success and Return Not Empty Response
    ${response}=           Get Request API      ${path}
    Should Not Be Empty    ${response}
    
    ${response_fact}=          Get From Dictionary    ${response}    fact    ${None}
    ${length_char_response_fact}=    Get Length        ${response_fact}
    ${response_length}=        Get From Dictionary    ${response}    length    ${None}
    Should Be Equal    ${length_char_response_fact}    ${response_length}
    
    ${expected_response_keys}    Create List    fact    length
    Response Should Contain Keys     ${response}    ${expected_response_keys}

Get Random Cat Fact Whose Length of Fact Should Less than or equal to Max Length
    ${param_length_fact}         Set Variable    50
    ${params}=             Create Dictionary    max_length=${param_length_fact}
    ${response}=           Get Request API      ${path}    ${params}
    Should Not Be Empty    ${response}

    ${response_fact}=          Get From Dictionary    ${response}    fact      ${None}
    ${count_char_response_fact}=    Get Length        ${response_fact}
    ${response_length}=        Get From Dictionary    ${response}    length    ${None}
    Should Be True    ${count_char_response_fact}<=${param_length_fact}
    Should Be True    ${response_length}<=${param_length_fact}

Get Random Cat Fact Should Success and Return Empty Response
    ${params}=        Create Dictionary    max_length=0
    ${response}=      Get Request API      ${path}    ${params}
    Should Be Empty   ${response}

