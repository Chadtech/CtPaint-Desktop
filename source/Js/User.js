function fromAttributes(attributes) {
    var payload = {};

    for (var i = 0; i < attributes.length; i++) {
        payload[attributes[i].getName()] = attributes[i].getValue();
    }

    return payload;
}

function logout(Client, toElm) {
    function succeed() {
        toElm("logout succeeded", null);
    }
    Client.logout({
        onSuccess: succeed,
        onFailure: function(err) {
            switch (err) {
                case "user was not signed in":
                    succeed();
                    break;

                default:
                    toElm("logout failed", err);
                    break;
            }
        }
    });
}

function login(Client, toElm, payload) {
    Client.login(payload, {
        onSuccess: function(user) {
            user.getUserAttributes(function(err, attrs) {
                if (err) {
                    toElm("login failed", String(err));
                } else {
                    toElm("login succeeded", fromAttributes(attrs));
                }
            });
        },
        onFailure: function(err) {
            toElm("login failed", String(err));
        }
    });
}

function get(Client, init) {
    Client.getSession({
        onSuccess: function(attrs) {
            init(fromAttributes(attrs));
        },
        onFailure: function(err) {
            switch (String(err)) {
                case "no session":
                    init(null);
                    break;

                case "NetworkingError: Network Failure":
                    init("offline");
                    break;

                case "UserNotFoundException: User does not exist.":
                    init(null);
                    break;

                default:
                    init("Unknown get session error");
            }
        }
    });
}

function verify(Client, toElm, payload) {
    Client.verify(payload, {
        onFailure: function(err) {
            toElm("verification failed", err);
        },
        onSuccess: function(result) {
            toElm('verification succeeded', result);
        }
    });
}

function register(Client, toElm, payload) {
    Client.register(payload, {
        onFailure: function(err) { 
            toElm("registration failed", err)
        },
        onSuccess: function(result) {
            toElm("registration succeeded", result.user.username);
        }
    });
}

module.exports = function(Client, toElm) {
    return {
        fromAttributes: fromAttributes,
        logout: function() {
            logout(Client, toElm);
        },
        login: function(payload) {
            login(Client, toElm, payload);
        },
        get: function(init) {
            get(Client, init);
        },
        verify: function(payload) {
            verify(Client, toElm, payload);
        },
        register: function(payload) {
            register(Client, toElm, payload);
        }
    };
};