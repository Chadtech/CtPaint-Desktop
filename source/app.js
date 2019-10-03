/*
    manifest
        { Client: Client
        , mountPath: String
        , buildNumber: Int
        , production : Bool
        }

*/

var canvasContainerId = "ctpaint-canvas-container";

var Flags = require("./Js/Flags");

StartCtPaint = function(manifest) {
    var Client = require("./Js/Client")();
    var track = manifest.track;
    var app = { elm: null };

    function toElm(name, props) {
        app.elm.ports.fromJs.send({
            name: name,
            props: props
        });
    }

    var User = require("./Js/User")(Client, toElm);
    var Drawing = require("./Js/Drawing")(Client, toElm);
    var CanvasManager = require("./Js/CanvasManager")(canvasContainerId, toElm)

    var actions = {
        log_in: User.login,
        track: track,
        forgot_password: User.forgotPassword,
        reset_password: User.resetPassword,
        open_in_new_window: window.open,
        get_drawings: Drawing.getAll,
        init_canvas_manager: CanvasManager.init
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
            flags: Flags.make(user, manifest, canvasContainerId)
        })
        app.elm.ports.toJs.subscribe(jsMsgHandler);
    });
}