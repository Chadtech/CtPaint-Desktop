AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
AuthenticationDetails = AmazonCognitoIdentity.AuthenticationDetails
CognitoUser = AmazonCognitoIdentity.CognitoUser


module.exports = (app, userPool) ->
    (payload) ->
        email = payload[0]
        password = payload[1]

        authenticationData =
            Username: email
            Password: password

        authenticationDetails = new AuthenticationDetails authenticationData

        userData =
            Username: email
            Pool: userPool

        cognitoUser = new CognitoUser userData
        cognitoUser.authenticateUser authenticationDetails,
            onSuccess: (result) ->
                app.ports.loginSuccess.send null

            onFailure: (err) ->
                app.ports.loginFail.send (String err)
