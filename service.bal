import ballerina/http;

type UserCredential record {|
    # Username
    string username;
    # Password
    string password;
|};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post change(UserCredential credentials) returns http:Ok|error {

        check changePassword();

        return {
            body: {
                message: "Password changed successfully"
            }
        };
        
    }
}
