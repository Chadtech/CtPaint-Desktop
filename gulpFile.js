var gulp = require("gulp");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");
var cp = require("child_process");
var browserify = require("browserify");
var util = require("gulp-util");

paths = {
  public: "./public",
  mainElm: "./source/Desktop.elm",
  elm: "./source/**/*.elm",
  js: "./source/**/*.js"
};


gulp.task("js", function () {
  return browserify("./source/app.js")
    .bundle()
    .pipe(source("desktop.js"))
    .pipe(buffer())
    .pipe(gulp.dest(paths.public));
});


gulp.task("elm", makeElm);

function elmCss() {
  util.log(util.colors.cyan("Elm-Css"), "starting");
  cp.spawn("elm-css", [ "./source/Stylesheets.elm" ], {
    stdio: 'inherit'
  }).on('close', function() {
    util.log(util.colors.cyan("Elm-Css"), "closed");
  });
}

function makeElm() {
  util.log(util.colors.cyan("Elm"), "starting");
  cp.spawn("elm-make", [
    paths.mainElm,
    "--warn",
    "--output",
    paths.public + "/desktop-elm.js",
    "--yes"
  ], {
      stdio: 'inherit'
    }).on("close", function (code) {
      util.log(util.colors.cyan("Elm"), "closed");
      if (code === 0) {
        elmCss()
      };
    });
};


gulp.task("server", function () {
  return (require("./server"))(2964, util.log);
});

gulp.task("watch", function () {
  gulp.watch(paths.elm, ["elm"]);
  gulp.watch(paths.js, ["js"]);
});

gulp.task("build", ["elm", "js"]);
gulp.task("default", ["watch", "elm", "js", "server"]);
