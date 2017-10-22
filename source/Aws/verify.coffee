AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUser = AmazonCognitoIdentity.CognitoUser


module.exports = (app, userPool) ->
    (payload) ->
        email = payload[0]
        code = payload[1]

        userData =
            Username: email
            Pool: userPool

        user = new CognitoUser userData
        user.confirmRegistration code, true, (err, result) ->
            if err
                app.ports.verificationFail.send (String err)
            else
                console.log "RESULT", result
                app.ports.verificationSuccess.send email