var gulp = require("gulp");
var source = require("vinyl-source-stream");
var buffer = require("vinyl-buffer");
var cp = require("child_process");
var browserify = require("browserify");
var util = require("gulp-util");
var server = require("./server");

function sourceDir(path) {
    return "./source/" + path;
}

var okayToCompileElm = true;

var paths = {
  public: "./public",
  dist: "./dist",
  mainElm: sourceDir("Main.elm"),
  elm: sourceDir("**/*.elm"),
  mainJs: sourceDir("app.js"),
  js: sourceDir("**/*.js"),
};

gulp.task("js", function () {
  return browserify(paths.mainJs)
    .bundle()
    .pipe(source("app.js"))
    .pipe(buffer())
    .pipe(gulp.dest(paths.public));
});


gulp.task("elm", function () {
  if (okayToCompileElm) {
    okayToCompileElm = false;
    setTimeout(function(){
      okayToCompileElm = true;
    }, 300);
    util.log(util.colors.cyan("Elm"), "starting");
    cp.spawn("elm", [
      "make",
      paths.mainElm,
      // "--optimize",
      "--output",
      paths.public + "/elm.js",
    ], {
      stdio: 'inherit'
    }).on("close", function (code) {
      util.log(util.colors.cyan("Elm"), "closed");
    });
  }
});

gulp.task("server", function () {
    server(2956, util.log);
});

gulp.watch(paths.elm, ["elm"]);
gulp.watch(paths.js, ["js"]);

gulp.task("default", ["elm", "js", "server"]);
