var AmazonCognitoIdentity = require("amazon-cognito-identity-js");
var CognitoUserAttribute = AmazonCognitoIdentity.CognitoUserAttribute;

module.exports = function(userPool) {
    return function(app, payload) {

        function attr(name, value) {
            return new CognitoUserAttribute({
                Name: name,
                Value: value
            });
        };

        var dataEmail = attr("email", payload.email);
        var dataNickname = attr("nickname", payload.username);

        var attributes = [ dataEmail, dataNickname ];

        userPool.signUp(payload.email, payload.password, attributes, null, function(err, result){
            if (err) {
                app.ports.fromJs.send({
                    type: "registration fail",
                    payload: String(err)
                });
            } else {
                app.ports.fromJs.send({
                    type: "registration success",
                    payload: result.user.username
                });
            }
        });
    }
};