var app = Elm.Main.fullscreen();


app.ports.toJs.subscribe(function(msg) {
    switch (msg.type) {
        case "console log" :
            console.log(msg.payload)
            app.ports.fromJs.send({
                type: "console log happened"
            });
            break;
    }
})

