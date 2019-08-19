var AmazonCognitoIdentity = require("amazon-cognito-identity-js");
var AWS = require("aws-sdk");
var CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool;
var CognitoIdentityCredentials = AWS.CognitoIdentityCredentials;

var Config = require("./Client/config");

var userPool = new CognitoUserPool({
    UserPoolId: Config.UserPoolId,
    ClientId: Config.ClientId
});

function getUser() {
    return userPool.getCurrentUser();
}

var login = require("./Client/login");
var logout = require("./Client/logout");
var verify = require("./Client/verify");
var register = require("./Client/register");
var getSession = require("./Client/get-session");
var getDrawing = require("./Client/get-drawing");
var getDrawings = require("./Client/get-drawings");
var updateDrawing = require("./Client/update-drawing");
var createDrawing = require("./Client/create-drawing");
var deleteDrawing = require("./Client/delete-drawing");
var resetPassword = require("./Client/reset-password");
var forgotPassword = require("./Client/forgot-password");
var updateUser = require("./Client/update-user");

module.exports = function() {
    return {
        getUser: getUser,
        login: login(userPool),
        logout: logout(userPool),
        verify: verify(userPool),
        register: register(userPool),
        getSession: getSession(userPool),
        getDrawing: getDrawing,
        getDrawings: getDrawings,
        updateDrawing: updateDrawing,
        createDrawing: createDrawing,
        deleteDrawing: deleteDrawing,
        resetPassword: resetPassword(userPool),
        forgotPassword: forgotPassword(userPool),
        updateUser: updateUser(userPool)
    }
}
