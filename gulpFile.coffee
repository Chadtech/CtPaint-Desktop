gulp = require "gulp"
source = require "vinyl-source-stream"
buffer = require "vinyl-buffer"
cp = require "child_process"
coffeeify = require "coffeeify"
browserify = require "browserify"
util = require "gulp-util"


paths =
    public: "./public"
    mainElm: "./source/Main.elm"
    elm: "./source/**/*.elm"
    coffee: "./source/**/*.coffee"


gulp.task "coffee", ->

    config =
        debug: true
        cash: {}

    b = browserify "./source/app.coffee", config

    b
        .transform coffeeify
        .bundle()
        .pipe (source "app.js")
        .pipe buffer()
        .pipe (gulp.dest paths.public)


gulp.task "elm", [ "elm-make" ]


gulp.task "elm-make", ->
    cmd = [
        "elm-make"
        paths.mainElm
        "--warn"
        "--output"
        paths.public + "/elm.js"
    ].join " "

    cp.exec cmd, (error, stdout, stderr) ->
        if error
            error = (String error).slice 0, (String error).length - 1
            (error.split "\n").forEach (line) ->
                util.log (util.colors.red (String line))
        else
            stderr = stderr.slice 0, stderr.length - 1
            (stderr.split "\n").forEach (line) ->
                util.log (util.colors.yellow (String line))


        stdout = stdout.slice 0, stdout.length - 1
        (stdout.split "\n").forEach (line) ->
            util.log (util.colors.cyan "Elm"), line


gulp.task "server", ->
    (require "./server")(2970, util.log)


gulp.watch paths.elm, [ "elm" ]
gulp.watch paths.coffee, [ "coffee" ]


gulp.task "default", [ "elm", "coffee", "server" ]
