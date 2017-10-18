var gulp = require("gulp");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");
var cp = require("child_process");
var browserify = require("browserify");
var util = require("gulp-util");


var paths = {
  public: "./public",
  dist: "./dist",
  mainElm: "./src/Main.elm",
  elm: "./src/**/*.elm",
  js: "./src/*.js"
};


var production = false;


gulp.task("js", function() {
  return browserify("./src/app.js", {
    debug: !production,
    cache: {},
  }).bundle()
    .pipe(source("app.js"))
    .pipe(buffer())
    .pipe(gulp.dest(paths.public));
});


// Uncomment out for automatic formatting
// gulp.task("elm", ["elm-format", "elm-make"]);
gulp.task("elm", ["elm-make"]);



gulp.task("elm-format", function() {
  var formatCmd = "elm-format ./src --yes";
  cp.exec(formatCmd, function(error, stdout) {})
})


function makeCss () {
  var cmd = [
    "elm-css",
    "src/Stylesheets.elm"
  ].join(" ");

  cp.exec(cmd);
}

gulp.task("elm-make", function () {
  var cmd = [
    "elm-make",
    paths.mainElm,
    "--output",
    paths.public + "/elm.js",
  ].join(" ");

  makeCss();

  cp.exec(cmd, function(error, stdout) {
    if (error) {
      util.log(util.colors.cyan("Elm"),
        util.colors.red(String(error))
      );
    } 
    var stdout = stdout.slice(0, stdout.length - 1);

    stdout.split("\n").forEach(function(line) {
      util.log(util.colors.cyan("Elm"), line);
    })
  }); 
})

gulp.task("server", function() {
  return require("./server")(2984, util.log);
});


gulp.task("dist", function() {
  production = true;
  gulp.task("default");

  return gulp
    .src(paths.public + "/**/*")
    .pipe(gulp.dest(paths.dist));
})


gulp.watch(paths.elm, ["elm"]);
gulp.watch(paths.js, ["js"]);
gulp.watch("public/index.html", ["server"])


gulp.task("default", ["elm", "js", "server"]);
