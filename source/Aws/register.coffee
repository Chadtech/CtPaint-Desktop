AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUserAttribute = AmazonCognitoIdentity.CognitoUserAttribute

module.exports = (app, userPool) ->
    (registration) ->
    
        attr = (name, value) ->
            payload =
                Name: name
                Value: value

            new CognitoUserAttribute payload

        dataEmail = attr "email", registration.email
        dataNickname = attr "nickname", registration.username

        attributes = [ dataEmail, dataNickname ]

        email = registration.email
        password = registration.password

        userPool.signUp email, password, attributes, null, (err, result) ->
            if err
                app.ports.registrationFail.send (String err)
            else
                app.ports.registrationSuccess.send result.user.username

