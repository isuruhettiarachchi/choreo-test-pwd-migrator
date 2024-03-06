import ballerina/http;
import ballerina/log;

type OAuth2App readonly & record {|
    # OAuth2 token endpoint URL
    string tokenUrl;
    # OAuth2 client ID
    string clientId;
    # OAuth2 client secret
    string clientSecret;
|};

configurable string asgardeoUrl = ?;
configurable OAuth2App asgardeoAppConfig = ?;

final string ASGARDEO_USER_UPDATE_SCOPE = "internal_user_mgt_update";

final http:Client asgardeoHttpClient = check new (asgardeoUrl, {
    auth: {
        ...asgardeoAppConfig,
        scopes: ASGARDEO_USER_UPDATE_SCOPE
    }
});

isolated function changePassword() returns error? {

    http:Response response = check asgardeoHttpClient->/scim2/Users/\1b10d573\-ac78\-4961\-a24e\-35afb472424a.patch({
        "schemas": [
            "urn:ietf:params:scim:api:messages:2.0:PatchOp"
        ],
        "Operations": [
            {
                "op": "replace",
                "value": {
                    "password": "Admin123!x2"
                }
            }
        ]
    });

    if response.statusCode != http:STATUS_OK {
        json|error jsonPayload = response.getJsonPayload();
        log:printError(string `Error while changing password. ${jsonPayload is json ? 
            jsonPayload.toString() : response.statusCode}`);
        return error("Error while changing password.");
    }
}