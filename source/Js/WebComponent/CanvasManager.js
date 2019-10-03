

module.exports = function (manifest) {
    var toElm = manifest.toElm;

    var CanvasManager = {
        model: "waiting"
    }

    var msgQueue = []

    var actions = {
        initialize_layers: function(payload, model) {
            console.log("initialize canvases", payload)
            return model
        }
    }

    function consumeMsgs() {
        if (msgQueue.length === 0) {
            waitToConsumeMsgs()
            return;
        } else {
            var msg = msgQueue[0];
            var rest = msgQueue.slice(1);

            console.log(msg);
            var action = actions[msg.name];
            if (typeof action === "undefined") {
                if (!manifest.production) {
                    console.log("Unrecognized Canvas Manager Msg type ->", msg.name);
                }
                return;
            }
            actions[msg.name](msg.props);
            msgQueue = rest;
            consumeMsgs()
        }
    }

    function waitToConsumeMsgs() {
        requestAnimationFrame(consumeMsgs)
    }

    waitToConsumeMsgs()

    function setModel(newModel) {
        CanvasManager.model = newModel;
    }

    window.customElements.define(manifest.canvasManagerNodeName, class CanvasContainer extends HTMLElement {
        constructor() {
            super();

            function initMsg (props) {
                toElm("canvas manager init", props);
            }

            function succeed() {
                initMsg(null);
            }

            function fail(props) {
                initMsg(props)
            }

            if (CanvasManager.model === "waiting") {
                setModel({
                    canvases: null
                });
                succeed()
            }
            else {
                fail("canvas manager was not waiting")
            }
        }

        connectedCallback() {
            console.log("Connected callback!!")
        }
    });

    return {
        update: function(payload) {
            msgQueue.push(payload.msg);
        }
    };
}