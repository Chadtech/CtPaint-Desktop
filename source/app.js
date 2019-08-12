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