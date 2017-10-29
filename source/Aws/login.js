var AmazonCognitoIdentity = require("amazon-cognito-identity-js");
var AuthenticationDetails = AmazonCognitoIdentity.AuthenticationDetails;
var CognitoUser = AmazonCognitoIdentity.CognitoUser;

module.exports = function(userPool){
    return function(app, payload){
        var authenticationData = {
            Username: payload.email,
            Password: payload.password
        };

        var authenticationDetails = new AuthenticationDetails(authenticationDetails);

        var userData = {
            Username: payload.email,
            Pool: userPool
        };

        var cognitoUser = new CognitoUser(userData);
        cognitoUser.authenticateUser(authenticationDetails, {
            onSuccess: function(result) {
                console.log("RESULT", result);
                app.ports.fromJs.send({
                    type: "login success",
                    payload: null
                });
            },
            onFailure: function(err) {
                app.ports.fromJs.send({
                    type: "login fail",
                    payload: String(err)
                });
            }
        })
    };
}