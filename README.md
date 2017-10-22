# CtPaint Desktop

This is the desktop part of CtPaint. By that I mean, the home page, and your settings, and the login, and all the things that are not part of the paint app.

## Getting Started

```
npm install
elm package install
gulp
--> localhost:2970
```

## Directory Structure

```
├── Aws
│   ├── login.coffee
│   ├── register.coffee
│   └── verify.coffee
├── Data
│   └── Session.elm
├── Main.elm
├── Model.elm
├── Msg.elm
├── Page
│   ├── Error.elm
│   ├── Home.elm
│   ├── Login.elm
│   ├── Register.elm
│   └── Verify.elm
├── Page.elm
├── Ports.elm
├── Route.elm
├── Styles
│   └── Shared.elm
├── Styles.elm
├── Stylesheets.elm
├── Update.elm
├── Util.elm
└── app.coffee
```