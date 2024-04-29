*** Settings ***
Resource    ../project_resources/settings.resource

*** Variables ***
${path}    /objects

*** Test Cases ***
Create Update Delete Object
    # Create
    ${name}=    Get Object Name
    &{data}=    Create Object
    &{request_body}=    Create Dictionary    name=${name}    data=${data}
    ${response}=        POST Request API      ${path}    ${request_body}
    ${expected_response_keys}=    Create List    id    name    createdAt    data
    Response Should Contain Keys    ${response}    ${expected_response_keys}

    # Get Object
    ${response_id}=    Get From Dictionary    ${response}    id    0
    ${response}=    GET Request API    ${path}/${response_id}
    Dictionary Should Contain Sub Dictionary    ${response}     ${request_body}    

    # Update Object
    ${expected_name}=       Get Object Name
    &{data}=    Create Object
    &{request_body}=    Create Dictionary    name=${expected_name}    data=${data}
    ${response}=        PUT Request API      ${path}/${response_id}    ${request_body}
    ${expected_response_keys}=    Create List    id    name    updatedAt    data
    Response Should Contain Keys    ${response}    ${expected_response_keys}
    ${updated_name}=    Get From Dictionary    ${response}    name    ${None}
    Should Be Equal    ${updated_name}    ${expected_name}

    # Delete Object
    ${response}=        DELETE Request API      ${path}/${response_id}
    ${delete_msg}    Get From Dictionary    ${response}           message    0
    Should Contain Any    ${delete_msg}     ${response_id}        has been deleted