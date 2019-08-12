(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
module.exports = {
    make: function(user, manifest) {
        var localWork = localStorage.getItem("local work");

        var buf = new Uint32Array(1);
        window.crypto.getRandomValues(buf);
        var milliseconds = new Date().getMilliseconds()
        var seed = buf[0] * 1000 + milliseconds;

        return {
            windowHeight: window.innerHeight,
            windowWidth: window.innerWidth,
            seed: seed,
            isMac: window.navigator.userAgent.indexOf("Mac") !== -1,
            browser: getBrowser(),
            user: user,
            mountPath: manifest.mountPath,
            buildNumber: manifest.buildNumber
        }; 
    }
}


function getBrowser() {
    if (window.navigator.userAgent.indexOf("Firefox") !== -1) {
        return "Firefox";
    } 
    if (window.navigator.userAgent.indexOf("Chrome") !== -1) {
        return "Chrome";
    }
    return "Unknown";
}
},{}],2:[function(require,module,exports){
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
    Client.forgotPassword(payload, {
        onSuccess: function(data) {
            toElm("forgot password sent", null);
        },
        onFailure: function(err) {
            toElm("forgot password failed", String(err));
        }
    });
}

function resetPassword(Client, toElm, payload) {
    Client.resetPassword(payload, {
        onSuccess: function(data) {
            toElm("reset password succeeded", null);
        },
        onFailure: function(err) {
            toElm("reset password failed", String(err));
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

},{}],3:[function(require,module,exports){
/*
    manifest
        { Client: Client
        , mountPath: String
        , buildNumber: Int
        , production : Bool
        }

*/

var Flags = require("./Js/Flags");

StartCtPaint = function(manifest) {
    var Client = manifest.Client;
    var track = manifest.track;
    var app = { elm: null };

    function toElm(type, payload) {
        app.elm.ports.fromJs.send({
            type: type,
            payload: payload
        });
    }

    var User = require("./Js/User")(Client, toElm);

    function jsMsgHandler(msg) {
        var action = actions[msg.type];
        if (typeof action === "undefined") {
            if (!manifest.production) {
                console.log("Unrecognized JsMsg type ->", msg.type);
            }
            return;
        }
        action(msg.payload);
    }

    User.get(function(user) {
        app.elm = Elm.Main.init({
            flags: Flags.make(user, manifest)
        })
//        app.elm.ports.toJs.subscribe(jsMsgHandler);
    });
}
},{"./Js/Flags":1,"./Js/User":2}]},{},[3]);
