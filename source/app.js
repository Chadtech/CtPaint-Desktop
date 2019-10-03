/*
    manifest
        { Client: Client
        , mountPath: String
        , buildNumber: Int
        , production : Bool
        }

*/

var canvasManagerNodeName = "canvas-manager";
var msgsWaitingForInitialization = []

var Flags = require("./Js/Flags");


StartCtPaint = function(manifest) {
    var Client = require("./Js/Client")();
    var track = manifest.track;
    var app = { elm: "loading" };

    function flushInitializationMsg () {
        msgsWaitingForInitialization.forEach(function(msg) {
            toElm(msg.name, msg.props);
        });
    }

    function toElm(name, props) {
        var msg = {
            name: name,
            props: props || null
        };

        if (app.elm === "loading") {
            msgsWaitingForInitialization.push(msg)
        }
        else {
            app.elm.ports.fromJs.send(msg);
        }

    }

    var CanvasManager = require("./Js/WebComponent/CanvasManager")({
        canvasManagerNodeName: canvasManagerNodeName,
        toElm: toElm,
        production: manifest.production
    });

    var User = require("./Js/User")(Client, toElm);
    var Drawing = require("./Js/Drawing")(Client, toElm);

    var actions = {
        log_in: User.login,
        track: track,
        forgot_password: User.forgotPassword,
        reset_password: User.resetPassword,
        open_in_new_window: window.open,
        get_drawings: Drawing.getAll,
        canvas_manager_msg: CanvasManager.update
    };

    function jsMsgHandler(msg) {
        var action = actions[msg.name];
        if (typeof action === "undefined") {
            if (!manifest.production) {
                console.log("Unrecognized JsMsg type ->", msg.name);
            }
            return;
        }
        action(msg.props);
    }

    User.get(function(user) {
        app.elm = Elm.Main.init({
            flags: Flags.make(user, manifest, canvasManagerNodeName)
        })
        flushInitializationMsg()
        app.elm.ports.toJs.subscribe(jsMsgHandler);
    });
}