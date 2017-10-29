// var register = require("./Aws/register");
// var verify = require("./Aws/verify");

var AmazonCognitoIdentity = require("amazon-cognito-identity-js");
var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool;

var poolData = {
    UserPoolId: "us-east-2_xc2oQp2ju",
    ClientId: "7r81o7o9pnar49lrh54mhv0u5s"
};

var userPool = new CognitoUserPool(poolData);

var user = userPool.getCurrentUser();

var login = require("./Aws/login")(userPool);

Desktop = {
    init: function(flags) {
        var app = Elm.Desktop.fullscreen(flags);

        function jsMsgHandler(msg) {
            switch (msg.type) {
                case "login" :
                    login(app, msg.payload);
                    break;

                case "end session" :
                    if (user !== null) {
                        user.signOut();
                    }
                    break;

                default:
                    console.log("Unknown js msg type", msg.type);
            }
        }
        app.ports.toJs.subscribe(jsMsgHandler);
    }
};
