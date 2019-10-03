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
    function sendLogin(v) {
        toElm("login", v);
    }
    Client.login(payload, {
        onSuccess: function(user) {
            user.getUserAttributes(function(err, attrs) {
                if (err) {
                    sendLogin(err);
                } else {
                    sendLogin(fromAttributes(attrs));
                }
            });
        },
        onFailure: function(err) {
            sendLogin(err);
        }
    });
}

function get(Client, init) {
    Client.getSession({
        onSuccess: function(attrs) {
            init(fromAttributes(attrs));
        },
        onFailure: function(err) {
            switch (err.name) {
                case "no session":
                    init(null);
                    break;

                case "NetworkingError":
                    init("offline");
                    break;

                case "UserNotFoundException":
                    init(null);
                    break;

                default:
                    init(err.name);
            }
        }
    });
}

function verify(Client, toElm, payload) {
    Client.verify(payload, {
        onFailure: function(err) {
            toElm("verification failed", String(err));
        },
        onSuccess: function(result) {
            toElm('verification succeeded', result);
        }
    });
}

function register(Client, toElm, payload) {
    Client.register(payload, {
        onFailure: function(err) {
            toElm("registration failed", err);
        },
        onSuccess: function(result) {
            toElm("registration succeeded", result.user.username);
        }
    });
}

function update(Client, toElm, payload) {
    Client.updateUser(payload, {
        onFailure: function(err) {
            toElm("user update failed", String(err));
        },
        onSuccess: function(result) {
            toElm("user update succeeded", null);
        }
    });
}

function forgotPassword(Client, toElm, payload) {
    function sendForgotPassword(result) {
        toElm("forgot password", result)
    };
    console.log(payload);
    Client.forgotPassword(payload.email, {
        onSuccess: function(data) {
            sendForgotPassword(null);
        },
        onFailure: function(err) {
            sendForgotPassword(err);
        }
    });
}

function resetPassword(Client, toElm, payload) {
    function sendResetPassword(result) {
        toElm("reset password", result)
    }
    Client.resetPassword(payload, {
        onSuccess: function(data) {
            sendResetPassword(null);
        },
        onFailure: function(err) {
            console.log(err.message)
            sendResetPassword(err);
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
        },
        update: function(payload) {
            update(Client, toElm, payload);
        },
        forgotPassword: function(payload) {
            forgotPassword(Client, toElm, payload);
        },
        resetPassword: function(payload) {
            resetPassword(Client, toElm, payload);
        }
    };
};
