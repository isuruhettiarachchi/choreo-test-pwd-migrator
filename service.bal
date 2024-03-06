import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function get change() returns http:Ok|error {

        check changePassword();
        
        return {
            body: {
                message: "Password changed successfully"
            }
        };
        
    }
}
