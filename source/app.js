/*
    manifest
        { Client: Client
        , mountPath: String
        , buildNumber: Int
        }

*/

var Flags = require("./Js/Flags");

Desktop = function(manifest) {
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
    var Drawing = require("./Js/Drawing")(Client, toElm);
    var PaintApp = require("./Js/PaintApp");

    var actions = {
        logIn: User.login,
        verifyEmail: User.verify,
        register: User.register,
        updateUser: User.update,
        logOut: User.logout,
        getDrawings: Drawing.getAll,
        openPaintApp: PaintApp.open,
        openPaintAppWithParams: PaintApp.openWithParams,
        openUrlInPaintApp: PaintApp.openUrl,
        openDrawingInPaintApp: PaintApp.openDrawing,
        openInNewWindow: window.open,
        deleteDrawing: Drawing.delete,
        forgotPassword: User.forgotPassword,
        resetPassword: User.resetPassword,
        track: track
    };

    function jsMsgHandler(msg) {
        var action = actions[msg.type];
        if (typeof action === "undefined") {
            console.log("Unrecognized JsMsg type ->", msg.type);
            return;
        }
        action(msg.payload);
    }

    User.get(function(user) {
        var inithtml = document.getElementById("inithtml");
        if (inithtml !== null) {
            document.body.removeChild(inithtml);
        }
        app.elm = Elm.Desktop.fullscreen(Flags.make(user, manifest));
        app.elm.ports.toJs.subscribe(jsMsgHandler);
    });
};

