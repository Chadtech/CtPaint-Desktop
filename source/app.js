Desktop = function(Client) {

    var app = Elm.Desktop.fullscreen({
        isLoggedIn: Client.getUser() !== null,
    });

    function toElm(type, payload) {
        app.ports.fromJs.send({
            type: type,
            payload: payload
        });
    };

    var handleLogin = {
        onSuccess: function(result) {
            toElm("log in success", null);
        },
        onFailure: function(err) {
            toElm("log in fail", String(err));
        }
    };

    function handleLogin(err, result) {
        if (err) {
            toElm("verification fail", String(err));
        } else {
            toElm("verification success", payload.email);
        }
    };

    function handleRegister(err, result){
        if (err) {
            toElm("registration fail", String(err));
        } else {
            toElm("registration success", result.user.username);
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
                Client.verify(msg.payload, handleLogin);
                break;

            case "register" :
                Client.register(msg.payload, handleRegister)
                break;

            case "log out" :
                Client.logout(handleLogout);
                break;

            default:
                console.log("Unknown js msg type", msg.type);
        }
    }

    app.ports.toJs.subscribe(jsMsgHandler);

    return app;
};

