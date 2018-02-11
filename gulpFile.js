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

var waitApp = false;
var waitStylesheet = false;

function startWaiting(what) {
  switch (what) {
    case "app": 
      waitApp = true;
      break;

    case "stylesheet":
      waitStylesheet = true;
      break;
  }
  setTimeout(function() {
    waitApp = false;
    waitStylesheet = false;
  }, 3000);
}

gulp.task("js", function() {
  return browserify("./source/app.js")
    .bundle()
    .pipe(source("desktop.js"))
    .pipe(buffer())
    .pipe(gulp.dest(paths.public));
});



gulp.task("elm", [ "elm-make", "elm-css" ]);

gulp.task("elm-make", function() {
  if (!waitApp) {
    startWaiting("app");
    var cmd = [
      "elm-make",
      paths.mainElm,
      "--warn",
      "--output",
      paths.public + "/desktop-elm.js"
    ].join(" ");
    return cp.exec(cmd, function(error, stdout, stderr) {
      if (error) {
        error = (String(error)).slice(0, (String(error)).length - 1);
        (error.split("\n")).forEach(function(line) {
          return util.log(util.colors.red(String(line)));
        });
      } else {
        stderr = stderr.slice(0, stderr.length - 1);
        (stderr.split("\n")).forEach(function(line) {
          return util.log(util.colors.yellow(String(line)));
        });
      }
      stdout = stdout.slice(0, stdout.length - 1);
      return (stdout.split("\n")).forEach(function(line) {
        return util.log(util.colors.cyan("Elm"), line);
      });
    });
  }
});

gulp.task("elm-css", function() {
  if (!waitStylesheet) {
    startWaiting("stylesheet");
    var cmd = [
      "elm-css",
      "./source/Stylesheets.elm",
    ].join(" ");
    return cp.exec(cmd, function(error, stdout, stderr) {
      if (error) {
        error = (String(error)).slice(0, (String(error)).length - 1);
        (error.split("\n")).forEach(function(line) {
          util.log(util.colors.red(String(line)));
        });
      } else {
        stderr = stderr.slice(0, stderr.length);
        (stderr.split("\n")).forEach(function(line) {
          util.log(util.colors.yellow(String(line)));
        });
      }
      stdout = stdout.slice(0, stdout.length - 1);
      (stdout.split("\n")).forEach(function(line) {
        util.log(util.colors.cyan("Elm Css"), line);
      });
    });
  }
});

gulp.task("server", function() {
  return (require("./server"))(2964, util.log);
});

gulp.task("watch", function(){
    gulp.watch(paths.elm, ["elm"]);
    gulp.watch(paths.js, ["js"]);
});

gulp.task("build", [ "elm",  "js" ]);
gulp.task("default", ["watch", "elm", "js", "server"]);

