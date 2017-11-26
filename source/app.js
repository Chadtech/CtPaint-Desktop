Desktop = function(Client) {
    var app;

    function toElm(type, payload) {
        app.ports.fromJs.send({
            type: type,
            payload: payload
        });
    };

    function handleLoginSuccess(user) {
        user.getUserAttributes(function(err, attributes) {
            if (err) {
                toElm("log in fail", String(err));
            } else {
                toElm("log in success", (toUser(attributes)))
            }
        });
    }

    var handleLogin = {
        onSuccess: handleLoginSuccess,
        onFailure: function(err) {
            toElm("log in fail", String(err));
        }
    };

    var handleLogout = {
        onSuccess: function() {
            toElm("log out success", null);
        },
        onFailure: function(err) {
            toElm("log out fail", err);
        }
    };

    function jsMsgHandler(msg) {
        switch (msg.type) {
            case "log in" :
                Client.login(msg.payload, handleLogin);
                break;

            case "verify email" :
                Client.verify(msg.payload, {
                    onFailure: function(err) {
                        toElm("verification fail", err);
                    },
                    onSuccess: function(result) {
                        toElm('verification success', result);
                    }
                });
                break;

            case "register" :
                Client.register(msg.payload, {
                    onFailure: function(err) { 
                        toElm("registration fail", err)
                    },
                    onSuccess: function(result) {
                        toElm("registration success", result.user.username);
                    }
                });
                break;

            case "log out" :
                Client.logout(handleLogout);
                break;

            default:
                console.log("Unknown js msg type", msg.type);
        }
    }

    function toUser(attributes) {
        var payload = {};

        for (i = 0; i < attributes.length; i++) {
            payload[ attributes[i].getName() ] = attributes[i].getValue();
        }

        return payload;
    }

    function flags(extraFlags){
        return {
          user: extraFlags.user
        };
    }

    function init(extraFlags) {
        app = Elm.Desktop.fullscreen(flags(extraFlags));
        app.ports.toJs.subscribe(jsMsgHandler);
    }

    Client.getSession({
        onSuccess: function(attributes) {
            init({
                user: toUser(attributes)
            });
        },
        onFailure: function(err) {
            switch (err) {
                case "no session" :
                    init({ user: null });
                    break;

                case "NetworkingError: Network Failure":
                    init({ user: "offline" });
                    break;

                case "UserNotFoundException: User does not exist.":
                    init({ user : null });

                default : 
                    console.log("Unknown get session error", err);
            }
        }
    });
};

