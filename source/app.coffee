app = Elm.Main.fullscreen()


app.ports.toJs.subscribe (msg) ->
    switch msg.type
        when "console log"
            console.log msg.payload
            app.ports.fromJs.send 
                type: "console log happens"