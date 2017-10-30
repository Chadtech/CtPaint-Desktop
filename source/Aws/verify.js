var AmazonCognitoIdentity = require("amazon-cognito-identity-js");
var CognitoUser = AmazonCognitoIdentity.CognitoUser;

module.exports = function(userPool) {
    return function(app, payload) {
        var userData = {
            Username: payload.email,
            Pool: userPool
        }   

        var user = new CognitoUser(userData);
        user.confirmRegistration(payload.code, true, function(err, result) {
            if (err) {
                app.ports.fromJs.send({
                    type: "verification fail",
                    payload: null
                });
            } else {
                console.log("Result", result);
                app.ports.fromJs.send({
                    type: "verification success",
                    payload: email
                });
            }
        });
    }
}